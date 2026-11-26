-- MASTER WORLD VIP backend foundation
-- Apply in Supabase SQL Editor as project owner. Review before production.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text default '',
 country text,
 avatar_url text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table public.profiles alter column display_name set default '';
create table if not exists public.user_roles (
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check (role in ('member','moderator','admin')),
 granted_at timestamptz not null default now(),
 granted_by uuid references auth.users(id),
 primary key(user_id, role)
);
create table if not exists public.privacy_consents (
 user_id uuid primary key references auth.users(id) on delete cascade,
 analytics boolean not null default false,
 personalization boolean not null default false,
 notifications boolean not null default false,
 policy_version text not null default '1.0',
 updated_at timestamptz not null default now()
);
create table if not exists public.referrals (
 id uuid primary key default gen_random_uuid(),
 referrer_id uuid not null references auth.users(id) on delete cascade,
 referred_user_id uuid unique references auth.users(id) on delete set null,
 referral_code text not null,
 status text not null default 'registered' check(status in ('registered','qualified','rewarded','cancelled')),
 created_at timestamptz not null default now(),
 qualified_at timestamptz
);
create table if not exists public.notifications (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null,
 body text not null,
 category text not null default 'general',
 read_at timestamptz,
 created_at timestamptz not null default now()
);
create table if not exists public.support_tickets (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 subject text not null,
 message text not null,
 status text not null default 'open' check(status in ('open','in_progress','resolved','closed')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.audit_logs (
 id bigint generated always as identity primary key,
 actor_id uuid references auth.users(id) on delete set null,
 action text not null,
 target_table text,
 target_id text,
 metadata jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);

create or replace function public.has_role(required_role text)
returns boolean language sql stable security definer set search_path=public
as $$ select exists(select 1 from public.user_roles r where r.user_id=auth.uid() and r.role=required_role); $$;
revoke all on function public.has_role(text) from public;
grant execute on function public.has_role(text) to authenticated;

alter table public.profiles enable row level security;
alter table public.user_roles enable row level security;
alter table public.privacy_consents enable row level security;
alter table public.referrals enable row level security;
alter table public.notifications enable row level security;
alter table public.support_tickets enable row level security;
alter table public.audit_logs enable row level security;

drop policy if exists "profile read own or admin" on public.profiles;
create policy "profile read own or admin" on public.profiles for select to authenticated using (auth.uid()=id or public.has_role('admin'));
drop policy if exists "profile insert own" on public.profiles;
create policy "profile insert own" on public.profiles for insert to authenticated with check (auth.uid()=id);
drop policy if exists "profile update own or admin" on public.profiles;
create policy "profile update own or admin" on public.profiles for update to authenticated using (auth.uid()=id or public.has_role('admin')) with check (auth.uid()=id or public.has_role('admin'));

drop policy if exists "roles readable by self or admin" on public.user_roles;
create policy "roles readable by self or admin" on public.user_roles for select to authenticated using (auth.uid()=user_id or public.has_role('admin'));
-- No client-side INSERT/UPDATE/DELETE policy for roles: grant roles only from trusted server/admin process.

drop policy if exists "consent own select" on public.privacy_consents;
create policy "consent own select" on public.privacy_consents for select to authenticated using (auth.uid()=user_id);
drop policy if exists "consent own insert" on public.privacy_consents;
create policy "consent own insert" on public.privacy_consents for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "consent own update" on public.privacy_consents;
create policy "consent own update" on public.privacy_consents for update to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "referral participant read" on public.referrals;
create policy "referral participant read" on public.referrals for select to authenticated using (auth.uid()=referrer_id or auth.uid()=referred_user_id);
drop policy if exists "referral owner insert" on public.referrals;
create policy "referral owner insert" on public.referrals for insert to authenticated with check (auth.uid()=referrer_id and referred_user_id is null);
-- Referral qualification/rewards must be performed by a trusted server workflow, not by the browser.

drop policy if exists "notifications own read" on public.notifications;
create policy "notifications own read" on public.notifications for select to authenticated using (auth.uid()=user_id);
drop policy if exists "notifications own update" on public.notifications;
create policy "notifications own update" on public.notifications for update to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists "support own read" on public.support_tickets;
create policy "support own read" on public.support_tickets for select to authenticated using (auth.uid()=user_id or public.has_role('admin'));
drop policy if exists "support own create" on public.support_tickets;
create policy "support own create" on public.support_tickets for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "support admin update" on public.support_tickets;
create policy "support admin update" on public.support_tickets for update to authenticated using (public.has_role('admin')) with check (public.has_role('admin'));

drop policy if exists "audit admin read" on public.audit_logs;
create policy "audit admin read" on public.audit_logs for select to authenticated using (public.has_role('admin'));
-- No client write policy on audit_logs.

create or replace function public.touch_updated_at()
returns trigger language plpgsql set search_path=public as $$
begin new.updated_at=now(); return new; end; $$;
drop trigger if exists profiles_touch_updated_at on public.profiles;
create trigger profiles_touch_updated_at before update on public.profiles for each row execute function public.touch_updated_at();
drop trigger if exists support_touch_updated_at on public.support_tickets;
create trigger support_touch_updated_at before update on public.support_tickets for each row execute function public.touch_updated_at();

create or replace function public.bootstrap_profile()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,display_name) values(new.id,coalesce(new.raw_user_meta_data->>'display_name','')) on conflict(id) do nothing;
 insert into public.user_roles(user_id,role) values(new.id,'member') on conflict do nothing;
 return new;
end; $$;
drop trigger if exists on_auth_user_created_mwvip on auth.users;
create trigger on_auth_user_created_mwvip after insert on auth.users for each row execute function public.bootstrap_profile();

-- Create the first admin explicitly after verifying the target account UUID:
-- insert into public.user_roles(user_id,role) values ('YOUR_AUTH_USER_UUID','admin');
-- Never expose a service/secret key in browser code.
