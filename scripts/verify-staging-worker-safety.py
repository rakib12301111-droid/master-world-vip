#!/usr/bin/env python3
"""Static checks for Staging isolation and fail-closed allowlisted worker execution."""
from pathlib import Path

workflow = Path(".github/workflows/validate-staging-supabase.yml").read_text(encoding="utf-8")
worker = Path("supabase/functions/project-automation-worker/index.ts").read_text(encoding="utf-8")
migration = Path("supabase/migrations/20261127100000_worker_execution_kill_switch_and_handler_allowlist.sql").read_text(encoding="utf-8")

checks = {
    "Staging workflow is manual-only": "workflow_dispatch:" in workflow and "push:" not in workflow and "schedule:" not in workflow,
    "known Production project ref is explicitly rejected": 'PROJECT_REF" != "lztbbrzeuyjkuiyzrsxp' in workflow,
    "Staging DB host is restricted to Supabase Session Pooler": 'endswith(".pooler.supabase.com")' in workflow,
    "Staging DB uses port 5432 and /postgres": 'u.port != 5432 or u.path != "/postgres"' in workflow,
    "Staging DB username is exactly bound to project ref": 'username != "postgres." + expected' in workflow,
    "Staging DB password is required": "or not password" in workflow,
    "Staging API URL host is bound to project ref": 'u.hostname != expected + ".supabase.co"' in workflow,
    "Staging API endpoint must use HTTPS and no unexpected URL parts": 'u.scheme != "https"' in workflow and "u.query or u.fragment" in workflow,
    "three distinct Staging Auth identities are required": "Owner, Admin and Member must be three distinct Staging Auth users" in workflow,
    "worker is disabled unless explicit function secret is true": 'Deno.env.get("MWVIP_WORKER_ENABLED") !== "true"' in worker,
    "worker requires service-role bearer authorization": 'auth !== `Bearer ${serviceKey}`' in worker,
    "worker claims only through the database RPC": "worker_claim_project_automation_task" in worker,
    "worker implements only read-only system health handler": "system_health_check" in worker and "external_side_effects: false" in worker and "financial_effects: false" in worker,
    "worker completes task with lease token and zero-cost handler": "p_lease_token: task.lease_token" in worker and "p_actual_cost: 0" in worker,
    "worker fails closed for unimplemented task types": "Task type is not implemented by this worker." in worker,
    "database emergency stop defaults to true": "emergency_stop boolean not null default true" in migration,
    "database claim checks emergency stop and read-only allowlist": "emergency_stop=false" in migration and "h.side_effect_class='read_only'" in migration,
    "worker never reports revenue enabled": "revenue_enabled: false" in worker,
    "worker key is not returned in the response": "worker: workerKey" not in worker and "worker_registered: true" in worker,
    "RPC response bodies are not exposed in errors": "text.slice(0, 500)" not in worker and 'return json({ error: "Worker operation failed" }, 500)' in worker,
}
for label, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + label)
if not all(checks.values()):
    raise SystemExit(1)
