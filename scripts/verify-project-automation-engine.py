#!/usr/bin/env python3
"""Static safety checks for the 4,000-project orchestration and worker execution controls."""
from pathlib import Path
import re

sql = Path("supabase/migrations/20261126110000_project_automation_engine.sql").read_text(encoding="utf-8")
controls = Path("supabase/migrations/20261127100000_worker_execution_kill_switch_and_handler_allowlist.sql").read_text(encoding="utf-8")
worker = Path("supabase/functions/project-automation-worker/index.ts").read_text(encoding="utf-8")
flat = re.sub(r"\s+", " ", sql.lower())
gate = re.sub(r"\s+", " ", controls.lower())
checks = {
    "project scheduler, worker, queue and audit tables exist": all(x in flat for x in (
        "create table if not exists public.project_automation_settings",
        "create table if not exists public.project_automation_workers",
        "create table if not exists public.project_automation_tasks",
        "create table if not exists public.project_automation_audit")),
    "all scheduler settings default disabled with zero budget": "enabled boolean not null default false" in flat and "daily_budget numeric(14,2) not null default 0" in flat,
    "tasks are idempotent with bounded retries": "idempotency_key text not null unique" in flat and "max_attempts integer not null default 3" in flat,
    "worker claims use a lease and skip locked": "lease_token" in flat and "for update of t,s skip locked" in flat,
    "one running task per project": "project_automation_one_running_per_project_idx" in flat,
    "execution requires separately enabled registry project": "r.execution_enabled and r.budget_cap>0" in flat,
    "scheduler only queues due, enabled projects": "where s.enabled and s.next_run_at<=now()" in flat,
    "admin scheduler enable requires approved positive project budget": "project execution must be separately enabled" in flat and "p_daily_budget>v_project.budget_cap" in flat,
    "daily and per-task budgets enforced": "project daily budget cap exceeded" in flat and "task budget cap exceeded" in flat,
    "task budget is reserved at claim and released on finish or lease expiry": "daily_reserved" in gate and "budget_reserved" in gate and "daily_spent+daily_reserved" in gate and "budget_reservation_released" in gate,
    "expired worker leases are recovered": "scheduler_reap_expired_project_task_leases" in flat and "worker lease expired before task completion" in flat,
    "retries become dead letters after max attempts": "dead_letter" in flat and "attempts>=max_attempts" in flat,
    "task claim and finish are service-role only": "auth.role()<>'service_role'" in flat and "worker_finish_project_automation_task" in flat,
    "RLS enabled and client table access revoked": "enable row level security" in flat and "from anon,authenticated" in flat,
    "emergency stop defaults to stopped": "emergency_stop boolean not null default true" in gate,
    "admin kill switch changes are audited": "admin_set_project_automation_kill_switch" in gate and "global_kill_switch_engaged" in gate and "global_kill_switch_released" in gate,
    "claim routine enforces emergency stop and read-only handler allowlist": "emergency_stop=false" in gate and "h.side_effect_class='read_only'" in gate and "t.task_type='system_health_check'" in gate,
    "worker implements only read-only system health check": "system_health_check" in worker and "external_side_effects: false" in worker and "financial_effects: false" in worker,
    "worker completes using the lease token and zero cost": "p_lease_token: task.lease_token" in worker and "p_actual_cost: 0" in worker,
    "no external payments or revenue collection": not any(x in flat for x in ("stripe.checkout", "sslcommerz", "bkash", "nagad", "net.http_post", "http_post(")),
}
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if not all(checks.values()):
    raise SystemExit(1)
