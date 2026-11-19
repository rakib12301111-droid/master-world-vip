# MASTER WORLD VIP — backend setup

This repository now contains a Supabase database migration and an authenticated AI Edge Function starter.

## 1. Database
Open Supabase → SQL Editor → New query. Paste and run `supabase/migrations/202611180001_master_world_vip.sql`.
This creates profiles, member roles, privacy consent, referrals, notifications, support tickets and audit log tables with RLS. New users receive a `member` role. Admin role grants are deliberately restricted to trusted project-owner operations.

## 2. Update Center release metadata

Apply `supabase/migrations/20261119200000_update_releases.sql` after the foundation migration. It creates the `update_releases` table; app clients can read published release metadata only. Publishing a release remains a trusted Supabase SQL Editor operation. The `check-updates` Edge Function and `supabase/config.toml` setting (`verify_jwt = false`, with publishable-key validation inside the function) must be deployed together. A release record does not itself publish PWA files; GitHub Pages deployment and a waiting service worker are required before the app can show Allow Now.

## 3. Global Community
Apply `supabase/migrations/202611190001_global_community.sql` after the existing foundation migration. It adds discoverable member profiles, friend requests, direct conversations, private messages, public/private group foundations, group messages and in-app notifications with row-level security. Review and test in a staging Supabase project first. The browser Community screen uses these tables/RPCs; realtime and push delivery are not configured yet.


## 4. Admin roles and member broadcast
Apply these migrations in order after the foundation migration:
1. `supabase/migrations/20261119180000_admin_rbac_owner_control.sql` — before running it, confirm the owner email in its final bootstrap statement matches the verified owner account in Supabase Auth.
2. `supabase/migrations/20261119190000_member_broadcast.sql` — creates the admin-only broadcast inbox and recipient delivery records.

The Admin & Security screen includes a broadcast composer. Only users with `owner`, `super_admin`, or `admin` in `app_user_roles` can send; the server limits each sender to three broadcasts per hour. Broadcasts create in-app notifications/inbox records for all other registered users. This does not itself send OS push notifications; a push provider and device registration are separate work.

Test in staging: owner bootstrap, unauthorized member rejection, admin send, recipient visibility, read-state updates, delivery count, and rate-limit behavior. Do not claim broadcast is live until the migrations are applied to the target Supabase project and these tests pass.

## 5. AI function
Deploy `supabase/functions/ai-assistant/index.ts` as an Edge Function named `ai-assistant`. Add secrets in Supabase → Edge Functions → Secrets:
- `AI_PROVIDER_API_KEY` (your provider key)
- `AI_PROVIDER_URL` (optional; defaults to OpenAI-compatible chat completions endpoint)
- `AI_MODEL` (optional; defaults to gpt-4o-mini)

The function requires a signed-in Supabase user. Never put provider keys or Supabase secret/service-role keys in browser code.

## 6. What still needs external configuration/integration
- Apply the SQL migration in the Supabase project.
- Deploy the Edge Function and supply a paid/authorized AI provider credential.
- Facebook discovery requires a Meta app, approved permissions/access token and permitted Graph API use; this repo does not scrape accounts or access private data.
- Email/push notifications need a delivery provider and verified sender/device setup.
- Referral rewards/payments require reward rules, fraud controls and a trusted server-side qualification workflow.
- Admin UI and admin operations need a verified owner account and server-side workflows.
- Legal/privacy text needs jurisdiction-specific review. This is not a claim of GDPR certification.
- Google Play release requires Android packaging, developer account, store listing and policy review.

Do not mark modules live until they have been configured and tested in the target Supabase project.
