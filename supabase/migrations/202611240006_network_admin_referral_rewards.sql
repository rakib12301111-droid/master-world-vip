-- MASTER WORLD VIP — 100% direct member reward + 100% additional network Owner reward
-- Additive only. All credits remain gated by confirmed real reward funding.
-- Each eligible referral creates two equal BDT entitlements: the direct referrer and the single verified Owner.
-- Combined funding requirement is 200% of the standard referral reward.

alter table public.referral_wallet_ledger
  add column if not exists reward_kind text not null default 'member_direct';

alter table public.referral_wallet_ledger
  drop constraint if exists referral_wallet_one_reward_per_referral;

alter table public.referral_wallet_ledger
  add constraint referral_wallet_reward_kind_check
  check (reward_kind in ('member_direct','owner_network'));

alter table public.referral_wallet_ledger
  add constraint referral_wallet_one_reward_per_kind
  unique (referral_id,reward_kind);

create table if not exists public.referral_reward_entitlements (
  id uuid primary key default gen_random_uuid(),
  referral_id uuid not null references public.referrals(id) on delete restrict,
  beneficiary_id uuid not null references auth.users(id) on delete restrict,
  reward_kind text not null check (reward_kind in ('member_direct','owner_network')),
  amount numeric(12,2) not null check (amount > 0),
  currency text not null default 'BDT' check (currency='BDT'),
  reward_country text,
  base_amount_usd numeric(12,2),
  fx_rate_bdt_per_usd numeric(12,4),
  status text not null default 'pending' check (status in ('pending','credited')),
  created_at timestamptz not null default now(),
  credited_at timestamptz,
  unique (referral_id,reward_kind)
);
create index if not exists referral_reward_entitlements_beneficiary_status_idx
  on public.referral_reward_entitlements(beneficiary_id,status,created_at desc);
alter table public.referral_reward_entitlements enable row level security;
revoke all on public.referral_reward_entitlements from anon,authenticated;

create or replace function public.get_my_referral_pending_rewards()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare v_user uuid := auth.uid();
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  return jsonb_build_object(
    'pending_total',coalesce((select sum(amount) from public.referral_reward_entitlements
      where beneficiary_id=v_user and status='pending'),0),
    'pending_count',(select count(*) from public.referral_reward_entitlements
      where beneficiary_id=v_user and status='pending')
  );
end;
$$;
revoke all on function public.get_my_referral_pending_rewards() from public,anon;
grant execute on function public.get_my_referral_pending_rewards() to authenticated;

create or replace function public.get_admin_referral_network_reward_summary()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare v_owner uuid;
begin
  if not public.is_referral_finance_admin() then
    raise exception 'Owner/Admin permission required';
  end if;
  select user_id into v_owner from public.app_user_roles
    where role='owner' order by user_id limit 1;
  return jsonb_build_object(
    'owner_user_id',v_owner,
    'owner_network_pending',coalesce((select sum(amount) from public.referral_reward_entitlements
      where beneficiary_id=v_owner and reward_kind='owner_network' and status='pending'),0),
    'owner_network_credited',coalesce((select sum(amount) from public.referral_wallet_ledger
      where user_id=v_owner and reward_kind='owner_network' and entry_type='credit'),0),
    'owner_network_pending_count',(select count(*) from public.referral_reward_entitlements
      where beneficiary_id=v_owner and reward_kind='owner_network' and status='pending')
  );
end;
$$;
revoke all on function public.get_admin_referral_network_reward_summary() from public,anon;
grant execute on function public.get_admin_referral_network_reward_summary() to authenticated;

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
  v_verified boolean;
  v_budget numeric(12,2);
  v_owner uuid;
  v_owner_count integer;
  v_qualified integer := 0;
  v_entitlements integer := 0;
  v_credited integer := 0;
  v_waiting_country integer := 0;
  v_waiting_rate integer := 0;
  v_waiting_funds integer := 0;
begin
  if coalesce(auth.role(),'') <> 'service_role' then
    raise exception 'Service role required';
  end if;
  perform pg_advisory_xact_lock(hashtextextended('mwvip-referral-reward-processor',0));

  if not exists (
    select 1 from public.referral_reward_settings
    where singleton=true and rewards_enabled=true
  ) then
    return jsonb_build_object('qualified',0,'credited_referrals',0,'paused',true);
  end if;

  select count(*) into v_owner_count
  from public.app_user_roles where role='owner';
  if v_owner_count <> 1 then
    return jsonb_build_object(
      'paused',true,'reason','exactly_one_verified_owner_required',
      'owner_accounts_found',v_owner_count
    );
  end if;
  select user_id into v_owner
  from public.app_user_roles where role='owner' order by user_id limit 1;

  select bdt_per_usd into v_rate
  from public.referral_reward_fx_settings where singleton=true;

  -- Create a pending entitlement for both beneficiaries for every newly eligible referral.
  for v_row in
    select r.id,r.referrer_id,r.referred_user_id,r.status
    from public.referrals r
    join auth.users u on u.id=r.referred_user_id
    join public.profiles p on p.id=u.id
    where r.status in ('registered','qualified')
      and u.created_at <= now() - interval '24 hours'
      and u.confirmed_at is not null
      and (u.banned_until is null or u.banned_until <= now())
      and char_length(btrim(coalesce(p.display_name,''))) > 0
      and r.referrer_id <> u.id
    order by r.created_at asc
    for update of r skip locked
  loop
    select country,referral_reward_country_verified
      into v_country,v_verified
    from public.profiles where id=v_row.referrer_id;

    if v_country is null or char_length(btrim(v_country))=0 or v_verified is distinct from true then
      v_waiting_country := v_waiting_country + 1;
      continue;
    end if;

    if lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then
      v_reward := 50.00;
    else
      if v_rate is null or v_rate <= 0 then
        v_waiting_rate := v_waiting_rate + 1;
        continue;
      end if;
      v_reward := round(50.00 * v_rate,2);
    end if;

    if v_row.status='registered' then
      update public.referrals
      set status='qualified',qualified_at=coalesce(qualified_at,now())
      where id=v_row.id and status='registered';
      v_qualified := v_qualified + 1;
    end if;

    insert into public.referral_reward_entitlements(
      referral_id,beneficiary_id,reward_kind,amount,reward_country,
      base_amount_usd,fx_rate_bdt_per_usd
    ) values
      (v_row.id,v_row.referrer_id,'member_direct',v_reward,v_country,
       case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else 50.00 end,
       case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else v_rate end),
      (v_row.id,v_owner,'owner_network',v_reward,v_country,
       case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else 50.00 end,
       case when lower(btrim(v_country)) in ('bangladesh','বাংলাদেশ','bd') then null else v_rate end)
    on conflict (referral_id,reward_kind) do nothing;
    v_entitlements := v_entitlements + 2;
  end loop;

  -- Release both entitlements together only when the full 200% amount is covered by cleared funds.
  for v_row in
    select e.referral_id,sum(e.amount) as combined_amount,count(*) as entitlement_count,
           min(e.created_at) as first_created
    from public.referral_reward_entitlements e
    where e.status='pending'
    group by e.referral_id
    having count(*)=2
    order by min(e.created_at),e.referral_id
  loop
    select
      coalesce((select sum(amount) from public.referral_reward_fundings where confirmed_funds),0)
      - coalesce((select sum(amount) from public.referral_wallet_ledger where entry_type='credit'),0)
    into v_budget;

    if v_budget < v_row.combined_amount then
      v_waiting_funds := v_waiting_funds + 1;
      continue;
    end if;

    insert into public.referral_wallet_ledger(
      user_id,entry_type,amount,referral_id,description,reward_country,
      base_amount_usd,fx_rate_bdt_per_usd,reward_kind
    )
    select e.beneficiary_id,'credit',e.amount,e.referral_id,
      case when e.reward_kind='member_direct'
        then '100% direct referral reward'
        else 'Additional 100% Owner network referral reward'
      end,
      e.reward_country,e.base_amount_usd,e.fx_rate_bdt_per_usd,e.reward_kind
    from public.referral_reward_entitlements e
    where e.referral_id=v_row.referral_id and e.status='pending'
    on conflict (referral_id,reward_kind) do nothing;

    update public.referral_reward_entitlements
    set status='credited',credited_at=now()
    where referral_id=v_row.referral_id and status='pending';

    update public.referrals set status='rewarded' where id=v_row.referral_id;
    v_credited := v_credited + 1;
  end loop;

  return jsonb_build_object(
    'qualified',v_qualified,
    'new_entitlements',v_entitlements,
    'credited_referrals',v_credited,
    'waiting_for_country',v_waiting_country,
    'waiting_for_exchange_rate',v_waiting_rate,
    'waiting_for_funds',v_waiting_funds,
    'owner_network_rate_percent',100,
    'direct_member_rate_percent',100,
    'combined_reward_cost_percent',200,
    'paused',false
  );
end;
$$;
revoke all on function public.process_eligible_referrals() from public,anon,authenticated;
grant execute on function public.process_eligible_referrals() to service_role;

insert into public.admin_audit_logs(actor_user_id,action,details)
select auth.uid(),'referral_network_reward_policy_code_added',
  jsonb_build_object('member_direct_percent',100,'owner_network_percent',100,
    'combined_cost_percent',200,'funding_gate','confirmed_real_funds_only')
where auth.uid() is not null;
