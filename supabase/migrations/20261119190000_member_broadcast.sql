-- MASTER WORLD VIP — Admin-to-all-members Broadcast
-- Apply after 202611180001_master_world_vip.sql and 20261119180000_admin_rbac_owner_control.sql.
-- Broadcasts create in-app inbox deliveries. They do NOT send push notifications until a push provider is configured.

create table if not exists public.member_broadcasts (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references auth.users(id) on delete restrict,
  title text not null check (length(trim(title)) between 2 and 120),
  body text not null check (length(trim(body)) between 1 and 5000),
  created_at timestamptz not null default now()
);

create table if not exists public.member_broadcast_deliveries (
  broadcast_id uuid not null references public.member_broadcasts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  delivered_at timestamptz not null default now(),
  read_at timestamptz,
  primary key (broadcast_id,user_id)
);
create index if not exists member_broadcast_deliveries_user_time_idx
  on public.member_broadcast_deliveries(user_id,delivered_at desc);

alter table public.member_broadcasts enable row level security;
alter table public.member_broadcast_deliveries enable row level security;

drop policy if exists "members read broadcasts delivered to them" on public.member_broadcasts;
create policy "members read broadcasts delivered to them"
  on public.member_broadcasts for select to authenticated
  using (
    sender_id=auth.uid()
    or exists (
      select 1 from public.member_broadcast_deliveries d
      where d.broadcast_id=member_broadcasts.id and d.user_id=auth.uid()
    )
  );

drop policy if exists "members read own broadcast deliveries" on public.member_broadcast_deliveries;
create policy "members read own broadcast deliveries"
  on public.member_broadcast_deliveries for select to authenticated
  using (user_id=auth.uid());

drop policy if exists "members mark own broadcast read" on public.member_broadcast_deliveries;
create policy "members mark own broadcast read"
  on public.member_broadcast_deliveries for update to authenticated
  using (user_id=auth.uid()) with check (user_id=auth.uid());

revoke insert, update, delete on public.member_broadcasts from anon, authenticated;
revoke insert, delete on public.member_broadcast_deliveries from anon, authenticated;

create or replace function public.send_member_broadcast(p_title text,p_body text)
returns table(broadcast_id uuid,recipient_count integer)
language plpgsql
security definer
set search_path=public
as $$
declare
  v_actor uuid := auth.uid();
  v_broadcast_id uuid;
  v_count integer;
begin
  if v_actor is null then raise exception 'Authentication required'; end if;
  if not exists (
    select 1 from public.app_user_roles r
    where r.user_id=v_actor and r.role in ('owner','super_admin','admin')
  ) then
    raise exception 'Only authorized administrators can broadcast';
  end if;
  if length(trim(coalesce(p_title,''))) not between 2 and 120 then
    raise exception 'Title must be 2 to 120 characters';
  end if;
  if length(trim(coalesce(p_body,''))) not between 1 and 5000 then
    raise exception 'Message must be 1 to 5000 characters';
  end if;
  if (select count(*) from public.member_broadcasts
      where sender_id=v_actor and created_at > now()-interval '1 hour') >= 3 then
    raise exception 'Broadcast limit reached: maximum 3 per hour';
  end if;

  insert into public.member_broadcasts(sender_id,title,body)
  values(v_actor,trim(p_title),trim(p_body))
  returning id into v_broadcast_id;

  insert into public.member_broadcast_deliveries(broadcast_id,user_id)
  select v_broadcast_id,u.id
  from auth.users u
  where u.id <> v_actor
  on conflict do nothing;
  get diagnostics v_count = row_count;

  insert into public.notifications(user_id,title,body,category)
  select d.user_id,trim(p_title),trim(p_body),'broadcast'
  from public.member_broadcast_deliveries d
  where d.broadcast_id=v_broadcast_id;

  return query select v_broadcast_id,v_count;
end;
$$;

revoke all on function public.send_member_broadcast(text,text) from public,anon;
grant execute on function public.send_member_broadcast(text,text) to authenticated;
