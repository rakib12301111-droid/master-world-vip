-- MASTER WORLD VIP: public member attribution badge and shareable public profile
-- Public output is limited to profiles whose owner enabled discoverability.

create or replace function public.get_public_member_profile(p_user_id uuid)
returns jsonb
language plpgsql
volatile
security definer
set search_path = public, extensions
as $$
declare
  v_profile public.profiles%rowtype;
  v_code text;
begin
  select * into v_profile
  from public.profiles
  where id = p_user_id and coalesce(is_discoverable, false) = true;

  if not found then
    return null;
  end if;

  insert into public.member_referral_codes(user_id, code)
  values (p_user_id, 'MW' || upper(encode(gen_random_bytes(5), 'hex')))
  on conflict (user_id) do nothing;

  select code into v_code
  from public.member_referral_codes
  where user_id = p_user_id;

  return jsonb_build_object(
    'id', v_profile.id,
    'display_name', coalesce(v_profile.display_name, 'MASTER WORLD VIP Member'),
    'username', v_profile.username,
    'bio', v_profile.bio,
    'avatar_url', v_profile.avatar_url,
    'country', v_profile.country,
    'created_at', v_profile.created_at,
    'referral_code', v_code
  );
end;
$$;

revoke all on function public.get_public_member_profile(uuid) from public;
grant execute on function public.get_public_member_profile(uuid) to anon, authenticated;
