#!/usr/bin/env python3
"""Static safety checks for the MASTER WORLD VIP Owner compensation ledger."""
from pathlib import Path
import sys

sql = Path("supabase/migrations/202611240004_owner_monthly_compensation.sql").read_text(encoding="utf-8")
ui = Path("www/index.html").read_text(encoding="utf-8")
deploy = Path(".github/workflows/apply-supabase-migrations.yml").read_text(encoding="utf-8")

checks = {
    "monthly minimum is fixed at BDT 1000": "minimum_amount numeric(12,2) not null default 1000.00 check (minimum_amount=1000.00)" in sql,
    "minimum top-up and due use max of commission and minimum": "greatest(minimum_amount-eligible_commission,0)" in sql and "greatest(minimum_amount,p_eligible_commission)" in sql,
    "only verified Owner role can access compensation": "r.role='owner'" in sql and sql.count("Verified Owner permission required") >= 4,
    "monthly accrual is idempotent and backfills from policy start": "on conflict(owner_user_id,period_start) do nothing" in sql and "date '2026-11-01'" in sql,
    "direct client table writes are revoked": "revoke all on public.owner_compensation_months from anon,authenticated" in sql and "revoke all on public.owner_compensation_payments from anon,authenticated" in sql,
    "commission entry requires source and non-secret reference": "Settled revenue source and non-secret ledger reference are required" in sql,
    "payments require actual reference and cannot exceed outstanding": "actual transfer reference are required" in sql and "Payment exceeds outstanding amount" in sql,
    "payment and commission changes are audited": "owner_compensation_commission_updated" in sql and "owner_compensation_payment_recorded" in sql,
    "Owner-only compensation panel and RPCs are wired": 'id="ownerCompensationPanel"' in ui and "get_my_owner_compensation" in ui and "owner_set_monthly_compensation_commission" in ui and "owner_record_compensation_payment" in ui,
    "month input validation uses correct YYYY-MM digit regex": r"/^\d{4}-\d{2}$/.test(month)" in ui,
    "guarded migration workflow includes compensation migration": "202611240004_owner_monthly_compensation.sql" in deploy,
}
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " — " + name)
failed = [name for name, ok in checks.items() if not ok]
if failed:
    sys.exit(1)
print(f"All {len(checks)} Owner compensation safety checks passed.")
