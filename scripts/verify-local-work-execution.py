#!/usr/bin/env python3
"""Static safety checks for the no-money local work queue and worker handlers."""
from pathlib import Path

sql = Path("supabase/migrations/20261128100000_local_work_execution_mvp.sql").read_text(encoding="utf-8").lower()
worker = Path("supabase/functions/project-automation-worker/index.ts").read_text(encoding="utf-8")

checks = {
    "local queue supports bounded deterministic task types": all(x in sql for x in (
        "'text_cleanup'", "'text_quality_report'", "'json_validate'", "'csv_validate'",
        "char_length(v_text)>50000")),
    "admin enqueue requires admin role and idempotency key": "is_admin_auto_work_admin()" in sql and "idempotency_key" in sql,
    "worker claim and finish are service-role only": "auth.role()<>'service_role'" in sql and "worker_claim_local_work_task" in sql and "worker_finish_local_work_task" in sql,
    "worker tasks use lease tokens and bounded retries": "lease_token" in sql and "lease_expires_at" in sql and "max_attempts" in sql,
    "member queue is scoped to the authenticated member": "get_my_admin_access()<>'member'" in sql and "assigned_member_id=auth.uid()" in sql,
    "member claim is atomic and skips locked work": "for update skip locked" in sql and "member_claim_next_local_work_task" in sql,
    "member submission requires assigned ownership": "status='claimed' and assigned_member_id=auth.uid()" in sql,
    "admin review accepts or sends work back": "admin_review_local_work_task" in sql and "then 'accepted' else 'rework'" in sql,
    "RLS enabled and direct client table access revoked": "enable row level security" in sql and "from public,anon,authenticated" in sql,
    "worker runs local text cleanup and quality report": 'task.task_type === "text_cleanup"' in worker and 'task.task_type === "text_quality_report"' in worker and "cleaned_text" in worker,
    "worker validates JSON and CSV locally": 'task.task_type === "json_validate"' in worker and 'task.task_type === "csv_validate"' in worker and "parseCsv" in worker,
    "worker stores results through lease-bound RPC": "worker_finish_local_work_task" in worker and "p_lease_token: localTask.lease_token" in worker and "p_result: result" in worker,
    "local worker declares no external or financial effects": "financial_effects: false" in worker and "external_side_effects: false" in worker,
    "local work processor does not call payment providers": not any(x in worker.lower() for x in ("sslcommerz", "bkash", "nagad", "stripe", "paypal")),
}
for label, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + label)
if not all(checks.values()):
    raise SystemExit(1)
