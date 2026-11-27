#!/usr/bin/env python3
"""Static safety checks for the customer quote workflow."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
migration = (root / "supabase/migrations/20261127140000_customer_quote_workflow.sql").read_text()
customer = (root / "www/services.html").read_text()
admin = (root / "www/admin-quotes.html").read_text()
dashboard = (root / "www/index.html").read_text()
runtime = (root / "supabase/tests/customer-quote-workflow-runtime.sql").read_text()

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
    "customer UI calls secure submit RPC": "submit_my_customer_quote_request" in customer,
    "customer UI has no service-role key": "service_role" not in customer.lower(),
    "Admin UI verifies server role": "get_my_admin_access" in admin,
    "Admin UI calls quote RPCs": "admin_review_customer_quote_request" in admin and "admin_send_customer_quote" in admin,
    "Admin link hidden until role verification": "customerQuoteAdminLink" in dashboard and "quoteLink.hidden=!canViewAutoWork" in dashboard,
    "runtime test covers cross-customer privacy": "Customer B can read another customer quote request" in runtime,
    "runtime test covers Admin quote and customer acceptance": "admin_send_customer_quote" in runtime and "customer_respond_to_quote" in runtime,
    "runtime test covers append-only event guard": "Append-only quote event mutation unexpectedly succeeded" in runtime,
}

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " " + name)
if failed:
    raise SystemExit(f"{len(failed)} customer quote workflow check(s) failed")
print(f"PASS all {len(checks)} customer quote workflow checks")
