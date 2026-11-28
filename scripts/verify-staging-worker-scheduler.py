#!/usr/bin/env python3
"""Static safety checks for the opt-in Staging worker scheduler."""
from pathlib import Path

workflow = Path(".github/workflows/staging-worker-scheduler.yml").read_text(encoding="utf-8")
worker = Path("supabase/functions/project-automation-worker/index.ts").read_text(encoding="utf-8")

checks = {
    "scheduler uses a five-minute cadence": 'cron: "*/5 * * * *"' in workflow,
    "scheduler is opt-in through a repository variable": "vars.STAGING_WORKER_SCHEDULER_ENABLED == 'true'" in workflow,
    "scheduler targets only the confirmed Staging Supabase project": 'awatzrapqrteybgspqlq.supabase.co' in workflow,
    "scheduler requires a Staging service-role secret": "STAGING_SUPABASE_SERVICE_ROLE_KEY" in workflow,
    "scheduler uses the deployed project automation Edge Function": "/functions/v1/project-automation-worker" in workflow,
    "scheduler sends service-role bearer and apikey headers": 'Authorization: Bearer $SERVICE_ROLE_KEY' in workflow and 'apikey: $SERVICE_ROLE_KEY' in workflow,
    "scheduler fails if the Edge Function remains disabled": "status != \"disabled\"" in workflow,
    "scheduler never prints worker response/task content": "Never print the response body, task input, or task result." in workflow,
    "Edge Function remains disabled unless its separate function secret is explicitly true": 'Deno.env.get("MWVIP_WORKER_ENABLED") !== "true"' in worker,
    "worker requires exact service-role bearer authentication": 'auth !== `Bearer ${serviceKey}`' in worker,
}
for label, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + label)
if not all(checks.values()):
    raise SystemExit(1)
