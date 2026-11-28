-- MASTER WORLD VIP — Step 3: Free/Paid plan and customer-funded order safety foundation.
-- Additive schema only. No prices are invented, no checkout/provider is connected.
-- This records allocation evidence; it does NOT itself custody or segregate real bank funds.
-- Requires project registry and existing auth.users.

create table if not exists public.project_plan_catalog (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.earning_project_registry(id) on delete restrict,
  audience text not null check (audience in ('admin','member')),
  plan_kind text not null check (plan_kind in ('free','paid')),
  plan_code text not null unique check (plan_code ~ '^[A-Z0-9][A-Z0-9_-]{2,79}$'),
  currency text not null check (currency in ('USD','BDT')),
  price numeric(14,2) not null default 0 check (price >= 0),
  billing_period text check (billing_period in ('monthly','yearly','one_time')),
  features jsonb not null default '{}'::jsonb check (jsonb_typeof(features)='object'),
  enabled boolean not null default false,
  paid_activation_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((plan_kind='free' and price=0 and billing_period is null)
      or (plan_kind='paid' and price>0 and billing_period is not null)),
  check (not paid_activation_enabled or (plan_kind='paid' and enabled))
);

create index if not exists project_plan_catalog_lookup_idx
  on public.project_plan_catalog(project_id,audience,enabled,plan_kind);

create table if not exists public.project_plan_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete restrict,
  plan_id uuid not null references public.project_plan_catalog(id) on delete restrict,
  status text not null default 'pending_payment'
    check (status in ('pending_payment','active','expired','cancelled','refunded','disputed')),
  provider text check (provider in ('sslcommerz','bkash','nagad','stripe','paypal','other_approved')),
  provider_transaction_id text unique,
  provider_event_id text unique,
  settled_amount numeric(14,2),
  currency text check (currency in ('USD','BDT')),
  provider_settled_at timestamptz,
  starts_at timestamptz,
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (status<>'active' or (
    provider_transaction_id is not null and provider_event_id is not null
    and settled_amount>0 and currency is not null and provider_settled_at is not null
    and starts_at is not null and (expires_at is null or expires_at>starts_at)
  ))
);

create index if not exists project_plan_subscriptions_user_idx
  on public.project_plan_subscriptions(user_id,status,created_at desc);

-- Customer service delivery is always a positive-price paid order.
create table if not exists public.customer_service_orders (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.earning_project_registry(id) on delete restrict,
  customer_user_id uuid not null references auth.users(id) on delete restrict,
  currency text not null check (currency in ('USD','BDT')),
  customer_price numeric(14,2) not null check (customer_price>0),
  member_payable numeric(14,2) not null check (member_payable>=0),
  refund_liability numeric(14,2) not null check (refund_liability>=0),
  operating_cost_budget numeric(14,2) not null check (operating_cost_budget>=0),
  status text not null default 'pending_payment'
    check (status in ('pending_payment','funded','in_progress','delivered','accepted','completed','cancelled','disputed','refunded')),
  provider text check (provider in ('sslcommerz','bkash','nagad','stripe','paypal','other_approved')),
  provider_transaction_id text unique,
  provider_event_id text unique,
  provider_settled_at timestamptz,
  funds_segregated_at timestamptz,
  refund_reserve_verified_at timestamptz,
  operating_budget_verified_at timestamptz,
  scope_terms jsonb not null default '{}'::jsonb check (jsonb_typeof(scope_terms)='object'),
  acceptance_evidence jsonb not null default '{}'::jsonb check (jsonb_typeof(acceptance_evidence)='object'),
  idempotency_key text not null unique check (char_length(idempotency_key) between 8 and 180),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (customer_price>=member_payable+refund_liability+operating_cost_budget),
  check (status not in ('funded','in_progress','delivered','accepted','completed') or (
    provider_transaction_id is not null and provider_event_id is not null
    and provider_settled_at is not null and funds_segregated_at is not null
    and refund_reserve_verified_at is not null and operating_budget_verified_at is not null
  )),
  check (status not in ('accepted','completed') or acceptance_evidence<>'{}'::jsonb)
);

create index if not exists customer_service_orders_project_status_idx
  on public.customer_service_orders(project_id,status,created_at desc);
create index if not exists customer_service_orders_customer_idx
  on public.customer_service_orders(customer_user_id,created_at desc);

-- One independently reconciled locked allocation per protected money bucket.
-- These rows are internal allocation evidence, not proof of an external bank trust account.
create table if not exists public.customer_order_fund_allocations (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.customer_service_orders(id) on delete restrict,
  bucket text not null check (bucket in ('member_payable','refund_reserve','operating_cost')),
  currency text not null check (currency in ('USD','BDT')),
  amount numeric(14,2) not null check (amount>=0),
  state text not null default 'locked'
    check (state in ('locked','released','refunded','consumed')),
  reconciliation_reference text not null check (char_length(reconciliation_reference) between 8 and 180),
  reconciled_at timestamptz not null,
  created_at timestamptz not null default now(),
  unique(order_id,bucket)
);

create index if not exists customer_order_fund_allocations_order_idx
  on public.customer_order_fund_allocations(order_id,bucket);

-- Entitlements only activate for an enabled paid offer with exact settled price/currency.
create or replace function public.validate_project_plan_subscription()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_plan public.project_plan_catalog%rowtype;
begin
  if new.status='active' then
    select * into v_plan
      from public.project_plan_catalog
      where id=new.plan_id
      for share;
    if not found or v_plan.plan_kind<>'paid' or not v_plan.enabled
      or not v_plan.paid_activation_enabled then
      raise exception 'Paid plan is not enabled for activation';
    end if;
    if new.settled_amount is distinct from v_plan.price
      or new.currency is distinct from v_plan.currency then
      raise exception 'Settled plan amount/currency does not match catalog';
    end if;
  end if;
  return new;
end;
$function$;

revoke all on function public.validate_project_plan_subscription() from public,anon,authenticated;
create trigger project_plan_subscription_validate
  before insert or update on public.project_plan_subscriptions
  for each row execute function public.validate_project_plan_subscription();

-- Work may start only for an active project with correct currency, complete terms,
-- verified provider settlement and three exactly matching locked fund allocations.
create or replace function public.validate_customer_service_order()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_project public.earning_project_registry%rowtype;
  v_allocation_count integer;
  v_allocations_match boolean;
begin
  select * into v_project
    from public.earning_project_registry
    where id=new.project_id
    for share;
  if not found or new.currency is distinct from v_project.revenue_currency then
    raise exception 'Customer order project/currency mismatch';
  end if;

  if new.status in ('funded','in_progress','delivered','accepted','completed') then
    if not v_project.execution_enabled or not v_project.revenue_collection_enabled
      or v_project.lifecycle_status<>'active' then
      raise exception 'Project is not approved for customer order execution';
    end if;
    if new.scope_terms='{}'::jsonb then
      raise exception 'Customer scope and order terms must be recorded before funding';
    end if;
    if new.provider_transaction_id is null or new.provider_event_id is null
      or new.provider_settled_at is null then
      raise exception 'Verified provider settlement is required';
    end if;
    select count(*),
      coalesce(bool_and(
        (bucket='member_payable' and amount=new.member_payable)
        or (bucket='refund_reserve' and amount=new.refund_liability)
        or (bucket='operating_cost' and amount=new.operating_cost_budget)
      ),false)
      into v_allocation_count,v_allocations_match
      from public.customer_order_fund_allocations
      where order_id=new.id
        and currency=new.currency
        and state='locked';
    if v_allocation_count<>3 or not v_allocations_match then
      raise exception 'Three matching locked fund allocations are required';
    end if;
    if new.funds_segregated_at is null or new.refund_reserve_verified_at is null
      or new.operating_budget_verified_at is null then
      raise exception 'Fund segregation, refund reserve and operating budget verification required';
    end if;
  end if;
  return new;
end;
$function$;

revoke all on function public.validate_customer_service_order() from public,anon,authenticated;
create trigger customer_service_order_validate
  before insert or update on public.customer_service_orders
  for each row execute function public.validate_customer_service_order();

alter table public.project_plan_catalog enable row level security;
alter table public.project_plan_subscriptions enable row level security;
alter table public.customer_service_orders enable row level security;
alter table public.customer_order_fund_allocations enable row level security;

revoke all on public.project_plan_catalog,public.project_plan_subscriptions,
  public.customer_service_orders,public.customer_order_fund_allocations
  from public,anon,authenticated;

grant select on public.project_plan_catalog to authenticated;
grant select on public.project_plan_subscriptions,public.customer_service_orders to authenticated;

create policy "authenticated users read enabled plan catalog"
  on public.project_plan_catalog for select to authenticated using (enabled=true);
create policy "members read own plan subscriptions"
  on public.project_plan_subscriptions for select to authenticated using (user_id=auth.uid());
create policy "customers read own service orders"
  on public.customer_service_orders for select to authenticated using (customer_user_id=auth.uid());

grant select,insert,update on public.project_plan_subscriptions to service_role;
grant select,insert,update on public.customer_service_orders to service_role;
grant select,insert,update,delete on public.project_plan_catalog to service_role;
grant select,insert,update on public.customer_order_fund_allocations to service_role;

comment on table public.project_plan_catalog is
  'Free/Paid plan catalog. Prices and features remain unconfigured until explicitly approved.';
comment on table public.project_plan_subscriptions is
  'Paid entitlement activates only after server-verified provider settlement and exact catalog amount/currency match.';
comment on table public.customer_service_orders is
  'Paid customer work orders. Execution requires provider settlement, three matching locked fund buckets, external segregation/reserve/operating verification and acceptance evidence.';
comment on table public.customer_order_fund_allocations is
  'Internal order-level allocation evidence for member payable, refund reserve and operating cost. This is not a bank custody or trust-account integration.';
