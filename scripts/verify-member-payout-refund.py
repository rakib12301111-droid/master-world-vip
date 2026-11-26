#!/usr/bin/env python3
"""Static safety checks for guarded Member payout and customer refund workflows."""
from pathlib import Path
import re
sql=Path("supabase/migrations/20261126150000_guarded_member_payout_refund_workflows.sql").read_text(encoding="utf-8").lower()
flat=re.sub(r"\s+"," ",sql)
checks={
 "payout and refund requests are separate typed workflows": "request_kind in ('member_payout','customer_refund')" in flat,
 "request financial terms are immutable": "disbursement identity and financial terms are immutable" in flat,
 "state transitions are allow-listed": "invalid disbursement state transition" in flat,
 "paid status requires provider and reconciliation evidence": all(x in flat for x in ["provider_transaction_id is not null","provider_event_id is not null","provider_settled_at is not null","reconciliation_reference is not null","reconciled_at is not null"]),
 "paid status requires a matching balanced journal reference": "balanced disbursement journal is required before marking paid" in flat and "j.reference_type='disbursement'" in flat,
 "Member payout cannot exceed available Member liability": "payout exceeds available member payable balance" in flat,
 "customer refund requires matching cancelled/disputed/refunded order": "v_order.status not in ('cancelled','disputed','refunded')" in flat,
 "refund cannot exceed available refund liability": "refund exceeds available customer refund liability" in flat,
 "pending requests reserve balance against double spending": "status in ('requested','approved','processing','disputed')" in flat,
 "requests cannot be deleted": "financial disbursement requests cannot be deleted" in flat,
 "all request writes are service-role only": "from public,anon,authenticated" in flat and "to service_role" in flat,
 "no live payout connector is claimed": "no cash transfer rail is included" in flat,
}
for name,ok in checks.items(): print(("PASS" if ok else "FAIL")+" - "+name)
if not all(checks.values()): raise SystemExit(1)
