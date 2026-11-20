#!/usr/bin/env python3
"""Static safety checks for Owner-only live service diagnostics."""
from pathlib import Path
import sys

health = Path("supabase/functions/service-health/index.ts").read_text(encoding="utf-8")
config = Path("supabase/config.toml").read_text(encoding="utf-8")
deploy = Path(".github/workflows/deploy-update-functions.yml").read_text(encoding="utf-8")
ui = Path("www/index.html").read_text(encoding="utf-8")
checks = {
    "health endpoint requires a bearer session": 'Authorization' in health and 'Bearer ' in health and '401' in health,
    "health endpoint verifies Owner role server-side": 'app_user_roles' in health and 'role !== "owner"' in health,
    "health endpoint checks schema with service-role key only server-side": 'SUPABASE_SERVICE_ROLE_KEY' in health and 'serviceRoleKey' in health,
    "health endpoint never returns secret values": 'serviceRoleKey:' not in health and 'VAPID_PRIVATE_KEY:' not in health,
    "health endpoint is JWT protected in Supabase config": '[functions.service-health]' in config and 'verify_jwt = true' in config.split('[functions.service-health]',1)[1],
    "production workflow deploys service-health": 'supabase functions deploy service-health ' in deploy,
    "production workflow checks deployment token before deploy": 'Missing SUPABASE_ACCESS_TOKEN' in deploy,
    "Update Center provides Owner live backend check": 'ownerLiveHealthCheck' in ui and 'service-health' in ui and 'ownerLiveHealthStatus' in ui,
    "browser UI does not contain service-role or VAPID private secrets": 'SUPABASE_SERVICE_ROLE_KEY' not in ui and 'VAPID_PRIVATE_KEY' not in ui,
}
for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " — " + name)
failed = [name for name, passed in checks.items() if not passed]
if failed:
    print(f"\n{len(failed)} safety check(s) failed.", file=sys.stderr)
    sys.exit(1)
print(f"\nAll {len(checks)} live health safety checks passed.")
