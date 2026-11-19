-- MASTER WORLD VIP Admin RBAC — Stage 1 migration
-- IMPORTANT: Replace OWNER_EMAIL_HERE with the verified email of the platform owner.
-- Run once in Supabase SQL Editor after confirming the target project.

create table if not exists public.app_user_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('owner','super_admin','admin','moderator','member')),
  granted_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.app_user_roles enable row level security;
revoke all on public.app_user_roles from anon, authenticated;

create table if not exists public.admin_audit_logs (
  id bigint generated always as identity primary key,
  actor_user_id uuid references auth.users(id),
  target_user_id uuid references auth.users(id),
  action text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.admin_audit_logs enable row level security;
revoke all on public.admin_audit_logs from anon, authenticated;

create or replace function public.get_my_admin_access()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((select r.role from public.app_user_roles r where r.user_id = auth.uid()), 'member');
$$;

create or replace function public.owner_set_member_role(p_target_user_id uuid, p_new_role text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_actor uuid := auth.uid();
  v_old_role text;
begin
  if v_actor is null then raise exception 'Authentication required'; end if;
  if not exists (select 1 from public.app_user_roles where user_id=v_actor and role='owner') then
    raise exception 'Only the platform owner can change member roles';
  end if;
  if p_new_role not in ('member','moderator','admin','super_admin') then
    raise exception 'Invalid role';
  end if;
  if p_target_user_id is null or not exists(select 1 from auth.users where id=p_target_user_id) then
    raise exception 'Target user not found';
  end if;
  if exists(select 1 from public.app_user_roles where user_id=p_target_user_id and role='owner') then
    raise exception 'Owner role cannot be changed here';
  end if;
  select role into v_old_role from public.app_user_roles where user_id=p_target_user_id;
  insert into public.app_user_roles(user_id,role,granted_by,updated_at)
  values(p_target_user_id,p_new_role,v_actor,now())
  on conflict(user_id) do update set role=excluded.role,granted_by=v_actor,updated_at=now();
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_actor,p_target_user_id,'role_changed',jsonb_build_object('old_role',coalesce(v_old_role,'member'),'new_role',p_new_role));
  return true;
end;
$$;

create or replace function public.get_admin_audit_logs()
returns table(id bigint, actor_user_id uuid, target_user_id uuid, action text, details jsonb, created_at timestamptz)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not exists(select 1 from public.app_user_roles where user_id=auth.uid() and role='owner') then
    raise exception 'Only the platform owner can view audit logs';
  end if;
  return query select l.id,l.actor_user_id,l.target_user_id,l.action,l.details,l.created_at
    from public.admin_audit_logs l order by l.created_at desc limit 100;
end;
$$;

revoke all on function public.get_my_admin_access() from public, anon;
revoke all on function public.owner_set_member_role(uuid,text) from public, anon;
revoke all on function public.get_admin_audit_logs() from public, anon;
grant execute on function public.get_my_admin_access() to authenticated;
grant execute on function public.owner_set_member_role(uuid,text) to authenticated;
grant execute on function public.get_admin_audit_logs() to authenticated;

-- Owner bootstrap: edit the email below before running this statement.
insert into public.app_user_roles(user_id,role)
select id,'owner' from auth.users where lower(email)=lower('OWNER_EMAIL_HERE')
on conflict(user_id) do update set role='owner',updated_at=now();
