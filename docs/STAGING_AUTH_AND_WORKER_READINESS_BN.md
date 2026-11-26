# Staging validation and worker service status

Updated: 2026-11-27

## Added to the planning branch

- `.github/workflows/validate-staging-supabase.yml`: manual Staging-only workflow. It rejects the known Production project ref, previews and applies the full ordered local migration set to the configured Staging DB URL, establishes separate Admin and Member test roles using the Staging Owner JWT, checks role RPC results, verifies Admin overview is allowed for Owner/Admin and denied for Member, then deploys the worker Edge Function to Staging.
- Required GitHub Actions secrets (configure only in repository Actions secrets; never paste into chat): `STAGING_SUPABASE_ACCESS_TOKEN`, `STAGING_SUPABASE_DB_URL`, `STAGING_SUPABASE_PROJECT_REF` (must differ from Production), `STAGING_SUPABASE_URL`, `STAGING_SUPABASE_ANON_KEY`, `STAGING_OWNER_JWT`, `STAGING_ADMIN_JWT`, `STAGING_MEMBER_JWT`.
- The Staging Owner JWT must belong to the Owner account bootstrapped by the RBAC migration. The Owner test account then assigns Admin and Member roles to the two separate Staging test accounts through the protected Owner RPC.
- `supabase/functions/project-automation-worker/index.ts`: a service-role-only queue consumer with worker registration, heartbeat, lease claim and finish calls. It processes at most five tasks per invocation and fails closed when no approved handler exists.
- `.github/workflows/verify-project-automation-worker.yml`: Deno type-check on PR/push.

## Critical limitations

- These workflows have been committed to the Draft PR branch but have not been dispatched. No Staging secrets or staging project credentials are available to this workflow execution, so no real Staging migration or Auth test has yet been run.
- The Worker Edge Function is a queue-consumer foundation, not a production business-task executor. No task handlers, external service integrations, revenue generation, or payout execution are implemented. Unsupported task types are marked for retry/dead-letter via the database's bounded retry policy; they are never falsely marked successful.
- The function is disabled unless `MWVIP_WORKER_ENABLED=true` is configured in the target Supabase project's function secrets. Do not enable until reviewed task handlers and budgets are approved.
- Deploying this Edge Function to Staging is included in the workflow only after migration and role checks pass. No Production worker deploy is included.
- Production migrations and public deployment are not performed by this Staging workflow. Production remains separately gated and requires a fresh, explicit approval and verified backup/restore evidence.
