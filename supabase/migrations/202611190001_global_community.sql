-- MASTER WORLD VIP Global Community System
-- New additive migration. Apply in Supabase SQL Editor after 202611180001_master_world_vip.sql.
-- Review in a staging project first; this file does not connect to or modify a live database.

alter table public.profiles
  add column if not exists username text,
  add column if not exists bio text not null default '',
  add column if not exists is_discoverable boolean not null default true;

create unique index if not exists profiles_username_lower_uidx
  on public.profiles (lower(username)) where username is not null;
alter table public.profiles drop constraint if exists profiles_username_format_check;
alter table public.profiles add constraint profiles_username_format_check
  check (username is null or username ~ '^[A-Za-z0-9_]{3,24}$');

drop policy if exists "discoverable profiles visible to members" on public.profiles;
create policy "discoverable profiles visible to members"
  on public.profiles for select to authenticated
  using (is_discoverable = true);

create table if not exists public.friend_requests (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references auth.users(id) on delete cascade,
  addressee_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','declined','cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint friend_requests_not_self check (requester_id <> addressee_id),
  constraint friend_requests_pair_unique unique (requester_id, addressee_id)
);
create index if not exists friend_requests_addressee_status_idx
  on public.friend_requests(addressee_id,status,created_at desc);
alter table public.friend_requests enable row level security;
drop policy if exists "friend requests participant read" on public.friend_requests;
create policy "friend requests participant read" on public.friend_requests
  for select to authenticated using (auth.uid() in (requester_id,addressee_id));
drop policy if exists "friend requests requester create" on public.friend_requests;
create policy "friend requests requester create" on public.friend_requests
  for insert to authenticated with check (auth.uid()=requester_id and status='pending');
drop policy if exists "friend requests recipient respond" on public.friend_requests;
create policy "friend requests recipient respond" on public.friend_requests
  for update to authenticated using (auth.uid()=addressee_id and status='pending')
  with check (auth.uid()=addressee_id and status in ('accepted','declined'));
drop policy if exists "friend requests requester cancel" on public.friend_requests;
create policy "friend requests requester cancel" on public.friend_requests
  for delete to authenticated using (auth.uid()=requester_id and status='pending');

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  kind text not null default 'direct' check (kind in ('direct','group')),
  direct_pair_key text unique,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.conversation_members (
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  joined_at timestamptz not null default now(),
  last_read_at timestamptz,
  primary key(conversation_id,user_id)
);
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (length(trim(body)) between 1 and 5000),
  created_at timestamptz not null default now(),
  edited_at timestamptz
);
create index if not exists messages_conversation_created_idx
  on public.messages(conversation_id,created_at desc);

create or replace function public.is_conversation_member(target_conversation uuid, target_user uuid default auth.uid())
returns boolean language sql stable security definer set search_path=public
as $ select exists(select 1 from public.conversation_members cm where cm.conversation_id=target_conversation and cm.user_id=target_user); $;

alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.messages enable row level security;
drop policy if exists "conversation members read" on public.conversation_members;
create policy "conversation members read" on public.conversation_members
  for select to authenticated using (user_id=auth.uid() or public.is_conversation_member(conversation_id,auth.uid()));
drop policy if exists "conversation participants read conversations" on public.conversations;
create policy "conversation participants read conversations" on public.conversations
  for select to authenticated using (public.is_conversation_member(id,auth.uid()));
drop policy if exists "conversation members read messages" on public.messages;
create policy "conversation members read messages" on public.messages
  for select to authenticated using (public.is_conversation_member(conversation_id,auth.uid()));
drop policy if exists "conversation members send messages" on public.messages;
create policy "conversation members send messages" on public.messages
  for insert to authenticated with check (
    sender_id=auth.uid() and exists (
      select 1 from public.conversation_members cm
      where cm.conversation_id=messages.conversation_id and cm.user_id=auth.uid()
    )
  );

create or replace function public.start_direct_conversation(target_user uuid)
returns uuid language plpgsql security definer set search_path=public
as $$
declare me uuid := auth.uid(); pair_key text; conversation_id uuid;
begin
  if me is null then raise exception 'Authentication required'; end if;
  if target_user is null or target_user=me then raise exception 'Choose another member'; end if;
  if not exists (
    select 1 from public.friend_requests fr
    where fr.status='accepted'
      and ((fr.requester_id=me and fr.addressee_id=target_user)
        or (fr.requester_id=target_user and fr.addressee_id=me))
  ) then raise exception 'Accept the friend request before starting a chat'; end if;
  pair_key := least(me::text,target_user::text)||':'||greatest(me::text,target_user::text);
  insert into public.conversations(kind,direct_pair_key,created_by)
    values('direct',pair_key,me)
    on conflict(direct_pair_key) do update set direct_pair_key=excluded.direct_pair_key
    returning id into conversation_id;
  insert into public.conversation_members(conversation_id,user_id)
    values(conversation_id,me),(conversation_id,target_user)
    on conflict do nothing;
  return conversation_id;
end;
$$;
revoke all on function public.start_direct_conversation(uuid) from public;
grant execute on function public.start_direct_conversation(uuid) to authenticated;

create table if not exists public.community_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) between 2 and 80),
  description text not null default '',
  is_private boolean not null default false,
  owner_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.group_members (
  group_id uuid not null references public.community_groups(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('member','moderator','owner')),
  joined_at timestamptz not null default now(),
  primary key(group_id,user_id)
);
create table if not exists public.group_messages (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.community_groups(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (length(trim(body)) between 1 and 5000),
  created_at timestamptz not null default now()
);

-- SECURITY DEFINER membership helpers are created only after both membership
-- tables exist; this avoids referencing group_members before it is created.
create or replace function public.is_group_member(target_group uuid, target_user uuid default auth.uid())
returns boolean language sql stable security definer set search_path=public
as $ select exists(select 1 from public.group_members gm where gm.group_id=target_group and gm.user_id=target_user); $;
revoke all on function public.is_conversation_member(uuid,uuid) from public;
revoke all on function public.is_group_member(uuid,uuid) from public;
grant execute on function public.is_conversation_member(uuid,uuid) to authenticated;
grant execute on function public.is_group_member(uuid,uuid) to authenticated;
create index if not exists group_messages_group_created_idx
  on public.group_messages(group_id,created_at desc);
alter table public.community_groups enable row level security;
alter table public.group_members enable row level security;
alter table public.group_messages enable row level security;
drop policy if exists "public groups or member can read" on public.community_groups;
create policy "public groups or member can read" on public.community_groups
  for select to authenticated using (not is_private or owner_id=auth.uid() or exists (
    select 1 from public.group_members gm where gm.group_id=community_groups.id and gm.user_id=auth.uid()
  ));
drop policy if exists "members create groups" on public.community_groups;
create policy "members create groups" on public.community_groups
  for insert to authenticated with check (owner_id=auth.uid());
drop policy if exists "group owners update" on public.community_groups;
create policy "group owners update" on public.community_groups
  for update to authenticated using (owner_id=auth.uid()) with check (owner_id=auth.uid());
drop policy if exists "group members read roster" on public.group_members;
create policy "group members read roster" on public.group_members
  for select to authenticated using (exists (
    select 1 from public.community_groups g where g.id=group_members.group_id
      and (not g.is_private or public.is_group_member(g.id,auth.uid()))
  ));
drop policy if exists "members join public groups" on public.group_members;
create policy "members join public groups" on public.group_members
  for insert to authenticated with check (
    user_id=auth.uid() and role='member' and exists (
      select 1 from public.community_groups g where g.id=group_id and not g.is_private
    )
  );
drop policy if exists "group owner manages membership" on public.group_members;
create policy "group owner manages membership" on public.group_members
  for delete to authenticated using (
    user_id=auth.uid() or exists (
      select 1 from public.community_groups g where g.id=group_id and g.owner_id=auth.uid()
    )
  );
drop policy if exists "group members read posts" on public.group_messages;
create policy "group members read posts" on public.group_messages
  for select to authenticated using (public.is_group_member(group_id,auth.uid()));
drop policy if exists "group members send posts" on public.group_messages;
create policy "group members send posts" on public.group_messages
  for insert to authenticated with check (sender_id=auth.uid() and public.is_group_member(group_id,auth.uid()));

create or replace function public.create_community_group(group_name text, group_description text default '', private_group boolean default false)
returns uuid language plpgsql security definer set search_path=public
as $$
declare me uuid := auth.uid(); new_group_id uuid;
begin
  if me is null then raise exception 'Authentication required'; end if;
  insert into public.community_groups(name,description,is_private,owner_id)
    values(trim(group_name),coalesce(group_description,''),coalesce(private_group,false),me)
    returning id into new_group_id;
  insert into public.group_members(group_id,user_id,role) values(new_group_id,me,'owner');
  return new_group_id;
end;
$$;
revoke all on function public.create_community_group(text,text,boolean) from public;
grant execute on function public.create_community_group(text,text,boolean) to authenticated;

-- Friend-request and message notifications are created server-side by triggers.
create or replace function public.notify_friend_request()
returns trigger language plpgsql security definer set search_path=public
as $$
begin
  insert into public.notifications(user_id,title,body,category)
  values(new.addressee_id,'Friend request','You received a new friend request.','social');
  return new;
end;
$$;
drop trigger if exists friend_request_notification on public.friend_requests;
create trigger friend_request_notification after insert on public.friend_requests
for each row execute function public.notify_friend_request();

create or replace function public.notify_direct_message()
returns trigger language plpgsql security definer set search_path=public
as $$
begin
  insert into public.notifications(user_id,title,body,category)
  select cm.user_id,'New message','You received a new message.','message'
  from public.conversation_members cm
  where cm.conversation_id=new.conversation_id and cm.user_id<>new.sender_id;
  return new;
end;
$$;
drop trigger if exists direct_message_notification on public.messages;
create trigger direct_message_notification after insert on public.messages
for each row execute function public.notify_direct_message();

create or replace function public.notify_group_message()
returns trigger language plpgsql security definer set search_path=public
as $$
begin
  insert into public.notifications(user_id,title,body,category)
  select gm.user_id,'New group message','A group has a new message.','group'
  from public.group_members gm
  where gm.group_id=new.group_id and gm.user_id<>new.sender_id;
  return new;
end;
$$;
drop trigger if exists group_message_notification on public.group_messages;
create trigger group_message_notification after insert on public.group_messages
for each row execute function public.notify_group_message();

drop trigger if exists friend_requests_touch_updated_at on public.friend_requests;
create trigger friend_requests_touch_updated_at before update on public.friend_requests
for each row execute function public.touch_updated_at();

-- Realtime publication setup is optional; enable Realtime for messages/notifications
-- in Supabase Dashboard after applying this migration. The app can initially refresh manually.
