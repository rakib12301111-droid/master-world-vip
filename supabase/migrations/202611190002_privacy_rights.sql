-- MASTER WORLD VIP Privacy & Data Rights foundation
-- Apply after 202611180001_master_world_vip.sql.
-- This creates consent history and a user-owned request queue; it does not perform
-- account deletion or certify legal compliance.

create table if not exists public.privacy_consent_events (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  analytics boolean not null default false,
  personalization boolean not null default false,
  notifications boolean not null default false,
  policy_version text not null default '1.0',
  source text not null default 'web',
  created_at timestamptz not null default now()
);
create index if not exists privacy_consent_events_user_created_idx
  on public.privacy_consent_events(user_id, created_at desc);
alter table public.privacy_consent_events enable row level security;
drop policy if exists "consent events own read" on public.privacy_consent_events;
create policy "consent events own read" on public.privacy_consent_events
  for select to authenticated using (auth.uid() = user_id);
-- No client update/delete policy: consent history is append-only from the browser.

create or replace function public.save_my_privacy_choices(
  p_analytics boolean,
  p_personalization boolean,
  p_notifications boolean,
  p_policy_version text default '1.0'
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare me uuid := auth.uid();
begin
  if me is null then raise exception 'Authentication required'; end if;
  insert into public.privacy_consents(user_id, analytics, personalization, notifications, policy_version, updated_at)
  values(me, coalesce(p_analytics,false), coalesce(p_personalization,false),
    coalesce(p_notifications,false), coalesce(nullif(p_policy_version,''),'1.0'), now())
  on conflict(user_id) do update set
    analytics=excluded.analytics,
    personalization=excluded.personalization,
    notifications=excluded.notifications,
    policy_version=excluded.policy_version,
    updated_at=now();

  insert into public.privacy_consent_events(user_id, analytics, personalization, notifications, policy_version, source)
  values(me, coalesce(p_analytics,false), coalesce(p_personalization,false),
    coalesce(p_notifications,false), coalesce(nullif(p_policy_version,''),'1.0'), 'web');
end;
$$;
revoke all on function public.save_my_privacy_choices(boolean,boolean,boolean,text) from public;
grant execute on function public.save_my_privacy_choices(boolean,boolean,boolean,text) to authenticated;

create table if not exists public.account_data_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  request_type text not null check (request_type in ('access','correction','deletion')),
  details text,
  status text not null default 'received'
    check (status in ('received','identity_check','in_review','approved','completed','rejected')),
  admin_note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  completed_at timestamptz
);
create index if not exists account_data_requests_user_created_idx
  on public.account_data_requests(user_id, created_at desc);
alter table public.account_data_requests enable row level security;
drop policy if exists "data requests own read" on public.account_data_requests;
create policy "data requests own read" on public.account_data_requests
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "data requests own create" on public.account_data_requests;
create policy "data requests own create" on public.account_data_requests
  for insert to authenticated with check (auth.uid() = user_id and status = 'received');
drop policy if exists "data requests admin read" on public.account_data_requests;
create policy "data requests admin read" on public.account_data_requests
  for select to authenticated using (public.has_role('admin'));
drop policy if exists "data requests admin update" on public.account_data_requests;
create policy "data requests admin update" on public.account_data_requests
  for update to authenticated using (public.has_role('admin')) with check (public.has_role('admin'));
drop trigger if exists account_data_requests_touch_updated_at on public.account_data_requests;
create trigger account_data_requests_touch_updated_at
before update on public.account_data_requests
for each row execute function public.touch_updated_at();

-- Fulfilment remains a controlled server/admin process:
-- verify identity, assess retention/legal holds, export/correct records, then
-- use a trusted server with Supabase service-role credentials to delete auth.users.
-- Never expose service-role credentials to the browser.
