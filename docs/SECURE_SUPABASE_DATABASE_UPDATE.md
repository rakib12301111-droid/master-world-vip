# Secure Supabase Database Update

This workflow applies the repository's versioned Supabase migrations through the Supabase CLI. It does not expose database credentials to the browser or app.

## Required GitHub Actions secrets

In GitHub repository Settings → Secrets and variables → Actions, add:

- `SUPABASE_ACCESS_TOKEN`: a Supabase personal access token with project access.
- `SUPABASE_DB_PASSWORD`: the database password for the approved project.
- `SUPABASE_PROJECT_REF`: `lztbbrzeuyjkuiyzrsxp`.

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
- The browser Update Center must never receive the Supabase database password, personal access token, or service-role key.
