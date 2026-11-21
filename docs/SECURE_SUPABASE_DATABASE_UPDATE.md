# Secure Supabase Database Update

This workflow applies the repository's versioned Supabase migrations through the Supabase CLI. It does not expose database credentials to the browser or app.

## Required GitHub Actions secrets

In GitHub repository Settings → Secrets and variables → Actions, add:

- `SUPABASE_ACCESS_TOKEN`: a Supabase personal access token with project access.
- `SUPABASE_DB_PASSWORD`: the database password for the approved project.
- The approved project ref `lztbbrzeuyjkuiyzrsxp` is pinned inside the workflow; it is **not** a third GitHub Actions secret for this migration workflow. Do not add a duplicate project-ref secret just for this workflow.

Never put these values in frontend code, SQL snippets, commits, or chat.

## Run

1. Open Actions → **MASTER WORLD VIP - Safe Supabase Migration Deploy** → Run workflow.
2. First run with `apply_migrations=no`. Review the dry-run output and confirm that the target is the approved project.
3. Separately verify that a current, restorable full Supabase database backup exists.
4. Only after that backup check, run again with `apply_migrations=yes` and `confirm_recoverable_backup=yes`.
5. Review the complete run, including the pre-migration schema snapshot artifact and the migration push result.

The workflow serializes deployments and pins the approved project ref. The schema-only artifact is a structural snapshot, **not** a recoverable data backup. A successful CLI push is not by itself proof that every application feature is live; verify the resulting schema, policies, functions and app behavior before announcing release readiness.

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
