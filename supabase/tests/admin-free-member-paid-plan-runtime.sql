-- Disposable-only runtime acceptance for Admin Free / Member Paid-only gates.
-- All identities and settlement references are synthetic. Entire transaction rolls back.
begin;

do $$
declare
  v_admin uuid := gen_random_uuid();
  v_member uuid := gen_random_uuid();
  v_no_plan_member uuid := gen_random_uuid();
  v_project uuid;
  v_admin_free_plan uuid;
  v_member_paid_plan uuid;
  v_error text;
begin
  select id into v_project
  from public.earning_project_registry
  where project_number = 1;
  if v_project is null then
    raise exception 'Test fixture missing project registry row 1';
  end if;

  insert into auth.users(id,email) values
    (v_admin, 'admin-free-test-'||v_admin||'@example.invalid'),
    (v_member, 'member-paid-test-'||v_member||'@example.invalid'),
    (v_no_plan_member, 'member-no-plan-test-'||v_no_plan_member||'@example.invalid');

  insert into public.app_user_roles(user_id,role)
  values (v_admin,'owner');

  insert into public.project_plan_catalog(
    project_id,audience,plan_kind,plan_code,currency,price,billing_period,
    features,enabled,paid_activation_enabled
  ) values (
    v_project,'admin','free','TEST-ADMIN-FREE-'||upper(replace(v_admin::text,'-','')),
    'USD',0,null,'{}'::jsonb,true,false
  ) returning id into v_admin_free_plan;

  insert into public.project_plan_catalog(
    project_id,audience,plan_kind,plan_code,currency,price,billing_period,
    features,enabled,paid_activation_enabled
  ) values (
    v_project,'member','paid','TEST-MEMBER-PAID-'||upper(replace(v_member::text,'-','')),
    'USD',10,'one_time','{}'::jsonb,true,true
  ) returning id into v_member_paid_plan;

  -- Members cannot be given a Free catalog entry.
  begin
    insert into public.project_plan_catalog(
      project_id,audience,plan_kind,plan_code,currency,price,billing_period
    ) values (
      v_project,'member','free','TEST-MEMBER-FREE-'||upper(replace(v_no_plan_member::text,'-','')),
      'USD',0,null
    );
    raise exception 'TEST_EXPECTED_MEMBER_FREE_REJECTION';
  exception when others then
    get stacked diagnostics v_error = message_text;
    if v_error not like 'Members must use a Paid Plan%' then
      raise;
    end if;
  end;

  -- Admin audience cannot be configured as Paid.
  begin
    insert into public.project_plan_catalog(
      project_id,audience,plan_kind,plan_code,currency,price,billing_period
    ) values (
      v_project,'admin','paid','TEST-ADMIN-PAID-'||upper(replace(v_admin::text,'-','')),
      'USD',10,'one_time'
    );
    raise exception 'TEST_EXPECTED_ADMIN_PAID_REJECTION';
  exception when others then
    get stacked diagnostics v_error = message_text;
    if v_error not like 'Admin audience is restricted to the Free Plan%' then
      raise;
    end if;
  end;

  -- Owner/Admin gets Admin Free without buying a Member Paid subscription.
  perform set_config('request.jwt.claim.sub',v_admin::text,true);
  if public.my_project_plan_access(v_project) <> 'admin_free' then
    raise exception 'Admin Free entitlement did not resolve';
  end if;

  -- A normal Member without verified Paid entitlement is denied.
  perform set_config('request.jwt.claim.sub',v_no_plan_member::text,true);
  if public.my_project_plan_access(v_project) <> 'no_access' then
    raise exception 'Member without Paid Plan was not denied';
  end if;

  -- A Member cannot be activated with mismatched settlement amount.
  begin
    insert into public.project_plan_subscriptions(
      user_id,plan_id,status,provider,provider_transaction_id,provider_event_id,
      settled_amount,currency,provider_settled_at,starts_at
    ) values (
      v_member,v_member_paid_plan,'active','other_approved',
      'TEST-MISMATCH-TXN-'||v_member,'TEST-MISMATCH-EVENT-'||v_member,
      9.99,'USD',now(),now()
    );
    raise exception 'TEST_EXPECTED_AMOUNT_MISMATCH_REJECTION';
  exception when others then
    get stacked diagnostics v_error = message_text;
    if v_error not like 'Verified provider settlement and exact plan price/currency are required%' then
      raise;
    end if;
  end;

  -- Admin cannot activate a Member Paid subscription even with synthetic settlement evidence.
  begin
    insert into public.project_plan_subscriptions(
      user_id,plan_id,status,provider,provider_transaction_id,provider_event_id,
      settled_amount,currency,provider_settled_at,starts_at
    ) values (
      v_admin,v_member_paid_plan,'active','other_approved',
      'TEST-ADMIN-TXN-'||v_admin,'TEST-ADMIN-EVENT-'||v_admin,
      10,'USD',now(),now()
    );
    raise exception 'TEST_EXPECTED_ADMIN_SUBSCRIPTION_REJECTION';
  exception when others then
    get stacked diagnostics v_error = message_text;
    if v_error not like 'Admin accounts use the Admin Free Plan%' then
      raise;
    end if;
  end;

  -- A valid, synthetic, exact-value Member Paid settlement grants access.
  insert into public.project_plan_subscriptions(
    user_id,plan_id,status,provider,provider_transaction_id,provider_event_id,
    settled_amount,currency,provider_settled_at,starts_at
  ) values (
    v_member,v_member_paid_plan,'active','other_approved',
    'TEST-VALID-TXN-'||v_member,'TEST-VALID-EVENT-'||v_member,
    10,'USD',now(),now()-interval '1 minute'
  );

  perform set_config('request.jwt.claim.sub',v_member::text,true);
  if public.my_project_plan_access(v_project) <> 'member_paid' then
    raise exception 'Verified Member Paid entitlement did not resolve';
  end if;

  -- Expired/cancelled subscriptions do not grant access.
  update public.project_plan_subscriptions
  set status='expired', expires_at=now()-interval '1 minute'
  where user_id=v_member and plan_id=v_member_paid_plan;
  if public.my_project_plan_access(v_project) <> 'no_access' then
    raise exception 'Expired Member Paid subscription still grants access';
  end if;

  raise notice 'PASS: Admin Free, Member no-plan denial, Member Paid grant, expiry, audience and settlement guards';
end
$$;

rollback;
