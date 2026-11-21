-- MASTER WORLD VIP: Trusted Devices + Login History
-- Apply once in Supabase SQL Editor after the existing base/auth migrations.
create extension if not exists pgcrypto;

create table if not exists public.trusted_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  device_key text not null,
  device_name text not null default 'Unknown device',
  platform text not null default 'Web',
  user_agent text,
  first_seen_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  trusted_at timestamptz not null default now(),
  revoked_at timestamptz,
  unique(user_id, device_key)
);

create index if not exists trusted_devices_user_last_seen_idx
  on public.trusted_devices(user_id, last_seen_at desc);

alter table public.trusted_devices enable row level security;

drop policy if exists "Users read own trusted devices" on public.trusted_devices;
create policy "Users read own trusted devices"
  on public.trusted_devices for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "Users register own trusted devices" on public.trusted_devices;
create policy "Users register own trusted devices"
  on public.trusted_devices for insert to authenticated
  with check (user_id = (select auth.uid()));

drop policy if exists "Users update own trusted devices" on public.trusted_devices;
create policy "Users update own trusted devices"
  on public.trusted_devices for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "Users revoke own trusted devices" on public.trusted_devices;
create policy "Users revoke own trusted devices"
  on public.trusted_devices for delete to authenticated
  using (user_id = (select auth.uid()));

grant select, insert, update, delete on public.trusted_devices to authenticated;

create table if not exists public.login_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  device_key text not null,
  device_name text not null default 'Unknown device',
  platform text not null default 'Web',
  user_agent text,
  event_type text not null default 'sign_in'
    check (event_type in ('sign_in','sign_out','token_refresh')),
  occurred_at timestamptz not null default now()
);

create index if not exists login_history_user_occurred_idx
  on public.login_history(user_id, occurred_at desc);

alter table public.login_history enable row level security;

drop policy if exists "Users read own login history" on public.login_history;
create policy "Users read own login history"
  on public.login_history for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "Users append own login history" on public.login_history;
create policy "Users append own login history"
  on public.login_history for insert to authenticated
  with check (user_id = (select auth.uid()));

grant select, insert on public.login_history to authenticated;

comment on table public.trusted_devices is
  'User-managed device registry for this app. Browser device identifiers are app-generated, not hardware attestation.';
comment on table public.login_history is
  'App-observed sign-in history. Entries are recorded by the authenticated client and are not a substitute for provider-level audit logs.';
