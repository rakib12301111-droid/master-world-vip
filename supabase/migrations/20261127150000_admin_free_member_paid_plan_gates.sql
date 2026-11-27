-- Admin Free / Member Paid-only entitlement policy. Additive; no live payment/deployment.
create or replace function public.guard_project_plan_audience()
returns trigger language plpgsql security definer set search_path = ''
as $function$
begin
  if new.audience = 'admin' and new.plan_kind <> 'free' then
    raise exception 'Admin audience is restricted to the Free Plan';
  end if;
  if new.audience = 'member' and new.plan_kind <> 'paid' then
    raise exception 'Members must use a Paid Plan; Member Free Plans are disabled';
  end if;
  if new.audience = 'admin' and (new.price <> 0 or new.billing_period is not null) then
    raise exception 'Admin Free Plan must have zero price and no billing period';
  end if;
  return new;
end;
$function$;
revoke all on function public.guard_project_plan_audience() from public, anon, authenticated;
drop trigger if exists project_plan_catalog_audience_guard on public.project_plan_catalog;
create trigger project_plan_catalog_audience_guard before insert or update on public.project_plan_catalog
for each row execute function public.guard_project_plan_audience();

create or replace function public.validate_project_plan_subscription()
returns trigger language plpgsql security definer set search_path = ''
as $function$
declare
  v_plan public.project_plan_catalog%rowtype;
  v_is_admin boolean;
begin
  if new.status = 'active' then
    select * into v_plan from public.project_plan_catalog where id = new.plan_id for share;
    if not found or v_plan.audience <> 'member' or v_plan.plan_kind <> 'paid'
      or not v_plan.enabled or not v_plan.paid_activation_enabled then
      raise exception 'Only an enabled Member Paid Plan can activate a subscription';
    end if;
    select exists (select 1 from public.app_user_roles r
      where r.user_id = new.user_id and r.role in ('owner','super_admin','admin'))
      into v_is_admin;
    if v_is_admin then
      raise exception 'Admin accounts use the Admin Free Plan, not Member Paid subscriptions';
    end if;
    if new.settled_amount is distinct from v_plan.price
      or new.currency is distinct from v_plan.currency
      or new.provider_transaction_id is null or new.provider_event_id is null
      or new.provider_settled_at is null or new.starts_at is null then
      raise exception 'Verified provider settlement and exact plan price/currency are required';
    end if;
  end if;
  return new;
end;
$function$;
revoke all on function public.validate_project_plan_subscription() from public, anon, authenticated;
drop trigger if exists project_plan_subscription_validate on public.project_plan_subscriptions;
create trigger project_plan_subscription_validate before insert or update on public.project_plan_subscriptions
for each row execute function public.validate_project_plan_subscription();

create or replace function public.my_project_plan_access(p_project_id uuid)
returns text language plpgsql stable security definer set search_path = ''
as $function$
declare v_user uuid := auth.uid();
begin
  if v_user is null or p_project_id is null then return 'no_access'; end if;
  if exists (select 1 from public.app_user_roles r where r.user_id = v_user
    and r.role in ('owner','super_admin','admin')) then return 'admin_free'; end if;
  if exists (
    select 1 from public.project_plan_subscriptions s
    join public.project_plan_catalog p on p.id = s.plan_id
    where s.user_id = v_user and p.project_id = p_project_id
      and p.audience = 'member' and p.plan_kind = 'paid'
      and p.enabled = true and p.paid_activation_enabled = true
      and s.status = 'active' and s.provider_transaction_id is not null
      and s.provider_event_id is not null and s.provider_settled_at is not null
      and s.starts_at is not null and s.starts_at <= now()
      and (s.expires_at is null or s.expires_at > now())
  ) then return 'member_paid'; end if;
  return 'no_access';
end;
$function$;
revoke all on function public.my_project_plan_access(uuid) from public, anon;
grant execute on function public.my_project_plan_access(uuid) to authenticated;
comment on function public.my_project_plan_access(uuid) is
  'Admin Free / provider-verified Member Paid entitlement resolver; each work entry point must enforce server-side.';
