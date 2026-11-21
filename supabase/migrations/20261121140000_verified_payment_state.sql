-- Provider-verified payment state for Facebook setup orders.
-- Existing manual Transaction IDs are NOT treated as paid.
alter table public.facebook_setup_orders
  add column if not exists payment_status text not null default 'unpaid'
    check (payment_status in ('unpaid','pending','paid','failed','cancelled','refunded')),
  add column if not exists paid_at timestamptz,
  add column if not exists payment_provider text;

alter table public.facebook_setup_orders
  drop constraint if exists facebook_setup_orders_payment_method_check;
alter table public.facebook_setup_orders
  add constraint facebook_setup_orders_payment_method_check
  check (payment_method in ('nagad','bkash','sslcommerz'));

create table if not exists public.facebook_setup_payment_attempts (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.facebook_setup_orders(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  provider text not null check (provider = 'sslcommerz'),
  tran_id text not null unique,
  amount numeric(12,2) not null check (amount > 0),
  currency text not null default 'BDT' check (currency = 'BDT'),
  status text not null default 'pending' check (status in ('pending','paid','failed','cancelled')),
  val_id text unique,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists fb_payment_attempt_order_idx
  on public.facebook_setup_payment_attempts(order_id, created_at desc);
alter table public.facebook_setup_payment_attempts enable row level security;
revoke all on public.facebook_setup_payment_attempts from anon, authenticated, public;
grant select on public.facebook_setup_payment_attempts to authenticated;
create policy "members read own payment attempts"
  on public.facebook_setup_payment_attempts for select to authenticated
  using (user_id = (select auth.uid()));

-- Only trusted Edge Functions using the service-role key can write payment attempts
-- or mark an order paid. Browser clients receive no INSERT/UPDATE privileges.
revoke insert, update, delete on public.facebook_setup_payment_attempts from anon, authenticated;
revoke update on public.facebook_setup_orders from authenticated;
drop policy if exists "admins update facebook setup orders" on public.facebook_setup_orders;
-- Fulfilment status is deliberately separate from payment_status.
-- Admin UI must not be able to assert payment success.
-- Authenticated clients have no UPDATE privilege on orders after this migration.
-- Admin fulfilment changes must be exposed through a separate role-checked server function.

comment on column public.facebook_setup_orders.payment_status is
  'Provider-confirmed payment state. Only server-side provider validation may set paid.';
comment on table public.facebook_setup_payment_attempts is
  'SSLCommerz payment attempts. Never mark paid based only on browser redirects or customer-submitted transaction IDs.';
