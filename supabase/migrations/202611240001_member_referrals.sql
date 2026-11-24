-- MASTER WORLD VIP: secure member referral codes and attribution
-- Apply only after reviewing the migration preview and confirming the target Supabase project.

create table if not exists public.member_referral_codes (
  user_id uuid primary key references auth.users(id) on delete cascade,
  code text not null unique,
  created_at timestamptz not null default now()
);

alter table public.member_referral_codes enable row level security;
drop policy if exists "member reads own referral code" on public.member_referral_codes;
create policy "member reads own referral code"
  on public.member_referral_codes for select to authenticated
  using (auth.uid() = user_id);

create or replace function public.get_my_referral_code()
returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  insert into public.member_referral_codes(user_id, code)
  values (auth.uid(), 'MW' || upper(encode(gen_random_bytes(5), 'hex')))
  on conflict (user_id) do nothing;

  select code into v_code
  from public.member_referral_codes
  where user_id = auth.uid();

  return v_code;
end;
$$;

revoke all on function public.get_my_referral_code() from public;
grant execute on function public.get_my_referral_code() to authenticated;

create or replace function public.attribute_new_referral()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text;
  v_referrer uuid;
begin
  v_code := upper(trim(coalesce(new.raw_user_meta_data ->> 'referral_code', '')));
  if v_code = '' then
    return new;
  end if;

  select user_id into v_referrer
  from public.member_referral_codes
  where code = v_code;

  if v_referrer is null or v_referrer = new.id then
    return new;
  end if;

  insert into public.referrals(referrer_id, referred_user_id, referral_code, status)
  values (v_referrer, new.id, v_code, 'registered')
  on conflict (referred_user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists mwvip_attribute_new_referral on auth.users;
create trigger mwvip_attribute_new_referral
after insert on auth.users
for each row execute function public.attribute_new_referral();

create or replace function public.get_my_referral_stats()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'total', count(*)::integer,
    'registered', count(*) filter (where status = 'registered')::integer,
    'qualified', count(*) filter (where status = 'qualified')::integer,
    'rewarded', count(*) filter (where status = 'rewarded')::integer
  )
  from public.referrals
  where referrer_id = auth.uid();
$$;

revoke all on function public.get_my_referral_stats() from public;
grant execute on function public.get_my_referral_stats() to authenticated;

create or replace function public.get_admin_referral_overview()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_result jsonb;
begin
  if not exists (
    select 1 from public.app_user_roles r
    where r.user_id = auth.uid() and r.role in ('owner','super_admin','admin')
  ) then
    raise exception 'Owner/Admin permission required';
  end if;

  select jsonb_build_object(
    'total', (select count(*) from public.referrals),
    'registered', (select count(*) from public.referrals where status = 'registered'),
    'qualified', (select count(*) from public.referrals where status = 'qualified'),
    'rewarded', (select count(*) from public.referrals where status = 'rewarded'),
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'referrer_id', x.referrer_id,
        'display_name', coalesce(p.display_name, 'Member'),
        'referral_count', x.referral_count
      ) order by x.referral_count desc)
      from (
        select referrer_id, count(*)::integer as referral_count
        from public.referrals
        group by referrer_id
      ) x
      left join public.profiles p on p.id = x.referrer_id
    ), '[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$$;

revoke all on function public.get_admin_referral_overview() from public;
grant execute on function public.get_admin_referral_overview() to authenticated;
