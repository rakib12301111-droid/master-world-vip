#!/usr/bin/env python3
"""Static checks for Admin Free / Member Paid-only entitlement policy."""
from pathlib import Path
import re
sql = Path("supabase/migrations/20261127150000_admin_free_member_paid_plan_gates.sql").read_text(encoding="utf-8")
flat = re.sub(r"\s+", " ", sql.lower())
checks = {
    "Admin audience is Free-only": "new.audience = 'admin' and new.plan_kind <> 'free'" in flat,
    "Member audience is Paid-only": "new.audience = 'member' and new.plan_kind <> 'paid'" in flat,
    "Admin Free Plan is zero price": "new.price <> 0 or new.billing_period is not null" in flat,
    "only Member Paid plans activate": "v_plan.audience <> 'member'" in flat and "v_plan.plan_kind <> 'paid'" in flat,
    "Admin cannot activate Member Paid subscription": "admin accounts use the admin free plan" in flat,
    "exact settled amount/currency enforced": "new.settled_amount is distinct from v_plan.price" in flat and "new.currency is distinct from v_plan.currency" in flat,
    "provider settlement evidence required": "new.provider_transaction_id is null" in flat and "new.provider_event_id is null" in flat and "new.provider_settled_at is null" in flat,
    "Admin Free entitlement resolver": "return 'admin_free'" in flat,
    "Member Paid entitlement resolver": "p.audience = 'member'" in flat and "p.plan_kind = 'paid'" in flat and "s.status = 'active'" in flat,
    "subscription expiry enforced": "s.expires_at > now()" in flat,
    "unauthenticated access denied": "return 'no_access'" in flat,
    "RPC is authenticated-only": "from public, anon" in flat and "to authenticated" in flat,
}
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if not all(checks.values()):
    raise SystemExit(1)
