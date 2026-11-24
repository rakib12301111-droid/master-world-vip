-- MASTER WORLD VIP — Owner monthly minimum compensation ledger
-- Additive migration only. Production apply remains gated by backup/restore and explicit Owner authorization.
-- This is an accounting ledger, not a funding source or an automatic money transfer.

create table if not exists public.owner_compensation_months (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete restrict,
  period_start date not null check (extract(day from period_start)=1),
  minimum_amount numeric(12,2) not null default 1000.00 check (minimum_amount=1000.00),
  eligible_commission numeric(12,2) not null default 0 check (eligible_commission >= 0),
  minimum_top_up numeric(12,2) not null default 1000.00 check (minimum_top_up >= 0),
  amount_due numeric(12,2) not null default 1000.00 check (amount_due >= 1000.00),
  amount_paid numeric(12,2) not null default 0 check (amount_paid >= 0),
  commission_source text,
  commission_reference text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(owner_user_id,period_start),
  check (amount_paid <= amount_due),
  check (minimum_top_up = greatest(minimum_amount-eligible_commission,0)),
  check (amount_due = greatest(minimum_amount,eligible_commission))
);

create table if not exists public.owner_compensation_payments (
  id uuid primary key default gen_random_uuid(),
  compensation_month_id uuid not null references public.owner_compensation_months(id) on delete restrict,
  owner_user_id uuid not null references auth.users(id) on delete restrict,
  amount numeric(12,2) not null check (amount > 0),
  payment_reference text not null check (char_length(btrim(payment_reference)) between 4 and 120),
  recorded_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  unique(owner_user_id,payment_reference)
);

create index if not exists owner_compensation_months_owner_period_idx
  on public.owner_compensation_months(owner_user_id,period_start desc);
create index if not exists owner_compensation_payments_owner_created_idx
  on public.owner_compensation_payments(owner_user_id,created_at desc);

alter table public.owner_compensation_months enable row level security;
alter table public.owner_compensation_payments enable row level security;
revoke all on public.owner_compensation_months from anon,authenticated;
revoke all on public.owner_compensation_payments from anon,authenticated;

create or replace function public.is_mwvip_owner()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select auth.uid() is not null and exists (
    select 1 from public.app_user_roles r
    where r.user_id=auth.uid() and r.role='owner'
  );
$$;
revoke all on function public.is_mwvip_owner() from public,anon;
grant execute on function public.is_mwvip_owner() to authenticated;

create or replace function public.ensure_owner_compensation_months()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid := auth.uid();
begin
  if v_owner is null or not public.is_mwvip_owner() then
    raise exception 'Verified Owner permission required';
  end if;
  -- Create one monthly accrual per calendar month from policy commencement.
  -- This is idempotent and backfills missed months whenever the Owner opens the ledger.
  insert into public.owner_compensation_months(
    owner_user_id,period_start,minimum_amount,eligible_commission,
    minimum_top_up,amount_due,amount_paid
  )
  select v_owner, gs::date, 1000.00, 0.00, 1000.00, 1000.00, 0.00
  from generate_series(
    date '2026-11-01',
    date_trunc('month',now() at time zone 'Asia/Dhaka')::date,
    interval '1 month'
  ) as gs
  on conflict(owner_user_id,period_start) do nothing;
end;
$$;
revoke all on function public.ensure_owner_compensation_months() from public,anon,authenticated;

create or replace function public.service_accrue_owner_compensation_months()
returns integer
language plpgsql
security definer
set search_path = ''
as $
declare
  v_owner record;
  v_inserted integer := 0;
  v_count integer := 0;
begin
  -- This entry point is callable only by service_role (or the database owner).
  for v_owner in
    select distinct r.user_id
    from public.app_user_roles r
    where r.role='owner'
  loop
    insert into public.owner_compensation_months(
      owner_user_id,period_start,minimum_amount,eligible_commission,
      minimum_top_up,amount_due,amount_paid
    )
    select v_owner.user_id,gs::date,1000.00,0.00,1000.00,1000.00,0.00
    from generate_series(
      date '2026-11-01',
      date_trunc('month',now() at time zone 'Asia/Dhaka')::date,
      interval '1 month'
    ) as gs
    on conflict(owner_user_id,period_start) do nothing;
    get diagnostics v_count = row_count;
    v_inserted := v_inserted + v_count;
  end loop;
  return v_inserted;
end;
$;
revoke all on function public.service_accrue_owner_compensation_months() from public,anon,authenticated;
grant execute on function public.service_accrue_owner_compensation_months() to service_role;

create or replace function public.get_my_owner_compensation()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid := auth.uid();
  v_result jsonb;
begin
  if v_owner is null or not public.is_mwvip_owner() then
    raise exception 'Verified Owner permission required';
  end if;
  perform public.ensure_owner_compensation_months();
  select jsonb_build_object(
    'minimum_monthly',1000.00,
    'due_total',(select coalesce(sum(m.amount_due),0) from public.owner_compensation_months m where m.owner_user_id=v_owner),
    'paid_total',(select coalesce(sum(m.amount_paid),0) from public.owner_compensation_months m where m.owner_user_id=v_owner),
    'outstanding_total',(select coalesce(sum(m.amount_due-m.amount_paid),0) from public.owner_compensation_months m where m.owner_user_id=v_owner),
    'months',coalesce((
      select jsonb_agg(jsonb_build_object(
        'id',m.id,'period_start',m.period_start,
        'minimum_amount',m.minimum_amount,
        'eligible_commission',m.eligible_commission,
        'minimum_top_up',m.minimum_top_up,
        'amount_due',m.amount_due,'amount_paid',m.amount_paid,
        'outstanding',m.amount_due-m.amount_paid,
        'commission_source',m.commission_source,
        'commission_reference',m.commission_reference
      ) order by m.period_start desc)
      from public.owner_compensation_months m
      where m.owner_user_id=v_owner
    ),'[]'::jsonb)
  ) into v_result;
  return v_result;
end;
$$;
revoke all on function public.get_my_owner_compensation() from public,anon;
grant execute on function public.get_my_owner_compensation() to authenticated;

create or replace function public.owner_set_monthly_compensation_commission(
  p_period_start date,
  p_eligible_commission numeric,
  p_source text,
  p_reference text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid := auth.uid();
  v_month public.owner_compensation_months%rowtype;
begin
  if v_owner is null or not public.is_mwvip_owner() then
    raise exception 'Verified Owner permission required';
  end if;
  if p_period_start is null or extract(day from p_period_start)<>1
     or p_period_start > date_trunc('month',now() at time zone 'Asia/Dhaka')::date then
    raise exception 'Select a valid current or past month';
  end if;
  if p_eligible_commission is null or p_eligible_commission < 0 then
    raise exception 'Commission cannot be negative';
  end if;
  if p_eligible_commission > 0 and (
    char_length(btrim(coalesce(p_source,''))) < 3
    or char_length(btrim(coalesce(p_reference,''))) < 4
  ) then
    raise exception 'Settled revenue source and non-secret ledger reference are required';
  end if;

  perform public.ensure_owner_compensation_months();
  select * into v_month from public.owner_compensation_months
    where owner_user_id=v_owner and period_start=p_period_start for update;
  if not found then raise exception 'Compensation month not found'; end if;
  if v_month.amount_paid > greatest(v_month.minimum_amount,p_eligible_commission) then
    raise exception 'New due amount cannot be lower than amounts already paid';
  end if;

  update public.owner_compensation_months
  set eligible_commission=p_eligible_commission,
      minimum_top_up=greatest(minimum_amount-p_eligible_commission,0),
      amount_due=greatest(minimum_amount,p_eligible_commission),
      commission_source=nullif(left(btrim(coalesce(p_source,'')),120),''),
      commission_reference=nullif(left(btrim(coalesce(p_reference,'')),120),''),
      updated_at=now()
  where id=v_month.id;

  insert into public.admin_audit_logs(actor_user_id,action,details)
  values(v_owner,'owner_compensation_commission_updated',
    jsonb_build_object('period_start',p_period_start,'eligible_commission',p_eligible_commission,
      'minimum_top_up',greatest(v_month.minimum_amount-p_eligible_commission,0),
      'amount_due',greatest(v_month.minimum_amount,p_eligible_commission),
      'source',left(coalesce(p_source,''),120),'reference',left(coalesce(p_reference,''),120)));
  return true;
end;
$$;
revoke all on function public.owner_set_monthly_compensation_commission(date,numeric,text,text) from public,anon;
grant execute on function public.owner_set_monthly_compensation_commission(date,numeric,text,text) to authenticated;

create or replace function public.owner_record_compensation_payment(
  p_period_start date,
  p_amount numeric,
  p_payment_reference text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid := auth.uid();
  v_month public.owner_compensation_months%rowtype;
begin
  if v_owner is null or not public.is_mwvip_owner() then
    raise exception 'Verified Owner permission required';
  end if;
  if p_period_start is null or extract(day from p_period_start)<>1
     or p_amount is null or p_amount<=0
     or char_length(btrim(coalesce(p_payment_reference,''))) < 4 then
    raise exception 'Valid month, positive payment and actual transfer reference are required';
  end if;
  select * into v_month from public.owner_compensation_months
    where owner_user_id=v_owner and period_start=p_period_start for update;
  if not found then raise exception 'Compensation month not found'; end if;
  if p_amount > (v_month.amount_due-v_month.amount_paid) then
    raise exception 'Payment exceeds outstanding amount';
  end if;

  insert into public.owner_compensation_payments(
    compensation_month_id,owner_user_id,amount,payment_reference,recorded_by
  ) values(v_month.id,v_owner,p_amount,left(btrim(p_payment_reference),120),v_owner);

  update public.owner_compensation_months
  set amount_paid=amount_paid+p_amount,updated_at=now()
  where id=v_month.id;

  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_owner,v_owner,'owner_compensation_payment_recorded',
    jsonb_build_object('period_start',p_period_start,'amount',p_amount,
      'payment_reference',left(p_payment_reference,120)));
  return true;
end;
$$;
revoke all on function public.owner_record_compensation_payment(date,numeric,text) from public,anon;
grant execute on function public.owner_record_compensation_payment(date,numeric,text) to authenticated;

-- No direct client writes: all accrual, commission and payment records go through Owner-only RPCs.
