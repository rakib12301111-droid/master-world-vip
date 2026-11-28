# Staging validation and worker service status

Updated: 2026-11-27

## Staging workflow
- `.github/workflows/validate-staging-supabase.yml` is manual-dispatch-only. It rejects the known Production project ref, validates that the Session Pooler URL is bound to the configured Staging project ref, previews then applies ordered migrations to Staging, signs in as three distinct Owner/Admin/Member test users, assigns test roles through the protected Owner RPC, checks Admin overview allow/deny behavior, and deploys the worker Edge Function to Staging.
- Required repository Actions secrets (Staging only): `STAGING_SUPABASE_ACCESS_TOKEN`, `STAGING_SUPABASE_DB_URL`, `STAGING_SUPABASE_PROJECT_REF`, `STAGING_SUPABASE_URL`, `STAGING_SUPABASE_ANON_KEY`, `STAGING_OWNER_EMAIL`, `STAGING_OWNER_PASSWORD`, `STAGING_ADMIN_EMAIL`, `STAGING_ADMIN_PASSWORD`, `STAGING_MEMBER_EMAIL`, `STAGING_MEMBER_PASSWORD`.
- The DB URL must use the Supabase Session Pooler, port 5432, database `postgres`, and username `postgres.<STAGING_SUPABASE_PROJECT_REF>`. The API URL must match `https://<STAGING_SUPABASE_PROJECT_REF>.supabase.co`. Values must never be pasted into chat or committed.
- The three Auth accounts must be distinct. The Owner account must be bootstrapped by the RBAC migration. The workflow signs in freshly each run; do not store JWTs as long-lived secrets.
- The workflow applies migrations and deploys a function, so it must only be manually dispatched after checking every target and secret. It must never be triggered automatically by PR events.

## Worker implementation scope
- `supabase/functions/project-automation-worker/index.ts` registers and heartbeats, then claims tasks only when the server-side enable switch and database controls permit it.
- Currently implemented allowlisted handlers are limited to read-only `system_health_check`, `project_usage_digest`, and `work_order_validate`. They do not perform customer work, external side effects, or financial effects.
- The worker requires Staging Function Secrets `SUPABASE_SERVICE_ROLE_KEY` and `MWVIP_WORKER_KEY`. Keep `MWVIP_WORKER_ENABLED` unset/false during initial deployment and acceptance.
- Before enabling execution, add and review each business handler with strict input validation, authorization, tenant isolation, idempotency, bounded cost/time, audit events, retries/dead-letter handling, kill switch, and end-to-end tests. No unknown task type may be executed.
- Add and test a scheduler/cron trigger, queue cadence, timezone, retry policy, heartbeat alert, quota/cost monitoring, emergency stop and recovery runbook before claiming 24/7 operation.

## Full launch gates
1. User confirms the Staging Project Reference; it must differ from Production ref `lztbbrzeuyjkuiyzrsxp`.
2. User configures the Staging-only GitHub Actions secrets and three separate test accounts directly in GitHub/Supabase dashboards. Never ask for secret values in chat.
3. Manually run the Staging workflow once; review migration preview, applied migration list, Auth/RBAC positive and negative checks, worker deployment and protected logs.
4. Run RLS isolation tests, RPC privilege tests, schema audit, migration rerun/recovery checks and legacy-data compatibility tests.
5. Test worker disabled-by-default, auth, registration/heartbeat, leases, concurrency, duplicate prevention, idempotency, retry/dead-letter, budget ceilings, kill switch, failures and recovery.
6. Implement and test real customer order intake, service catalog, task-specific business handlers, QA/acceptance and customer-funded settlement. Current read-only handlers are not a real earning engine.
7. Verify separate member-payable and company-revenue ledgers, USD/BDT settlement, commission rules, refund reserves, reconciliation, anti-fraud and entitlement checks. Real payouts remain disabled until authorized provider integration.
8. Review security/privacy/legal obligations, backups, restore drills, observability, alerts, incident response and rollback.
9. Review PR #20/#23 dependencies and exact diffs; merge only an approved narrow release after Staging acceptance and green CI on the exact commit.
10. Production migration requires fresh encrypted backup, successful isolated restore, exact migration/rollback plan and separate approval phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS`.
11. Production worker deployment/activation and schedule require separate explicit approval; start disabled and canary only safe read-only work under strict monitoring.
12. Monitor a 24-hour canary and 7-day reliability period before scaling. Never claim guaranteed income; only actual accepted work and settled customer funds can support earnings.

## Current verified status (2026-11-27)
- Owner-confirmed Supabase Staging project: `MASTER-WORLD-VIP-STAGING`, ref `awatzrapqrteybgspqlq`, region `ap-northeast-1`, Dashboard status Healthy. Project Overview showed `No repository connected`, `No migrations`, and `No backups`.
- Project Settings showed the current account as Project Owner. The Project has not been transferred; the target Organization was selected in the transfer form, but the transfer was not submitted.
- No Staging secrets are confirmed configured; no Staging backup/restore, migration/Auth/RBAC/Worker acceptance run is recorded. The manual workflow now gates migration on a successful encrypted Staging backup and isolated restore.
- No Production migration, Worker activation, live customer-task execution, payment collection or payout is authorized or proven.
- GitHub Pages static site deployment was previously workflow-verified; that does not mean backend automation is live.


## 2026-11-28 — Local Work and opt-in Staging scheduler

- Local Work MVP is now integrated into `main` (PR #27, merge commit `94bbf5f35a3ff63480966a6be9a24a7c11d4077f`). Disposable migration, Worker, finance runtime and static safety checks passed on the exact PR head.
- Added `.github/workflows/staging-worker-scheduler.yml`: a five-minute Staging canary trigger. It is opt-in only and targets only `https://awatzrapqrteybgspqlq.supabase.co`.
- Scheduler remains OFF unless GitHub repository variable `STAGING_WORKER_SCHEDULER_ENABLED=true` is set. It also requires Actions secret `STAGING_SUPABASE_SERVICE_ROLE_KEY`.
- The Edge Function independently remains disabled unless its Staging Function Secret `MWVIP_WORKER_ENABLED=true` is set. It also requires `SUPABASE_SERVICE_ROLE_KEY` and `MWVIP_WORKER_KEY` in the Staging Edge Function environment.
- Do not enable the scheduler or worker until the manual Staging workflow has passed encrypted backup/restore, migration preview/apply, three distinct Owner/Admin/Member Auth logins, role/RPC checks and Worker deployment.
- The scheduled workflow invokes at most one worker cycle every five minutes. GitHub scheduled Actions are best-effort and may be delayed; this is a Staging canary, **not a guaranteed production-grade 24/7 service**. A dedicated reliable scheduler/worker service and monitoring are still required before production claims.
- The workflow never prints the service-role secret or worker task/result payload. Payment/deposit/withdrawal/payout remain disabled.
