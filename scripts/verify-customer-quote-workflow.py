#!/usr/bin/env python3
"""Static safety checks for the customer quote workflow."""
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
migration = (root / "supabase/migrations/20261127140000_customer_quote_workflow.sql").read_text()
customer = (root / "www/services.html").read_text()
admin = (root / "www/admin-quotes.html").read_text()
dashboard = (root / "www/index.html").read_text()
runtime = (root / "supabase/tests/customer-quote-workflow-runtime.sql").read_text()
staging_workflow = (root / ".github/workflows/apply-staging-supabase-migrations.yml").read_text()

checks = {
    "quote requests are private and RLS enabled": "alter table public.customer_quote_requests enable row level security" in migration,
    "customer can read own requests only": "customer_user_id = auth.uid()" in migration,
    "Admin access uses server-side RBAC": "public.is_customer_quote_staff()" in migration and "r.role in ('owner','super_admin','admin')" in migration,
    "client direct table writes are revoked": "revoke all on public.customer_quote_requests, public.customer_quote_request_events from public, anon, authenticated" in migration,
    "submission requires authentication": "if v_user is null then raise exception 'Authentication required'" in migration,
    "submission has per-user rate limit and concurrency lock": "pg_advisory_xact_lock" in migration and "Quote request rate limit reached" in migration,
    "quote amount and expiry are validated": "finite positive value" in migration and "Quote expiry must be between 1 hour and 30 days" in migration,
    "customer acceptance is separate from order/payment": "Accepted quote is not a paid order" in migration and "customer_respond_to_quote" in migration,
    "quote event history is append-only": "Customer quote events are append-only" in migration,
    "submitted scope and quote terms are immutable": "Customer quote request identity and submitted scope are immutable" in migration and "Issued quote terms are immutable" in migration,
    "quote requests cannot be deleted": "Customer quote requests cannot be deleted" in migration,
    "customer UI calls secure submit RPC": "submit_my_customer_quote_request" in customer,
    "customer UI has no service-role key": "service_role" not in customer.lower(),
    "Admin UI verifies server role": "get_my_admin_access" in admin,
    "Admin UI calls quote RPCs": "admin_review_customer_quote_request" in admin and "admin_send_customer_quote" in admin,
    "Admin link hidden until role verification": "customerQuoteAdminLink" in dashboard and "quoteLink.hidden=!canViewAutoWork" in dashboard,
    "runtime test covers cross-customer privacy": "Customer B can read another customer quote request" in runtime,
    "runtime test covers Admin quote and customer acceptance": "admin_send_customer_quote" in runtime and "customer_respond_to_quote" in runtime,
    "runtime test covers customer cancellation": "cancel_my_customer_quote_request" in runtime and "Customer quote cancellation was not recorded" in runtime,
    "runtime test covers append-only event guard": "Append-only quote event mutation unexpectedly succeeded" in runtime,
    "Staging migration workflow is manual-only and preview-default": "workflow_dispatch:" in staging_workflow and "default: \"no\"" in staging_workflow and "\n  push:" not in staging_workflow,
    "Staging workflow refuses known Production project": 'SUPABASE_PROJECT_REF" != "lztbbrzeuyjkuiyzrsxp' in staging_workflow,
    "Staging apply requires backup, restore and exact confirmation": "confirm_staging_backup" in staging_workflow and "confirm_staging_restore_tested" in staging_workflow and "APPLY-MASTER-WORLD-VIP-STAGING-MIGRATIONS" in staging_workflow,
    "Staging workflow uses separate Staging-only secrets": "SUPABASE_STAGING_ACCESS_TOKEN" in staging_workflow and "SUPABASE_STAGING_PROJECT_REF" in staging_workflow and "SUPABASE_STAGING_DB_URL" in staging_workflow,
    "runtime SQL dollar delimiters are balanced": runtime.count(chr(36) * 2) % 2 == 0 and "do $" + chr(10) not in runtime and "end $;" + chr(10) not in runtime,
}

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " " + name)
if failed:
    raise SystemExit(f"{len(failed)} customer quote workflow check(s) failed")
print(f"PASS all {len(checks)} customer quote workflow checks")

# The repository safety workflow installs Node.js before invoking this verifier.
node = shutil.which("node")
if not node:
    raise SystemExit("Node.js is required to syntax-check customer quote UI scripts")
for html_path in (root / "www/services.html", root / "www/admin-quotes.html"):
    html = html_path.read_text()
    inline_scripts = re.findall(r"<script[^>]*>(.*?)</script>", html, flags=re.S | re.I)
    for index, source in enumerate(inline_scripts):
        if not source.strip():
            continue
        with tempfile.NamedTemporaryFile("w", suffix=".js", encoding="utf-8") as tmp:
            tmp.write(source)
            tmp.flush()
            subprocess.run([node, "--check", tmp.name], check=True)
    print("PASS JavaScript syntax " + html_path.name)
