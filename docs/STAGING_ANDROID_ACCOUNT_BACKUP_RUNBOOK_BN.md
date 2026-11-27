# MASTER WORLD VIP — Staging, Android, Test Accounts ও Backup/Restore Runbook

**Updated:** 27 November 2026 (Bangladesh time)  
**Scope:** Existing repository only. This runbook prepares the four Owner-priority gates without changing Production.

## 1. Safety boundary

- All migration and account acceptance work in this runbook is for the separate `MASTER-WORLD-VIP-STAGING` project only.
- Known Production project ref is `lztbbrzeuyjkuiyzrsxp`. Never use it as Staging.
- Do not paste secrets, DB URLs, passwords, JWTs, service-role keys, OTPs or backup passphrases into chat, issues, source files or screenshots.
- Do not enable the project worker or any paid provider. The worker is a queue foundation, not a real revenue-producing task executor.
- Do not perform Production migration, payment, public deployment or real customer intake from these steps.

## 2. Staging project identity — Owner action required

In Supabase Dashboard, open the separate `MASTER-WORLD-VIP-STAGING` project.

- Project URL: Project Settings → API → Project URL.
- Project Reference: Project Settings → General → Reference ID (or the project URL hostname prefix).
- Confirm the reference is different from Production. Do not put the DB password or full DB URI in a screenshot.
- If the project is paused, resume it only if the Owner accepts any applicable plan/quota terms. Do not upgrade or buy anything automatically.

## 3. Add only the three secrets required by the current Staging migration workflow

GitHub repository → Settings → Secrets and variables → Actions → New repository secret.

Create these exact repository secrets from the matching values in the Staging Supabase project:

1. `SUPABASE_STAGING_ACCESS_TOKEN` — Supabase access token with only the access needed for the Staging project.
2. `SUPABASE_STAGING_PROJECT_REF` — Staging Project Reference ID.
3. `SUPABASE_STAGING_DB_URL` — Staging Session Pooler PostgreSQL URI; never Production.

Do not create placeholder values. Do not use Production secrets. Do not add JWT, anon key or project URL secrets to this particular workflow; its current YAML uses only the three names above. Secret values remain visible only to GitHub's encrypted secret store.

## 4. Staging backup and migration sequence

1. Before any Staging migration apply, create a recoverable backup of the Staging database and test that backup can be restored to a disposable PostgreSQL database. Record only a non-secret backup reference and the PASS result.
2. Open Actions → “MASTER WORLD VIP - Safe Staging Supabase Migration” → Run workflow.
3. First run with `apply_staging = no`. This is preview-only and must not change the database.
4. Review the workflow log for the expected Staging project, successful URI validation, complete migration inventory and successful dry-run. Never accept a Production ref.
5. Apply to Staging only after the separate Staging backup and restore proof exist. The workflow additionally requires the Staging-specific confirmation phrase `APPLY-MASTER-WORLD-VIP-STAGING-MIGRATIONS` and a non-secret backup reference.
6. Save the run ID and non-secret backup reference in the handover. A successful preview is not an applied migration; a successful migration is not customer acceptance.

The current migration workflow does not itself create or restore the Staging backup. Do not claim that backup/restore is complete merely because its confirmation inputs were selected.

## 5. Create isolated Customer and Admin test accounts

After the Staging migration is applied:

1. In the Staging Supabase project only, open Authentication → Users and create three dedicated test users: Customer A, Customer B and Admin. Use test-only email addresses controlled by the Owner; do not use real customer PII.
2. Complete the configured email verification flow for each account.
3. Sign in as the Staging Owner and assign the Admin role to the dedicated Admin test user only through the project's protected Owner/Admin role-management path. Do not grant Admin by editing browser storage, changing client JavaScript or running an unreviewed SQL statement.
4. Keep Customer A and Customer B as ordinary members.
5. Run `docs/CUSTOMER_QUOTE_WORKFLOW_ACCEPTANCE_TEST_BN.md` from top to bottom. Confirm Customer B cannot read Customer A's requests, ordinary members cannot open the Admin inbox, and quote acceptance does not create a paid order, ledger entry, member assignment or payout.
6. Keep test credentials in the Owner's password manager. Never send credentials or JWTs to chat.

If the protected Owner role-management path is unavailable, stop and record the exact non-secret error; do not bypass RBAC.

## 6. Android phone acceptance

Use the Owner's Android phone with Chrome. Test only the Staging preview URL configured to use the Staging Supabase public project URL/key.

- Open Customer Services; confirm layout fits the screen with no horizontal scrolling.
- Sign in as Customer A; submit a test quote request and confirm it appears in My Quote Requests.
- Sign in as Customer B; confirm Customer A's request and event history are not visible.
- Sign in as Admin; confirm Admin Quote Inbox opens and can review/send a test quote.
- Sign in as an ordinary member; confirm Admin Quote Inbox is denied.
- Test quote accept, decline and cancel; confirm the event history and notifications are correct.
- Check keyboard focus, readable labels, touch targets, loading/error states and browser back/refresh behavior.
- Record browser version, device model, date, test account role (not email/password), outcome and sanitized error only.

A desktop CI pass or responsive static check is not a substitute for this real Android acceptance.

## 7. Existing Production backup/restore evidence

The root handover records a successful encrypted Production logical backup, disposable restore test and migration dry-run in DB Safety Pipeline run `45810029561` (backup reference `mwvip-logical-45810029561-1`; encrypted artifact ID `15111217500`, seven-day retention at creation). This is evidence of that recorded run only. Before any Production migration, verify that the artifact is still available, its encrypted bytes are safely retained, and the separately stored passphrase is recoverable. If the artifact has expired or cannot be restored, create a fresh encrypted backup and successful restore test before considering Production apply.

Production migration still requires the separate exact Owner authorization `APPLY-MASTER-WORLD-VIP-MIGRATIONS`; no Staging secret or Staging approval authorizes Production.

## 8. Evidence checklist — do not mark complete without proof

- [ ] Staging Project URL/ref confirmed (ref masked in shared screenshots).
- [ ] Three exact Staging GitHub Actions secrets added.
- [ ] Staging backup encrypted and disposable restore test passed.
- [ ] Staging migration preview passed.
- [ ] Staging migration applied and run verified.
- [ ] Customer A, Customer B and Admin test accounts created and verified.
- [ ] RBAC test passed: Admin allowed, ordinary member denied.
- [ ] Customer privacy and quote lifecycle tests passed.
- [ ] Android Chrome/accessibility acceptance passed.
- [ ] Non-secret run IDs, dates and results recorded in `PROJECT_HANDOVER_MASTER_BN.md`.

**Current status at creation:** This is an execution guide, not evidence that any of the pending Owner actions or Staging/Android tests have already happened.
