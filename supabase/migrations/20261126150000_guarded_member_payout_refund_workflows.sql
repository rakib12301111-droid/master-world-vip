-- MASTER WORLD VIP — guarded Member payout and customer refund workflow.
-- This creates internal requests only. It does not move money or connect payout rails.

create table if not exists public.finance_disbursement_requests (
 id uuid primary key default gen_random_uuid(),
 request_kind text not null check(request_kind in ('member_payout','customer_refund')),
 order_id uuid references public.customer_service_orders(id) on delete restrict,
 beneficiary_user_id uuid not null references auth.users(id) on delete restrict,
 source_account_id uuid not null references public.finance_accounts(id) on delete restrict,
 currency text not null check(currency in ('USD','BDT')),
 amount numeric(18,2) not null check(amount>0),
 status text not null default 'requested'
   check(status in ('requested','approved','processing','paid','failed','disputed','cancelled')),
 idempotency_key text not null unique check(char_length(btrim(idempotency_key)) between 8 and 180),
 provider text check(provider in ('sslcommerz','bkash','nagad','bank','other_approved')),
 provider_transaction_id text unique,
 provider_event_id text unique,
 provider_settled_at timestamptz,
 reconciliation_reference text,
 reconciled_at timestamptz,
 failure_reason text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 check((request_kind='member_payout' and order_id is null) or
       (request_kind='customer_refund' and order_id is not null)),
 check(status<>'paid' or (
   provider is not null and provider_transaction_id is not null
   and provider_event_id is not null and provider_settled_at is not null
   and reconciliation_reference is not null and reconciled_at is not null
 ))
);
create index if not exists finance_disbursement_pending_idx
 on public.finance_disbursement_requests(source_account_id,status,created_at)
 where status in ('requested','approved','processing','disputed');

create or replace function public.guard_finance_disbursement_request()
returns trigger language plpgsql security definer set search_path=''
as $function$
declare
 v_source public.finance_accounts%rowtype;
 v_journal_id uuid;
 v_debit numeric(18,2);
 v_credit numeric(18,2);
begin
 if tg_op='UPDATE' then
  if new.id is distinct from old.id or new.request_kind is distinct from old.request_kind
   or new.order_id is distinct from old.order_id
   or new.beneficiary_user_id is distinct from old.beneficiary_user_id
   or new.source_account_id is distinct from old.source_account_id
   or new.currency is distinct from old.currency or new.amount is distinct from old.amount
   or new.idempotency_key is distinct from old.idempotency_key then
   raise exception 'Disbursement identity and financial terms are immutable';
  end if;
  if new.status is distinct from old.status and not (
    (old.status='requested' and new.status in ('approved','cancelled'))
    or (old.status='approved' and new.status in ('processing','cancelled'))
    or (old.status='processing' and new.status in ('paid','failed','disputed'))
    or (old.status='failed' and new.status in ('processing','cancelled'))
    or (old.status='disputed' and new.status in ('processing','cancelled'))
  ) then raise exception 'Invalid disbursement state transition'; end if;
 end if;
 if new.status='paid' then
  if new.provider is null or new.provider_transaction_id is null or new.provider_event_id is null
   or new.provider_settled_at is null or new.reconciliation_reference is null or new.reconciled_at is null then
   raise exception 'Provider settlement and reconciliation evidence required before paid state';
  end if;
  select * into v_source from public.finance_accounts where id=new.source_account_id;
  if not found or v_source.currency<>new.currency then raise exception 'Disbursement source account mismatch'; end if;
  select j.id into v_journal_id
   from public.finance_journals j
   join public.finance_journal_lines debit_line on debit_line.journal_id=j.id
   join public.finance_accounts debit_account on debit_account.id=debit_line.account_id
   join public.finance_journal_lines credit_line on credit_line.journal_id=j.id
   join public.finance_accounts credit_account on credit_account.id=credit_line.account_id
   where j.reference_type='disbursement'
    and j.reference_id=new.id::text and j.currency=new.currency
    and debit_line.account_id=new.source_account_id and debit_line.debit=new.amount and debit_line.credit=0
    and credit_account.account_code='operating_cash'
    and credit_line.credit=new.amount and credit_line.debit=0
   limit 1;
  if v_journal_id is null then raise exception 'Balanced disbursement journal is required before marking paid'; end if;
 end if;
 new.updated_at=now();
 return new;
end;
$function$;
revoke all on function public.guard_finance_disbursement_request() from public,anon,authenticated;
drop trigger if exists finance_disbursement_request_guard on public.finance_disbursement_requests;
create trigger finance_disbursement_request_guard
 before update on public.finance_disbursement_requests
 for each row execute function public.guard_finance_disbursement_request();
create or replace function public.reject_finance_disbursement_delete()
returns trigger language plpgsql security definer set search_path=''
as $function$
begin raise exception 'Financial disbursement requests cannot be deleted'; end;
$function$;
revoke all on function public.reject_finance_disbursement_delete() from public,anon,authenticated;
create trigger finance_disbursement_no_delete before delete on public.finance_disbursement_requests
 for each row execute function public.reject_finance_disbursement_delete();

create or replace function public.service_create_member_payout_request(
 p_member_user_id uuid,p_currency text,p_amount numeric,p_idempotency_key text
) returns uuid language plpgsql security definer set search_path=''
as $function$
declare v_account public.finance_accounts%rowtype; v_available numeric(18,2); v_pending numeric(18,2); v_id uuid;
begin
 if coalesce(current_setting('request.jwt.claim.role',true),'')<>'service_role'
  and current_user<>'service_role' then raise exception 'Trusted finance service role required'; end if;
 if p_amount is null or p_amount<=0 or round(p_amount,2)<>p_amount then raise exception 'Valid payout amount required'; end if;
 select * into v_account from public.finance_accounts
  where account_code='member_payable' and owner_user_id=p_member_user_id and currency=p_currency for update;
 if not found then raise exception 'Member payable account not found'; end if;
 select coalesce(sum(l.credit-l.debit),0) into v_available
  from public.finance_journal_lines l where l.account_id=v_account.id;
 select coalesce(sum(amount),0) into v_pending from public.finance_disbursement_requests
  where source_account_id=v_account.id and status in ('requested','approved','processing','disputed');
 if p_amount>v_available-v_pending then raise exception 'Payout exceeds available Member payable balance'; end if;
 insert into public.finance_disbursement_requests(request_kind,beneficiary_user_id,source_account_id,currency,amount,idempotency_key)
 values('member_payout',p_member_user_id,v_account.id,p_currency,p_amount,p_idempotency_key)
 returning id into v_id;
 return v_id;
end;
$function$;
revoke all on function public.service_create_member_payout_request(uuid,text,numeric,text) from public,anon,authenticated;
grant execute on function public.service_create_member_payout_request(uuid,text,numeric,text) to service_role;

create or replace function public.service_create_customer_refund_request(
 p_order_id uuid,p_customer_user_id uuid,p_currency text,p_amount numeric,p_idempotency_key text
) returns uuid language plpgsql security definer set search_path=''
as $function$
declare v_order public.customer_service_orders%rowtype; v_account public.finance_accounts%rowtype;
 v_available numeric(18,2); v_pending numeric(18,2); v_id uuid;
begin
 if coalesce(current_setting('request.jwt.claim.role',true),'')<>'service_role'
  and current_user<>'service_role' then raise exception 'Trusted finance service role required'; end if;
 if p_amount is null or p_amount<=0 or round(p_amount,2)<>p_amount then raise exception 'Valid refund amount required'; end if;
 select * into v_order from public.customer_service_orders where id=p_order_id for share;
 if not found or v_order.customer_user_id<>p_customer_user_id or v_order.currency<>p_currency
  or v_order.status not in ('cancelled','disputed','refunded') then
  raise exception 'Refund requires the matching cancelled, disputed or refunded order';
 end if;
 select * into v_account from public.finance_accounts
  where currency=p_currency and account_code='customer_refunds' and owner_user_id is null for update;
 if not found then raise exception 'Customer refund liability account not found'; end if;
 select coalesce(sum(l.credit-l.debit),0) into v_available
  from public.finance_journal_lines l where l.account_id=v_account.id;
 select coalesce(sum(amount),0) into v_pending from public.finance_disbursement_requests
  where source_account_id=v_account.id and status in ('requested','approved','processing','disputed');
 if p_amount>v_available-v_pending then raise exception 'Refund exceeds available customer refund liability'; end if;
 insert into public.finance_disbursement_requests(request_kind,order_id,beneficiary_user_id,source_account_id,currency,amount,idempotency_key)
 values('customer_refund',p_order_id,p_customer_user_id,v_account.id,p_currency,p_amount,p_idempotency_key)
 returning id into v_id;
 return v_id;
end;
$function$;
revoke all on function public.service_create_customer_refund_request(uuid,uuid,text,numeric,text) from public,anon,authenticated;
grant execute on function public.service_create_customer_refund_request(uuid,uuid,text,numeric,text) to service_role;

alter table public.finance_disbursement_requests enable row level security;
revoke all on public.finance_disbursement_requests from public,anon,authenticated;
grant select,insert,update on public.finance_disbursement_requests to service_role;
comment on table public.finance_disbursement_requests is
 'Internal Member payout/customer refund workflow. Paid requires provider settlement evidence and a balanced ledger journal; no cash transfer rail is included.';
