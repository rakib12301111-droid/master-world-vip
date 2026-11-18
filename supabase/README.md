# MASTER WORLD VIP — backend setup

This repository now contains a Supabase database migration and an authenticated AI Edge Function starter.

## 1. Database
Open Supabase → SQL Editor → New query. Paste and run `supabase/migrations/202611180001_master_world_vip.sql`.
This creates profiles, member roles, privacy consent, referrals, notifications, support tickets and audit log tables with RLS. New users receive a `member` role. Admin role grants are deliberately restricted to trusted project-owner operations.

## 2. AI function
Deploy `supabase/functions/ai-assistant/index.ts` as an Edge Function named `ai-assistant`. Add secrets in Supabase → Edge Functions → Secrets:
- `AI_PROVIDER_API_KEY` (your provider key)
- `AI_PROVIDER_URL` (optional; defaults to OpenAI-compatible chat completions endpoint)
- `AI_MODEL` (optional; defaults to gpt-4o-mini)

The function requires a signed-in Supabase user. Never put provider keys or Supabase secret/service-role keys in browser code.

## 3. What still needs external configuration/integration
- Apply the SQL migration in the Supabase project.
- Deploy the Edge Function and supply a paid/authorized AI provider credential.
- Facebook discovery requires a Meta app, approved permissions/access token and permitted Graph API use; this repo does not scrape accounts or access private data.
- Email/push notifications need a delivery provider and verified sender/device setup.
- Referral rewards/payments require reward rules, fraud controls and a trusted server-side qualification workflow.
- Admin UI and admin operations need a verified owner account and server-side workflows.
- Legal/privacy text needs jurisdiction-specific review. This is not a claim of GDPR certification.
- Google Play release requires Android packaging, developer account, store listing and policy review.

Do not mark modules live until they have been configured and tested in the target Supabase project.
