-- MASTER WORLD VIP — membership helper privacy hardening
-- Replace helpers that accepted an arbitrary user ID with caller-scoped checks.
-- Remove policies bound to the legacy two-argument helpers before dropping
-- those functions. This prevents PostgreSQL overload ambiguity during upgrade.
drop policy if exists "conversation members read" on public.conversation_members;
drop policy if exists "conversation participants read conversations" on public.conversations;
drop policy if exists "conversation members read messages" on public.messages;
drop policy if exists "group members read roster" on public.group_members;
drop policy if exists "group members read posts" on public.group_messages;
drop policy if exists "group members send posts" on public.group_messages;
drop function if exists public.is_conversation_member(uuid, uuid);
drop function if exists public.is_group_member(uuid, uuid);

-- This prevents authenticated clients from probing another member's conversation/group membership.
-- Additive migration: updates RLS policies and removes the old two-argument helper signatures.

create or replace function public.is_conversation_member(target_conversation uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.conversation_members cm
    where cm.conversation_id = target_conversation
      and cm.user_id = auth.uid()
  );
$$;

create or replace function public.is_group_member(target_group uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.group_members gm
    where gm.group_id = target_group
      and gm.user_id = auth.uid()
  );
$$;

revoke all on function public.is_conversation_member(uuid) from public, anon;
revoke all on function public.is_group_member(uuid) from public, anon;
grant execute on function public.is_conversation_member(uuid) to authenticated;
grant execute on function public.is_group_member(uuid) to authenticated;

-- Rebind conversation policies to the authenticated caller only.
drop policy if exists "conversation members read" on public.conversation_members;
create policy "conversation members read" on public.conversation_members
  for select to authenticated
  using (
    user_id = auth.uid()
    or public.is_conversation_member(conversation_id)
  );

drop policy if exists "conversation participants read conversations" on public.conversations;
create policy "conversation participants read conversations" on public.conversations
  for select to authenticated
  using (public.is_conversation_member(id));

drop policy if exists "conversation members read messages" on public.messages;
create policy "conversation members read messages" on public.messages
  for select to authenticated
  using (public.is_conversation_member(conversation_id));

-- Rebind group policies to the authenticated caller only.
drop policy if exists "group members read roster" on public.group_members;
create policy "group members read roster" on public.group_members
  for select to authenticated
  using (
    exists (
      select 1
      from public.community_groups g
      where g.id = group_members.group_id
        and (
          not g.is_private
          or public.is_group_member(g.id)
        )
    )
  );

drop policy if exists "group members read posts" on public.group_messages;
create policy "group members read posts" on public.group_messages
  for select to authenticated
  using (public.is_group_member(group_id));

drop policy if exists "group members send posts" on public.group_messages;
create policy "group members send posts" on public.group_messages
  for insert to authenticated
  with check (
    sender_id = auth.uid()
    and public.is_group_member(group_id)
  );

-- Remove the older overloads that accepted a caller-supplied target_user.
drop function if exists public.is_conversation_member(uuid, uuid);
drop function if exists public.is_group_member(uuid, uuid);
