-- Facebook account setup assistance orders.
-- Apply after the base profile/auth and Admin RBAC migrations.
-- Never store identity-document images, Facebook passwords, OTPs or login codes.

create table if not exists public.facebook_setup_orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  package_price integer not null check (package_price in (500, 750, 1000)),
  customer_name text not null check (char_length(trim(customer_name)) between 2 and 80),
  customer_phone text not null check (char_length(trim(customer_phone)) between 8 and 24),
  payment_method text not null check (payment_method in ('nagad','bkash')),
  transaction_id text not null unique check (char_length(trim(transaction_id)) between 4 and 80),
  status text not null default 'payment_review'
    check (status in ('pending_payment','payment_review','approved','in_progress','completed','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists facebook_setup_orders_user_created_idx
  on public.facebook_setup_orders(user_id, created_at desc);
create index if not exists facebook_setup_orders_status_created_idx
  on public.facebook_setup_orders(status, created_at desc);

alter table public.facebook_setup_orders enable row level security;
revoke all on public.facebook_setup_orders from anon, public;
grant select, insert on public.facebook_setup_orders to authenticated;
grant update on public.facebook_setup_orders to authenticated;

drop policy if exists "members read own facebook setup orders" on public.facebook_setup_orders;
create policy "members read own facebook setup orders"
  on public.facebook_setup_orders for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "members create own facebook setup orders" on public.facebook_setup_orders;
create policy "members create own facebook setup orders"
  on public.facebook_setup_orders for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and status = 'payment_review'
    and package_price in (500,750,1000)
  );

drop policy if exists "admins read all facebook setup orders" on public.facebook_setup_orders;
create policy "admins read all facebook setup orders"
  on public.facebook_setup_orders for select to authenticated
  using (public.get_my_admin_access() in ('owner','super_admin','admin'));

drop policy if exists "admins update facebook setup orders" on public.facebook_setup_orders;
create policy "admins update facebook setup orders"
  on public.facebook_setup_orders for update to authenticated
  using (public.get_my_admin_access() in ('owner','super_admin','admin'))
  with check (public.get_my_admin_access() in ('owner','super_admin','admin'));

comment on table public.facebook_setup_orders is
  'Customer orders for lawful Facebook account setup assistance. Never store Facebook credentials, OTPs, or identity document images.';
