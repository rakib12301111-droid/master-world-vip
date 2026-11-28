-- MASTER WORLD VIP — no-money local work execution MVP.
-- Local deterministic processing only. No customer payment, provider API, refunds or payouts.
-- Depends on app_user_roles and is_admin_auto_work_admin().

create table if not exists public.mwvip_local_work_tasks (
  id uuid primary key default gen_random_uuid(),
  task_type text not null check (task_type in ('text_cleanup','text_quality_report','json_validate','csv_validate')),
  status text not null default 'queued'
    check (status in ('queued','running','available','claimed','submitted','accepted','rework','failed','cancelled')),
  payload jsonb not null check (jsonb_typeof(payload)='object'),
  worker_result jsonb not null default '{}'::jsonb check (jsonb_typeof(worker_result)='object'),
  member_submission jsonb not null default '{}'::jsonb check (jsonb_typeof(member_submission)='object'),
  created_by uuid not null references auth.users(id),
  assigned_member_id uuid references auth.users(id),
  reviewed_by uuid references auth.users(id),
  review_note text,
  idempotency_key text not null unique check (char_length(idempotency_key) between 8 and 180),
  attempts integer not null default 0 check (attempts between 0 and 5),
  max_attempts integer not null default 3 check (max_attempts between 1 and 5),
  lease_token uuid,
  lease_expires_at timestamptz,
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  submitted_at timestamptz,
  reviewed_at timestamptz,
  check ((status='running') = (lease_token is not null and lease_expires_at is not null))
);

create index if not exists mwvip_local_work_queue_idx
  on public.mwvip_local_work_tasks(status,created_at)
  where status in ('queued','rework');
create index if not exists mwvip_local_work_member_idx
  on public.mwvip_local_work_tasks(assigned_member_id,status,created_at desc);

alter table public.mwvip_local_work_tasks enable row level security;
revoke all on public.mwvip_local_work_tasks from public,anon,authenticated;

create or replace function public.admin_enqueue_local_work_task(
  p_task_type text,p_payload jsonb,p_idempotency_key text
) returns uuid
language plpgsql security definer set search_path=''
as $$
declare v_id uuid; v_text text;
begin
  if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
  if p_task_type not in ('text_cleanup','text_quality_report','json_validate','csv_validate') then
    raise exception 'Unsupported local work task type';
  end if;
  if jsonb_typeof(coalesce(p_payload,'{}'::jsonb))<>'object' then raise exception 'Payload must be a JSON object'; end if;
  if char_length(btrim(coalesce(p_idempotency_key,''))) not between 8 and 180 then raise exception 'Valid idempotency key required'; end if;
  if p_task_type in ('text_cleanup','text_quality_report') then
    v_text:=p_payload->>'text';
    if v_text is null or char_length(v_text)>50000 then raise exception 'Text input is required and must be at most 50000 characters'; end if;
  elsif p_task_type='json_validate' then
    v_text:=p_payload->>'json_text';
    if v_text is null or char_length(v_text)>50000 then raise exception 'json_text is required and must be at most 50000 characters'; end if;
  elsif p_task_type='csv_validate' then
    v_text:=p_payload->>'csv_text';
    if v_text is null or char_length(v_text)>50000 then raise exception 'csv_text is required and must be at most 50000 characters'; end if;
  end if;
  insert into public.mwvip_local_work_tasks(task_type,payload,created_by,idempotency_key)
  values(p_task_type,p_payload,auth.uid(),p_idempotency_key)
  on conflict(idempotency_key) do update set idempotency_key=excluded.idempotency_key
  returning id into v_id;
  return v_id;
end $$;

create or replace function public.worker_claim_local_work_task()
returns setof public.mwvip_local_work_tasks
language plpgsql security definer set search_path=''
as $$
declare v_id uuid; v_lease uuid;
begin
  if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
  with candidate as (
    select id from public.mwvip_local_work_tasks
    where status in ('queued','rework') and attempts<max_attempts
    order by created_at for update skip locked limit 1
  )
  select id into v_id from candidate;
  if v_id is null then return; end if;
  v_lease:=gen_random_uuid();
  update public.mwvip_local_work_tasks
  set status='running',attempts=attempts+1,lease_token=v_lease,
      lease_expires_at=now()+interval '5 minutes',last_error=null,updated_at=now()
  where id=v_id;
  return query select * from public.mwvip_local_work_tasks where id=v_id;
end $$;

create or replace function public.worker_finish_local_work_task(
  p_task_id uuid,p_lease_token uuid,p_success boolean,p_result jsonb default '{}'::jsonb,p_error text default null
) returns boolean
language plpgsql security definer set search_path=''
as $$
declare v_task public.mwvip_local_work_tasks%rowtype;
begin
  if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
  select * into v_task from public.mwvip_local_work_tasks
  where id=p_task_id and status='running' and lease_token=p_lease_token for update;
  if not found or now()>v_task.lease_expires_at then raise exception 'Task lease invalid or expired'; end if;
  if p_success then
    if jsonb_typeof(coalesce(p_result,'{}'::jsonb))<>'object' then raise exception 'Worker result must be a JSON object'; end if;
    update public.mwvip_local_work_tasks set status='available',worker_result=p_result,
      lease_token=null,lease_expires_at=null,last_error=null,updated_at=now() where id=p_task_id;
  else
    update public.mwvip_local_work_tasks
    set status=case when attempts>=max_attempts then 'failed' else 'queued' end,
      lease_token=null,lease_expires_at=null,last_error=left(coalesce(p_error,'Local worker failed'),500),updated_at=now()
    where id=p_task_id;
  end if;
  return true;
end $$;

create or replace function public.member_list_local_work_tasks()
returns setof public.mwvip_local_work_tasks
language plpgsql stable security definer set search_path=''
as $$
begin
  if public.get_my_admin_access()<>'member' then raise exception 'Member access required'; end if;
  return query select * from public.mwvip_local_work_tasks
    where assigned_member_id=auth.uid()
    order by created_at desc limit 100;
end $$;

create or replace function public.member_claim_next_local_work_task()
returns setof public.mwvip_local_work_tasks
language plpgsql security definer set search_path=''
as $
declare v_id uuid;
begin
  if public.get_my_admin_access()<>'member' then raise exception 'Member access required'; end if;
  select id into v_id from public.mwvip_local_work_tasks
  where status='available' and assigned_member_id is null
  order by created_at for update skip locked limit 1;
  if v_id is null then return; end if;
  update public.mwvip_local_work_tasks set status='claimed',assigned_member_id=auth.uid(),updated_at=now()
  where id=v_id;
  return query select * from public.mwvip_local_work_tasks where id=v_id;
end $;

create or replace function public.admin_list_local_work_tasks()
returns setof public.mwvip_local_work_tasks
language plpgsql stable security definer set search_path=''
as $
begin
  if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
  return query select * from public.mwvip_local_work_tasks order by created_at desc limit 250;
end $;

create or replace function public.member_claim_local_work_task(p_task_id uuid)
returns boolean
language plpgsql security definer set search_path=''
as $$
begin
  if public.get_my_admin_access()<>'member' then raise exception 'Member access required'; end if;
  update public.mwvip_local_work_tasks set status='claimed',assigned_member_id=auth.uid(),updated_at=now()
  where id=p_task_id and status='available' and assigned_member_id is null;
  if not found then raise exception 'Task is no longer available'; end if;
  return true;
end $$;

create or replace function public.member_submit_local_work_task(p_task_id uuid,p_submission jsonb)
returns boolean
language plpgsql security definer set search_path=''
as $$
begin
  if public.get_my_admin_access()<>'member' then raise exception 'Member access required'; end if;
  if jsonb_typeof(coalesce(p_submission,'{}'::jsonb))<>'object' or p_submission='{}'::jsonb then
    raise exception 'A non-empty submission object is required';
  end if;
  update public.mwvip_local_work_tasks
  set status='submitted',member_submission=p_submission,submitted_at=now(),updated_at=now()
  where id=p_task_id and status='claimed' and assigned_member_id=auth.uid();
  if not found then raise exception 'Task is not assigned to this member'; end if;
  return true;
end $$;

create or replace function public.admin_review_local_work_task(
  p_task_id uuid,p_accept boolean,p_review_note text default null
) returns boolean
language plpgsql security definer set search_path=''
as $$
begin
  if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
  if char_length(coalesce(p_review_note,''))>1000 then raise exception 'Review note is too long'; end if;
  update public.mwvip_local_work_tasks
  set status=case when p_accept then 'accepted' else 'rework' end,
      assigned_member_id=case when p_accept then assigned_member_id else null end,
      member_submission=case when p_accept then member_submission else '{}'::jsonb end,
      reviewed_by=auth.uid(),reviewed_at=now(),review_note=left(coalesce(p_review_note,''),1000),updated_at=now()
  where id=p_task_id and status='submitted';
  if not found then raise exception 'Submitted task not found'; end if;
  return true;
end $$;

revoke all on function public.admin_enqueue_local_work_task(text,jsonb,text) from public,anon;
revoke all on function public.worker_claim_local_work_task() from public,anon,authenticated;
revoke all on function public.worker_finish_local_work_task(uuid,uuid,boolean,jsonb,text) from public,anon,authenticated;
revoke all on function public.member_list_local_work_tasks() from public,anon;
revoke all on function public.member_claim_next_local_work_task() from public,anon;
revoke all on function public.admin_list_local_work_tasks() from public,anon;
revoke all on function public.member_claim_local_work_task(uuid) from public,anon;
revoke all on function public.member_submit_local_work_task(uuid,jsonb) from public,anon;
revoke all on function public.admin_review_local_work_task(uuid,boolean,text) from public,anon;

grant execute on function public.admin_enqueue_local_work_task(text,jsonb,text) to authenticated;
grant execute on function public.worker_claim_local_work_task() to service_role;
grant execute on function public.worker_finish_local_work_task(uuid,uuid,boolean,jsonb,text) to service_role;
grant execute on function public.member_list_local_work_tasks() to authenticated;
grant execute on function public.member_claim_next_local_work_task() to authenticated;
grant execute on function public.admin_list_local_work_tasks() to authenticated;
grant execute on function public.member_claim_local_work_task(uuid) to authenticated;
grant execute on function public.member_submit_local_work_task(uuid,jsonb) to authenticated;
grant execute on function public.admin_review_local_work_task(uuid,boolean,text) to authenticated;

comment on table public.mwvip_local_work_tasks is
  'No-money local work queue: worker processes text/JSON/CSV inputs; members claim and submit reviewed work; no payment or payout fields.';
