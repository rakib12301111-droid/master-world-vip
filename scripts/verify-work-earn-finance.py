#!/usr/bin/env python3
"""Static regression checks for the Work & Earn wallet / Owner profit migration."""
from pathlib import Path
import re
import sys

migration_path = Path('supabase/migrations/20261125160000_work_earn_wallet_owner_profit.sql')
sql = migration_path.read_text(encoding='utf-8')
workflow = Path('.github/workflows/apply-supabase-migrations.yml').read_text(encoding='utf-8')
readme = Path('supabase/README.md').read_text(encoding='utf-8')
tests = Path('docs/WORK_EARN_WALLET_OWNER_PROFIT_ACCEPTANCE_TEST_BN.md').read_text(encoding='utf-8')

checks = {
    'migration exists and SQL dollar delimiters are balanced': migration_path.exists() and sql.count('$$') >= 10 and sql.count('$$') % 2 == 0,
    'no malformed dollar delimiters or escaped newline artifacts': not re.search(r'\\bas \\$(?!\\$)', sql) and r'\\n' not in sql,
    'member wallet and Owner profit are separate tables': 'create table if not exists public.member_work_wallet_ledger' in sql and 'create table if not exists public.owner_work_profit_ledger' in sql,
    'both ledgers are append-only for browser roles': 'revoke all on public.work_earn_payment_events' in sql and 'from public,anon,authenticated' in sql and 'grant select on public.member_work_wallet_ledger to authenticated' in sql,
    'member ledger has unique idempotency key': 'idempotency_key text not null unique' in sql,
    'provider event and transaction references are unique': 'provider_event_id text not null unique' in sql and 'provider_transaction_id text not null unique' in sql,
    'payment requires provider verification and client acceptance': "status <> 'settled' or (provider_verified_at is not null and client_accepted_at is not null)" in sql and "v_event.status<>'settled'" in sql,
    'reconciliation gate requires ledger, refund reserve and operating budget': all(x in sql for x in ['ledger_reconciled','refund_reserves_fully_covered','operating_budget_sufficient','valid_until < now()']),
    'default commission rate is 20 percent and bounded': 'owner_profit_rate numeric(5,2) not null default 20.00' in sql and 'owner_profit_rate between 0 and 50' in sql,
    'rate change is Owner-only and audited': 'owner_set_work_earn_profit_rate' in sql and 'work_earn_commission_settings_audit' in sql and 'work_earn_owner_profit_rate_changed' in sql,
    'settlement posting is service-role-only': "coalesce(auth.role(),'') <> 'service_role'" in sql and 'to service_role' in sql,
    'member full payable and Owner profit are posted in one RPC transaction': 'service_post_work_earn_settlement' in sql and 'member_work_wallet_ledger' in sql and 'owner_work_profit_ledger' in sql,
    'Owner profit is based on distributable net platform fee': 'v_net := greatest(0,p_platform_fee_gross-p_tax_amount-p_provider_fee-p_operating_cost-p_restricted_liability)' in sql and 'v_profit := round(v_net*v_rate/100,2)' in sql,
    'gross client receipt must equal member payable plus platform fee': 'gross_received = member_payable + platform_fee_gross' in sql and 'v_event.gross_amount <> p_member_payable+p_platform_fee_gross' in sql,
    'duplicate retries return original settlement and collisions fail': "'duplicate',true" in sql and 'already used by another settlement' in sql,
    'exactly one Owner is required': 'v_owner_count <> 1' in sql,
    'member and Owner ledger reads are role-scoped': 'get_my_work_earn_wallet' in sql and 'get_my_work_earn_profit_ledger' in sql and 'owner_user_id=auth.uid()' in sql,
    'provider and reconciliation inputs are writable only by service role': 'grant select,insert,update on public.work_earn_payment_events,public.finance_reconciliation_snapshots to service_role' in sql,
    'migration is in guarded production preflight and README order': '20261125160000_work_earn_wallet_owner_profit.sql' in workflow and '20261125160000_work_earn_wallet_owner_profit.sql' in readme,
    'acceptance test covers retries, rollback, gates and payout distinction': all(x in tests for x in ['Duplicate webhook/retry','Atomic rollback','Fail-closed gates','No fake cash']),
    'no provider or cash payout is falsely declared live': 'does not itself prove custody of funds' in sql and 'Internal wallet/accrual entries are not cash transfers' in readme,
}
for name, passed in checks.items():
    print(('PASS' if passed else 'FAIL') + ' — ' + name)
failed = [name for name, passed in checks.items() if not passed]
if failed:
    print(f'\\n{len(failed)} Work & Earn finance check(s) failed.', file=sys.stderr)
    sys.exit(1)
print(f'\\nAll {len(checks)} Work & Earn finance static checks passed.')
