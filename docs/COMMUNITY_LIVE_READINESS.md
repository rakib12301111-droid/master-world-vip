# MASTER WORLD VIP — Community live-readiness checklist

This checklist distinguishes repository code from verified live services. A green GitHub Pages deployment does not prove that Supabase migrations or Edge Functions have been deployed.

## Database migrations via guarded GitHub Actions workflow

The repository now includes `.github/workflows/apply-supabase-migrations.yml`. Run it manually from GitHub Actions. It defaults to preview-only (`apply_migrations=no`). It is pinned to project ref `lztbbrzeuyjkuiyzrsxp` and requires repository Actions secrets `SUPABASE_ACCESS_TOKEN` and `SUPABASE_DB_PASSWORD`. Before applying, the operator must select `apply_migrations=yes`, confirm a current recoverable backup, confirm the restore procedure was tested, and enter a non-secret backup record reference. The workflow blocks production changes if any of these confirmations is missing. Never enter passwords, access tokens, or signed backup URLs in the reference field. The project ref is hard-coded as a reviewed, fixed target, not a secret. A successful workflow run proves only that the CLI migration command completed; still verify the resulting schema and run the two-account acceptance tests below.

## Edge Functions deployed by GitHub Actions

The production workflow deploys:
- `ai-assistant`
- `check-updates`
- `dispatch-db-update`
- `get-db-update-status`
- `send-push`

Required repository-level GitHub Actions secret:
- `SUPABASE_ACCESS_TOKEN`

The approved project ref `lztbbrzeuyjkuiyzrsxp` is pinned in the workflow, not read from a secret. The workflow intentionally fails closed if the token is missing and never prints secret values.

## Supabase Edge Function runtime secrets

Configure these in Supabase Dashboard → Edge Functions → Secrets. Never put them in the website, browser storage, source code, or chat.

For authenticated database update dispatch:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `GITHUB_ACTIONS_TOKEN` (repository-scoped token with Actions workflow dispatch and read permissions)
- `GITHUB_REPOSITORY` (optional; defaults to `rakib12301111-droid/master-world-vip`)

For Web Push delivery:
- `PUSH_WEBHOOK_SECRET`
- `VAPID_PUBLIC_KEY`
- `VAPID_PRIVATE_KEY`
- `VAPID_SUBJECT` (for example a mailto contact controlled by the project owner)

The service-role key, GitHub token, VAPID private key, and webhook secret are server-only.

## Required database migrations

Run the Update Center Dry Run first and inspect its complete output. The expected migration sequence is:

1. `202611180001_master_world_vip.sql`
2. `202611190001_global_community.sql`
3. `202611190002_privacy_rights.sql`
4. `20261119180000_admin_rbac_owner_control.sql`
5. `20261119190000_member_broadcast.sql`
6. `20261119200000_update_releases.sql`
7. `20261120100000_inbox_push_foundation.sql`
8. `20261120150000_membership_helper_hardening.sql`
9. `20261121100000_profiles_discovery_privacy_hardening.sql`
10. `20261121120000_facebook_setup_orders.sql`
11. `20261121130000_facebook_setup_feedback.sql`
12. `20261121140000_verified_payment_state.sql`
13. `20261121150000_sslcommerz_checkout_enable.sql`
14. `20261121160000_trusted_devices_login_history.sql`
15. `20261121170000_group_rls_recursion_fix.sql`
16. `20261121180000_member_verification_helpdesk.sql`
17. `20261121190000_member_live_location.sql`
18. `20261122100000_messaging_realtime.sql`

Do not apply until the target project and a recent recoverable backup are confirmed. The Owner bootstrap statement is in migration 4 and is email-specific; verify that the matching auth user exists before applying. Never assume that a matching email query alone proves the role has been granted.

## Live acceptance test — two real test accounts

Use two accounts controlled by the project owner. Do not use strangers' accounts or ask users to share passwords.

### Private chat and inbox
1. Confirm migration `20261122100000_messaging_realtime.sql` is applied. The website subscribes to Supabase Realtime when available and uses a 15-second visible-page refresh fallback.
2. Account A sends a friend request to B.
3. B accepts it.
4. A starts a direct conversation and sends a unique test message.
5. B opens Inbox, confirms the conversation and unread count, then opens it.
6. B replies; A confirms the reply appears without manual page reload.
7. B confirms unread count clears; A confirms the message remains visible.
8. Verify A cannot read a conversation that neither account belongs to.

### Group chat
1. A creates a public test group.
2. B joins it.
3. A sends a unique test group message; B confirms receipt.
4. B replies; A confirms the message appears without manual page reload.
5. B opens the group through Inbox and confirms read status.
6. Verify a non-member cannot read or post to the group.

### Broadcast
1. Promote A to an authorized admin only in a controlled test environment.
2. Send one clearly labelled test broadcast.
3. B confirms it appears in Broadcast Inbox and can be marked read.
4. Confirm an ordinary member cannot call the broadcast RPC successfully.
5. Check the hourly rate limit (maximum three broadcasts per sender per hour).

### Web Push
1. Configure the runtime secrets above and deploy `send-push`.
2. Configure a Supabase Database Webhook for new notification rows to call the Edge Function, sending `x-push-webhook-secret` from a server-side secret store.
3. Use an HTTPS browser and explicitly grant notification permission on the test device.
4. Confirm subscription is saved for the signed-in user, then create a test notification and verify delivery.
5. Confirm an expired endpoint (404/410) is removed and no other user's subscriptions are exposed.

### Android / PWA
1. Open the published HTTPS website in Chrome on Android.
2. Confirm manifest and service worker load; use Chrome's Install app / Add to Home screen action.
3. Launch the installed app, sign in, and repeat chat/inbox tests.
4. Verify responsive layout, back navigation, offline shell, and notification permission flow.
5. APK/Play Store distribution is a separate packaging and release task; PWA install does not mean an APK is already published.

## What automation can and cannot prove

GitHub CI can validate repository structure and static safety checks. It cannot prove two-user message delivery, actual push delivery, Owner role assignment, Supabase schema state, or Android installation without configured server credentials and real test accounts. Record each acceptance test as PASS only after observing it on the live project.


## Profile discovery privacy correction

The new migration removes the broad discoverable-profile table SELECT policy because permissive PostgreSQL policies combine with OR. It retains direct profile reads for the profile owner/admin and exposes a separate authenticated RPC returning only public discovery fields. Do not mark this protection live until the migration is applied and two-account RLS tests pass.


## Group RLS recursion correction

The migration `20261121170000_group_rls_recursion_fix.sql` adds a narrowly scoped SECURITY DEFINER membership helper with a fixed search path and updates group policies to avoid recursive RLS evaluation. It is included in the guarded migration workflow. Do not mark the correction live until the migration has been applied and the two-member group access tests pass.

## Read-only production index and RLS audit

Run Actions → **MASTER WORLD VIP - Read-only Supabase Index and RLS Audit** → Run workflow. It uses repository Actions secrets `SUPABASE_DB_PASSWORD` and `RLS_TEST_MEMBER_A_UUID` and a fixed approved project target; it does not require the unused Supabase access token because the audit connects directly with the database password. The audit is read-only: it reports expected indexes, structurally duplicate index candidates, RLS enabled state, policy definitions, direct grants on admin tables, and EXPLAIN (ANALYZE, BUFFERS) plans for published releases and recent message lookups. It does not create/drop indexes or change policies.

A clean audit is not a substitute for live two-account authorization tests. In particular, verify a normal member cannot read another member's private profile fields, role assignments, admin audit logs, private conversations, private group roster/posts, or support tickets. The audit workflow must complete successfully and its output must be reviewed before recording any item as PASS.


## Member verification and private helpdesk foundation

The additive migration `20261121180000_member_verification_helpdesk.sql` adds a private request queue, member/staff message thread, status-event history, staff-only review RPC, one-active-request-per-member rule, a three-requests-per-24-hours limit, a 20-messages-per-hour limit and in-app notifications for staff/member replies and review decisions. It intentionally stores a short explanation only. Do not request or upload Facebook passwords, OTPs, login codes, or government-ID images through this feature. The migration is not live until the guarded production workflow completes and the request/message/review flows pass with separate member and staff accounts. A member-facing web UI and staff review controls are now present in `www/index.html`; confirm them only after applying the migration and passing member/staff acceptance tests. Optional voice/video support remains a separate implementation task.

### Verification/helpdesk acceptance test

1. Sign in as ordinary Member A and submit a short verification request without attaching identity documents or sharing credentials.
2. Sign in as ordinary Member B and confirm A's request, messages and event history are not visible.
3. Sign in as an authorized helpdesk staff account (`owner`, `super_admin`, `admin` or `moderator`) and confirm the request appears in the private queue.
4. Set the request to `needs_info` with a short staff note; confirm A can read the note and reply.
5. Confirm staff can approve or reject the request and that status history plus `admin_audit_logs` record the review.
6. Confirm ordinary members cannot call the review RPC successfully, a member cannot submit a second active request, and message rate limits are enforced.
7. Confirm approved/rejected requests are closed to further messages.

The UI uses the RPCs `submit_my_verification_request`, `send_verification_message` and `review_verification_request`. Do not mark the feature live until this sequence passes against the production project.



## Four controlled workflows — no public app release

These four workflows are the only current operational focus. Updating workflow files or storing a build artifact in GitHub Actions does not publish an app to users.

### 1. Supabase Production Migration

Workflow: `.github/workflows/apply-supabase-migrations.yml`

Required GitHub Actions secrets:
- `SUPABASE_ACCESS_TOKEN`
- `SUPABASE_DB_PASSWORD`

The workflow is pinned to project `lztbbrzeuyjkuiyzrsxp`, defaults to dry-run, and requires explicit apply confirmation, recoverable-backup confirmation, restore-test confirmation, and a non-secret backup reference. The generated pre-migration artifact is a **schema-only snapshot**, not a full database backup and not a substitute for a tested, restorable backup. Do not choose `apply_migrations=yes` until a separate full backup is confirmed restorable and its restore procedure has been tested.

### 2. Live RLS Audit

Workflow: `.github/workflows/audit-supabase-indexes-rls.yml`

Required GitHub Actions secrets:
- `SUPABASE_DB_PASSWORD`
- `RLS_TEST_MEMBER_A_UUID`

This is a read-only audit. It does not migrate or modify the database.

### 3. Two Member Live Test

Workflow: `.github/workflows/test-two-member-rls.yml`

Required GitHub Actions secrets:
- `SUPABASE_DB_PASSWORD`
- `RLS_TEST_MEMBER_A_UUID`
- `RLS_TEST_MEMBER_B_UUID`

Use two distinct, existing ordinary member accounts. Do not use owner/admin/moderator accounts. The SQL test uses a transaction and rolls back its temporary fixtures. It also exercises the accepted-friend direct-chat RPC, A-to-B and B-to-A direct/group message inserts and reads, Inbox unread counts, and read acknowledgements.

### 4. Signed Release APK

Workflow: `.github/workflows/android-release.yml`

Required GitHub Actions secrets:
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

The workflow verifies the restored signing key and APK signature, then stores the APK and SHA-256 checksum as a private workflow artifact. It does not create a GitHub Release, publish to Google Play, or upload the APK to a public download page. Keep the long-term signing keystore backed up securely.

### Secret handling and release boundary

Add secrets directly in GitHub → Settings → Secrets and variables → Actions. Never paste passwords, tokens, keystore contents, or member UUIDs into ChatGPT, source files, logs, or public issues. A workflow is marked Live/PASS only after its corresponding real run completes successfully and its result is reviewed. Static CI success alone is not a live result.


## Consent-based live member location map

The additive migration `20261121190000_member_live_location.sql` adds a private GPS-sharing table and authenticated RPCs: `set_my_location_sharing` enables/disables sharing and clears coordinates when disabled; `update_my_live_location` accepts GPS only while the signed-in member has sharing enabled; `lookup_member_location_by_phone` searches only verified Supabase Auth phone numbers, limits each caller to 10 lookups per minute, and returns coordinates only while sharing is enabled and the last GPS update is newer than two minutes.

The member-facing page is `Live Number Location Map`. It requires a verified phone number, an explicit sharing checkbox, HTTPS browser GPS permission, and a signed-in session. A stale or disabled share is reported as OFFLINE without coordinates. Map/place labels are derived from returned GPS coordinates; reverse geocoding uses OpenStreetMap Nominatim and may be unavailable or delayed. A phone/SIM being powered on does not reveal GPS location. The browser stops its GPS watch when the page is hidden; members must re-enable sharing when they return.

Before production, run the guarded migration workflow in preview mode, confirm the full recoverable backup and tested restore process, then apply only after explicit operator approval. Verify with two controlled accounts: confirm phone A by SMS, enable sharing and grant GPS; search A from B and confirm the pin/place name; disable sharing on A and confirm B sees OFFLINE with no coordinates; wait over two minutes without updates and confirm OFFLINE; verify an unverified phone cannot be found; confirm ordinary members cannot directly select or write the location tables; confirm the lookup rate limit. Do not mark this feature live until the migration is applied and these tests pass.
