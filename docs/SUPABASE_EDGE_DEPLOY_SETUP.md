# Supabase Edge Function deployment setup

The deploy workflow requires one secret value: `SUPABASE_ACCESS_TOKEN`.

1. Open GitHub repository Settings → Environments → `production` → Environment secrets.
2. Add `SUPABASE_ACCESS_TOKEN`.
3. Get the token from Supabase Dashboard → Account → Access Tokens. Never paste it into chat, app code, source files, or workflow inputs.
4. `SUPABASE_PROJECT_REF` is now set to the approved project in the workflow: `lztbbrzeuyjkuiyzrsxp`.
5. Run Actions → MASTER WORLD VIP - Deploy Secure Update Functions → Run workflow.

The workflow validates the token before deploying. If absent, it stops before deployment and prints setup guidance. It deploys the six configured Edge Functions only; it does not apply database migrations.

Configure runtime secrets separately in Supabase → Edge Functions → Secrets as required by each function. Never put service-role keys in browser code.
