# Secure Supabase Database Update

This workflow applies the repository's versioned Supabase migrations through the Supabase CLI. It does not expose database credentials to the browser or app.

## Required GitHub Actions secrets

In GitHub repository Settings → Secrets and variables → Actions, add:

- `SUPABASE_ACCESS_TOKEN`: a Supabase personal access token with project access.
- `SUPABASE_DB_PASSWORD`: the database password for the approved project.
- The approved project ref `lztbbrzeuyjkuiyzrsxp` is pinned inside the workflow; it is **not** a third GitHub Actions secret for this migration workflow. Do not add a duplicate project-ref secret just for this workflow.

Never put these values in frontend code, SQL snippets, commits, or chat.

## Run

1. Open Actions → MASTER WORLD VIP - Secure Database Update → Run workflow.
2. Enter `MASTER-WORLD-VIP` in the confirmation field.
3. First run with Apply migrations = false. This performs a dry run only.
4. Review the migration plan and backup status.
5. Only after confirming the target project and backup, run again with Apply migrations = true.

The workflow serializes deployments and refuses to run against a different project ref. A successful workflow is evidence that the CLI applied pending migrations; verify the resulting tables and role in Supabase before announcing the feature live.

## Important

- The owner bootstrap migration grants owner to the verified email hardcoded in `20261119180000_admin_rbac_owner_control.sql`. Confirm that email before applying.
- `supabase db push` applies all pending migrations in timestamp order, not only the owner migration. Review the dry-run output first.
- This workflow does not create a backup automatically. Take/verify a Supabase backup or point-in-time recovery availability before applying production migrations.
- The browser Update Center must never receive the Supabase database password, personal access token, GitHub token, or service-role key.

## Automatic Edge Function deployment through the update pipeline

- The repository includes `.github/workflows/deploy-update-functions.yml`. After this PR is reviewed and merged, changes to either Update Center Edge Function or `supabase/config.toml` on `main` trigger deployment to the fixed approved project.
- The workflow can also be started manually from GitHub Actions. It requires `SUPABASE_ACCESS_TOKEN` and `SUPABASE_PROJECT_REF` GitHub Actions secrets; the workflow rejects any project ref other than `lztbbrzeuyjkuiyzrsxp`.
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
