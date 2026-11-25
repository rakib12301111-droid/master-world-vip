# MASTER WORLD VIP — Supabase backend setup

This repository contains the database foundation, community, privacy, admin/broadcast and release metadata migrations, plus Edge Function starters.

## 1. Supabase project and database setup

1. Open [Supabase Projects](https://supabase.com/dashboard/projects). Use the existing project `lztbbrzeuyjkuiyzrsxp` or create a new project if you do not have one. Wait until its database is ready.
2. Open that project's **SQL Editor**. For the existing project, use [this SQL Editor link](https://supabase.com/dashboard/project/lztbbrzeuyjkuiyzrsxp/sql/new). If you created a different project, open SQL Editor from that project's dashboard instead.
3. Review and run the migration files below **one at a time and in this exact dependency order**. Do not paste all files together. Back up an existing production database and test restore before applying changes. If a migration fails, stop and resolve it before running later migrations.
4. Before running `20261119180000_admin_rbac_owner_control.sql`, verify that the owner email in its final bootstrap statement is the verified email of the intended Supabase Auth account. The current file contains `rakib12301111@gmail.com`; change it if that is not the correct owner account. Do not grant Owner to an unverified account.
5. After migrations, use the read-only smoke checks in `UPDATE_SYSTEM_TESTS.md` and test with at least two separate accounts where applicable.

### Full migration order

1. `202611180001_master_world_vip.sql` — base tables, profile bootstrap, role helper and initial RLS.
2. `202611190001_global_community.sql` — member profiles/discovery, friend requests, direct/group chat and notifications.
3. `202611190002_privacy_rights.sql` — privacy consent history and data-rights request queue.
4. `20261119180000_admin_rbac_owner_control.sql` — Owner/Admin RBAC and audit controls. **Verify the Owner email before running.**
5. `20261119190000_member_broadcast.sql` — authorized member broadcast; requires Admin RBAC.
6. `20261119200000_update_releases.sql` — Update Center release metadata.
7. `20261120100000_inbox_push_foundation.sql` — unified inbox, read markers and push subscription storage.
8. `20261120150000_membership_helper_hardening.sql` — caller-scoped membership helpers and RLS hardening.
9. `20261121100000_profiles_discovery_privacy_hardening.sql` — restrict profile table access and expose only approved discoverable fields.
10. `20261121120000_facebook_setup_orders.sql` — Facebook setup service order records.
11. `20261121130000_facebook_setup_feedback.sql` — customer feedback records and related access controls.
12. `20261121140000_verified_payment_state.sql` — verified payment-state handling.
13. `20261121150000_sslcommerz_checkout_enable.sql` — checkout enablement foundation; live checkout still needs valid provider credentials and server configuration.
14. `20261121160000_trusted_devices_login_history.sql` — user-scoped trusted-device and login-history records.
15. `20261121170000_group_rls_recursion_fix.sql` — group membership RLS recursion fix.
16. `20261121180000_member_verification_helpdesk.sql` — private member verification/helpdesk requests and staff workflow.
17. `20261121190000_member_live_location.sql` — consent-based live location sharing and lookup foundation.
18. `20261122100000_messaging_realtime.sql` — realtime publication and messaging delivery support.
19. `20261123100000_work_earn_job_board.sql` — member work board and applications.
20. `202611240001_member_referrals.sql` — referral foundation.
21. `202611240002_public_member_referral_profile.sql` — public referral profile support.
22. `202611240003_referral_wallet_rewards.sql` — referral wallet and reward qualification.
23. `202611240004_owner_monthly_compensation.sql` — Owner monthly compensation ledger.
24. `202611240005_international_referral_usd_equivalent.sql` — international referral currency equivalent.
25. `202611240006_network_admin_referral_rewards.sql` — Admin referral reward controls.
26. `202611240007_referral_payout_reference_hardening.sql` — payout reference validation.
27. `20261125100000_admin_auto_work_control_plane.sql` — Admin-only five-module Auto Work control plane; modules start disabled.
28. `20261125120000_anti_theft_device_recovery.sql` — anti-theft and device recovery foundation.
29. `20261125130000_admin_auto_work_claim_concurrency_fix.sql` — ensures at most one running job per module when multiple workers poll concurrently.
30. `20261125160000_work_earn_wallet_owner_profit.sql` — separate member Work & Earn wallet and Owner profit ledgers, audited 20% default commission setting, provider-settlement intake and atomic idempotent posting RPC (backend foundation only; no payment gateway or payout is live).

**Important:** Repository files and this checklist do not prove that any migration has been applied to your Supabase project. SQL is not run by the website automatically. Keep a record of each successfully applied migration. Do not rerun a migration blindly if the project already has part or all of its schema; inspect the database first.

### Browser connection and Auth test

- In **Project Settings → API**, copy the Project URL and the **Publishable key** (`sb_publishable_...`) or the legacy **anon public JWT**.
- In MASTER WORLD VIP → Account setup, enter those two public values and press **Connect Supabase**.
- The browser and `check-updates` Edge Function reject `sb_secret_...` keys and legacy JWTs unless their decoded role is exactly `anon`. Never paste a `service_role` or secret key into the website, HTML, JavaScript, chat, or public repository.
- In Supabase Authentication settings, configure the allowed Site URL and Redirect URLs for your deployed website. Configure email confirmation and an email provider as required.
- Create a test account, complete email confirmation if enabled, log in, then open Member Hub and save/load your profile. Repeat with a second test account to check user isolation.
- A successful browser connection does not prove that all database migrations, RLS policies, email delivery, or production security have been verified.

## 2. GitHub Actions database connectivity

For GitHub-hosted runners, use the IPv4-compatible Supabase **Session Pooler** connection string. Save it as the repository Actions secret `SUPABASE_DB_URL`; the secure database update workflow validates the pooler host and passes the URL through `supabase db push --db-url` for both dry-run and apply. Do not use the direct database host on an IPv4-only runner, and never commit the connection string or paste it into chat. The workflow still requires the configured Supabase personal access token and all backup/restore/explicit-authorization gates before production changes.

## 3. Update Center

The app and Edge Function use version `3.3.0`. The app sends its own `current_version` to `check-updates`; the function validates that value and compares it with the newest published row in `update_releases`. The function reads `SUPABASE_URL` from the Supabase Edge runtime and uses the app's public publishable/anon API key to read published releases. It does not require an AI provider key or a service-role key.

Deploy the function after code changes:

```sh
supabase functions deploy check-updates --project-ref lztbbrzeuyjkuiyzrsxp
```

The Supabase Edge Function config keeps `verify_jwt = false`; the function validates the public API key itself. Only published release rows are exposed to app clients. Publishing metadata does not publish website files: deploy the PWA to GitHub Pages first, then publish the matching version row.

Detailed checks: `supabase/UPDATE_SYSTEM_TESTS.md`.

## 4. AI function

Deploy `supabase/functions/ai-assistant/index.ts` as `ai-assistant`:

```sh
supabase functions deploy ai-assistant --project-ref lztbbrzeuyjkuiyzrsxp
```

The function requires a valid signed-in user JWT (`verify_jwt = true`). Configure `AI_PROVIDER_API_KEY` and optional `AI_PROVIDER_URL` / `AI_MODEL` secrets only for the AI feature. Do not confuse AI provider secrets with the Update Center; update checking does not need an AI secret.

Never put provider keys or Supabase secret/service-role keys in browser code.

## 5. Remaining external integrations

- Email/push delivery needs a provider, sender/device registration and permission tests.
- Facebook discovery requires a Meta app, approved permissions and permitted Graph API use.
- Referral rewards require trusted server-side qualification and fraud controls.
- Legal/privacy text requires jurisdiction-specific review; this is not a claim of GDPR certification.
- Google Play release requires a signed production Android App Bundle, developer account, store listing and policy review.

Do not mark modules live until configured and tested in the target Supabase project and on real devices.


## 6. Unified Inbox and Push foundation

Apply `20261120100000_inbox_push_foundation.sql` after the Global Community migration. It adds `get_my_inbox()` and `mark_my_inbox_read()` RPCs, unread counts/read markers, and RLS-protected per-user browser push subscriptions. The PWA can request browser permission only after the member presses Enable Push, then store the browser subscription. Actual push delivery is not active until a trusted sender service is deployed with VAPID public/private keys; keep the private key in server secrets only. Test subscribe, unsubscribe, user isolation, inbox unread/read counts and real-device delivery before marking this feature live.

## 7. Real Web Push delivery setup

The repository includes `supabase/functions/send-push/index.ts`. Deploy it after setting these Edge Function secrets (never put them in the web app):

```sh
supabase secrets set PUSH_WEBHOOK_SECRET="a-long-random-secret"
supabase secrets set VAPID_PUBLIC_KEY="your-vapid-public-key"
supabase secrets set VAPID_PRIVATE_KEY="your-vapid-private-key"
supabase secrets set VAPID_SUBJECT="mailto:admin@example.com"
supabase functions deploy send-push --no-verify-jwt
```

Also ensure `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are available to the Edge Function runtime. The service-role key stays server-side only. Set the same random secret as the request header `x-push-webhook-secret` in a Supabase Database Webhook configured for table `public.notifications`, event INSERT, URL `https://lztbbrzeuyjkuiyzrsxp.supabase.co/functions/v1/send-push`. The webhook must send the row JSON payload and the secret header. Use a unique secret and rotate it if exposed.

Before enabling for members, test with two consenting accounts and a test device: create a notification row for the recipient, verify the browser subscription is present, confirm the sender reports `sent: 1`, check notification display while the PWA is backgrounded, and confirm 404/410 subscriptions are cleaned up. Do not send message body content in push if privacy settings require generic alerts; current sender uses the notification title/body already stored in the notifications table.

## 8. Android WebView limitation

The current APK is a WebView shell. Web Push through a browser Service Worker is not guaranteed to work inside Android WebView, and this project has not yet added Firebase Cloud Messaging (FCM) native integration. Validate push in Chrome/PWA separately; native Android push requires FCM registration, a secure device-token table and a trusted FCM sender before claiming APK push support.
## 9. Admin Auto Work — deployment status and remaining requirements

The Auto Work control plane consists of:
- 20261125100000_admin_auto_work_control_plane.sql
- 20261125130000_admin_auto_work_claim_concurrency_fix.sql

The existing Admin & Security page contains a read-only Admin Auto Work overview panel. It calls admin_auto_work_overview() and is visible only after server-side role verification. If the migration is not applied, the panel will show a migration/RPC error. If the RPC reports execution_ready: false, the system is control-plane-only.

DO NOT ENABLE THE FIVE MODULES YET. A real server-side worker and reviewed provider-specific connectors do not exist in this repository as deployed services. Before any job can execute, implement and deploy the worker, connect the actual provider APIs using server-side secrets, validate client permission/contract and acceptance criteria, and test idempotency, retries, timeouts, cost caps, provider outages and queue isolation in staging.

Storage decision: Cloudflare R2 Standard is the primary storage candidate, with an independent encrypted backup and an Owner-downloadable copy. No R2 bucket or backup connector is currently connected. Do not put customer files in GitHub.

The guarded workflow .github/workflows/apply-supabase-migrations.yml includes both Auto Work migrations in its migration inventory. Production migration apply remains blocked unless the workflow's recoverable-backup confirmation, restore-test confirmation, non-secret backup reference and exact authorization phrase are supplied. A documentation/code commit does not apply a database migration.

CURRENT STATUS: Admin overview UI code added; migration files and guarded workflow inventory updated; Supabase migrations, worker, connectors, R2 storage and end-to-end execution remain NOT DEPLOYED.


## Member Auto Work package safety — Owner directive (2026-11-25)
সাধারণ সদস্যের আর্থিক সুরক্ষা সর্বোচ্চ অগ্রাধিকার। Member Auto Work বাতিল নয়, আপাতত বন্ধ; ভবিষ্যতে dedicated isolated infrastructure দিয়ে পুনরায় বিবেচনা করা যাবে। বর্তমান অবস্থায় member Auto Work execution এবং paid package checkout **DISABLED / NOT LIVE**; কোনো সদস্যের কাছ থেকে package fee/deposit নেওয়া যাবে না। Work & Earn-এর human-reviewed, funded task আলাদা নিয়মে চলতে পারে।

ভবিষ্যৎ paid package-এর আগে প্রতিটি বিক্রির সমপরিমাণ ১০০% actual liquid BDT refund reserve আলাদা রাখতে হবে; reserve server/API/operations cost, Owner profit, commission বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Compute/API খরচ আলাদা platform operating fund থেকে দিতে হবে। Reserve 100% না থাকলে, reconciliation stale/mismatch হলে, payment provider hold/dispute থাকলে বা আলাদা operating budget না থাকলে checkout ও নতুন jobs fail-closed হবে। নতুন সদস্যের package payment দিয়ে পুরোনো সদস্যকে refund করা যাবে না।

প্রস্তাবিত refund rule: নির্দিষ্ট evaluation period শেষে package-সম্পর্কিত client-accepted এবং payment-settled কাজ থেকে member-এর withdrawable net earning package price-এর কম হলে original package price 100% ফেরত; সদস্যের ইতোমধ্যে অর্জিত কাজের পারিশ্রমিক অক্ষত থাকবে। Platform/provider outage বা promised service না পেলে দ্রুত cancellation/full refund path থাকবে। Refund SLA, qualifying threshold, original payment route, fees এবং appeal process কেনার আগেই প্রকাশ করতে হবে; legal/payment-provider review ছাড়া এই guarantee বিক্রি করা যাবে না।

Owner commission কেবল সব member payable, refund liability, provider cost, tax/fee ও restricted customer funds সুরক্ষিত/মেটানোর পর প্রকৃত settled platform net revenue থেকে; member wage, deposit বা refund reserve থেকে নয়। Dedicated member worker/queue/storage/API credentials/budget, strict resource isolation, per-member hard caps, emergency stop, payment-provider server verification, audit logs, privacy controls, load/failure/security tests এবং independent reconciliation—সব launch gate পাস না করলে package sales/execution বন্ধ থাকবে। বিস্তারিত authoritative rules: [MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md](MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md).

**Implementation status:** policy/document/UI source update only. No member package catalog/checkout, actual refund reserve account, payment/refund integration, dedicated member worker or payout system is live. No member payments should be collected. GitHub Pages deployment and production database migration are separate and remain subject to their own verified gates.


## 10. Work & Earn wallet and Owner profit settlement foundation

Migration `20261125160000_work_earn_wallet_owner_profit.sql` adds separate append-only Member Work Wallet and Owner Work Profit ledgers, an Owner-only audited commission-rate setting (default 20%), server-only provider-verified payment-event and short-lived reconciliation-snapshot intake, member wallet/Owner profit read RPCs, and a service-role-only atomic/idempotent settlement RPC. The settlement RPC posts the member's full payable and the Owner's percentage of distributable net platform revenue in one database transaction; it rejects unverified/unaccepted payments, stale or failed financial gates, amount mismatches, duplicate/colliding events, and a missing/non-unique Owner.

A trusted backend must independently validate provider signatures/status before inserting payment events and must create reconciliation snapshots from real provider/bank records. No Edge Function, merchant credentials, actual reserve custody, bank/bKash/Nagad payout connector, production migration apply, or live wallet funding is included by this schema migration. Internal wallet/accrual entries are not cash transfers. See `docs/WORK_EARN_WALLET_OWNER_PROFIT_ACCEPTANCE_TEST_BN.md`. Keep paid Member Auto Work packages disabled.
