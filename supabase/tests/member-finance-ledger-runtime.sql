-- Isolated PostgreSQL runtime test for the new ledger migration.
-- Run only in disposable CI PostgreSQL, never Production.
\set ON_ERROR_STOP on
create schema if not exists auth;
do $$ begin
 if not exists(select 1 from pg_roles where rolname='anon') then create role anon nologin; end if;
 if not exists(select 1 from pg_roles where rolname='authenticated') then create role authenticated nologin; end if;
 if not exists(select 1 from pg_roles where rolname='service_role') then create role service_role nologin bypassrls; end if;
end $$;
create table if not exists auth.users(id uuid primary key);
insert into auth.users(id) values('00000000-0000-0000-0000-000000000101') on conflict do nothing;
\i supabase/migrations/20261126140000_append_only_double_entry_finance_ledger.sql
create table public.customer_service_orders(id uuid primary key,customer_user_id uuid not null references auth.users(id),currency text not null,status text not null);
\i supabase/tests/member-payout-refund-runtime.sql
select set_config('request.jwt.claim.role','service_role',false);
do $$
declare
 v_member uuid; v_clearing uuid; v_personal uuid; v_journal jsonb; v_retry jsonb; v_balance numeric;
begin
 select id into v_member from public.finance_accounts where currency='BDT' and account_code='member_payable_control';
 select id into v_clearing from public.finance_accounts where currency='BDT' and account_code='gateway_clearing';
 insert into public.finance_accounts(currency,account_code,account_name,account_class,normal_side,owner_user_id)
 values('BDT','member_payable','Test Member payable','liability','credit','00000000-0000-0000-0000-000000000101') returning id into v_personal;
 v_journal:=public.service_post_double_entry_journal('BDT','runtime_test','settlement-1','runtime-ledger-0001','funded customer settlement',
  jsonb_build_array(jsonb_build_object('account_id',v_clearing,'debit',1000,'credit',0),
                    jsonb_build_object('account_id',v_member,'debit',0,'credit',1000)));
 v_retry:=public.service_post_double_entry_journal('BDT','runtime_test','settlement-1','runtime-ledger-0001','funded customer settlement',
  jsonb_build_array(jsonb_build_object('account_id',v_clearing,'debit',1000,'credit',0),
                    jsonb_build_object('account_id',v_member,'debit',0,'credit',1000)));
 if (v_journal->>'duplicate')::boolean or not (v_retry->>'duplicate')::boolean then
   raise exception 'Idempotent retry invariant failed';
 end if;
 if (public.finance_journal_integrity_check()->>'integrity_ok')::boolean is not true then
   raise exception 'Ledger integrity audit failed';
 end if;
 select coalesce(sum(credit-debit),0) into v_balance from public.finance_journal_lines where account_id=v_member;
 if v_balance<>1000 then raise exception 'Member control balance mismatch'; end if;
 perform public.service_post_double_entry_journal('BDT','runtime_test','member-earned','runtime-ledger-0003','member earns payable',
  jsonb_build_array(jsonb_build_object('account_id',v_clearing,'debit',500,'credit',0),
                    jsonb_build_object('account_id',v_personal,'debit',0,'credit',500)));
 begin
   perform public.service_post_double_entry_journal('BDT','runtime_test','member-overdraw','runtime-ledger-0004','overdraw blocked',
     jsonb_build_array(jsonb_build_object('account_id',v_personal,'debit',501,'credit',0),
                       jsonb_build_object('account_id',v_clearing,'debit',0,'credit',501)));
   raise exception 'Expected Member overdraw to fail';
 exception when others then
   if sqlerrm='Expected Member overdraw to fail' then raise; end if;
 end;
 begin
   perform public.service_post_double_entry_journal('USD','runtime_test','bad-currency','runtime-ledger-0002','currency mismatch',
     jsonb_build_array(jsonb_build_object('account_id',v_clearing,'debit',1,'credit',0),
                       jsonb_build_object('account_id',v_member,'debit',0,'credit',1)));
   raise exception 'Expected currency mismatch to fail';
 exception when others then
   if sqlerrm='Expected currency mismatch to fail' then raise; end if;
 end;
 begin
   update public.finance_journals set memo='tampered' where id=(v_journal->>'journal_id')::uuid;
   raise exception 'Expected immutable journal update to fail';
 exception when others then
   if sqlerrm='Expected immutable journal update to fail' then raise; end if;
 end;
end $$;
