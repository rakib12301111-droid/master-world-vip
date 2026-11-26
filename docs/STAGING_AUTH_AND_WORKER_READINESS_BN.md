# Staging validation and worker service status

Updated: 2026-11-27

## Added to the planning branch

- `.github/workflows/validate-staging-supabase.yml`: manual Staging-only workflow. It rejects the known Production project ref, previews and applies the full ordered local migration set to the configured Staging DB URL, logs into three separate test accounts, uses the Staging Owner RPC to set the Admin and Member test roles, verifies all three returned roles, verifies Admin overview is allowed for Owner/Admin and denied for Member, then deploys the worker Edge Function to Staging.
- Required GitHub Actions secrets (configure only in repository Actions secrets; never paste into chat): `STAGING_SUPABASE_ACCESS_TOKEN`, `STAGING_SUPABASE_DB_URL`, `STAGING_SUPABASE_PROJECT_REF` (must differ from Production), `STAGING_SUPABASE_URL`, `STAGING_SUPABASE_ANON_KEY`, `STAGING_OWNER_EMAIL`, `STAGING_OWNER_PASSWORD`, `STAGING_ADMIN_EMAIL`, `STAGING_ADMIN_PASSWORD`, `STAGING_MEMBER_EMAIL`, `STAGING_MEMBER_PASSWORD`.
- The Staging Owner account must already be bootstrapped by the RBAC migration. The workflow signs in afresh for each run (no expiring JWT secrets), then assigns Admin and Member roles to the two separate Staging test accounts through the protected Owner RPC.
- `supabase/functions/project-automation-worker/index.ts`: Supabase Edge Function queue-worker foundation. It uses service-role RPCs for worker registration and heartbeat. It deliberately does **not** claim tasks because no approved business-task handler is implemented; it returns an idle status rather than consuming work it cannot execute.
- `.github/workflows/verify-project-automation-worker.yml`: Deno type-check on PR/push.
- The Staging workflow deploys the Edge Function only after migrations and access-control acceptance checks pass. The function remains disabled unless `MWVIP_WORKER_ENABLED=true` is configured in Supabase function secrets.

## Critical limitations

- These workflows have been committed to the Draft PR branch but have not been dispatched. No Staging secrets or staging project credentials are available to this workflow execution, so no real Staging migration or Auth test has yet been run.
- The worker code is not a completed business-task executor. No project-specific task handlers, external connectors, revenue generation, customer payment collection, or payout execution are implemented. It only registers and heartbeats while idle.
- Do not set `MWVIP_WORKER_ENABLED=true` until reviewed handlers, budgets, task idempotency and end-to-end tests are approved.
- No Production worker deploy is included.
- Production migrations and public deployment are not performed by this Staging workflow. Production remains separately gated and requires a fresh explicit approval and verified backup/restore evidence.
