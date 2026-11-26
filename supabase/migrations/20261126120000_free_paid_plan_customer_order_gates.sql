-- MASTER WORLD VIP — Step 3: Free/Paid plan and customer-funded order safety foundation.
-- Additive schema only. No prices are invented, no checkout/provider is connected,
-- and all paid activation/order execution remains disabled until verified server-side.
-- Requires project registry, Admin RBAC helpers and existing auth.users.

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

-- Plan subscriptions are only activated from trusted server-side provider settlement.
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

-- A customer may browse/quote for free, but a delivered service/order is never a free plan benefit.
-- A positive-price order must be provider-settled and fully funded before work can start.
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
  check (status not in ('funded','in_progress','delivered','accepted','completed') or (
    provider_transaction_id is not null and provider_event_id is not null
    and provider_settled_at is not null and funds_segregated_at is not null
    and refund_reserve_verified_at is not null and operating_budget_verified_at is not null
    and customer_price>=member_payable+refund_liability+operating_cost_budget
  )),
  check (status not in ('accepted','completed') or acceptance_evidence<>'{}'::jsonb)
);

create index if not exists customer_service_orders_project_status_idx
  on public.customer_service_orders(project_id,status,created_at desc);
create index if not exists customer_service_orders_customer_idx
  on public.customer_service_orders(customer_user_id,created_at desc);

alter table public.project_plan_catalog enable row level security;
alter table public.project_plan_subscriptions enable row level security;
alter table public.customer_service_orders enable row level security;

revoke all on public.project_plan_catalog,public.project_plan_subscriptions,
  public.customer_service_orders from public,anon,authenticated;
grant select on public.project_plan_catalog to authenticated;
grant select on public.project_plan_subscriptions,public.customer_service_orders to authenticated;

create policy "authenticated users read enabled plan catalog"
  on public.project_plan_catalog for select to authenticated using (enabled=true);
create policy "members read own plan subscriptions"
  on public.project_plan_subscriptions for select to authenticated using (user_id=auth.uid());
create policy "customers read own service orders"
  on public.customer_service_orders for select to authenticated using (customer_user_id=auth.uid());

-- Trusted server-side payment, entitlement and order services only.
grant select,insert,update on public.project_plan_subscriptions to service_role;
grant select,insert,update on public.customer_service_orders to service_role;
grant select,insert,update,delete on public.project_plan_catalog to service_role;

comment on table public.project_plan_catalog is
  'Free/Paid plan catalog. Prices and features are intentionally unconfigured until approved; rows are not seeded or enabled.';
comment on table public.project_plan_subscriptions is
  'Plan entitlements. Active status requires server-verified settled payment metadata; browser success redirects are not proof.';
comment on table public.customer_service_orders is
  'Paid customer work orders. Positive customer price and verified settlement, segregated funds, refund reserve and operating budget are required before execution.';
