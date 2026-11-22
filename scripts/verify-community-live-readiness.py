#!/usr/bin/env python3
"""Static readiness checks for MASTER WORLD VIP community services."""
from pathlib import Path
import re
import sys

required_functions = [
    "ai-assistant", "check-updates", "dispatch-db-update",
    "get-db-update-status", "send-push",
]
workflow = Path(".github/workflows/deploy-update-functions.yml").read_text(encoding="utf-8")
workflow_normalized = re.sub(r"\\\\\\s*\\n\\s*", " ", workflow)
config = Path("supabase/config.toml").read_text(encoding="utf-8")
ui = Path("www/index.html").read_text(encoding="utf-8")
push = Path("supabase/functions/send-push/index.ts").read_text(encoding="utf-8")
migration_files = sorted(Path("supabase/migrations").glob("*.sql"))
migration_versions = [p.name.split("_", 1)[0] for p in migration_files]
migration_version_unique = len(migration_versions) == len(set(migration_versions))
migration_workflow = Path(".github/workflows/apply-supabase-migrations.yml").read_text(encoding="utf-8")
verify_workflow = Path(".github/workflows/verify-supabase-migrations.yml").read_text(encoding="utf-8")
audit_workflow = Path(".github/workflows/audit-supabase-indexes-rls.yml").read_text(encoding="utf-8")
rls_workflow = Path(".github/workflows/test-two-member-rls.yml").read_text(encoding="utf-8")
audit_sql = Path("supabase/audits/production-index-rls-audit.sql").read_text(encoding="utf-8")
rls_sql = Path("supabase/audits/two-member-rls-integration-test.sql").read_text(encoding="utf-8")
android_gradle = Path("android-app/app/build.gradle").read_text(encoding="utf-8")
android_release_workflow = Path(".github/workflows/android-release.yml").read_text(encoding="utf-8")
helpdesk_sql = Path("supabase/migrations/20261121180000_member_verification_helpdesk.sql").read_text(encoding="utf-8")
location_sql = Path("supabase/migrations/20261121190000_member_live_location.sql").read_text(encoding="utf-8")
server_code_staging = Path("supabase/functions/stage-server-code/index.ts").read_text(encoding="utf-8")
migration_block_start = migration_workflow.find("for migration in ")
migration_block_end = migration_workflow.find("; do", migration_block_start)
migration_block = (
    migration_workflow[migration_block_start:migration_block_end]
    if migration_block_start >= 0 and migration_block_end > migration_block_start
    else ""
)
workflow_migrations = sorted(
    re.findall(r"\b[0-9]{12,14}_[A-Za-z0-9_-]+\.sql\b", migration_block)
)
repository_migrations = sorted(p.name for p in migration_files)
required_migrations = [
    "20261121120000_facebook_setup_orders.sql",
    "20261121130000_facebook_setup_feedback.sql",
    "20261121140000_verified_payment_state.sql",
    "20261121150000_sslcommerz_checkout_enable.sql",
    "20261121160000_trusted_devices_login_history.sql",
    "20261121170000_group_rls_recursion_fix.sql",
    "20261121180000_member_verification_helpdesk.sql",
    "20261121190000_member_live_location.sql",
    "20261122100000_messaging_realtime.sql",
]
checks = {
    "Supabase migration versions are unique": migration_version_unique,
    "production workflow covers every SQL migration exactly once": (
        workflow_migrations == repository_migrations
    ),
    "all latest database migrations are present": all(
        Path("supabase/migrations", name).exists() for name in required_migrations
    ),
    "all Edge Functions are deployed by production workflow": (
        'for function_dir in supabase/functions/*/' in workflow
        and 'supabase functions deploy "$function_name" --project-ref "$SUPABASE_PROJECT_REF"' in workflow_normalized
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
    "CI runs Node syntax validation for the published inline JavaScript": (
        "actions/setup-node@v4" in verify_workflow
        and "node-version: \"22\"" in verify_workflow
        and "python scripts/verify-inline-js.py" in verify_workflow
    ),
    "production migration workflow defaults to preview and requires explicit backup confirmation": (
        'default: "no"' in migration_workflow
        and 'supabase db push --dry-run --db-url "$SUPABASE_DB_URL"' in migration_workflow
        and 'supabase db push --db-url "$SUPABASE_DB_URL" --yes' in migration_workflow
        and "SUPABASE_DB_URL" in migration_workflow
        and "SUPABASE_ACCESS_TOKEN" in migration_workflow
        and "inputs.apply_migrations == 'yes' && inputs.confirm_recoverable_backup == 'yes' && inputs.confirm_restore_tested == 'yes'" in migration_workflow
        and "backup_reference" in migration_workflow
        and "Capture pre-migration schema snapshot" in migration_workflow
    ),
    "read-only production audit workflow requires a test member and runs the audit SQL": (
        "RLS_TEST_MEMBER_A_UUID" in audit_workflow
        and "supabase/audits/production-index-rls-audit.sql" in audit_workflow
        and "PGSSLMODE: require" in audit_workflow
    ),
    "two-member RLS workflow requires two distinct member IDs and runs the transactional test": (
        "RLS_TEST_MEMBER_A_UUID" in rls_workflow
        and "RLS_TEST_MEMBER_B_UUID" in rls_workflow
        and 'test "$MEMBER_A" != "$MEMBER_B"' in rls_workflow
        and "supabase/audits/two-member-rls-integration-test.sql" in rls_workflow
    ),
    "production audit SQL fails on missing indexes, disabled RLS or unsafe admin grants": (
        "RAISE EXCEPTION 'FAIL: required indexes missing" in audit_sql
        and "RAISE EXCEPTION 'FAIL: required tables missing or RLS disabled" in audit_sql
        and "authenticated role has direct SELECT" in audit_sql
        and "private verification/helpdesk RLS policies are missing" in audit_sql
        and "verification_request_messages_request_created_idx" in audit_sql
    ),
    "two-member RLS SQL rejects elevated fixtures and rolls back all test data": (
        "Use ordinary member accounts only" in rls_sql
        and "SET LOCAL ROLE authenticated" in rls_sql
        and "ROLLBACK;" in rls_sql
        and "B can read A private conversation" in rls_sql
        and "A cannot read own conversation" in rls_sql
        and "B can read A verification request" in rls_sql
        and "A cannot read own verification request" in rls_sql
        and "A can read B private conversation" in rls_sql
        and "B cannot read own conversation" in rls_sql
        and "A can read B verification request" in rls_sql
        and "B cannot read own verification request" in rls_sql
    ),
    "verification helpdesk UI uses secure RPCs and does not request identity secrets": (
        'id="verification"' in ui
        and "submit_my_verification_request" in ui
        and "send_verification_message" in ui
        and "review_verification_request" in ui
        and "search_discoverable_profiles" in ui
        and "password" in ui.lower()
        and "OTP" in ui
    ),
    "live location lookup is verified-phone-only, consent-based, stale-safe, rate-limited and RPC-only": (
        "phone_confirmed_at is not null" in location_sql
        and "sharing_enabled=true" in location_sql
        and "now()-interval '2 minutes'" in location_sql
        and ">=10" in location_sql
        and "revoke all on public.member_location_shares from anon, authenticated" in location_sql
        and "set_my_location_sharing" in ui
        and "update_my_live_location" in ui
        and "lookup_member_location_by_phone" in ui
        and "locationShareConsent" in ui
        and "openstreetmap.org" in ui
    ),
    "verification helpdesk is private, role-gated, rate-limited and audited": (
        "public.is_helpdesk_staff()" in helpdesk_sql
        and "status in ('pending','needs_info','approved','rejected')" in helpdesk_sql
        and "member_verification_one_active_per_user_uidx" in helpdesk_sql
        and ">= 20" in helpdesk_sql
        and ">= 3" in helpdesk_sql
        and "24 hours" in helpdesk_sql
        and "verification_request_events" in helpdesk_sql
        and "review_verification_request" in helpdesk_sql
        and "insert into public.notifications" in helpdesk_sql
        and "government IDs, passwords, OTPs or login codes" in helpdesk_sql
    ),
    "Android signed release uses repository secrets and verifies the APK signature": (
        "System.getenv(\"ANDROID_KEYSTORE_PATH\")" in android_gradle
        and "System.getenv(\"ANDROID_KEYSTORE_PASSWORD\")" in android_gradle
        and "confirm_signed_release" in android_release_workflow
        and "ANDROID_KEYSTORE_BASE64" in android_release_workflow
        and "ANDROID_KEY_ALIAS" in android_release_workflow
        and "keytool -list" in android_release_workflow
        and "apksigner" in android_release_workflow
        and "--print-certs" in android_release_workflow
        and "sha256sum" in android_release_workflow
        and "actions/upload-artifact@v4" in android_release_workflow
    ),
    "Owner Server Code Box queues SQL preview only and preserves separate production approval gates": (
        'apply_migrations: "false"' in server_code_staging
        and 'apply_migrations: "true"' not in server_code_staging
        and "No database changes were applied" in server_code_staging
        and "restore-test and confirmation gates" in server_code_staging
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
