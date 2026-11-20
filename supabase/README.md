# MASTER WORLD VIP — Supabase backend setup

This repository contains the database foundation, community, privacy, admin/broadcast and release metadata migrations, plus Edge Function starters.

## 1. Apply database migrations in dependency order

Run each SQL file once in Supabase → SQL Editor, in this exact order:

1. `supabase/migrations/202611180001_master_world_vip.sql` — base tables and helpers.
2. `supabase/migrations/202611190001_global_community.sql` — profiles, friend requests, direct/group conversations and notifications.
3. `supabase/migrations/202611190002_privacy_rights.sql` — privacy consent history and data-rights request queue.
4. `supabase/migrations/20261119180000_admin_rbac_owner_control.sql` — owner/admin roles and audit log. Verify the Owner email in the final bootstrap statement before running.
5. `supabase/migrations/20261119190000_member_broadcast.sql` — admin-to-all-member inbox broadcasts. Requires both the base notifications table and Admin RBAC.
6. `supabase/migrations/20261119200000_update_releases.sql` — release metadata for Update Center.
7. `supabase/migrations/20261120100000_inbox_push_foundation.sql` — unified inbox, unread/read markers and per-device Web Push subscription storage. Requires the global community migration first.
8. `supabase/migrations/20261121120000_facebook_setup_orders.sql` — Facebook setup assistance order records, customer-only order visibility and Admin/Owner review. Requires the base and Admin RBAC migrations.

Review and apply in a staging project first. The repository cannot confirm whether these migrations have already been applied to your live Supabase project.

## 2. Update Center

The app and Edge Function use version `3.3.0`. The app sends its own `current_version` to `check-updates`; the function validates that value and compares it with the newest published row in `update_releases`. The function reads `SUPABASE_URL` from the Supabase Edge runtime and uses the app's public publishable/anon API key to read published releases. It does not require an AI provider key or a service-role key.

Deploy the function after code changes:

```sh
supabase functions deploy check-updates --project-ref lztbbrzeuyjkuiyzrsxp
```

The Supabase Edge Function config keeps `verify_jwt = false`; the function validates the public API key itself. Only published release rows are exposed to app clients. Publishing metadata does not publish website files: deploy the PWA to GitHub Pages first, then publish the matching version row.

Detailed checks: `supabase/UPDATE_SYSTEM_TESTS.md`.

## 3. AI function

Deploy `supabase/functions/ai-assistant/index.ts` as `ai-assistant`. Configure `AI_PROVIDER_API_KEY` and optional `AI_PROVIDER_URL` / `AI_MODEL` secrets only for the AI feature. Do not confuse AI provider secrets with the Update Center; update checking does not need an AI secret.

Never put provider keys or Supabase secret/service-role keys in browser code.

## 4. Remaining external integrations

- Email/push delivery needs a provider, sender/device registration and permission tests.
- Facebook discovery requires a Meta app, approved permissions and permitted Graph API use.
- Referral rewards require trusted server-side qualification and fraud controls.
- Legal/privacy text requires jurisdiction-specific review; this is not a claim of GDPR certification.
- Google Play release requires a signed production Android App Bundle, developer account, store listing and policy review.

Do not mark modules live until configured and tested in the target Supabase project and on real devices.


## 5. Unified Inbox and Push foundation

Apply `20261120100000_inbox_push_foundation.sql` after the Global Community migration. It adds `get_my_inbox()` and `mark_my_inbox_read()` RPCs, unread counts/read markers, and RLS-protected per-user browser push subscriptions. The PWA can request browser permission only after the member presses Enable Push, then store the browser subscription. Actual push delivery is not active until a trusted sender service is deployed with VAPID public/private keys; keep the private key in server secrets only. Test subscribe, unsubscribe, user isolation, inbox unread/read counts and real-device delivery before marking this feature live.

## 6. Real Web Push delivery setup

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

## 7. Android WebView limitation

The current APK is a WebView shell. Web Push through a browser Service Worker is not guaranteed to work inside Android WebView, and this project has not yet added Firebase Cloud Messaging (FCM) native integration. Validate push in Chrome/PWA separately; native Android push requires FCM registration, a secure device-token table and a trusted FCM sender before claiming APK push support.
