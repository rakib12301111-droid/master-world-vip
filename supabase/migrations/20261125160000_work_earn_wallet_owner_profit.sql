-- MASTER WORLD VIP: verified Work & Earn settlement, separate member wallet and Owner profit ledgers.
-- Additive only. No payment gateway, bank/MFS transfer, or real-money reserve is provisioned by this migration.
-- Only trusted server-side code may insert provider-verified payment events and reconciliation snapshots.
-- Apply only through the guarded backup/restore/Owner-approval workflow.

create table if not exists public.work_earn_payment_events (
  id uuid primary key default gen_random_uuid(),
  provider text not null check (provider in ('sslcommerz','bkash','nagad','bank','other_approved')),
  provider_event_id text not null unique check (char_length(btrim(provider_event_id)) between 4 and 180),
  provider_transaction_id text not null unique check (char_length(btrim(provider_transaction_id)) between 4 and 180),
  currency text not null default 'BDT' check (currency='BDT'),
  gross_amount numeric(14,2) not null check (gross_amount > 0),
  status text not null default 'pending' check (status in ('pending','settled','failed','reversed','disputed')),
  member_user_id uuid not null references auth.users(id) on delete restrict,
  work_post_id uuid references public.work_posts(id) on delete restrict,
  client_accepted_at timestamptz,
  provider_verified_at timestamptz,
  provider_payload_hash text,
  created_at timestamptz not null default now(),
  check (status <> 'settled' or (provider_verified_at is not null and client_accepted_at is not null))
);

create table if not exists public.finance_reconciliation_snapshots (
  id uuid primary key default gen_random_uuid(),
  source_reference text not null unique check (char_length(btrim(source_reference)) between 4 and 180),
  ledger_reconciled boolean not null default false,
  refund_reserves_fully_covered boolean not null default false,
  operating_budget_sufficient boolean not null default false,
  verified_at timestamptz not null,
  valid_until timestamptz not null,
  verified_by_service text not null,
  created_at timestamptz not null default now(),
  check (valid_until > verified_at)
);

create table if not exists public.work_earn_commission_settings (
  singleton boolean primary key default true check (singleton),
  owner_profit_rate numeric(5,2) not null default 20.00 check (owner_profit_rate between 0 and 50),
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now(),
  effective_from timestamptz not null default now()
);
insert into public.work_earn_commission_settings(singleton,owner_profit_rate)
values(true,20.00) on conflict(singleton) do nothing;

create table if not exists public.work_earn_commission_settings_audit (
  id bigint generated always as identity primary key,
  actor_user_id uuid not null references auth.users(id),
  old_rate numeric(5,2) not null,
  new_rate numeric(5,2) not null,
  reason text not null check (char_length(btrim(reason)) between 4 and 500),
  effective_from timestamptz not null,
  created_at timestamptz not null default now()
);

create table if not exists public.member_work_wallet_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete restrict,
  entry_type text not null check (entry_type in ('credit','debit','reversal')),
  amount numeric(14,2) not null check (amount > 0),
  currency text not null default 'BDT' check (currency='BDT'),
  settlement_id uuid,
  idempotency_key text not null unique,
  description text not null check (char_length(btrim(description)) between 3 and 300),
  created_at timestamptz not null default now()
);

create table if not exists public.owner_work_profit_ledger (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete restrict,
  settlement_id uuid not null unique,
  distributable_net_revenue numeric(14,2) not null check (distributable_net_revenue >= 0),
  applied_rate numeric(5,2) not null check (applied_rate between 0 and 50),
  profit_amount numeric(14,2) not null check (profit_amount >= 0),
  currency text not null default 'BDT' check (currency='BDT'),
  status text not null default 'accrued' check (status in ('accrued','paid','reversed')),
  payout_reference text,
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  check ((status <> 'paid') or (paid_at is not null and payout_reference is not null))
);

create table if not exists public.work_earn_settlements (
  id uuid primary key default gen_random_uuid(),
  payment_event_id uuid not null unique references public.work_earn_payment_events(id) on delete restrict,
  reconciliation_snapshot_id uuid not null references public.finance_reconciliation_snapshots(id) on delete restrict,
  member_user_id uuid not null references auth.users(id) on delete restrict,
  owner_user_id uuid not null references auth.users(id) on delete restrict,
  gross_received numeric(14,2) not null check (gross_received > 0),
  member_payable numeric(14,2) not null check (member_payable >= 0),
  platform_fee_gross numeric(14,2) not null check (platform_fee_gross >= 0),
  tax_amount numeric(14,2) not null check (tax_amount >= 0),
  provider_fee numeric(14,2) not null check (provider_fee >= 0),
  operating_cost numeric(14,2) not null check (operating_cost >= 0),
  restricted_liability numeric(14,2) not null check (restricted_liability >= 0),
  distributable_net_revenue numeric(14,2) not null check (distributable_net_revenue >= 0),
  applied_owner_rate numeric(5,2) not null check (applied_owner_rate between 0 and 50),
  owner_profit_amount numeric(14,2) not null check (owner_profit_amount >= 0),
  idempotency_key text not null unique,
  created_at timestamptz not null default now(),
  check (gross_received = member_payable + platform_fee_gross),
  check (distributable_net_revenue = greatest(0, platform_fee_gross-tax_amount-provider_fee-operating_cost-restricted_liability))
);

alter table public.member_work_wallet_ledger
  add constraint member_work_wallet_ledger_settlement_fk
  foreign key (settlement_id) references public.work_earn_settlements(id) on delete restrict;
alter table public.owner_work_profit_ledger
  add constraint owner_work_profit_ledger_settlement_fk
  foreign key (settlement_id) references public.work_earn_settlements(id) on delete restrict;

create index if not exists member_work_wallet_user_created_idx
  on public.member_work_wallet_ledger(user_id,created_at desc);
create index if not exists owner_work_profit_owner_created_idx
  on public.owner_work_profit_ledger(owner_user_id,created_at desc);

alter table public.work_earn_payment_events enable row level security;
alter table public.finance_reconciliation_snapshots enable row level security;
alter table public.work_earn_commission_settings enable row level security;
alter table public.work_earn_commission_settings_audit enable row level security;
alter table public.member_work_wallet_ledger enable row level security;
alter table public.owner_work_profit_ledger enable row level security;
alter table public.work_earn_settlements enable row level security;

revoke all on public.work_earn_payment_events,public.finance_reconciliation_snapshots,
  public.work_earn_commission_settings,public.work_earn_commission_settings_audit,
  public.member_work_wallet_ledger,public.owner_work_profit_ledger,public.work_earn_settlements
  from public,anon,authenticated;
grant select on public.member_work_wallet_ledger to authenticated;
grant select on public.owner_work_profit_ledger to authenticated;

create policy "members read own work wallet" on public.member_work_wallet_ledger
  for select to authenticated using (user_id=auth.uid());
create policy "owner reads own work profit" on public.owner_work_profit_ledger
  for select to authenticated using (
    owner_user_id=auth.uid() and exists(
      select 1 from public.app_user_roles r where r.user_id=auth.uid() and r.role='owner'
    )
  );

create or replace function public.is_work_earn_finance_owner()
returns boolean language sql stable security definer set search_path=''
as $$
  select auth.uid() is not null and exists(
    select 1 from public.app_user_roles r where r.user_id=auth.uid() and r.role='owner'
  );
$$;
revoke all on function public.is_work_earn_finance_owner() from public,anon;
grant execute on function public.is_work_earn_finance_owner() to authenticated;

create or replace function public.owner_set_work_earn_profit_rate(p_rate numeric,p_reason text)
returns boolean language plpgsql security definer set search_path=''
as $$
declare v_old numeric(5,2); v_now timestamptz := now();
begin
  if not public.is_work_earn_finance_owner() then raise exception 'Verified Owner permission required'; end if;
  if p_rate is null or p_rate < 0 or p_rate > 50 or round(p_rate,2)<>p_rate then
    raise exception 'Rate must be between 0 and 50 with at most two decimals';
  end if;
  if char_length(btrim(coalesce(p_reason,''))) not between 4 and 500 then raise exception 'Change reason required'; end if;
  select owner_profit_rate into v_old from public.work_earn_commission_settings where singleton=true for update;
  update public.work_earn_commission_settings
    set owner_profit_rate=p_rate,updated_by=auth.uid(),updated_at=v_now,effective_from=v_now
    where singleton=true;
  insert into public.work_earn_commission_settings_audit(actor_user_id,old_rate,new_rate,reason,effective_from)
    values(auth.uid(),v_old,p_rate,btrim(p_reason),v_now);
  insert into public.admin_audit_logs(actor_user_id,action,details)
    values(auth.uid(),'work_earn_owner_profit_rate_changed',
      jsonb_build_object('old_rate',v_old,'new_rate',p_rate,'reason',btrim(p_reason),'effective_from',v_now));
  return true;
end;
$$;
revoke all on function public.owner_set_work_earn_profit_rate(numeric,text) from public,anon;
grant execute on function public.owner_set_work_earn_profit_rate(numeric,text) to authenticated;

create or replace function public.get_my_work_earn_wallet()
returns jsonb language plpgsql stable security definer set search_path=''
as $$
declare v_user uuid := auth.uid(); v_credits numeric(14,2); v_debits numeric(14,2);
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  select coalesce(sum(amount) filter(where entry_type in ('credit','reversal')),0),
         coalesce(sum(amount) filter(where entry_type='debit'),0)
    into v_credits,v_debits from public.member_work_wallet_ledger where user_id=v_user;
  return jsonb_build_object(
    'earned_total',v_credits,'withdrawn_total',v_debits,
    'available_balance',greatest(0,v_credits-v_debits),
    'transactions',coalesce((select jsonb_agg(jsonb_build_object(
      'entry_type',entry_type,'amount',amount,'description',description,'created_at',created_at
    ) order by created_at desc) from (
      select entry_type,amount,description,created_at from public.member_work_wallet_ledger
      where user_id=v_user order by created_at desc limit 50
    ) x),'[]'::jsonb)
  );
end;
$$;
revoke all on function public.get_my_work_earn_wallet() from public,anon;
grant execute on function public.get_my_work_earn_wallet() to authenticated;

create or replace function public.get_my_work_earn_profit_ledger()
returns jsonb language plpgsql stable security definer set search_path=''
as $$
declare v_owner uuid := auth.uid();
begin
  if v_owner is null or not public.is_work_earn_finance_owner() then raise exception 'Verified Owner permission required'; end if;
  return jsonb_build_object(
    'rate', (select owner_profit_rate from public.work_earn_commission_settings where singleton=true),
    'profit_total', (select coalesce(sum(profit_amount),0) from public.owner_work_profit_ledger where owner_user_id=v_owner and status<>'reversed'),
    'paid_total', (select coalesce(sum(profit_amount),0) from public.owner_work_profit_ledger where owner_user_id=v_owner and status='paid'),
    'unpaid_accrued', (select coalesce(sum(profit_amount),0) from public.owner_work_profit_ledger where owner_user_id=v_owner and status='accrued'),
    'entries',coalesce((select jsonb_agg(jsonb_build_object(
      'settlement_id',settlement_id,'net_revenue',distributable_net_revenue,
      'rate',applied_rate,'profit',profit_amount,'status',status,'created_at',created_at
    ) order by created_at desc) from (
      select settlement_id,distributable_net_revenue,applied_rate,profit_amount,status,created_at
      from public.owner_work_profit_ledger where owner_user_id=v_owner order by created_at desc limit 100
    ) x),'[]'::jsonb)
  );
end;
$$;
revoke all on function public.get_my_work_earn_profit_ledger() from public,anon;
grant execute on function public.get_my_work_earn_profit_ledger() to authenticated;

-- Called only after an independently verified provider webhook and client acceptance.
-- Service role must insert the event and reconciliation snapshot using server-side credentials.
create or replace function public.service_post_work_earn_settlement(
  p_payment_event_id uuid,
  p_member_payable numeric,
  p_platform_fee_gross numeric,
  p_tax_amount numeric,
  p_provider_fee numeric,
  p_operating_cost numeric,
  p_restricted_liability numeric,
  p_reconciliation_snapshot_id uuid,
  p_idempotency_key text
)
returns jsonb language plpgsql security definer set search_path=''
as $$
declare
  v_event public.work_earn_payment_events%rowtype;
  v_snapshot public.finance_reconciliation_snapshots%rowtype;
  v_owner uuid;
  v_rate numeric(5,2);
  v_net numeric(14,2);
  v_profit numeric(14,2);
  v_settlement uuid;
  v_existing public.work_earn_settlements%rowtype;
begin
  if coalesce(auth.role(),'') <> 'service_role' then raise exception 'Trusted service role required'; end if;
  if p_idempotency_key is null or char_length(btrim(p_idempotency_key)) not between 8 and 180 then raise exception 'Valid idempotency key required'; end if;
  if p_member_payable is null or p_member_payable<0 or
     p_platform_fee_gross is null or p_platform_fee_gross<0 or
     p_tax_amount is null or p_tax_amount<0 or
     p_provider_fee is null or p_provider_fee<0 or
     p_operating_cost is null or p_operating_cost<0 or
     p_restricted_liability is null or p_restricted_liability<0 then
    raise exception 'All settlement amounts must be non-negative';
  end if;
  if round(p_member_payable,2)<>p_member_payable or round(p_platform_fee_gross,2)<>p_platform_fee_gross or
     round(p_tax_amount,2)<>p_tax_amount or round(p_provider_fee,2)<>p_provider_fee or
     round(p_operating_cost,2)<>p_operating_cost or round(p_restricted_liability,2)<>p_restricted_liability then
    raise exception 'Settlement amounts must use BDT minor-unit precision';
  end if;

  select * into v_event from public.work_earn_payment_events where id=p_payment_event_id for update;
  if not found or v_event.status<>'settled' or v_event.provider_verified_at is null or v_event.client_accepted_at is null then
    raise exception 'Provider settlement and client acceptance are not verified';
  end if;
  if v_event.currency<>'BDT' or v_event.gross_amount <> p_member_payable+p_platform_fee_gross then
    raise exception 'Gross payment must exactly equal member payable plus disclosed platform fee';
  end if;

  select * into v_existing from public.work_earn_settlements
    where payment_event_id=p_payment_event_id or idempotency_key=p_idempotency_key;
  if found then
    if v_existing.payment_event_id=p_payment_event_id and v_existing.idempotency_key=p_idempotency_key then
      return jsonb_build_object('settlement_id',v_existing.id,'duplicate',true,
        'member_credit',v_existing.member_payable,'owner_profit',v_existing.owner_profit_amount);
    end if;
    raise exception 'Payment event or idempotency key already used by another settlement';
  end if;

  select * into v_snapshot from public.finance_reconciliation_snapshots
    where id=p_reconciliation_snapshot_id for update;
  if not found or not v_snapshot.ledger_reconciled or not v_snapshot.refund_reserves_fully_covered
     or not v_snapshot.operating_budget_sufficient
     or v_snapshot.verified_at < now()-interval '15 minutes'
     or v_snapshot.valid_until < now() then
    raise exception 'Financial reconciliation, 100% refund reserves or operating budget gate failed/stale';
  end if;

  select user_id into v_owner from public.app_user_roles where role='owner' order by user_id limit 1;
  if v_owner is null then raise exception 'Verified Owner account missing'; end if;
  select owner_profit_rate into v_rate from public.work_earn_commission_settings where singleton=true for update;
  v_net := greatest(0,p_platform_fee_gross-p_tax_amount-p_provider_fee-p_operating_cost-p_restricted_liability);
  v_profit := round(v_net*v_rate/100,2);

  insert into public.work_earn_settlements(
    payment_event_id,reconciliation_snapshot_id,member_user_id,owner_user_id,
    gross_received,member_payable,platform_fee_gross,tax_amount,provider_fee,
    operating_cost,restricted_liability,distributable_net_revenue,
    applied_owner_rate,owner_profit_amount,idempotency_key
  ) values (
    v_event.id,p_reconciliation_snapshot_id,v_event.member_user_id,v_owner,
    v_event.gross_amount,p_member_payable,p_platform_fee_gross,p_tax_amount,p_provider_fee,
    p_operating_cost,p_restricted_liability,v_net,v_rate,v_profit,p_idempotency_key
  ) returning id into v_settlement;

  if p_member_payable>0 then
    insert into public.member_work_wallet_ledger(user_id,entry_type,amount,settlement_id,idempotency_key,description)
    values(v_event.member_user_id,'credit',p_member_payable,v_settlement,
      'member:'||p_idempotency_key,'Approved and provider-settled Work & Earn payment');
  end if;
  if v_profit>0 then
    insert into public.owner_work_profit_ledger(
      owner_user_id,settlement_id,distributable_net_revenue,applied_rate,profit_amount
    ) values(v_owner,v_settlement,v_net,v_rate,v_profit);
  end if;
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
    values(v_owner,v_event.member_user_id,'work_earn_payment_and_owner_profit_posted',
      jsonb_build_object('settlement_id',v_settlement,'payment_event_id',v_event.id,
        'member_payable',p_member_payable,'distributable_net_revenue',v_net,
        'owner_rate',v_rate,'owner_profit',v_profit,'reconciliation_snapshot_id',v_snapshot.id));
  return jsonb_build_object('settlement_id',v_settlement,'duplicate',false,
    'member_credit',p_member_payable,'owner_profit',v_profit,'owner_rate',v_rate,
    'distributable_net_revenue',v_net,'status','ledger_posted_not_cash_withdrawn');
end;
$$;
revoke all on function public.service_post_work_earn_settlement(uuid,numeric,numeric,numeric,numeric,numeric,numeric,uuid,text) from public,anon,authenticated;
grant execute on function public.service_post_work_earn_settlement(uuid,numeric,numeric,numeric,numeric,numeric,numeric,uuid,text) to service_role;

comment on table public.member_work_wallet_ledger is 'Append-only member Work & Earn wallet ledger; no client-side minting or editing.';
comment on table public.owner_work_profit_ledger is 'Separate Owner profit accrual ledger; accrued is not a completed bank/MFS transfer.';
comment on table public.work_earn_payment_events is 'Server-only provider-verified payment events. Browser redirects and screenshots are not proof of settlement.';
comment on table public.finance_reconciliation_snapshots is 'Server-only short-lived financial gate; does not itself prove custody of funds without independently verified provider/bank evidence.';
