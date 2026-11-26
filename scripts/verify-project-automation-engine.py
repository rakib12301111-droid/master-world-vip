#!/usr/bin/env python3
"""Static safety checks for the central 4,000-project orchestration migration."""
from pathlib import Path
import re

sql = Path("supabase/migrations/20261126110000_project_automation_engine.sql").read_text(encoding="utf-8")
flat = re.sub(r"\s+", " ", sql.lower())
checks = {
    "project scheduler, worker, queue and audit tables exist": all(x in flat for x in (
        "create table if not exists public.project_automation_settings",
        "create table if not exists public.project_automation_workers",
        "create table if not exists public.project_automation_tasks",
        "create table if not exists public.project_automation_audit")),
    "all scheduler settings default disabled with zero budget": "enabled boolean not null default false" in flat and "daily_budget numeric(14,2) not null default 0" in flat,
    "tasks are idempotent with bounded retries": "idempotency_key text not null unique" in flat and "max_attempts integer not null default 3" in flat,
    "worker claims use a lease and skip locked": "lease_token" in flat and "for update of t skip locked" in flat,
    "one running task per project": "project_automation_one_running_per_project_idx" in flat,
    "execution requires separately enabled registry project": "r.execution_enabled and r.budget_cap>0" in flat,
    "scheduler only queues due, enabled projects": "where s.enabled and s.next_run_at<=now()" in flat,
    "admin scheduler enable requires approved positive project budget": "project execution must be separately enabled" in flat and "p_daily_budget>v_project.budget_cap" in flat,
    "daily and per-task budgets enforced": "project daily budget cap exceeded" in flat and "task budget cap exceeded" in flat,
    "retries become dead letters after max attempts": "dead_letter" in flat and "attempts>=max_attempts" in flat,
    "worker operations are service-role only": all(f"to service_role" in flat for _ in [0]) and "auth.role()<>'service_role'" in flat,
    "RLS enabled and client table access revoked": "enable row level security" in flat and "from anon,authenticated" in flat,
    "no external payments or revenue collection": not any(x in flat for x in ("stripe.checkout", "sslcommerz", "bkash", "nagad", "net.http_post", "http_post(")),
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if failed:
    raise SystemExit(1)
