# Secure Supabase Database Update

This workflow applies the repository's versioned Supabase migrations through the Supabase CLI. It does not expose database credentials to the browser or app.

## Required GitHub Actions secrets

In GitHub repository Settings → Secrets and variables → Actions, add:

- `SUPABASE_ACCESS_TOKEN`: a Supabase personal access token with project access.
- `SUPABASE_DB_PASSWORD`: the database password for the approved project.
- The approved project ref `lztbbrzeuyjkuiyzrsxp` is pinned inside the workflow; it is **not** a third GitHub Actions secret for this migration workflow. Do not add a duplicate project-ref secret just for this workflow.

Never put these values in frontend code, SQL snippets, commits, or chat.

## Run — guarded Owner workflow

1. Open Actions → **MASTER WORLD VIP - Secure Database Update** → Run workflow.
2. First run with `apply_migrations=false` (the default). This validates repository secrets, checks required migration files, links only the pinned project `lztbbrzeuyjkuiyzrsxp`, and runs `supabase db push --dry-run`. No database changes are applied.
3. Review the entire Dry Run log and verify the target project and pending migration list.
4. Separately create or verify a current, recoverable full Supabase backup. Confirm that the restore procedure has actually been tested. A schema-only snapshot is not a full backup.
5. Only after those checks, request Apply with `apply_migrations=true`, `backup_confirmed=true`, `restore_tested=true`, a non-secret backup ID/reference, and the exact phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS`.
6. Review the full Actions run and verify the resulting schema, RLS policies, functions and application behavior. A queued request is not a successful migration.

The workflow has no GitHub production Environment binding, so repository-level Actions secrets are read directly and cannot be shadowed by same-named Environment secrets. It serializes runs, pins the approved project, re-runs Dry Run before every Apply, checks required migration files and blocks Apply unless every explicit approval gate passes. The backup reference must be a non-secret identifier, not a URL or credential. The workflow does not create the full database backup for you.

## Important

- The owner bootstrap migration grants owner to the verified email hardcoded in `20261119180000_admin_rbac_owner_control.sql`. Confirm that email before applying.
- `supabase db push` applies all pending migrations in timestamp order, not only the owner migration. Review the dry-run output first.
- This workflow does not create a backup automatically. Take/verify a Supabase backup or point-in-time recovery availability before applying production migrations.
- The browser Update Center must never receive the Supabase database password, personal access token, GitHub token, or service-role key.

## Automatic Edge Function deployment through the update pipeline

- The repository includes `.github/workflows/deploy-update-functions.yml`. After this PR is reviewed and merged, changes to either Update Center Edge Function or `supabase/config.toml` on `main` trigger deployment to the fixed approved project.
- The workflow can also be started manually from GitHub Actions. It requires the repository Actions secret `SUPABASE_ACCESS_TOKEN`; the approved project ref `lztbbrzeuyjkuiyzrsxp` is pinned in the workflow and is not a secret.
- Protect the GitHub `production` environment with required reviewers if you want an approval gate before any function deployment. Deployment is not considered complete until the workflow run succeeds and the functions are visible in Supabase.

## Connect the app Update Center (one-time server setup)

1. The new GitHub Actions deployment workflow deploys both authenticated Update Center Edge Functions after merge to `main`; alternatively use the documented Supabase CLI commands for a one-time manual bootstrap.
2. In Supabase Edge Function secrets, set `GITHUB_ACTIONS_TOKEN` to a fine-grained GitHub token restricted to this repository with Actions: Read and write. Set `GITHUB_REPOSITORY` to `rakib12301111-droid/master-world-vip`.
3. Supabase's standard `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` runtime secrets are used by the function. Never expose the service-role key in the app.
4. Configure the GitHub Actions secrets listed above. Optionally protect the GitHub `production` environment with required reviewers.
5. The first Owner/RBAC migration is a bootstrap dependency: before the app can authorize Owner requests, run the workflow once from GitHub Actions after the dry run and backup review. It creates `app_user_roles` and assigns Owner to the exact verified email in that migration. The user must already exist in Supabase Auth.
6. After the bootstrap migration is successfully applied, the app Update Center can request Dry Run and Apply. The Edge Function validates the current Supabase access token, checks `app_user_roles.role = owner`, and only then dispatches the workflow.
7. The Update Center stores the returned request ID in the current browser session. Use **Update Status দেখুন** to retrieve the matching GitHub Actions run. The status endpoint is Owner-only and returns only run metadata (status, conclusion, run URL and timestamps), never logs or secrets.
8. Deploy the frontend branch to the hosting environment only after review/merge. A queued response means the workflow was requested, not that the migration succeeded. Verify the Actions run and database afterward.

The Update Center Apply action deliberately requires an explicit confirmation phrase and a backup acknowledgement. The workflow applies all pending migrations in timestamp order, so always inspect the Dry Run output first.


## Profile discovery privacy hardening

The additive migration `20261121100000_profiles_discovery_privacy_hardening.sql` removes the broad discoverable-profile SELECT policy. PostgreSQL permissive policies are combined with OR, so leaving that policy beside the own/admin policy could expose full profile rows. The migration restores own/admin-only direct table access and provides `search_discoverable_profiles`, which returns only explicitly selected public fields. It is included in the guarded migration preflight list. Review and apply it only through the same dry-run, backup and explicit approval process.


## Production migration, query-plan and two-member RLS verification

The production migration workflow now requires two explicit inputs: `apply_migrations=yes` and `confirm_recoverable_backup=yes`. It captures a schema-only snapshot artifact before applying migrations. This schema snapshot is **not** a full data backup; create and verify a recoverable Supabase database backup separately before confirming the input.

### Required repository Actions secrets

- `SUPABASE_ACCESS_TOKEN`
- `SUPABASE_DB_PASSWORD`
- `RLS_TEST_MEMBER_A_UUID`: UUID of an existing ordinary member account
- `RLS_TEST_MEMBER_B_UUID`: UUID of a different existing ordinary member account

Never use an owner/admin account for either RLS test identity. Never paste credentials or UUIDs into chat or commit them into the repository.

### Run sequence

1. Run **MASTER WORLD VIP - Safe Supabase Migration Deploy** with `apply_migrations=no` and review the dry-run.
2. Verify a current, restorable full database backup in Supabase. Then run with `apply_migrations=yes` and `confirm_recoverable_backup=yes`.
3. Run **MASTER WORLD VIP - Read-only Supabase Index and RLS Audit**. It checks expected index presence, structurally equivalent duplicate indexes, RLS state and policy definitions, admin-table grants, and EXPLAIN ANALYZE BUFFERS plans using the configured Member A activity.
4. Run **MASTER WORLD VIP - Two Member RLS Integration Test**. It inserts temporary direct-message, private-group, support-ticket and notification fixtures inside a transaction, switches authenticated JWT identities between the two ordinary members, asserts own-versus-other access and admin-table denial, then rolls back all fixtures.

The two-member test is destructive only within its own transaction and ends with ROLLBACK. Do not remove the rollback. A workflow success is the required evidence; do not mark live database migration, index health, query-plan improvement or RLS as verified until the corresponding run completes and its output has been reviewed. EXPLAIN plans are measurements, not an automatic pass/fail performance threshold; compare actual plan nodes, execution time and buffers against a saved baseline.


## Additional group RLS recursion correction (2026-11-21)

The two-member test review identified a policy dependency cycle: the community-group read policy queried `group_members`, while the group-roster policy queried `community_groups`. The additive migration `20261121120000_group_rls_recursion_fix.sql` replaces those checks with caller-scoped SECURITY DEFINER helpers using a fixed empty search path. It is included in the production migration preflight list. Apply only after the standard dry-run and recoverable-backup gate, then rerun the read-only audit and two-member integration test.


## Owner Update Center safety gates (2026-11-21)

The Owner Update Center sends the backup confirmation, restore-test confirmation, non-secret backup reference and exact Apply phrase to the server-side dispatch function. The Edge Function verifies the authenticated session and `app_user_roles.role = owner` before dispatching the workflow. The workflow independently validates those inputs and repeats the migration Dry Run before it can apply anything. Never tick the backup or restore-test boxes unless those checks were genuinely completed.

The first deployment still requires a trusted operator to deploy the Edge Functions and configure secrets outside the browser. Set `GITHUB_ACTIONS_TOKEN` as a Supabase Edge Function secret with access restricted to this repository and the minimum required GitHub permissions (Actions read/write for workflow dispatch/status; Actions secrets read/write only if using the Owner secret-setup function). Set `GITHUB_REPOSITORY=rakib12301111-droid/master-world-vip`. The repository Actions secrets `SUPABASE_ACCESS_TOKEN` and `SUPABASE_DB_PASSWORD` must be configured separately. A successful GitHub Pages build does not prove Edge Function deployment or database connectivity.


## Supabase access token format check

The GitHub Actions secret `SUPABASE_ACCESS_TOKEN` must be a Supabase Personal Access Token created under Supabase Account → Access Tokens. The current Supabase CLI expects the token format to begin with `sbp_`. A project publishable/anon key, service-role key, database password, or old unsupported token format is not a substitute. If the Edge Function deployment log reports “Invalid access token format”, replace the repository Actions secret with a newly created valid Supabase Personal Access Token using the Owner secret setup flow or GitHub Settings → Secrets and variables → Actions. Never paste the token into chat or frontend code.
