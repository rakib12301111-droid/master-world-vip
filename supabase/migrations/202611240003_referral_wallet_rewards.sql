-- MASTER WORLD VIP — funded referral rewards, wallet ledger and withdrawals
-- Additive migration. Production apply requires the documented backup + restore-test gate.
-- No client can mint wallet credit or mark a withdrawal paid.

create table if not exists public.referral_reward_settings (
  singleton boolean primary key default true check (singleton),
  reward_amount numeric(12,2) not null default 50.00 check (reward_amount = 50.00),
  qualification_hours integer not null default 24 check (qualification_hours = 24),
  rewards_enabled boolean not null default false,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);
insert into public.referral_reward_settings(singleton) values (true)
on conflict (singleton) do nothing;

create table if not exists public.referral_reward_fundings (
  id uuid primary key default gen_random_uuid(),
  amount numeric(12,2) not null check (amount >= 50.00),
  currency text not null default 'BDT' check (currency = 'BDT'),
  source text not null check (char_length(btrim(source)) between 3 and 80),
  funding_reference text not null unique check (char_length(btrim(funding_reference)) between 4 and 120),
  confirmed_funds boolean not null default false check (confirmed_funds),
  funded_by uuid not null references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.referral_wallet_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  entry_type text not null check (entry_type in ('credit','debit')),
  amount numeric(12,2) not null check (amount > 0),
  currency text not null default 'BDT' check (currency = 'BDT'),
  referral_id uuid references public.referrals(id),
  withdrawal_id uuid,
  description text not null,
  created_at timestamptz not null default now(),
  constraint referral_wallet_one_reward_per_referral unique(referral_id),
  constraint referral_wallet_one_debit_per_withdrawal unique(withdrawal_id)
);

create table if not exists public.referral_withdrawal_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  amount numeric(12,2) not null check (amount >= 50.00),
  currency text not null default 'BDT' check (currency = 'BDT'),
  payout_method text not null check (payout_method in ('bkash','nagad')),
  payout_account text not null check (payout_account ~ '^01[3-9][0-9]{8}$'),
  status text not null default 'pending' check (status in ('pending','approved','rejected','paid')),
  member_note text,
  admin_note text,
  payment_reference text,
  reviewed_by uuid references auth.users(id),
  requested_at timestamptz not null default now(),
  reviewed_at timestamptz,
  paid_at timestamptz
);
alter table public.referral_wallet_ledger
  drop constraint if exists referral_wallet_ledger_withdrawal_id_fkey;
alter table public.referral_wallet_ledger
  add constraint referral_wallet_ledger_withdrawal_id_fkey
  foreign key (withdrawal_id) references public.referral_withdrawal_requests(id);

create index if not exists referral_wallet_user_created_idx
  on public.referral_wallet_ledger(user_id, created_at desc);
create index if not exists referral_withdrawals_user_created_idx
  on public.referral_withdrawal_requests(user_id, requested_at desc);
create index if not exists referral_withdrawals_status_created_idx
  on public.referral_withdrawal_requests(status, requested_at);

alter table public.referral_reward_settings enable row level security;
alter table public.referral_reward_fundings enable row level security;
alter table public.referral_wallet_ledger enable row level security;
alter table public.referral_withdrawal_requests enable row level security;

drop policy if exists "member reads own referral wallet ledger" on public.referral_wallet_ledger;
create policy "member reads own referral wallet ledger"
  on public.referral_wallet_ledger for select to authenticated
  using (auth.uid() = user_id);
drop policy if exists "member reads own referral withdrawal requests" on public.referral_withdrawal_requests;
create policy "member reads own referral withdrawal requests"
  on public.referral_withdrawal_requests for select to authenticated
  using (auth.uid() = user_id);

revoke all on public.referral_reward_settings from anon, authenticated;
revoke all on public.referral_reward_fundings from anon, authenticated;
revoke insert, update, delete on public.referral_wallet_ledger from anon, authenticated;
revoke insert, update, delete on public.referral_withdrawal_requests from anon, authenticated;
grant select on public.referral_wallet_ledger to authenticated;
grant select on public.referral_withdrawal_requests to authenticated;

create or replace function public.is_referral_finance_admin()
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
revoke all on function public.is_referral_finance_admin() from public, anon;
grant execute on function public.is_referral_finance_admin() to authenticated;

create or replace function public.get_my_referral_wallet()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_earned numeric(12,2);
  v_paid numeric(12,2);
  v_reserved numeric(12,2);
  v_pending numeric(12,2);
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  select coalesce(sum(amount) filter (where entry_type='credit'),0),
         coalesce(sum(amount) filter (where entry_type='debit'),0)
    into v_earned,v_paid
    from public.referral_wallet_ledger where user_id=v_user;
  select coalesce(sum(amount) filter (where status in ('pending','approved')),0),
         coalesce(sum(amount) filter (where status='pending'),0)
    into v_reserved,v_pending
    from public.referral_withdrawal_requests where user_id=v_user;
  return jsonb_build_object(
    'earned_total',v_earned,
    'paid_total',v_paid,
    'reserved_total',v_reserved,
    'pending_withdrawal',v_pending,
    'available_balance',greatest(0,v_earned-v_paid-v_reserved),
    'transactions',coalesce((
      select jsonb_agg(jsonb_build_object(
        'entry_type',entry_type,'amount',amount,'description',description,'created_at',created_at
      ) order by created_at desc) from (
        select entry_type,amount,description,created_at
        from public.referral_wallet_ledger where user_id=v_user
        order by created_at desc limit 20
      ) t
    ),'[]'::jsonb),
    'withdrawals',coalesce((
      select jsonb_agg(jsonb_build_object(
        'id',id,'amount',amount,'method',payout_method,'status',status,
        'requested_at',requested_at,'admin_note',admin_note,'payment_reference',payment_reference
      ) order by requested_at desc) from (
        select id,amount,payout_method,status,requested_at,admin_note,payment_reference
        from public.referral_withdrawal_requests where user_id=v_user
        order by requested_at desc limit 20
      ) w
    ),'[]'::jsonb)
  );
end;
$$;
revoke all on function public.get_my_referral_wallet() from public, anon;
grant execute on function public.get_my_referral_wallet() to authenticated;

create or replace function public.request_referral_withdrawal(
  p_amount numeric,
  p_method text,
  p_account text,
  p_note text default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_earned numeric(12,2);
  v_paid numeric(12,2);
  v_reserved numeric(12,2);
  v_id uuid;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  if p_amount is null or p_amount < 50 or round(p_amount,2) <> p_amount then
    raise exception 'Minimum withdrawal is BDT 50.00';
  end if;
  if p_method not in ('bkash','nagad') then raise exception 'Unsupported payout method'; end if;
  if p_account !~ '^01[3-9][0-9]{8}$' then raise exception 'Enter a valid 11-digit Bangladesh mobile wallet number'; end if;

  perform pg_advisory_xact_lock(hashtextextended(v_user::text,0));
  select coalesce(sum(amount) filter (where entry_type='credit'),0),
         coalesce(sum(amount) filter (where entry_type='debit'),0)
    into v_earned,v_paid from public.referral_wallet_ledger where user_id=v_user;
  select coalesce(sum(amount),0) into v_reserved
    from public.referral_withdrawal_requests
    where user_id=v_user and status in ('pending','approved');
  if p_amount > greatest(0,v_earned-v_paid-v_reserved) then
    raise exception 'Insufficient available referral balance';
  end if;

  insert into public.referral_withdrawal_requests(user_id,amount,payout_method,payout_account,member_note)
  values(v_user,p_amount,p_method,p_account,nullif(left(coalesce(p_note,''),250),''))
  returning id into v_id;
  return v_id;
end;
$$;
revoke all on function public.request_referral_withdrawal(numeric,text,text,text) from public, anon;
grant execute on function public.request_referral_withdrawal(numeric,text,text,text) to authenticated;

create or replace function public.admin_add_referral_funds(
  p_amount numeric,
  p_source text,
  p_reference text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_id uuid;
  v_balance numeric(12,2);
begin
  if v_actor is null or not exists(
    select 1 from public.app_user_roles where user_id=v_actor and role='owner'
  ) then raise exception 'Only the verified Owner can add reward funds'; end if;
  if p_amount is null or p_amount < 50 or round(p_amount,2) <> p_amount then
    raise exception 'Funding amount must be at least BDT 50.00';
  end if;
  if char_length(btrim(coalesce(p_source,''))) not between 3 and 80
     or char_length(btrim(coalesce(p_reference,''))) not between 4 and 120 then
    raise exception 'A funding source and unique payment/reference record are required';
  end if;
  insert into public.referral_reward_fundings(amount,source,funding_reference,confirmed_funds,funded_by)
  values(p_amount,btrim(p_source),btrim(p_reference),true,v_actor)
  returning id into v_id;
  insert into public.admin_audit_logs(actor_user_id,action,details)
  values(v_actor,'referral_reward_funds_added',jsonb_build_object('funding_id',v_id,'amount',p_amount,'currency','BDT','reference',p_reference));
  select coalesce((select sum(amount) from public.referral_reward_fundings where confirmed_funds),0)
       - coalesce((select sum(amount) from public.referral_wallet_ledger where entry_type='credit'),0)
    into v_balance;
  return jsonb_build_object('funding_id',v_id,'remaining_budget',greatest(0,v_balance));
end;
$$;
revoke all on function public.admin_add_referral_funds(numeric,text,text) from public, anon;
grant execute on function public.admin_add_referral_funds(numeric,text,text) to authenticated;

create or replace function public.admin_set_referral_rewards_enabled(p_enabled boolean)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare v_actor uuid := auth.uid();
begin
  if v_actor is null or not exists(
    select 1 from public.app_user_roles where user_id=v_actor and role='owner'
  ) then raise exception 'Only the verified Owner can change referral reward status'; end if;
  update public.referral_reward_settings
    set rewards_enabled=p_enabled,updated_by=v_actor,updated_at=now()
    where singleton=true;
  insert into public.admin_audit_logs(actor_user_id,action,details)
  values(v_actor,'referral_rewards_enabled_changed',jsonb_build_object('enabled',p_enabled));
  return true;
end;
$$;
revoke all on function public.admin_set_referral_rewards_enabled(boolean) from public, anon;
grant execute on function public.admin_set_referral_rewards_enabled(boolean) to authenticated;

create or replace function public.get_admin_referral_finance_overview()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare v_result jsonb;
begin
  if not public.is_referral_finance_admin() then raise exception 'Owner/Admin permission required'; end if;
  select jsonb_build_object(
    'funded_total',(select coalesce(sum(amount),0) from public.referral_reward_fundings where confirmed_funds),
    'credited_total',(select coalesce(sum(amount),0) from public.referral_wallet_ledger where entry_type='credit'),
    'paid_total',(select coalesce(sum(amount),0) from public.referral_wallet_ledger where entry_type='debit'),
    'remaining_budget',greatest(0,
      (select coalesce(sum(amount),0) from public.referral_reward_fundings where confirmed_funds)
      -(select coalesce(sum(amount),0) from public.referral_wallet_ledger where entry_type='credit')),
    'rewards_enabled',(select rewards_enabled from public.referral_reward_settings where singleton=true),
    'pending_withdrawals',(select count(*) from public.referral_withdrawal_requests where status='pending')
  ) into v_result;
  return v_result;
end;
$$;
revoke all on function public.get_admin_referral_finance_overview() from public, anon;
grant execute on function public.get_admin_referral_finance_overview() to authenticated;

create or replace function public.get_admin_referral_withdrawals()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not public.is_referral_finance_admin() then raise exception 'Owner/Admin permission required'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id',w.id,'user_id',w.user_id,'display_name',coalesce(p.display_name,'Member'),
      'amount',w.amount,'method',w.payout_method,'account',w.payout_account,
      'status',w.status,'requested_at',w.requested_at,'admin_note',w.admin_note,
      'payment_reference',w.payment_reference
    ) order by w.requested_at asc)
    from public.referral_withdrawal_requests w
    left join public.profiles p on p.id=w.user_id
    where w.status in ('pending','approved')
  ),'[]'::jsonb);
end;
$$;
revoke all on function public.get_admin_referral_withdrawals() from public, anon;
grant execute on function public.get_admin_referral_withdrawals() to authenticated;

create or replace function public.admin_review_referral_withdrawal(
  p_withdrawal_id uuid,
  p_action text,
  p_note text default null,
  p_payment_reference text default null
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_request public.referral_withdrawal_requests%rowtype;
begin
  if v_actor is null or not public.is_referral_finance_admin() then
    raise exception 'Owner/Admin permission required';
  end if;
  select * into v_request from public.referral_withdrawal_requests
    where id=p_withdrawal_id for update;
  if not found then raise exception 'Withdrawal request not found'; end if;

  if p_action='approve' then
    if v_request.status <> 'pending' then raise exception 'Only pending requests can be approved'; end if;
    update public.referral_withdrawal_requests set status='approved',
      admin_note=left(coalesce(p_note,''),500),reviewed_by=v_actor,reviewed_at=now()
      where id=p_withdrawal_id;
  elsif p_action='reject' then
    if v_request.status <> 'pending' then raise exception 'Only pending requests can be rejected'; end if;
    update public.referral_withdrawal_requests set status='rejected',
      admin_note=left(coalesce(p_note,''),500),reviewed_by=v_actor,reviewed_at=now()
      where id=p_withdrawal_id;
  elsif p_action='paid' then
    if v_request.status <> 'approved' then raise exception 'Only approved requests can be marked paid'; end if;
    if char_length(btrim(coalesce(p_payment_reference,''))) < 4 then
      raise exception 'Actual bKash/Nagad transfer reference is required';
    end if;
    insert into public.referral_wallet_ledger(user_id,entry_type,amount,withdrawal_id,description)
    values(v_request.user_id,'debit',v_request.amount,p_withdrawal_id,
      'Referral withdrawal paid: '||left(p_payment_reference,120));
    update public.referral_withdrawal_requests set status='paid',
      payment_reference=left(btrim(p_payment_reference),120),
      admin_note=left(coalesce(p_note,''),500),reviewed_by=v_actor,
      reviewed_at=coalesce(reviewed_at,now()),paid_at=now()
      where id=p_withdrawal_id;
  else
    raise exception 'Action must be approve, reject or paid';
  end if;
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_actor,v_request.user_id,'referral_withdrawal_'||p_action,
    jsonb_build_object('withdrawal_id',p_withdrawal_id,'amount',v_request.amount,'method',v_request.payout_method,'reference',left(coalesce(p_payment_reference,''),120)));
  return true;
end;
$$;
revoke all on function public.admin_review_referral_withdrawal(uuid,text,text,text) from public, anon;
grant execute on function public.admin_review_referral_withdrawal(uuid,text,text,text) to authenticated;

create or replace function public.process_eligible_referrals()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
  v_reward numeric(12,2);
  v_budget numeric(12,2);
  v_qualified integer := 0;
  v_rewarded integer := 0;
begin
  if coalesce(auth.role(),'') <> 'service_role' then
    raise exception 'Service role required';
  end if;
  perform pg_advisory_xact_lock(hashtextextended('mwvip-referral-reward-processor',0));
  select reward_amount into v_reward from public.referral_reward_settings where singleton=true;
  if not exists(select 1 from public.referral_reward_settings where singleton=true and rewards_enabled=true) then
    return jsonb_build_object('qualified',0,'rewarded',0,'paused',true);
  end if;

  for v_row in
    select r.id,r.referrer_id,r.referred_user_id,r.status
    from public.referrals r
    join auth.users u on u.id=r.referred_user_id
    join public.profiles p on p.id=u.id
    where r.status in ('registered','qualified')
      and u.created_at <= now() - interval '24 hours'
      and u.confirmed_at is not null
      and char_length(btrim(coalesce(p.display_name,''))) > 0
      and r.referrer_id <> u.id
    order by r.created_at asc
    for update of r skip locked
  loop
    if v_row.status='registered' then
      update public.referrals set status='qualified',qualified_at=coalesce(qualified_at,now())
        where id=v_row.id and status='registered';
      v_qualified := v_qualified + 1;
    end if;

    if exists(select 1 from public.referral_wallet_ledger where referral_id=v_row.id) then
      update public.referrals set status='rewarded' where id=v_row.id;
      continue;
    end if;

    select
      coalesce((select sum(amount) from public.referral_reward_fundings where confirmed_funds),0)
      - coalesce((select sum(amount) from public.referral_wallet_ledger where entry_type='credit'),0)
      into v_budget;
    if v_budget < v_reward then
      exit;
    end if;

    insert into public.referral_wallet_ledger(user_id,entry_type,amount,referral_id,description)
    values(v_row.referrer_id,'credit',v_reward,v_row.id,'Successful direct referral reward');
    update public.referrals set status='rewarded' where id=v_row.id;
    v_rewarded := v_rewarded + 1;
  end loop;
  return jsonb_build_object('qualified',v_qualified,'rewarded',v_rewarded,'paused',false);
end;
$$;
revoke all on function public.process_eligible_referrals() from public, anon, authenticated;
grant execute on function public.process_eligible_referrals() to service_role;

-- No member can change funding, rewards, wallet entries, or payout states directly.
