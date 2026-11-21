-- Break recursive RLS between community_groups and group_members.
-- SECURITY DEFINER helpers use a fixed empty search_path and only answer the
-- caller's membership/roster-visibility question.
create or replace function public.can_read_group_roster(target_group uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.community_groups g
    where g.id = target_group
      and (
        not g.is_private
        or exists (
          select 1 from public.group_members gm
          where gm.group_id = target_group
            and gm.user_id = auth.uid()
        )
      )
  );
$$;

revoke all on function public.can_read_group_roster(uuid) from public, anon;
grant execute on function public.can_read_group_roster(uuid) to authenticated;

drop policy if exists "public groups or member can read" on public.community_groups;
create policy "public groups or member can read"
on public.community_groups
for select to authenticated
using (not is_private or public.is_group_member(id));

drop policy if exists "group members read roster" on public.group_members;
create policy "group members read roster"
on public.group_members
for select to authenticated
using (public.can_read_group_roster(group_id));

comment on function public.can_read_group_roster(uuid)
is 'RLS-safe roster visibility check; avoids recursive community_groups/group_members policies.';
