-- MASTER WORLD VIP — authenticated customer quote intake and Admin review.
-- Quotes are pre-order proposals only. Acceptance does NOT create an order or collect money.
-- Customer orders remain in the existing customer_service_orders workflow and its funding gates.

create or replace function public.is_customer_quote_staff()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.app_user_roles r
    where r.user_id = auth.uid()
      and r.role in ('owner','super_admin','admin')
  );
$$;

revoke all on function public.is_customer_quote_staff() from public, anon;
grant execute on function public.is_customer_quote_staff() to authenticated;

create table if not exists public.customer_quote_requests (
  id uuid primary key default gen_random_uuid(),
  customer_user_id uuid not null references auth.users(id) on delete restrict,
  service_key text not null check (service_key in (
    'typing','document_formatting','general_design','social_content','other'
  )),
  country text not null check (char_length(trim(country)) between 2 and 80),
  scope_description text not null check (char_length(trim(scope_description)) between 10 and 2000),
  requested_deadline text check (requested_deadline is null or char_length(trim(requested_deadline)) <= 100),
  budget_hint text check (budget_hint is null or char_length(trim(budget_hint)) <= 100),
  status text not null default 'submitted' check (status in (
    'submitted','under_review','quote_sent','accepted','declined','rejected','expired','cancelled'
  )),
  quote_amount numeric(14,2),
  quote_currency text check (quote_currency in ('BDT','USD')),
  quote_scope text,
  delivery_days integer check (delivery_days is null or delivery_days between 1 and 365),
  quote_expires_at timestamptz,
  admin_note text,
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  accepted_at timestamptz,
  declined_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (
    (status not in ('quote_sent','accepted','declined') or
      (quote_amount is not null and quote_amount > 0
       and quote_currency is not null
       and quote_scope is not null and char_length(trim(quote_scope)) between 10 and 2000
       and delivery_days is not null and quote_expires_at is not null))
  )
);

create index if not exists customer_quote_requests_customer_created_idx
  on public.customer_quote_requests(customer_user_id, created_at desc);
create index if not exists customer_quote_requests_status_created_idx
  on public.customer_quote_requests(status, created_at asc);

create table if not exists public.customer_quote_request_events (
  id bigint generated always as identity primary key,
  request_id uuid not null references public.customer_quote_requests(id) on delete restrict,
  actor_user_id uuid references auth.users(id) on delete set null,
  event_type text not null check (event_type in (
    'submitted','review_started','quote_sent','quote_accepted','quote_declined','quote_expired','rejected','cancelled'
  )),
  details jsonb not null default '{}'::jsonb check (jsonb_typeof(details)='object'),
  created_at timestamptz not null default now()
);
create index if not exists customer_quote_request_events_request_created_idx
  on public.customer_quote_request_events(request_id, created_at desc);

alter table public.customer_quote_requests enable row level security;
alter table public.customer_quote_request_events enable row level security;
revoke all on public.customer_quote_requests, public.customer_quote_request_events from public, anon, authenticated;
grant select on public.customer_quote_requests, public.customer_quote_request_events to authenticated;

drop policy if exists "customers and quote staff read quote requests" on public.customer_quote_requests;
create policy "customers and quote staff read quote requests"
  on public.customer_quote_requests for select to authenticated
  using (customer_user_id = auth.uid() or public.is_customer_quote_staff());

drop policy if exists "customers and quote staff read quote events" on public.customer_quote_request_events;
create policy "customers and quote staff read quote events"
  on public.customer_quote_request_events for select to authenticated
  using (
    public.is_customer_quote_staff()
    or exists (
      select 1 from public.customer_quote_requests q
      where q.id = request_id and q.customer_user_id = auth.uid()
    )
  );

create or replace function public.touch_customer_quote_request()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;
revoke all on function public.touch_customer_quote_request() from public, anon, authenticated;
drop trigger if exists customer_quote_request_touch_updated_at on public.customer_quote_requests;
create trigger customer_quote_request_touch_updated_at
  before update on public.customer_quote_requests
  for each row execute function public.touch_customer_quote_request();

create or replace function public.reject_customer_quote_event_mutation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  raise exception 'Customer quote events are append-only';
end;
$$;
revoke all on function public.reject_customer_quote_event_mutation() from public, anon, authenticated;
drop trigger if exists customer_quote_events_no_mutation on public.customer_quote_request_events;
create trigger customer_quote_events_no_mutation
  before update or delete on public.customer_quote_request_events
  for each row execute function public.reject_customer_quote_event_mutation();

create or replace function public.submit_my_customer_quote_request(
  p_service_key text,
  p_country text,
  p_scope_description text,
  p_requested_deadline text default null,
  p_budget_hint text default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_id uuid;
  v_service text := lower(trim(coalesce(p_service_key,'')));
  v_country text := trim(coalesce(p_country,''));
  v_scope text := trim(coalesce(p_scope_description,''));
  v_deadline text := nullif(trim(coalesce(p_requested_deadline,'')),'');
  v_budget text := nullif(trim(coalesce(p_budget_hint,'')),'');
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  if v_service not in ('typing','document_formatting','general_design','social_content','other') then
    raise exception 'Choose a valid service';
  end if;
  if char_length(v_country) not between 2 and 80 then raise exception 'Country must be 2 to 80 characters'; end if;
  if char_length(v_scope) not between 10 and 2000 then raise exception 'Work description must be 10 to 2000 characters'; end if;
  if v_deadline is not null and char_length(v_deadline)>100 then raise exception 'Deadline is too long'; end if;
  if v_budget is not null and char_length(v_budget)>100 then raise exception 'Budget hint is too long'; end if;

  perform pg_advisory_xact_lock(hashtextextended(v_user::text,0));

  if (select count(*) from public.customer_quote_requests q
      where q.customer_user_id=v_user and q.created_at>now()-interval '24 hours') >= 5 then
    raise exception 'Quote request rate limit reached; try again later';
  end if;
  if (select count(*) from public.customer_quote_requests q
      where q.customer_user_id=v_user and q.status in ('submitted','under_review','quote_sent')) >= 3 then
    raise exception 'You already have three active quote requests';
  end if;

  insert into public.customer_quote_requests(
    customer_user_id,service_key,country,scope_description,requested_deadline,budget_hint
  ) values(v_user,v_service,v_country,v_scope,v_deadline,v_budget)
  returning id into v_id;

  insert into public.customer_quote_request_events(request_id,actor_user_id,event_type)
  values(v_id,v_user,'submitted');

  insert into public.notifications(user_id,title,body,category)
  select r.user_id,'নতুন Customer Quote Request','একটি নতুন সার্ভিস কোট অনুরোধ Admin review-এর অপেক্ষায় আছে।','customer_quote'
  from public.app_user_roles r
  where r.role in ('owner','super_admin','admin');

  return v_id;
end;
$$;

create or replace function public.admin_review_customer_quote_request(
  p_request_id uuid,
  p_status text,
  p_admin_note text default null
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_user uuid;
  v_old text;
  v_note text := nullif(trim(coalesce(p_admin_note,'')),'');
  v_event text;
begin
  if v_actor is null or not public.is_customer_quote_staff() then
    raise exception 'Authorized Admin staff only';
  end if;
  if p_status not in ('under_review','rejected') then
    raise exception 'Invalid review status';
  end if;
  if v_note is not null and char_length(v_note)>2000 then raise exception 'Admin note is too long'; end if;

  select q.customer_user_id,q.status into v_user,v_old
  from public.customer_quote_requests q where q.id=p_request_id for update;
  if not found then raise exception 'Quote request not found'; end if;
  if v_old not in ('submitted','under_review') then raise exception 'Quote request is no longer reviewable'; end if;

  update public.customer_quote_requests
  set status=p_status,admin_note=v_note,reviewed_by=v_actor,reviewed_at=now()
  where id=p_request_id;

  v_event := case when p_status='under_review' then 'review_started' else 'rejected' end;
  insert into public.customer_quote_request_events(request_id,actor_user_id,event_type,details)
  values(p_request_id,v_actor,v_event,jsonb_build_object('status',p_status));

  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_actor,v_user,'customer_quote_reviewed',jsonb_build_object('request_id',p_request_id,'old_status',v_old,'new_status',p_status));

  insert into public.notifications(user_id,title,body,category)
  values(v_user,'Customer Quote Request আপডেট','আপনার কোট অনুরোধের অবস্থা আপডেট হয়েছে: '||p_status,'customer_quote');
  return true;
end;
$$;

create or replace function public.admin_send_customer_quote(
  p_request_id uuid,
  p_quote_amount numeric,
  p_quote_currency text,
  p_quote_scope text,
  p_delivery_days integer,
  p_quote_expires_at timestamptz,
  p_admin_note text default null
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_user uuid;
  v_old text;
  v_scope text := trim(coalesce(p_quote_scope,''));
  v_currency text := upper(trim(coalesce(p_quote_currency,'')));
  v_note text := nullif(trim(coalesce(p_admin_note,'')),'');
begin
  if v_actor is null or not public.is_customer_quote_staff() then
    raise exception 'Authorized Admin staff only';
  end if;
  if p_quote_amount is null or p_quote_amount<=0 or p_quote_amount::text in ('NaN','Infinity','-Infinity') then raise exception 'Quote amount must be a finite positive value'; end if;
  if v_currency not in ('BDT','USD') then raise exception 'Quote currency must be BDT or USD'; end if;
  if char_length(v_scope) not between 10 and 2000 then raise exception 'Quote scope must be 10 to 2000 characters'; end if;
  if p_delivery_days is null or p_delivery_days not between 1 and 365 then raise exception 'Delivery days must be between 1 and 365'; end if;
  if p_quote_expires_at is null or p_quote_expires_at not between now()+interval '1 hour' and now()+interval '30 days' then
    raise exception 'Quote expiry must be between 1 hour and 30 days from now';
  end if;
  if v_note is not null and char_length(v_note)>2000 then raise exception 'Admin note is too long'; end if;

  select q.customer_user_id,q.status into v_user,v_old
  from public.customer_quote_requests q where q.id=p_request_id for update;
  if not found then raise exception 'Quote request not found'; end if;
  if v_old not in ('submitted','under_review') then raise exception 'Quote request is not ready for a quote'; end if;

  update public.customer_quote_requests
  set status='quote_sent',quote_amount=p_quote_amount,quote_currency=v_currency,
      quote_scope=v_scope,delivery_days=p_delivery_days,quote_expires_at=p_quote_expires_at,
      admin_note=v_note,reviewed_by=v_actor,reviewed_at=now()
  where id=p_request_id;

  insert into public.customer_quote_request_events(request_id,actor_user_id,event_type,details)
  values(p_request_id,v_actor,'quote_sent',jsonb_build_object(
    'amount',p_quote_amount,'currency',v_currency,'delivery_days',p_delivery_days,
    'expires_at',p_quote_expires_at
  ));
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_actor,v_user,'customer_quote_sent',jsonb_build_object('request_id',p_request_id,'amount',p_quote_amount,'currency',v_currency));
  insert into public.notifications(user_id,title,body,category)
  values(v_user,'আপনার সার্ভিস Quote প্রস্তুত','আপনার কোট দেখুন এবং মেয়াদ শেষ হওয়ার আগে গ্রহণ বা প্রত্যাখ্যান করুন।','customer_quote');
  return true;
end;
$$;

create or replace function public.cancel_my_customer_quote_request(p_request_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $
declare
  v_user uuid := auth.uid();
  v_status text;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  select q.status into v_status
  from public.customer_quote_requests q
  where q.id=p_request_id and q.customer_user_id=v_user
  for update;
  if not found then raise exception 'Quote request not found'; end if;
  if v_status not in ('submitted','under_review','quote_sent') then
    raise exception 'This quote request can no longer be cancelled';
  end if;
  update public.customer_quote_requests set status='cancelled' where id=p_request_id;
  insert into public.customer_quote_request_events(request_id,actor_user_id,event_type)
  values(p_request_id,v_user,'cancelled');
  insert into public.notifications(user_id,title,body,category)
  select r.user_id,'Customer quote request cancelled','একজন গ্রাহক একটি Quote Request বাতিল করেছেন।','customer_quote'
  from public.app_user_roles r where r.role in ('owner','super_admin','admin');
  return true;
end;
$;

create or replace function public.admin_expire_customer_quotes()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_count integer := 0;
begin
  if v_actor is null or not public.is_customer_quote_staff() then
    raise exception 'Authorized Admin staff only';
  end if;
  with expired as (
    update public.customer_quote_requests q
    set status='expired'
    where q.status='quote_sent' and q.quote_expires_at<=now()
    returning q.id,q.customer_user_id
  ), events as (
    insert into public.customer_quote_request_events(request_id,actor_user_id,event_type)
    select e.id,v_actor,'quote_expired' from expired e
    returning request_id
  ), notifications_sent as (
    insert into public.notifications(user_id,title,body,category)
    select e.customer_user_id,'আপনার Quote-এর মেয়াদ শেষ',
      'আপনার Quote-এর মেয়াদ শেষ হয়েছে। নতুন Quote চাইলে নতুন অনুরোধ পাঠান।','customer_quote'
    from expired e
    returning id
  )
  select count(*) into v_count from expired;
  return v_count;
end;
$$;

create or replace function public.customer_respond_to_quote(
  p_request_id uuid,
  p_accept boolean
)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_status text;
  v_expiry timestamptz;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  select q.status,q.quote_expires_at into v_status,v_expiry
  from public.customer_quote_requests q
  where q.id=p_request_id and q.customer_user_id=v_user
  for update;
  if not found then raise exception 'Quote request not found'; end if;
  if v_status<>'quote_sent' then raise exception 'No active quote is awaiting your response'; end if;
  if v_expiry<=now() then
    update public.customer_quote_requests set status='expired' where id=p_request_id;
    insert into public.customer_quote_request_events(request_id,actor_user_id,event_type)
    values(p_request_id,v_user,'quote_expired');
    return 'expired';
  end if;

  update public.customer_quote_requests
  set status=case when p_accept then 'accepted' else 'declined' end,
      accepted_at=case when p_accept then now() else null end,
      declined_at=case when p_accept then null else now() end
  where id=p_request_id;

  insert into public.customer_quote_request_events(request_id,actor_user_id,event_type)
  values(p_request_id,v_user,case when p_accept then 'quote_accepted' else 'quote_declined' end);

  insert into public.notifications(user_id,title,body,category)
  select r.user_id,
    case when p_accept then 'Customer quote accepted' else 'Customer quote declined' end,
    'একজন গ্রাহক আপনার পাঠানো Quote-এর উত্তর দিয়েছেন।','customer_quote'
  from public.app_user_roles r
  where r.role in ('owner','super_admin','admin');
  return case when p_accept then 'accepted' else 'declined' end;
end;
$$;

revoke all on function public.submit_my_customer_quote_request(text,text,text,text,text) from public,anon;
revoke all on function public.admin_review_customer_quote_request(uuid,text,text) from public,anon;
revoke all on function public.admin_send_customer_quote(uuid,numeric,text,text,integer,timestamptz,text) from public,anon;
revoke all on function public.customer_respond_to_quote(uuid,boolean) from public,anon;
revoke all on function public.cancel_my_customer_quote_request(uuid) from public,anon;
revoke all on function public.admin_expire_customer_quotes() from public,anon;
grant execute on function public.submit_my_customer_quote_request(text,text,text,text,text) to authenticated;
grant execute on function public.admin_review_customer_quote_request(uuid,text,text) to authenticated;
grant execute on function public.admin_send_customer_quote(uuid,numeric,text,text,integer,timestamptz,text) to authenticated;
grant execute on function public.customer_respond_to_quote(uuid,boolean) to authenticated;
grant execute on function public.cancel_my_customer_quote_request(uuid) to authenticated;
grant execute on function public.admin_expire_customer_quotes() to authenticated;

comment on table public.customer_quote_requests is
'Private authenticated customer quote intake and Admin quote workflow. Accepted quote is not a paid order and does not collect funds.';
comment on table public.customer_quote_request_events is
'Append-only audit history for customer quote request submission, review, quote and response.';
