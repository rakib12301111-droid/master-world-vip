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
