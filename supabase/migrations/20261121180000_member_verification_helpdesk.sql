-- MASTER WORLD VIP — private member verification/helpdesk foundation.
-- Collect only a short member-provided explanation. Never collect passwords, OTPs,
-- login codes, Facebook credentials, or government-ID images in this workflow.

create or replace function public.is_helpdesk_staff()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.app_user_roles r
    where r.user_id = auth.uid()
      and r.role in ('owner','super_admin','admin','moderator')
  );
$$;

revoke all on function public.is_helpdesk_staff() from public, anon;
grant execute on function public.is_helpdesk_staff() to authenticated;

create table if not exists public.member_verification_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  request_note text not null check (char_length(trim(request_note)) between 10 and 2000),
  status text not null default 'pending'
    check (status in ('pending','needs_info','approved','rejected')),
  staff_note text,
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists member_verification_requests_user_created_idx
  on public.member_verification_requests(user_id, created_at desc);
create index if not exists member_verification_requests_status_created_idx
  on public.member_verification_requests(status, created_at asc);
create unique index if not exists member_verification_one_active_per_user_uidx
  on public.member_verification_requests(user_id)
  where status in ('pending','needs_info');

create table if not exists public.verification_request_messages (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null references public.member_verification_requests(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(trim(body)) between 1 and 2000),
  created_at timestamptz not null default now()
);
create index if not exists verification_request_messages_request_created_idx
  on public.verification_request_messages(request_id, created_at asc);

create table if not exists public.verification_request_events (
  id bigint generated always as identity primary key,
  request_id uuid not null references public.member_verification_requests(id) on delete cascade,
  actor_id uuid references auth.users(id) on delete set null,
  event_type text not null check (event_type in ('submitted','message_sent','status_changed')),
  old_status text,
  new_status text,
  created_at timestamptz not null default now()
);
create index if not exists verification_request_events_request_created_idx
  on public.verification_request_events(request_id, created_at desc);

alter table public.member_verification_requests enable row level security;
alter table public.verification_request_messages enable row level security;
alter table public.verification_request_events enable row level security;

revoke all on public.member_verification_requests from anon, authenticated;
revoke all on public.verification_request_messages from anon, authenticated;
revoke all on public.verification_request_events from anon, authenticated;
grant select on public.member_verification_requests to authenticated;
grant select on public.verification_request_messages to authenticated;
grant select on public.verification_request_events to authenticated;

drop policy if exists "members and helpdesk read own verification requests" on public.member_verification_requests;
create policy "members and helpdesk read own verification requests"
on public.member_verification_requests for select to authenticated
using (user_id = auth.uid() or public.is_helpdesk_staff());

drop policy if exists "members and helpdesk read verification messages" on public.verification_request_messages;
create policy "members and helpdesk read verification messages"
on public.verification_request_messages for select to authenticated
using (
  public.is_helpdesk_staff()
  or exists (
    select 1 from public.member_verification_requests r
    where r.id = request_id and r.user_id = auth.uid()
  )
);

drop policy if exists "members and helpdesk read verification events" on public.verification_request_events;
create policy "members and helpdesk read verification events"
on public.verification_request_events for select to authenticated
using (
  public.is_helpdesk_staff()
  or exists (
    select 1 from public.member_verification_requests r
    where r.id = request_id and r.user_id = auth.uid()
  )
);

create or replace function public.submit_my_verification_request(p_request_note text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_request_id uuid;
  v_note text := trim(coalesce(p_request_note,''));
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  if char_length(v_note) < 10 or char_length(v_note) > 2000 then
    raise exception 'Please provide a short explanation between 10 and 2000 characters';
  end if;
  if exists (
    select 1 from public.member_verification_requests
    where user_id = v_user and status in ('pending','needs_info')
  ) then
    raise exception 'You already have an active verification request';
  end if;

  insert into public.member_verification_requests(user_id,request_note)
  values(v_user,v_note)
  returning id into v_request_id;

  insert into public.verification_request_events(request_id,actor_id,event_type,new_status)
  values(v_request_id,v_user,'submitted','pending');
  return v_request_id;
end;
$$;

create or replace function public.send_verification_message(p_request_id uuid,p_body text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_body text := trim(coalesce(p_body,''));
  v_owner uuid;
  v_status text;
  v_message_id uuid;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  if char_length(v_body) < 1 or char_length(v_body) > 2000 then
    raise exception 'Message must contain 1 to 2000 characters';
  end if;

  select r.user_id,r.status into v_owner,v_status
  from public.member_verification_requests r
  where r.id=p_request_id;
  if not found then raise exception 'Verification request not found'; end if;
  if v_owner <> v_user and not public.is_helpdesk_staff() then
    raise exception 'Access denied';
  end if;
  if v_status in ('approved','rejected') then
    raise exception 'This verification request is closed';
  end if;
  if v_owner = v_user and v_status not in ('pending','needs_info') then
    raise exception 'This request is not accepting member replies';
  end if;

  if (
    select count(*) from public.verification_request_messages m
    where m.sender_id=v_user and m.created_at > now() - interval '1 hour'
  ) >= 20 then
    raise exception 'Message rate limit reached; try again later';
  end if;

  insert into public.verification_request_messages(request_id,sender_id,body)
  values(p_request_id,v_user,v_body)
  returning id into v_message_id;

  insert into public.verification_request_events(request_id,actor_id,event_type)
  values(p_request_id,v_user,'message_sent');

  if v_user = v_owner then
    insert into public.notifications(user_id,title,body,category)
    select r.user_id,'নতুন Helpdesk বার্তা','একটি ব্যক্তিগত verification request-এ নতুন বার্তা এসেছে।','verification'
    from public.app_user_roles r
    where r.role in ('owner','super_admin','admin','moderator') and r.user_id <> v_user;
  else
    insert into public.notifications(user_id,title,body,category)
    values(v_owner,'Helpdesk থেকে নতুন বার্তা','আপনার verification request-এ নতুন ব্যক্তিগত বার্তা এসেছে।','verification');
  end if;
  return v_message_id;
end;
$$;

create or replace function public.review_verification_request(
  p_request_id uuid,
  p_status text,
  p_staff_note text default null
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_old_status text;
  v_note text := nullif(trim(coalesce(p_staff_note,'')),'');
begin
  if v_actor is null or not public.is_helpdesk_staff() then
    raise exception 'Authorized helpdesk staff only';
  end if;
  if p_status not in ('pending','needs_info','approved','rejected') then
    raise exception 'Invalid verification status';
  end if;
  if v_note is not null and char_length(v_note)>2000 then
    raise exception 'Staff note is too long';
  end if;

  select status into v_old_status
  from public.member_verification_requests
  where id=p_request_id
  for update;
  if not found then raise exception 'Verification request not found'; end if;

  update public.member_verification_requests
  set status=p_status,
      staff_note=v_note,
      reviewed_by=v_actor,
      reviewed_at=now(),
      updated_at=now()
  where id=p_request_id;

  insert into public.verification_request_events(
    request_id,actor_id,event_type,old_status,new_status
  ) values (p_request_id,v_actor,'status_changed',v_old_status,p_status);
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  select v_actor,r.user_id,'verification_request_reviewed',
    jsonb_build_object('request_id',p_request_id,'old_status',v_old_status,
      'new_status',p_status)
  from public.member_verification_requests r
  where r.id=p_request_id;
  insert into public.notifications(user_id,title,body,category)
  select r.user_id,'Verification status updated',
    'Your private verification request status is now: ' || p_status || '.',
    'verification'
  from public.member_verification_requests r
  where r.id=p_request_id;
  return true;
end;
$$;

revoke all on function public.submit_my_verification_request(text) from public,anon;
revoke all on function public.send_verification_message(uuid,text) from public,anon;
revoke all on function public.review_verification_request(uuid,text,text) from public,anon;
grant execute on function public.submit_my_verification_request(text) to authenticated;
grant execute on function public.send_verification_message(uuid,text) to authenticated;
grant execute on function public.review_verification_request(uuid,text,text) to authenticated;

drop trigger if exists member_verification_requests_touch_updated_at
  on public.member_verification_requests;
create trigger member_verification_requests_touch_updated_at
before update on public.member_verification_requests
for each row execute function public.touch_updated_at();

comment on table public.member_verification_requests is
'Private member verification/helpdesk queue. Stores a short explanation only; do not upload government IDs, passwords, OTPs or login codes.';
comment on table public.verification_request_events is
'Append-only status and activity history for member verification requests.';
