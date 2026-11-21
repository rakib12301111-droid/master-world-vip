# MASTER WORLD VIP — Community live-readiness checklist

This checklist distinguishes repository code from verified live services. A green GitHub Pages deployment does not prove that Supabase migrations or Edge Functions have been deployed.

## Database migrations via guarded GitHub Actions workflow\n\nThe repository now includes `.github/workflows/apply-supabase-migrations.yml`. Run it manually from GitHub Actions. It defaults to preview-only (`apply_migrations=no`); applying changes requires explicitly selecting `yes`. It is pinned to project ref `lztbbrzeuyjkuiyzrsxp` and requires repository Actions secrets `SUPABASE_ACCESS_TOKEN` and `SUPABASE_DB_PASSWORD`. The project ref is hard-coded as a reviewed, fixed target in this workflow; it is not a third secret. Review the dry-run output and confirm a recoverable backup before selecting `yes`. A successful workflow run proves only that the CLI migration command completed; still verify the resulting schema and run the two-account acceptance tests below.\n\n## Edge Functions deployed by GitHub Actions

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
10. `20261121120000_group_rls_recursion_fix.sql`

Do not apply until the target project and a recent recoverable backup are confirmed. The Owner bootstrap statement is in migration 4 and is email-specific; verify that the matching auth user exists before applying. Never assume that a matching email query alone proves the role has been granted.

## Live acceptance test — two real test accounts

Use two accounts controlled by the project owner. Do not use strangers' accounts or ask users to share passwords.

### Private chat and inbox
1. Account A sends a friend request to B.
2. B accepts it.
3. A starts a direct conversation and sends a unique test message.
4. B opens Inbox, confirms the conversation and unread count, then opens it.
5. B confirms unread count clears; A confirms the message remains visible.
6. Verify A cannot read a conversation that neither account belongs to.

### Group chat
1. A creates a public test group.
2. B joins it.
3. A sends a unique test group message; B confirms receipt.
4. B opens the group through Inbox and confirms read status.
5. Verify a non-member cannot read or post to the group.

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

The migration `20261121120000_group_rls_recursion_fix.sql` adds a narrowly scoped SECURITY DEFINER membership helper with a fixed search path and updates group policies to avoid recursive RLS evaluation. It is included in the guarded migration workflow. Do not mark the correction live until the migration has been applied and the two-member group access tests pass.

## Read-only production index and RLS audit

Run Actions → **MASTER WORLD VIP - Read-only Supabase Index and RLS Audit** → Run workflow. It uses the same repository-level `SUPABASE_DB_PASSWORD` and `SUPABASE_ACCESS_TOKEN` secrets and a fixed approved project target. The audit is read-only: it reports expected indexes, structurally duplicate index candidates, RLS enabled state, policy definitions, direct grants on admin tables, and EXPLAIN (ANALYZE, BUFFERS) plans for published releases and recent message lookups. It does not create/drop indexes or change policies.

A clean audit is not a substitute for live two-account authorization tests. In particular, verify a normal member cannot read another member's private profile fields, role assignments, admin audit logs, private conversations, private group roster/posts, or support tickets. The audit workflow must complete successfully and its output must be reviewed before recording any item as PASS.
