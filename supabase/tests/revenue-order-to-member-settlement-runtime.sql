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
  where project_code='MW-BDT-2000';
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
      provider='other_approved',
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


-- Synthetic task execution, idempotency, bounded retry/dead-letter and budget accounting.
do $task_test$
declare
  v_project uuid;
  v_worker uuid;
  v_task uuid;
  v_lease uuid;
  v_duplicate_count integer;
  v_daily_spent numeric(14,2);
  v_daily_reserved numeric(14,2);
  v_dead_count integer;
begin
  select id into v_project from public.earning_project_registry where project_code='MW-BDT-2000';

  insert into public.project_automation_settings(
    project_id,enabled,task_type,schedule_interval_minutes,next_run_at,
    daily_budget,daily_spent,budget_date,max_attempts,max_concurrent_tasks
  ) values(v_project,true,'system_health_check',60,now(),10,0,current_date,2,1)
  on conflict(project_id) do update set
    enabled=true,task_type='system_health_check',next_run_at=now(),
    daily_budget=10,daily_spent=0,budget_date=current_date,max_attempts=2;

  update public.project_automation_runtime_control
  set emergency_stop=false,stop_reason='Disposable runtime test only',updated_at=now()
  where singleton=true;

  v_worker:=public.worker_register_project_automation(
    'worker-runtime-test-key','Disposable Runtime Test Worker',array['BDT']::text[]
  );
  perform public.worker_heartbeat_project_automation('worker-runtime-test-key');

  insert into public.project_automation_tasks(
    project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
  ) values(
    v_project,'system_health_check','{}'::jsonb,'runtime-health-idem-001',2,2,now()
  ) on conflict(idempotency_key) do nothing;
  insert into public.project_automation_tasks(
    project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
  ) values(
    v_project,'system_health_check','{}'::jsonb,'runtime-health-idem-001',2,2,now()
  ) on conflict(idempotency_key) do nothing;

  select count(*) into v_duplicate_count
  from public.project_automation_tasks where idempotency_key='runtime-health-idem-001';
  if v_duplicate_count<>1 then raise exception 'Duplicate task idempotency invariant failed'; end if;

  select id,lease_token into v_task,v_lease
  from public.worker_claim_project_automation_task('worker-runtime-test-key') limit 1;
  if v_task is null or v_lease is null then raise exception 'Worker did not claim eligible allowlisted task'; end if;
  select daily_reserved into v_daily_reserved from public.project_automation_settings where project_id=v_project;
  if v_daily_reserved<>2 then raise exception 'Task budget was not reserved at claim time'; end if;
  perform public.worker_finish_project_automation_task(v_task,v_lease,true,0.25,null);

  insert into public.project_automation_tasks(
    project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
  ) values(
    v_project,'system_health_check','{}'::jsonb,'runtime-health-retry-001',2,2,now()
  );

  select id,lease_token into v_task,v_lease
  from public.worker_claim_project_automation_task('worker-runtime-test-key') limit 1;
  if v_task is null then raise exception 'Worker did not claim retry fixture'; end if;
  perform public.worker_finish_project_automation_task(v_task,v_lease,false,0.25,'synthetic first failure');

  update public.project_automation_tasks set available_at=now()
  where id=v_task and status='retry_wait';

  select id,lease_token into v_task,v_lease
  from public.worker_claim_project_automation_task('worker-runtime-test-key') limit 1;
  if v_task is null then raise exception 'Worker did not reclaim retry fixture'; end if;
  perform public.worker_finish_project_automation_task(v_task,v_lease,false,0.25,'synthetic final failure');

  select count(*) into v_dead_count from public.project_automation_tasks
  where idempotency_key='runtime-health-retry-001' and status='dead_letter' and attempts=2;
  if v_dead_count<>1 then raise exception 'Retry limit did not dead-letter task'; end if;

  select daily_spent,daily_reserved into v_daily_spent,v_daily_reserved
  from public.project_automation_settings where project_id=v_project;
  if v_daily_spent<>0.75 or v_daily_reserved<>0 then
    raise exception 'Daily budget accounting mismatch: spent %, reserved %',v_daily_spent,v_daily_reserved;
  end if;

  if (select count(*) from public.project_automation_audit
      where action in ('task_claimed','task_succeeded','task_retry_scheduled','task_dead_lettered'))<5 then
    raise exception 'Task execution audit events missing';
  end if;

  update public.project_automation_runtime_control
  set emergency_stop=true,stop_reason='Disposable runtime test completed',updated_at=now()
  where singleton=true;
end;
$task_test$;

select 'TASK_CLAIM_EXECUTION_IDEMPOTENCY_RETRY_DEAD_LETTER_BUDGET_AUDIT=PASS' as result;
select 'GLOBAL_EMERGENCY_STOP_REENABLED=true' as result;


-- Phase A: read-only project usage digest Worker handler acceptance.
-- Disposable database only. The digest excludes customer/member data and performs no writes.
do $phase_a$
declare
  v_project uuid;
  v_worker uuid;
  v_task uuid;
  v_lease uuid;
  v_digest jsonb;
begin
  select id into v_project
  from public.earning_project_registry
  where project_code='MW-BDT-2000';
  if v_project is null then raise exception 'Phase A synthetic project missing'; end if;

  update public.project_automation_runtime_control
  set emergency_stop=false,stop_reason='Disposable Phase A read-only handler test',updated_at=now()
  where singleton=true;

  update public.earning_project_registry
  set lifecycle_status='active',execution_enabled=true,budget_cap=1000
  where id=v_project;

  insert into public.project_automation_settings(
    project_id,enabled,task_type,schedule_interval_minutes,next_run_at,
    daily_budget,daily_spent,daily_reserved,budget_date,max_attempts
  ) values(v_project,true,'project_usage_digest',60,now(),10,0,0,current_date,2)
  on conflict(project_id) do update set
    enabled=true,task_type='project_usage_digest',next_run_at=now(),
    daily_budget=10,daily_spent=0,daily_reserved=0,budget_date=current_date,max_attempts=2;

  v_worker:=public.worker_register_project_automation(
    'worker-phase-a-digest','Phase A Digest Runtime Worker',array['BDT']::text[]
  );
  perform public.worker_heartbeat_project_automation('worker-phase-a-digest');

  insert into public.project_automation_tasks(
    project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
  ) values(
    v_project,'project_usage_digest','{}'::jsonb,
    'phase-a-project-usage-digest-001',2,1,now()
  );

  select id,lease_token into v_task,v_lease
  from public.worker_claim_project_automation_task('worker-phase-a-digest')
  limit 1;
  if v_task is null or v_lease is null then
    raise exception 'Phase A digest task was not claimed';
  end if;

  v_digest:=public.worker_read_project_usage_digest(v_project);
  if v_digest->>'project_code'<>'MW-BDT-2000'
    or v_digest->>'currency'<>'BDT'
    or v_digest->'tasks' is null
    or (v_digest->'tasks'->>'queued') is null
    or v_digest ? 'customer'
    or v_digest ? 'member'
  then
    raise exception 'Phase A digest schema or data-scope assertion failed: %',v_digest;
  end if;

  perform public.worker_finish_project_automation_task(v_task,v_lease,true,0,null);

  if exists(
    select 1 from public.project_automation_tasks
    where id=v_task and (status<>'succeeded' or budget_reserved<>0)
  ) then
    raise exception 'Phase A task did not complete and release its reservation';
  end if;

  update public.project_automation_runtime_control
  set emergency_stop=true,stop_reason='Disposable Phase A test completed; restore safe state',updated_at=now()
  where singleton=true;
end;
$phase_a$;

select 'PHASE_A_PROJECT_USAGE_DIGEST_READ_ONLY_HANDLER=PASS' as result;
select 'PHASE_A_NO_CUSTOMER_MEMBER_DATA_OR_EXTERNAL_FINANCIAL_EFFECTS=true' as result;
select 'PHASE_A_GLOBAL_EMERGENCY_STOP_REENABLED=true' as result;


-- Phase A second read-only handler: validate a synthetic work order without exposing customer identity.
do $work_order_validate$
declare
  v_project uuid;
  v_order uuid;
  v_worker uuid;
  v_task uuid;
  v_lease uuid;
  v_validation jsonb;
begin
  select id into v_project from public.earning_project_registry
  where project_code='MW-BDT-2000';
  select id into v_order from public.customer_service_orders
  where idempotency_key='mwvip-e2e-order-0001' and project_id=v_project;
  if v_order is null then raise exception 'Synthetic work order fixture missing'; end if;

  -- The preceding Phase A digest test deliberately restores the global stop.
  -- Re-open it only inside this disposable test transaction, then re-engage below.
  update public.project_automation_runtime_control
  set emergency_stop=false,stop_reason='Disposable Phase A work-order validation test',updated_at=now()
  where singleton=true;

  v_worker:=public.worker_register_project_automation(
    'worker-phase-a-order-validation','Phase A Order Validation Worker',array['BDT']::text[]
  );
  perform public.worker_heartbeat_project_automation('worker-phase-a-order-validation');

  insert into public.project_automation_tasks(
    project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
  ) values(
    v_project,'work_order_validate',
    jsonb_build_object('order_id',v_order::text),
    'phase-a-work-order-validation-001',2,1,now()
  );

  select id,lease_token into v_task,v_lease
  from public.worker_claim_project_automation_task('worker-phase-a-order-validation')
  limit 1;
  if v_task is null or v_lease is null then
    raise exception 'Phase A work order validation task was not claimed';
  end if;

  v_validation:=public.worker_validate_work_order(v_project,v_order);
  if v_validation->>'status'<>'completed'
    or v_validation->>'validation_passed'<>'true'
    or v_validation->>'currency_match'<>'true'
    or v_validation->>'scope_terms_present'<>'true'
    or v_validation->>'settlement_evidence_present'<>'true'
    or v_validation->>'locked_allocation_count'<>'3'
    or v_validation ? 'customer_user_id'
  then
    raise exception 'Phase A work order validation failed or leaked customer identity: %',v_validation;
  end if;

  perform public.worker_finish_project_automation_task(v_task,v_lease,true,0,null);
  if exists(select 1 from public.project_automation_tasks
    where id=v_task and (status<>'succeeded' or budget_reserved<>0)) then
    raise exception 'Work order validation task did not finish/release budget';
  end if;

  update public.project_automation_runtime_control
  set emergency_stop=true,stop_reason='Disposable Phase A handler tests completed',updated_at=now()
  where singleton=true;
end;
$work_order_validate$;

select 'PHASE_A_WORK_ORDER_VALIDATE_READ_ONLY_HANDLER=PASS' as result;
select 'PHASE_A_WORK_ORDER_NO_CUSTOMER_IDENTITY_EXPOSED=true' as result;
select 'PHASE_A_GLOBAL_EMERGENCY_STOP_REENABLED=true' as result;
