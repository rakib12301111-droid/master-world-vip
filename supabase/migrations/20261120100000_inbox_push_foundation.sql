-- MASTER WORLD VIP — unified inbox and browser push subscription foundation
-- Apply after 202611190001_global_community.sql.
-- Push delivery still requires a trusted sender service and VAPID private key stored as a server secret.

alter table public.group_members
  add column if not exists last_read_at timestamptz;

create index if not exists conversation_members_user_read_idx
  on public.conversation_members(user_id,last_read_at);
create index if not exists group_members_user_read_idx
  on public.group_members(user_id,last_read_at);

create or replace function public.get_my_inbox()
returns table(
  thread_type text,
  thread_id uuid,
  title text,
  last_message text,
  last_message_at timestamptz,
  unread_count bigint
)
language sql
stable
security definer
set search_path=public
as $$
  with direct_rows as (
    select
      'direct'::text as thread_type,
      cm.conversation_id as thread_id,
      coalesce(nullif(other_profile.display_name,''),'সদস্য')::text as title,
      latest.body::text as last_message,
      latest.created_at as last_message_at,
      count(unread.id)::bigint as unread_count
    from public.conversation_members cm
    join public.conversations c on c.id=cm.conversation_id and c.kind='direct'
    join public.conversation_members other_cm
      on other_cm.conversation_id=cm.conversation_id and other_cm.user_id<>auth.uid()
    left join public.profiles other_profile on other_profile.id=other_cm.user_id
    left join lateral (
      select m.body,m.created_at
      from public.messages m
      where m.conversation_id=cm.conversation_id
      order by m.created_at desc
      limit 1
    ) latest on true
    left join public.messages unread
      on unread.conversation_id=cm.conversation_id
      and unread.sender_id<>auth.uid()
      and unread.created_at>coalesce(cm.last_read_at,'epoch'::timestamptz)
    where cm.user_id=auth.uid()
    group by cm.conversation_id,other_profile.display_name,latest.body,latest.created_at
  ),
  group_rows as (
    select
      'group'::text as thread_type,
      gm.group_id as thread_id,
      g.name::text as title,
      latest.body::text as last_message,
      latest.created_at as last_message_at,
      count(unread.id)::bigint as unread_count
    from public.group_members gm
    join public.community_groups g on g.id=gm.group_id
    left join lateral (
      select m.body,m.created_at
      from public.group_messages m
      where m.group_id=gm.group_id
      order by m.created_at desc
      limit 1
    ) latest on true
    left join public.group_messages unread
      on unread.group_id=gm.group_id
      and unread.sender_id<>auth.uid()
      and unread.created_at>coalesce(gm.last_read_at,'epoch'::timestamptz)
    where gm.user_id=auth.uid()
    group by gm.group_id,g.name,latest.body,latest.created_at
  )
  select * from direct_rows
  union all
  select * from group_rows
  order by last_message_at desc nulls last;
$$;

revoke all on function public.get_my_inbox() from public,anon;
grant execute on function public.get_my_inbox() to authenticated;

create or replace function public.mark_my_inbox_read(p_thread_type text,p_thread_id uuid)
returns boolean
language plpgsql
security definer
set search_path=public
as $$
declare affected integer;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if p_thread_type='direct' then
    update public.conversation_members
      set last_read_at=now()
      where conversation_id=p_thread_id and user_id=auth.uid();
  elsif p_thread_type='group' then
    update public.group_members
      set last_read_at=now()
      where group_id=p_thread_id and user_id=auth.uid();
  else
    raise exception 'Invalid inbox thread type';
  end if;
  get diagnostics affected=row_count;
  if affected=0 then raise exception 'Inbox thread not found or access denied'; end if;
  return true;
end;
$$;

revoke all on function public.mark_my_inbox_read(text,uuid) from public,anon;
grant execute on function public.mark_my_inbox_read(text,uuid) to authenticated;

create table if not exists public.push_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  endpoint text not null unique,
  p256dh text not null,
  auth_secret text not null,
  expiration_time bigint,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists push_subscriptions_user_idx
  on public.push_subscriptions(user_id,created_at desc);
alter table public.push_subscriptions enable row level security;

drop policy if exists "users read own push subscriptions" on public.push_subscriptions;
create policy "users read own push subscriptions"
  on public.push_subscriptions for select to authenticated
  using (user_id=auth.uid());
drop policy if exists "users add own push subscriptions" on public.push_subscriptions;
create policy "users add own push subscriptions"
  on public.push_subscriptions for insert to authenticated
  with check (user_id=auth.uid());
drop policy if exists "users update own push subscriptions" on public.push_subscriptions;
create policy "users update own push subscriptions"
  on public.push_subscriptions for update to authenticated
  using (user_id=auth.uid()) with check (user_id=auth.uid());
drop policy if exists "users remove own push subscriptions" on public.push_subscriptions;
create policy "users remove own push subscriptions"
  on public.push_subscriptions for delete to authenticated
  using (user_id=auth.uid());

drop trigger if exists push_subscriptions_touch_updated_at on public.push_subscriptions;
create trigger push_subscriptions_touch_updated_at
  before update on public.push_subscriptions
  for each row execute function public.touch_updated_at();

-- The browser can register a subscription only after explicit user action.
-- Never expose the VAPID private key or use a service-role key in browser code.
