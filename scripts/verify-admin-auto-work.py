#!/usr/bin/env python3
"""Static safety regression checks for MASTER WORLD VIP 24/7 Auto Work.

These checks validate repository source only. They do not prove production
migration, worker deployment, provider connectivity, uptime, revenue or payout.
"""
from pathlib import Path
import sys

base_path = Path("supabase/migrations/20261125100000_admin_auto_work_control_plane.sql")
fix_path = Path("supabase/migrations/20261125130000_admin_auto_work_claim_concurrency_fix.sql")
page_path = Path("www/index.html")
implementation_path = Path("docs/ADMIN_AUTO_WORK_EARN_IMPLEMENTATION_BN.md")
member_policy_path = Path("docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md")
readme_path = Path("supabase/README.md")
migration_workflow_path = Path(".github/workflows/apply-supabase-migrations.yml")

base = base_path.read_text(encoding="utf-8")
fix = fix_path.read_text(encoding="utf-8")
page = page_path.read_text(encoding="utf-8")
implementation = implementation_path.read_text(encoding="utf-8")
member_policy = member_policy_path.read_text(encoding="utf-8")
readme = readme_path.read_text(encoding="utf-8")
migration_workflow = migration_workflow_path.read_text(encoding="utf-8")

checks = {
    "both additive Auto Work migrations exist and SQL delimiters are balanced":
        base_path.exists() and fix_path.exists()
        and base.count("$$") % 2 == 0 and fix.count("$$") % 2 == 0,
    "exactly five approved work types are seeded and default disabled":
        all(x in base for x in [
            "'ai_data_processing'", "'ai_translation_documents'",
            "'pdf_automation'", "'image_processing'",
            "'website_monitoring_reporting'", "enabled boolean not null default false"
        ]),
    "provider activation requires contract and Owner approval metadata":
        "status <> 'active' or (contract_reference is not null and approved_by is not null and approved_at is not null)" in base
        and "Only the Owner can approve an Auto Work provider" in base,
    "all Auto Work tables enable RLS and deny direct browser-role table access":
        all(x in base for x in [
            "alter table public.admin_auto_work_providers enable row level security",
            "alter table public.admin_auto_work_modules enable row level security",
            "alter table public.admin_auto_work_jobs enable row level security",
            "alter table public.admin_auto_work_audit enable row level security",
            "from anon,authenticated"
        ]),
    "worker claim and finish RPCs are service-role-only":
        "grant execute on function public.worker_claim_admin_auto_work_job() to service_role" in base
        and "grant execute on function public.worker_finish_admin_auto_work_job(uuid,boolean,text,numeric,text) to service_role" in base
        and "from public,anon,authenticated" in base,
    "one-running-job-per-module is enforced by a partial unique index":
        "create unique index if not exists admin_auto_work_one_running_per_module_idx" in base
        and "where status='running'" in base,
    "claim concurrency fix also checks for an existing running job":
        "and not exists (" in fix
        and "running.work_type=j.work_type and running.status='running'" in fix,
    "job enqueue requires Admin, contract, permission, idempotency and budget":
        all(x in base for x in [
            "if not public.is_admin_auto_work_admin()",
            "p_contract_reference", "p_permission_reference",
            "p_idempotency_key", "p_budget_cap_bdt"
        ]),
    "module enable requires active approved provider and positive daily budget":
        "Set a positive daily budget cap before enabling" in base
        and "v_provider_status <> 'active'" in base,
    "overview remains fail-closed until a real worker/provider is deployed":
        "'execution_ready',false" in base
        and "reviewed provider connector and deployed worker" in base,
    "existing UI is hidden by default and requires server-verified Admin role":
        'id="adminAutoWorkPanel" hidden' in page
        and "['owner','super_admin','admin'].includes(data)" in page
        and "client.rpc('admin_auto_work_overview')" in page,
    "browser UI does not call worker-only claim/finish RPCs":
        "client.rpc('worker_claim_admin_auto_work_job')" not in page
        and "client.rpc('worker_finish_admin_auto_work_job')" not in page,
    "both migrations are included in guarded migration preflight and README":
        "20261125100000_admin_auto_work_control_plane.sql" in migration_workflow
        and "20261125130000_admin_auto_work_claim_concurrency_fix.sql" in migration_workflow
        and "20261125100000_admin_auto_work_control_plane.sql" in readme
        and "20261125130000_admin_auto_work_claim_concurrency_fix.sql" in readme,
    "documentation explicitly disclaims live execution and guaranteed income":
        "does not connect a client/provider, execute jobs, create income" in implementation
        and "Member Auto Work execution" in member_policy
        and "DISABLED" in member_policy,
}

for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " — " + name)

failed = [name for name, passed in checks.items() if not passed]
if failed:
    print(f"\\n{len(failed)} Auto Work safety check(s) failed.", file=sys.stderr)
    sys.exit(1)
print(f"\\nAll {len(checks)} Auto Work static safety checks passed.")
