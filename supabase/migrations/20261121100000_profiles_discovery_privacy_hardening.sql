-- MASTER WORLD VIP — prevent discoverable-profile policy from widening full-row access.
-- The earlier permissive SELECT policies combine with OR. A discoverable=true
-- policy on public.profiles would therefore expose every column to every member.
-- Keep table access owner/admin-only and expose only an explicit public-field RPC.

drop policy if exists "discoverable profiles visible to members" on public.profiles;

create or replace function public.search_discoverable_profiles(
  p_search text default null,
  p_limit integer default 30
)
returns table (
  id uuid,
  username text,
  display_name text,
  bio text,
  country text,
  avatar_url text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_search text := nullif(trim(coalesce(p_search,'')), '');
  v_limit integer := least(greatest(coalesce(p_limit,30),1),50);
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  return query
  select p.id, p.username, p.display_name, p.bio, p.country, p.avatar_url
  from public.profiles p
  where p.is_discoverable = true
    and p.id <> auth.uid()
    and (
      v_search is null
      or coalesce(p.username,'') ilike '%' || v_search || '%'
      or coalesce(p.display_name,'') ilike '%' || v_search || '%'
    )
  order by p.display_name, p.username
  limit v_limit;
end;
$$;

revoke all on function public.search_discoverable_profiles(text,integer) from public, anon;
grant execute on function public.search_discoverable_profiles(text,integer) to authenticated;

comment on function public.search_discoverable_profiles(text,integer)
is 'Returns only approved public profile fields for discoverable members; does not widen direct profiles table access.';
