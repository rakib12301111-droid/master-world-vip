#!/usr/bin/env python3
"""Static safety checks for the 4,000-project registry migration."""
from pathlib import Path
import re
sql = Path("supabase/migrations/20261126100000_earning_project_registry.sql").read_text(encoding="utf-8")
checks = {
    "registry table is created": "create table if not exists public.earning_project_registry" in sql.lower(),
    "stable 4,000 slot seed exists": "generate_series(1,4000)" in re.sub(r"\s+", "", sql.lower()),
    "USD and BDT split is explicit": "n<=2000" in re.sub(r"\s+", "", sql.lower()) and "international_usd" in sql and "bangladesh_bdt" in sql,
    "all slots expose Free and Paid options": "free_option_enabled" in sql and "paid_option_enabled" in sql,
    "paid plan remains unconfigured": "paid_plan_configured" in sql and "true,true,false,false,false" in re.sub(r"\s+", "", sql.lower()),
    "execution and revenue collection default off": "execution_enabled boolean not null default false" in sql.lower() and "revenue_collection_enabled boolean not null default false" in sql.lower(),
    "budget starts at zero": "budget_cap numeric(14,2) not null default 0" in sql.lower(),
    "RLS enabled and client writes revoked": "enable row level security" in sql.lower() and "revoke all on public.earning_project_registry from anon,authenticated" in sql.lower(),
    "admin-only read policy": "public.is_admin_auto_work_admin()" in sql,
    "migration asserts exact counts and no enabled projects": "v_total<>4000" in re.sub(r"\s+", "", sql.lower()) and "v_usd<>2000" in re.sub(r"\s+", "", sql.lower()) and "v_bdt<>2000" in re.sub(r"\s+", "", sql.lower()) and "v_enabled<>0" in re.sub(r"\s+", "", sql.lower()),
    "no payment or worker execution is invoked": not any(x in sql.lower() for x in ("net.http_post", "http_post(", "stripe.checkout", "sslcommerz", "bKash".lower(), "nagad")),
    "SQL dollar quote delimiters are balanced": sql.count("$$") % 2 == 0,
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " — " + name)
if failed:
    raise SystemExit(f"{len(failed)} registry safety check(s) failed")
print(f"All {len(checks)} project registry static safety checks passed.")
