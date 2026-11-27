-- Synthetic end-to-end order -> verified-payment evidence -> Member ledger -> guarded payout test.
-- Run only against disposable PostgreSQL after the full migration chain.
-- Provider references below are fake fixtures. No payment API or real money is used.
\set ON_ERROR_STOP on

insert into auth.users(id,email) values
 ('00000000-0000-0000-0000-000000000201','mwvip-test-member@example.invalid'),
 ('00000000-0000-0000-0000-000000000202','mwvip-test-customer@example.invalid')
on conflict(id) do nothing;

select set_config('request.jwt.claim.role','service_role',false);

do $test$
declare
  v_project uuid;
  v_order uuid;
  v_member_account uuid;
  v_gateway uuid;
  v_refund uuid;
  v_operating_cash uuid;
  v_journal jsonb;
  v_retry jsonb;
  v_payout uuid;
  v_balance numeric(18,2);
begin
  select id into v_project
  from public.earning_project_registry
  where project_code='MW-BDT-4000';
  if v_project is null then raise exception 'Synthetic test project missing'; end if;

  update public.earning_project_registry
  set lifecycle_status='active',
      execution_enabled=true,
      revenue_collection_enabled=true,
      budget_cap=1000
  where id=v_project;

  insert into public.customer_service_orders(
    project_id,customer_user_id,currency,customer_price,member_payable,
    refund_liability,operating_cost_budget,scope_terms,idempotency_key
  ) values (
    v_project,'00000000-0000-0000-0000-000000000202','BDT',
    700,600,100,0,'{"deliverable":"synthetic test service"}'::jsonb,
    'mwvip-e2e-order-0001'
  ) returning id into v_order;

  insert into public.customer_order_fund_allocations(
    order_id,bucket,currency,amount,state,reconciliation_reference,reconciled_at
  ) values
    (v_order,'member_payable','BDT',600,'locked','TEST-MEMBER-001',now()),
    (v_order,'refund_reserve','BDT',100,'locked','TEST-REFUND-001',now()),
    (v_order,'operating_cost','BDT',0,'locked','TEST-OPERATE-001',now());

  update public.customer_service_orders
  set status='funded',
      provider='bank',
      provider_transaction_id='SYNTHETIC-PAYMENT-TXN-001',
      provider_event_id='SYNTHETIC-PAYMENT-EVENT-001',
      provider_settled_at=now(),
      funds_segregated_at=now(),
      refund_reserve_verified_at=now(),
      operating_budget_verified_at=now()
  where id=v_order;

  update public.customer_service_orders set status='in_progress' where id=v_order;
  update public.customer_service_orders set status='delivered' where id=v_order;
  update public.customer_service_orders
  set status='accepted',acceptance_evidence='{"accepted_by":"synthetic_customer","evidence":"fixture"}'::jsonb
  where id=v_order;
  update public.customer_service_orders set status='completed' where id=v_order;

  select id into v_gateway from public.finance_accounts
  where currency='BDT' and account_code='gateway_clearing' and owner_user_id is null;
  select id into v_refund from public.finance_accounts
  where currency='BDT' and account_code='refund_reserve' and owner_user_id is null;
  select id into v_operating_cash from public.finance_accounts
  where currency='BDT' and account_code='operating_cash' and owner_user_id is null;

  insert into public.finance_accounts(
    currency,account_code,account_name,account_class,normal_side,owner_user_id
  ) values (
    'BDT','member_payable','Synthetic Member payable','liability','credit',
    '00000000-0000-0000-0000-000000000201'
  ) returning id into v_member_account;

  v_journal:=public.service_post_double_entry_journal(
    'BDT','customer_order_settlement',v_order::text,'mwvip-e2e-ledger-0001',
    'Synthetic settled order allocation',
    jsonb_build_array(
      jsonb_build_object('account_id',v_gateway,'debit',700,'credit',0),
      jsonb_build_object('account_id',v_member_account,'debit',0,'credit',600),
      jsonb_build_object('account_id',v_refund,'debit',0,'credit',100)
    )
  );
  v_retry:=public.service_post_double_entry_journal(
    'BDT','customer_order_settlement',v_order::text,'mwvip-e2e-ledger-0001',
    'Synthetic settled order allocation',
    jsonb_build_array(
      jsonb_build_object('account_id',v_gateway,'debit',700,'credit',0),
      jsonb_build_object('account_id',v_member_account,'debit',0,'credit',600),
      jsonb_build_object('account_id',v_refund,'debit',0,'credit',100)
    )
  );
  if (v_journal->>'duplicate')::boolean or not (v_retry->>'duplicate')::boolean then
    raise exception 'Order settlement journal idempotency failed';
  end if;

  v_payout:=public.service_create_member_payout_request(
    '00000000-0000-0000-0000-000000000201','BDT',200,'mwvip-e2e-payout-0001'
  );
  update public.finance_disbursement_requests set status='approved' where id=v_payout;
  update public.finance_disbursement_requests set status='processing' where id=v_payout;

  perform public.service_post_double_entry_journal(
    'BDT','disbursement',v_payout::text,'mwvip-e2e-payout-journal-001',
    'Synthetic Member payout settlement',
    jsonb_build_array(
      jsonb_build_object('account_id',v_member_account,'debit',200,'credit',0),
      jsonb_build_object('account_id',v_operating_cash,'debit',0,'credit',200)
    )
  );

  update public.finance_disbursement_requests
  set status='paid',
      provider='bank',
      provider_transaction_id='SYNTHETIC-PAYOUT-TXN-001',
      provider_event_id='SYNTHETIC-PAYOUT-EVENT-001',
      provider_settled_at=now(),
      reconciliation_reference='SYNTHETIC-RECON-001',
      reconciled_at=now()
  where id=v_payout;

  select coalesce(sum(l.credit-l.debit),0) into v_balance
  from public.finance_journal_lines l
  where l.account_id=v_member_account;
  if v_balance<>400 then
    raise exception 'Member payable balance after synthetic payout should be 400; got %',v_balance;
  end if;

  if (public.finance_journal_integrity_check()->>'integrity_ok')::boolean is not true then
    raise exception 'Double-entry ledger integrity failed after end-to-end synthetic settlement';
  end if;

  if not exists(select 1 from public.customer_service_orders where id=v_order and status='completed')
    or not exists(select 1 from public.finance_disbursement_requests where id=v_payout and status='paid') then
    raise exception 'Synthetic order-to-member-settlement flow did not reach expected terminal states';
  end if;
end;
$test$;

select 'SYNTHETIC_ORDER_TO_MEMBER_SETTLEMENT=PASS' as result;
select 'NO_EXTERNAL_PAYMENT_PROVIDER_OR_REAL_FUNDS_USED=true' as result;
