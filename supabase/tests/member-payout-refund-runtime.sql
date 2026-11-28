-- Disposable PostgreSQL test for guarded payout/refund workflow migration.
\set ON_ERROR_STOP on
\i supabase/migrations/20261126150000_guarded_member_payout_refund_workflows.sql
do $$
declare v_member uuid; v_request uuid; v_journal jsonb; v_clearing uuid; v_cash uuid;
begin
 select id into v_member from public.finance_accounts where currency='BDT' and account_code='member_payable'
  and owner_user_id='00000000-0000-0000-0000-000000000101';
 v_request:=public.service_create_member_payout_request('00000000-0000-0000-0000-000000000101','BDT',200,'runtime-payout-0001');
 if v_request is null then raise exception 'Payout request was not created'; end if;
 begin
  perform public.service_create_member_payout_request('00000000-0000-0000-0000-000000000101','BDT',301,'runtime-payout-0002');
  raise exception 'Expected overdraw with pending payout reservation to fail';
 exception when others then
  if sqlerrm='Expected overdraw with pending payout reservation to fail' then raise; end if;
 end;
 select id into v_clearing from public.finance_accounts where currency='BDT' and account_code='gateway_clearing';
 select id into v_cash from public.finance_accounts where currency='BDT' and account_code='operating_cash';
 update public.finance_disbursement_requests set status='approved' where id=v_request;
 update public.finance_disbursement_requests set status='processing' where id=v_request;
 v_journal:=public.service_post_double_entry_journal('BDT','disbursement',v_request::text,'runtime-payout-journal-0001','verified member payout',
  jsonb_build_array(jsonb_build_object('account_id',v_member,'debit',200,'credit',0),
                    jsonb_build_object('account_id',v_cash,'debit',0,'credit',200)));
 update public.finance_disbursement_requests set status='paid',provider='bank',
  provider_transaction_id='runtime-bank-transfer-001',provider_event_id='runtime-bank-event-001',
  provider_settled_at=now(),reconciliation_reference='runtime-reconcile-001',reconciled_at=now()
 where id=v_request;
end $$;
