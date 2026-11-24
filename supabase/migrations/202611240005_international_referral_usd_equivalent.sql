-- MASTER WORLD VIP — country-based USD-equivalent referral rewards
-- Additive only. Production apply remains subject to backup/restore/dry-run authorization.
-- All wallet credits remain denominated in BDT; foreign awards are valued at USD 50
-- using the Owner-maintained BDT-per-USD rate locked at the time of credit.

create table if not exists public.referral_reward_fx_settings (
  singleton boolean primary key default true check (singleton),
  bdt_per_usd numeric(12,4),
  rate_source text,
  rate_reference text,
  effective_at timestamptz,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now(),
  constraint referral_reward_fx_positive_rate check (bdt_per_usd is null or bdt_per_usd > 0)
);
insert into public.referral_reward_fx_settings(singleton)
values (true) on conflict (singleton) do nothing;

alter table public.profiles
  add column if not exists referral_reward_country_verified boolean not null default false,
  add column if not exists referral_reward_country_verified_at timestamptz,
  add column if not exists referral_reward_country_verified_by uuid references auth.users(id);

create or replace function public.admin_verify_referral_reward_country(
  p_member_id uuid,
  p_verified boolean,
  p_note text default null
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $
declare v_actor uuid := auth.uid();
begin
  if v_actor is null or not public.is_referral_finance_admin() then
    raise exception 'Owner/Admin permission required';
  end if;
  if p_member_id is null or not exists (
    select 1 from public.profiles
    where id=p_member_id and country is not null and char_length(btrim(country)) > 0
  ) then
    raise exception 'Member profile country is missing';
  end if;
  update public.profiles
  set referral_reward_country_verified=p_verified,
      referral_reward_country_verified_at=case when p_verified then now() else null end,
      referral_reward_country_verified_by=case when p_verified then v_actor else null end
  where id=p_member_id;
  insert into public.admin_audit_logs(actor_user_id,target_user_id,action,details)
  values(v_actor,p_member_id,'referral_reward_country_verification_changed',
    jsonb_build_object('verified',p_verified,'note',left(coalesce(p_note,''),250)));
  return true;
end;
$;
revoke all on function public.admin_verify_referral_reward_country(uuid,boolean,text) from public,anon;
grant execute on function public.admin_verify_referral_reward_country(uuid,boolean,text) to authenticated;

create or replace function public.get_admin_referral_country_review_queue()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $
begin
  if not public.is_referral_finance_admin() then
    raise exception 'Owner/Admin permission required';
  end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'user_id',p.id,
      'display_name',coalesce(p.display_name,'Member'),
      'country',p.country,
      'pending_referrals',q.pending_referrals,
      'verified',p.referral_reward_country_verified
    ) order by q.pending_referrals desc,p.display_name)
    from public.profiles p
    join (
      select referrer_id,count(*) as pending_referrals
      from public.referrals
      where status in ('registered','qualified')
      group by referrer_id
    ) q on q.referrer_id=p.id
    where p.country is not null and char_length(btrim(p.country)) > 0
      and p.referral_reward_country_verified=false
  ),'[]'::jsonb);
end;
$;
revoke all on function public.get_admin_referral_country_review_queue() from public,anon;
grant execute on function public.get_admin_referral_country_review_queue() to authenticated;

alter table public.referral_wallet_ledger
  add column if not exists reward_country text,
  add column if not exists base_amount_usd numeric(12,2),
  add column if not exists fx_rate_bdt_per_usd numeric(12,4);

revoke all on public.referral_reward_fx_settings from anon, authenticated;
alter table public.referral_reward_fx_settings enable row level security;

create or replace function public.admin_set_referral_usd_bdt_rate(
  p_rate numeric,
  p_source text,
  p_reference text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare v_actor uuid := auth.uid();
begin
  if v_actor is null or not exists (
    select 1 from public.app_user_roles where user_id=v_actor and role='owner'
  ) then
    raise exception 'Only the verified Owner can update the referral exchange rate';
  end if;
  if p_rate is null or p_rate <= 0 or p_rate > 10000 or round(p_rate,4) <> p_rate then
    raise exception 'Enter a valid BDT per USD rate with up to 4 decimal places';
  end if;
  if char_length(btrim(coalesce(p_source,''))) not between 3 and 80
     or char_length(btrim(coalesce(p_reference,''))) not between 4 and 160 then
    raise exception 'Exchange-rate source and reference/date are required';
  end if;

  insert into public.referral_reward_fx_settings(
    singleton,bdt_per_usd,rate_source,rate_reference,effective_at,updated_by,updated_at
  ) values (
    true,p_rate,btrim(p_source),btrim(p_reference),now(),v_actor,now()
  )
  on conflict (singleton) do update set
    bdt_per_usd=excluded.bdt_per_usd,
    rate_source=excluded.rate_source,
    rate_reference=excluded.rate_reference,
    effective_at=excluded.effective_at,
    updated_by=excluded.updated_by,
    updated_at=now();

  insert into public.admin_audit_logs(actor_user_id,action,details)
  values(v_actor,'referral_usd_bdt_rate_updated',
    jsonb_build_object('bdt_per_usd',p_rate,'source',p_source,'reference',p_reference));
  return true;
end;
$$;
revoke all on function public.admin_set_referral_usd_bdt_rate(numeric,text,text) from public,anon;
grant execute on function public.admin_set_referral_usd_bdt_rate(numeric,text,text) to authenticated;

create or replace function public.get_admin_referral_fx_rate()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not public.is_referral_finance_admin() then
    raise exception 'Owner/Admin permission required';
  end if;
  return coalesce((
    select jsonb_build_object(
      'bdt_per_usd',bdt_per_usd,'rate_source',rate_source,
      'rate_reference',rate_reference,'effective_at',effective_at,'updated_at',updated_at
    ) from public.referral_reward_fx_settings where singleton=true
  ),'{}'::jsonb);
end;
$$;
revoke all on function public.get_admin_referral_fx_rate() from public,anon;
grant execute on function public.get_admin_referral_fx_rate() to authenticated;

create or replace function public.process_eligible_referrals()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
  v_reward numeric(12,2);
  v_rate numeric(12,4);
  v_country text;
  v_budget numeric(12,2);
  v_qualified integer := 0;
  v_rewarded integer := 0;
  v_waiting_for_country integer := 0;
  v_waiting_for_rate integer := 0;
begin
  if coalesce(auth.role(),'') <> 'service_role' then
    raise exception 'Service role required';
  end if;
  perform pg_advisory_xact_lock(hashtextextended('mwvip-referral-reward-processor',0));

  if not exists (
    select 1 from public.referral_reward_settings
    where singleton=true and rewards_enabled=true
  ) then
    return jsonb_build_object('qualified',0,'rewarded',0,'paused',true);
  end if;

  select bdt_per_usd into v_rate
  from public.referral_reward_fx_settings where singleton=true;

  for v_row in
    select r.id,r.referrer_id,r.referred_user_id,r.status,inviter_profile.country
    from public.referrals r
    join auth.users u on u.id=r.referred_user_id
    join public.profiles p on p.id=u.id
    left join public.profiles inviter_profile on inviter_profile.id=r.referrer_id
    where r.status in ('registered','qualified')
      and u.created_at <= now() - interval '24 hours'
      and u.confirmed_at is not null
      and (u.banned_until is null or u.banned_until <= now())
      and char_length(btrim(coalesce(p.display_name,''))) > 0
      and r.referrer_id <> u.id
      and inviter_profile.country is not null
      and char_length(btrim(inviter_profile.country)) > 0\n      and inviter_profile.referral_reward_country_verified=true
    order by r.created_at asc
    for update of r skip locked
  loop
    select country into v_country
    from public.profiles where id=v_row.referrer_id;

    if v_row.status='registered' then
      update public.referrals set status='qualified',qualified_at=coalesce(qualified_at,now())
      where id=v_row.id and status='registered';
      v_qualified := v_qualified + 1;
    end if;

    if exists(select 1 from public.referral_wallet_ledger where referral_id=v_row.id) then
      update public.referrals set status='rewarded' where id=v_row.id;
      continue;
    end if;

    if lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then
      v_reward := 50.00;
    else
      if v_rate is null or v_rate <= 0 then
        v_waiting_for_rate := v_waiting_for_rate + 1;
        continue;
      end if;
      v_reward := round(50.00 * v_rate,2);
    end if;

    select
      coalesce((select sum(amount) from public.referral_reward_fundings where confirmed_funds),0)
      - coalesce((select sum(amount) from public.referral_wallet_ledger where entry_type='credit'),0)
    into v_budget;
    if v_budget < v_reward then
      exit;
    end if;

    insert into public.referral_wallet_ledger(
      user_id,entry_type,amount,referral_id,description,reward_country,
      base_amount_usd,fx_rate_bdt_per_usd
    )
    values(
      v_row.referrer_id,'credit',v_reward,v_row.id,
      case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd')
        then 'Bangladesh direct referral reward: BDT 50'
        else 'International direct referral reward: USD 50 equivalent at BDT/USD '||v_rate::text
      end,
      v_country,
      case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else 50.00 end,
      case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else v_rate end
    );
    update public.referrals set status='rewarded' where id=v_row.id;
    v_rewarded := v_rewarded + 1;
  end loop;

  select count(*) into v_waiting_for_country
  from public.referrals r
  join auth.users u on u.id=r.referred_user_id
  left join public.profiles inviter_profile on inviter_profile.id=r.referrer_id
  where r.status in ('registered','qualified')
    and u.created_at <= now() - interval '24 hours'
    and u.confirmed_at is not null
    and (u.banned_until is null or u.banned_until <= now())
    and (inviter_profile.country is null or char_length(btrim(inviter_profile.country))=0\n      or inviter_profile.referral_reward_country_verified is distinct from true);

  return jsonb_build_object(
    'qualified',v_qualified,'rewarded',v_rewarded,'paused',false,
    'waiting_for_country',v_waiting_for_country,'waiting_for_exchange_rate',v_waiting_for_rate
  );
end;
$$;
revoke all on function public.process_eligible_referrals() from public,anon,authenticated;
grant execute on function public.process_eligible_referrals() to service_role;
