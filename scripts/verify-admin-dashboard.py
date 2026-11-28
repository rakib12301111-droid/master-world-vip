from pathlib import Path

source = Path("www/admin-dashboard.js").read_text(encoding="utf-8")
checks = {
    "server-side role RPC is required": "get_my_admin_access" in source,
    "only privileged roles are allowed": "['owner','super_admin','admin']" in source,
    "registry overview is fetched through server RPC": "admin_project_automation_overview" in source,
    "no browser-side service role secret": "service_role" not in source and "sb_secret_" not in source,
    "execution is not enabled from this dashboard": "admin_configure_project_schedule" not in source and "scheduler_enqueue_due_project_tasks" not in source,
    "execution readiness defaults to NOT READY": "d.execution_ready===true?'READY':'NOT READY'" in source,
    "Admin page is hidden for unauthorized users": "legacy.hidden=!allowed" in source,
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + ": " + name)
if failed:
    raise SystemExit(1)
