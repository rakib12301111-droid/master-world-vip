-- MASTER WORLD VIP: owner-only anti-theft device recovery foundation
-- Apply only after the project's backup/restore and migration safety gate.
-- This schema does NOT provide native GPS collection or IP geolocation by itself.

create table if not exists public.member_recovery_devices (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  device_id uuid not null,
  platform text not null check (platform in ('android','ios')),
  device_label text not null check (char_length(device_label) between 1 and 100),
  app_version text,
  enrolled_at timestamptz not null default now(),
  last_seen_at timestamptz,
  sharing_enabled boolean not null default false,
  revoked_at timestamptz,
  unique (owner_user_id, device_id)
);

create table if not exists public.member_lost_device_reports (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  device_id uuid not null,
  report_status text not null default 'lost' check (report_status in ('lost','recovered','closed')),
  owner_note text check (owner_note is null or char_length(owner_note) <= 1000),
  created_at timestamptz not null default now(),
  resolved_at timestamptz,
  foreign key (owner_user_id, device_id)
    references public.member_recovery_devices(owner_user_id, device_id) on delete cascade
);

create table if not exists public.member_recovery_location_samples (
  id bigint generated always as identity primary key,
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  device_id uuid not null,
  latitude double precision not null check (latitude between -90 and 90),
  longitude double precision not null check (longitude between -180 and 180),
  accuracy_m double precision check (accuracy_m is null or accuracy_m >= 0),
  captured_at timestamptz not null,
  received_at timestamptz not null default now(),
  source text not null default 'native_gps' check (source in ('native_gps')),
  foreign key (owner_user_id, device_id)
    references public.member_recovery_devices(owner_user_id, device_id) on delete cascade
);

-- Server-only security telemetry. Never expose raw IP through member-facing RLS.
create table if not exists public.member_recovery_connection_events (
  id bigint generated always as identity primary key,
  owner_user_id uuid references auth.users(id) on delete set null,
  device_id uuid,
  ip_address inet,
  event_at timestamptz not null default now(),
  event_type text not null check (event_type in ('authenticated_request','device_heartbeat','lost_report')),
  retention_until timestamptz not null default (now() + interval '30 days')
);

create index if not exists recovery_devices_owner_idx on public.member_recovery_devices(owner_user_id);
create index if not exists recovery_reports_owner_idx on public.member_lost_device_reports(owner_user_id, created_at desc);
create index if not exists recovery_locations_owner_device_time_idx on public.member_recovery_location_samples(owner_user_id, device_id, captured_at desc);
create index if not exists recovery_connection_retention_idx on public.member_recovery_connection_events(retention_until);

alter table public.member_recovery_devices enable row level security;
alter table public.member_lost_device_reports enable row level security;
alter table public.member_recovery_location_samples enable row level security;
alter table public.member_recovery_connection_events enable row level security;

drop policy if exists "Owners read own recovery devices" on public.member_recovery_devices;
create policy "Owners read own recovery devices" on public.member_recovery_devices
  for select to authenticated using (owner_user_id = auth.uid());
drop policy if exists "Owners enroll own recovery devices" on public.member_recovery_devices;
create policy "Owners enroll own recovery devices" on public.member_recovery_devices
  for insert to authenticated with check (owner_user_id = auth.uid());
drop policy if exists "Owners update own recovery devices" on public.member_recovery_devices;
create policy "Owners update own recovery devices" on public.member_recovery_devices
  for update to authenticated using (owner_user_id = auth.uid()) with check (owner_user_id = auth.uid());
drop policy if exists "Owners delete own recovery devices" on public.member_recovery_devices;
create policy "Owners delete own recovery devices" on public.member_recovery_devices
  for delete to authenticated using (owner_user_id = auth.uid());

drop policy if exists "Owners read own lost reports" on public.member_lost_device_reports;
create policy "Owners read own lost reports" on public.member_lost_device_reports
  for select to authenticated using (owner_user_id = auth.uid());
drop policy if exists "Owners create own lost reports" on public.member_lost_device_reports;
create policy "Owners create own lost reports" on public.member_lost_device_reports
  for insert to authenticated with check (owner_user_id = auth.uid());

drop policy if exists "Owners read own recovery locations" on public.member_recovery_location_samples;
create policy "Owners read own recovery locations" on public.member_recovery_location_samples
  for select to authenticated using (owner_user_id = auth.uid());

-- No authenticated/anon policies on connection events: service-role/backend only.
revoke all on public.member_recovery_connection_events from anon, authenticated;
revoke all on public.member_recovery_devices, public.member_lost_device_reports, public.member_recovery_location_samples from anon;
grant select, insert, update, delete on public.member_recovery_devices to authenticated;
grant select, insert on public.member_lost_device_reports to authenticated;
grant select on public.member_recovery_location_samples to authenticated;
grant usage, select on sequence public.member_recovery_location_samples_id_seq to authenticated;

comment on table public.member_recovery_devices is 'Owner-only enrolled Android/iOS installations; device_id is a random app installation UUID, never IMEI.';
comment on table public.member_recovery_location_samples is 'Owner-only GPS samples sent by a permissioned native app; stale samples must never be labelled LIVE.';
comment on table public.member_recovery_connection_events is 'Backend-only IP/security telemetry with short retention; IP is not GPS and is not member-searchable.';
