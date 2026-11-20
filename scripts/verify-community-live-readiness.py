#!/usr/bin/env python3
"""Static readiness checks for MASTER WORLD VIP community services."""
from pathlib import Path
import sys

required_functions = [
    "ai-assistant", "check-updates", "dispatch-db-update",
    "get-db-update-status", "send-push",
]
workflow = Path(".github/workflows/deploy-update-functions.yml").read_text(encoding="utf-8")
config = Path("supabase/config.toml").read_text(encoding="utf-8")
ui = Path("www/index.html").read_text(encoding="utf-8")
push = Path("supabase/functions/send-push/index.ts").read_text(encoding="utf-8")
checks = {
    "all Edge Functions are deployed by production workflow": (
        'for function_dir in supabase/functions/*/' in workflow
        and 'supabase functions deploy "$function_name" --project-ref "$SUPABASE_PROJECT_REF"' in workflow
        and all(Path("supabase/functions", name, "index.ts").exists() for name in required_functions)
    ),
    "deployment is scoped to the approved Supabase project": 'lztbbrzeuyjkuiyzrsxp' in workflow,
    "workflow fails closed when deployment secrets are missing": (
        'SUPABASE_ACCESS_TOKEN is not available' in workflow
        and 'if [ -z "${SUPABASE_ACCESS_TOKEN:-}" ]' in workflow
        and 'exit 1' in workflow
    ),
    "public update checker does not require a user JWT": '[functions.check-updates]' in config and 'verify_jwt = false' in config.split('[functions.check-updates]',1)[1].split('[',1)[0],
    "push sender requires a webhook secret": 'PUSH_WEBHOOK_SECRET' in push and 'Unauthorized webhook' in push,
    "push sender verifies notification ownership before delivery": (
        '.eq("id", record.id)' in push and '.eq("user_id", record.user_id)' in push
    ),
    "browser does not embed service-role or private VAPID secrets": (
        'SUPABASE_SERVICE_ROLE_KEY' not in ui and 'VAPID_PRIVATE_KEY' not in ui
    ),
    "private chat, inbox, group and broadcast controls exist": all(
        x in ui for x in ["sendDirectMessage", "loadInbox", "sendGroupMessage",
                          "send_member_broadcast", "member_broadcast_deliveries"]
    ),
    "PWA service worker and push subscription flow exist": (
        "navigator.serviceWorker" in ui and "pushManager.subscribe" in ui
    ),
    "live acceptance guide exists": Path("docs/COMMUNITY_LIVE_READINESS.md").exists(),
}
for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " — " + name)
failed = [name for name, passed in checks.items() if not passed]
if failed:
    print(f"\n{len(failed)} readiness check(s) failed.", file=sys.stderr)
    sys.exit(1)
print(f"\nAll {len(checks)} community readiness checks passed.")
