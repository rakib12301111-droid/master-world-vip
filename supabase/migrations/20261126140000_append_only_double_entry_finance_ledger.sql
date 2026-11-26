-- MASTER WORLD VIP — append-only double-entry finance ledger (USD + BDT).
-- Ledger entries are accounting records, NOT proof of external custody or bank balances.
-- No live payment provider, bank, payout rail or real funds are connected by this migration.

create table if not exists public.finance_accounts (
  id uuid primary key default gen_random_uuid(),
  currency text not null check (currency in ('USD','BDT')),
  account_code text not null check (account_code ~ '^[a-z][a-z0-9_]{1,63}$'),
  account_name text not null check (char_length(btrim(account_name)) between 2 and 120),
  account_class text not null check (account_class in ('asset','liability','equity','revenue','expense')),
  normal_side text not null check (normal_side in ('debit','credit')),
  owner_user_id uuid references auth.users(id) on delete restrict,
  is_system boolean not null default false,
  created_at timestamptz not null default now(),
  check ((account_code='member_payable' and owner_user_id is not null and account_class='liability' and normal_side='credit')
      or (account_code<>'member_payable' and owner_user_id is null))
);
create unique index if not exists finance_accounts_system_code_uidx
  on public.finance_accounts(currency,account_code) where owner_user_id is null;
create unique index if not exists finance_accounts_member_code_uidx
  on public.finance_accounts(currency,account_code,owner_user_id) where owner_user_id is not null;

create table if not exists public.finance_journals (
  id uuid primary key default gen_random_uuid(),
  currency text not null check (currency in ('USD','BDT')),
  reference_type text not null check (char_length(btrim(reference_type)) between 2 and 80),
  reference_id text not null check (char_length(btrim(reference_id)) between 2 and 180),
  idempotency_key text not null unique check (char_length(btrim(idempotency_key)) between 8 and 180),
  memo text not null check (char_length(btrim(memo)) between 3 and 500),
  request_lines jsonb not null check (jsonb_typeof(request_lines)='array'),
  posted_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index if not exists finance_journals_reference_idx
  on public.finance_journals(reference_type,reference_id,posted_at desc);

create table if not exists public.finance_journal_lines (
  id bigint generated always as identity primary key,
  journal_id uuid not null references public.finance_journals(id) on delete restrict,
  account_id uuid not null references public.finance_accounts(id) on delete restrict,
  currency text not null check (currency in ('USD','BDT')),
  debit numeric(18,2) not null default 0 check (debit>=0),
  credit numeric(18,2) not null default 0 check (credit>=0),
  created_at timestamptz not null default now(),
  check ((debit>0 and credit=0) or (credit>0 and debit=0)),
  unique(journal_id,account_id)
);
create index if not exists finance_journal_lines_account_idx
  on public.finance_journal_lines(account_id,journal_id);

-- Fixed system chart of accounts, separately denominated for USD and BDT.
insert into public.finance_accounts(currency,account_code,account_name,account_class,normal_side,is_system)
select c.currency,a.account_code,a.account_name,a.account_class,a.normal_side,true
from (values ('USD'),('BDT')) c(currency)
cross join (values
 ('gateway_clearing','Verified gateway clearing','asset','debit'),
 ('refund_reserve','Customer refund and chargeback reserve','liability','credit'),
 ('operating_cash','Operating funds','asset','debit'),
 ('platform_revenue','Platform earned revenue','revenue','credit'),
 ('customer_refunds','Customer refunds payable','liability','credit'),
 ('member_payable_control','Member payable control','liability','credit')
) a(account_code,account_name,account_class,normal_side)
on conflict do nothing;

create or replace function public.reject_finance_ledger_mutation()
returns trigger language plpgsql security definer set search_path=''
as $function$
begin
  raise exception 'Posted finance ledger records are append-only; use a compensating journal entry';
end;
$function$;
revoke all on function public.reject_finance_ledger_mutation() from public,anon,authenticated;
drop trigger if exists finance_journals_no_mutation on public.finance_journals;
create trigger finance_journals_no_mutation
 before update or delete on public.finance_journals
 for each row execute function public.reject_finance_ledger_mutation();
drop trigger if exists finance_journal_lines_no_mutation on public.finance_journal_lines;
create trigger finance_journal_lines_no_mutation
 before update or delete on public.finance_journal_lines
 for each row execute function public.reject_finance_ledger_mutation();
drop trigger if exists finance_accounts_no_mutation on public.finance_accounts;
create trigger finance_accounts_no_mutation
 before update or delete on public.finance_accounts
 for each row execute function public.reject_finance_ledger_mutation();

create or replace function public.service_post_double_entry_journal(
 p_currency text,
 p_reference_type text,
 p_reference_id text,
 p_idempotency_key text,
 p_memo text,
 p_lines jsonb
) returns jsonb
language plpgsql security definer set search_path=''
as $function$
declare
 v_existing public.finance_journals%rowtype;
 v_journal_id uuid;
 v_line jsonb;
 v_account public.finance_accounts%rowtype;
 v_count integer;
 v_debits numeric(18,2);
 v_credits numeric(18,2);
 v_account_id uuid;
 v_balance numeric(18,2);
begin
 if coalesce(current_setting('request.jwt.claim.role',true),'')<>'service_role'
   and current_user<>'service_role' then
   raise exception 'Trusted finance service role required';
 end if;
 if p_currency not in ('USD','BDT') then raise exception 'Unsupported currency'; end if;
 if jsonb_typeof(p_lines)<>'array' or jsonb_array_length(p_lines)<2 then
   raise exception 'At least two journal lines are required';
 end if;
 if char_length(btrim(coalesce(p_idempotency_key,''))) not between 8 and 180 then
   raise exception 'Valid idempotency key required';
 end if;
 if char_length(btrim(coalesce(p_reference_type,''))) not between 2 and 80
   or char_length(btrim(coalesce(p_reference_id,''))) not between 2 and 180
   or char_length(btrim(coalesce(p_memo,''))) not between 3 and 500 then
   raise exception 'Journal reference and memo are required';
 end if;

 select count(*),coalesce(sum((x->>'debit')::numeric),0),coalesce(sum((x->>'credit')::numeric),0)
 into v_count,v_debits,v_credits from jsonb_array_elements(p_lines) x;
 if v_count<>jsonb_array_length(p_lines) or v_debits<=0 or v_debits<>v_credits
   or exists(select 1 from jsonb_array_elements(p_lines) x
     where coalesce((x->>'debit')::numeric,0)<0 or coalesce((x->>'credit')::numeric,0)<0
       or ((coalesce((x->>'debit')::numeric,0)>0)=(coalesce((x->>'credit')::numeric,0)>0))
       or round(coalesce((x->>'debit')::numeric,0),2)<>coalesce((x->>'debit')::numeric,0)
       or round(coalesce((x->>'credit')::numeric,0),2)<>coalesce((x->>'credit')::numeric,0))
 then raise exception 'Journal must have positive, two-decimal, one-sided lines and equal debit/credit totals'; end if;

 if exists(select 1 from jsonb_array_elements(p_lines) x
   group by x->>'account_id' having count(*)>1) then
   raise exception 'Each account may appear only once per journal';
 end if;

 -- Lock every account in deterministic order to prevent concurrent overspending.
 for v_account_id in
   select (x->>'account_id')::uuid from jsonb_array_elements(p_lines) x
   order by (x->>'account_id')::uuid
 loop
   select * into v_account from public.finance_accounts where id=v_account_id for update;
   if not found or v_account.currency<>p_currency then
     raise exception 'Journal account missing or currency mismatch';
   end if;
 end loop;

 -- A Member payable liability may only be debited up to its own accrued balance.
 for v_line in select x from jsonb_array_elements(p_lines) x loop
   select * into v_account from public.finance_accounts
    where id=(v_line->>'account_id')::uuid;
   if v_account.account_code='member_payable' then
     if v_account.owner_user_id is null then raise exception 'Member payable must belong to one Member'; end if;
     select coalesce(sum(l.credit-l.debit),0) into v_balance
       from public.finance_journal_lines l
       where l.account_id=v_account.id;
     if coalesce((v_line->>'debit')::numeric,0)>v_balance then
       raise exception 'Member payout exceeds that Member own settled payable balance';
     end if;
   end if;
 end loop;

 select * into v_existing from public.finance_journals where idempotency_key=p_idempotency_key;
 if found then
   if v_existing.currency=p_currency and v_existing.reference_type=p_reference_type
     and v_existing.reference_id=p_reference_id and v_existing.memo=p_memo
     and v_existing.request_lines=p_lines then
     return jsonb_build_object('journal_id',v_existing.id,'duplicate',true);
   end if;
   raise exception 'Idempotency key collision with different journal payload';
 end if;

 insert into public.finance_journals(currency,reference_type,reference_id,idempotency_key,memo,request_lines)
 values(p_currency,p_reference_type,p_reference_id,p_idempotency_key,p_memo,p_lines)
 returning id into v_journal_id;

 insert into public.finance_journal_lines(journal_id,account_id,currency,debit,credit)
 select v_journal_id,(x->>'account_id')::uuid,p_currency,
   coalesce((x->>'debit')::numeric,0),coalesce((x->>'credit')::numeric,0)
 from jsonb_array_elements(p_lines) x;

 return jsonb_build_object('journal_id',v_journal_id,'duplicate',false,
   'currency',p_currency,'debit_total',v_debits,'credit_total',v_credits);
end;
$function$;
revoke all on function public.service_post_double_entry_journal(text,text,text,text,text,jsonb) from public,anon,authenticated;
grant execute on function public.service_post_double_entry_journal(text,text,text,text,text,jsonb) to service_role;

create or replace function public.finance_journal_integrity_check()
returns jsonb language sql stable security definer set search_path=''
as $function$
 select jsonb_build_object(
  'journals',count(distinct j.id),
  'unbalanced_journals',count(distinct j.id) filter(where coalesce(t.debits,0)<>coalesce(t.credits,0) or coalesce(t.debits,0)=0),
  'currencies',jsonb_build_object('USD',count(distinct j.id) filter(where j.currency='USD'),'BDT',count(distinct j.id) filter(where j.currency='BDT')),
  'integrity_ok',coalesce(bool_and(coalesce(t.debits,0)=coalesce(t.credits,0) and coalesce(t.debits,0)>0),true)
 )
 from public.finance_journals j
 left join lateral (select sum(l.debit) debits,sum(l.credit) credits
   from public.finance_journal_lines l where l.journal_id=j.id) t on true;
$function$;
revoke all on function public.finance_journal_integrity_check() from public,anon,authenticated;
grant execute on function public.finance_journal_integrity_check() to service_role;

alter table public.finance_accounts enable row level security;
alter table public.finance_journals enable row level security;
alter table public.finance_journal_lines enable row level security;
revoke all on public.finance_accounts,public.finance_journals,public.finance_journal_lines from public,anon,authenticated;
grant select,insert on public.finance_accounts to service_role;
grant select,insert on public.finance_journals,public.finance_journal_lines to service_role;

comment on table public.finance_accounts is 'USD/BDT chart of accounts. Ledger balances are not proof of real bank custody.';
comment on table public.finance_journals is 'Immutable, idempotent, balanced double-entry journal headers.';
comment on table public.finance_journal_lines is 'Immutable journal lines; every posted journal balances within one currency.';
