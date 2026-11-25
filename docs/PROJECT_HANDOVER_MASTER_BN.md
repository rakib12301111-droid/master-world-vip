# MASTER WORLD VIP — Master Project Handover (Bangla)

**Last updated:** 2026-11-25 17:30 Bangladesh time  
**Repository:** https://github.com/rakib12301111-droid/master-world-vip  
**Production website:** https://rakib12301111-droid.github.io/master-world-vip/  
**Purpose:** This is the single source of truth for project continuity. Read this file first at every new work session. Do not repeat a successful check unless the relevant code/configuration changed, the evidence is stale/expired, or a dependent failure requires it.

## 1. Exact resume point — start here next time

**Do not restart the project or rerun all checks.** Continue from the latest commit:
`ade8cf030a92d95214be2b6fc2087bb4cb5418cd`

Next actions, in order:

1. Fix the single known failing assertion in `.github/workflows/verify-supabase-migrations.yml`: the Offline/Voice/Country News validator reports **“PWA cache version is refreshed”** as FAIL. Inspect the validator's expected cache version and the actual current `www/sw.js` / app cache version; update only the stale expectation or actual version as appropriate. Do not rerun successful unrelated feature validators manually.
2. Fix the post-deployment verification failure in `.github/workflows/deploy-pages.yml` (or the actual workflow file that defines the named “Verify live GitHub Pages release” job). Build and Deploy jobs succeeded; only the final published-content/cache assertion failed. Inspect the exact failed command/assertion and compare deployed files against commit `ade8cf...`. Do not assume the deployment itself failed.
3. After those targeted fixes, run the two affected workflows once against the new commit. Preserve run URLs and results here. Reuse already-passed Work & Earn finance static result unless its migration/validator code changes.
4. Only after static workflow and Pages release verification pass, continue with the **guarded database preview/backup/restore/production migration gates** described below. Do not apply production migrations automatically.

## 2. Latest verified GitHub workflow evidence (2026-11-25)

### A. Verify Supabase migration safety
- Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357136
- Commit tested: `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`
- Overall: **FAIL** — one unrelated Offline/Voice/Country News validation step failed.
- Passed steps:
  - Inline JavaScript syntax
  - Membership helper migration
  - Community live readiness
  - Owner-only live service health
  - **Work & Earn wallet and Owner profit security**
- Failed step: **Verify offline, voice and country news features**. Log says: `FAIL — PWA cache version is refreshed`.
- Later checks were skipped because the job stopped at this failure; do not mark those skipped checks as passed.
- The Work & Earn finance security validator did run (configured to run despite earlier failure) and passed, including duplicate retry/idempotency and collision checks.
- This is static repository validation, not a production database or payment test.

### B. GitHub Pages deployment
- Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357353
- Commit: `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`
- Build: **SUCCESS**
- Deploy: **SUCCESS**
- Final “Verify live GitHub Pages release”: **FAIL** at the published website content / Update Center audit link / manifest / PWA cache check.
- Conclusion: Pages build and deploy steps completed, but the release verification did not pass. Do not describe the latest release as fully verified.
- A separate Pages build/deployment run `45603356198` also completed success, but does not replace the failed final release verification.

## 3. Work & Earn wallet / Owner profit — already implemented foundation

Latest commit: `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`

Migration:
`supabase/migrations/20261125160000_work_earn_wallet_owner_profit.sql`

Repository foundation includes:
- Separate append-only Member Work Wallet and Owner Work Profit ledgers.
- Owner-only commission percentage setting, default 20%, with audit history.
- Atomic settlement: member payable and Owner commission entries are posted in the same DB transaction.
- Idempotency / duplicate event protection; collision fails closed.
- Commission rate selected using client acceptance timestamp, preserving the agreed rate for already accepted work.
- Owner commission applies only to distributable net platform revenue after taxes, provider fees, operating costs and restricted liabilities; never from member wages or refund reserve.
- Settlement requires provider-settled payment evidence, provider verification, client acceptance, exact split, fresh reconciliation snapshot and reserve/operating budget gates.
- Member wallet read and Owner ledger read RPCs; Owner-only rate change RPC.
- UI panels for Member Wallet and Owner Profit.

**Verified:** Work & Earn finance static security check passed in run 45603357136.

**Not live / not verified:** production Supabase migration has NOT been applied; no real payment provider webhook/merchant integration; no real refund custody/reconciliation; no Member Auto Work worker; no bKash/Nagad/bank payout connector; no end-to-end real-money tests. Internal ledger accrual is not a bank/mobile-wallet transfer. Do not claim anyone can currently deposit, receive cash, or withdraw.

## 4. Fixed financial and member-protection decisions

- Owner commission: **20% of distributable net platform revenue**, not gross client payment and not member compensation.
- Member work compensation is separate and protected; never claw back or offset already-earned wages against package refunds.
- Client money must actually be received and settled before Member or Owner ledger credit.
- Refund reserve, member payable and restricted liabilities are not Owner profit.
- Member Auto Work packages remain paused/disabled until isolated infrastructure, operating budget, full liquid refund reserve and all reconciliation/legal/provider gates are independently verified.
- No package payments should be collected while these gates are unmet.
- Human-reviewed funded Work & Earn tasks may be developed separately; no income guarantee and no payment for merely being online or registering.
- Referral bonus policy: member referral rewards remain off during initial 6–7 months; no deposits or member wages fund rewards.
- No actual cash payout integration is currently confirmed.

## 5. Production database migration safety — do not bypass

Production migrations have **not** been applied. Required sequence:
1. Check/configure required GitHub Actions secret names only in GitHub/provider dashboards; never ask the user to paste secret values into chat.
2. Run migration preview only (`apply_migrations=false`) and inspect the complete pending ordered migration list.
3. Verify correct Supabase project and Owner bootstrap identity.
4. Confirm a current recoverable backup and genuinely restore it to a separate test environment; retain non-secret backup and restore-test references.
5. Obtain the exact user authorization phrase: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`.
6. Only then run guarded apply with required confirmation flags and references.
7. Verify schema/RLS and execute the documented acceptance tests with separate test accounts.
Never infer that a backup/restore occurred merely because a workflow input boolean is true.

Related guides:
- `docs/DB_SAFETY_EXECUTION_STATUS_BN.md`
- `docs/SUPABASE_BACKUP_RESTORE_TEST_BN.md`
- `docs/WORK_EARN_WALLET_OWNER_PROFIT_ACCEPTANCE_TEST_BN.md`
- `docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md`
- `docs/FEATURE_COMPLETION_REGISTER_BN.md`

## 6. No-repeat verification ledger

| Check | Last evidence | Status | Repeat only if |
|---|---|---|---|
| Inline JavaScript syntax | Run 45603357136 | PASS | Inline JS changed |
| Membership helper migration static check | Run 45603357136 | PASS | Related migration/helper changed |
| Community live readiness static check | Run 45603357136 | PASS | Related code/config/migration inventory changed |
| Owner-only live service health static check | Run 45603357136 | PASS | Related code/config changed |
| Work & Earn wallet/Owner profit static security | Run 45603357136 | PASS | Finance migration/RPC/validator changed |
| Offline/Voice/Country News validator | Run 45603357136 | FAIL: PWA cache assertion | Fix targeted assertion, then rerun affected workflow |
| Pages Build | Run 45603357353 | PASS | Site build inputs changed |
| Pages Deploy | Run 45603357353 | PASS | New deploy needed after changes |
| Published Pages release verification | Run 45603357353 | FAIL: published content/manifest/cache assertion | Fix targeted assertion, then verify new deployment |
| Production Supabase migration | No evidence | NOT DONE | Only after full safety gate and explicit authorization |
| Real payment and cash withdrawal | No provider integration/evidence | NOT DONE | After provider onboarding, backend verification and acceptance tests |

## 7. General project status rule

A UI, SQL file, workflow, static test, or successful Pages deployment alone does not make a feature production-live. Use these labels precisely:
- **Repository foundation:** code exists in Git.
- **Static check passed:** source-level automated check passed.
- **Deployed:** deployment step succeeded.
- **Release verified:** live published content check passed.
- **Production applied:** database migration/function is applied to the intended live project.
- **Acceptance tested:** real integration and permission tests passed.
- **Live:** all relevant deployment, provider, production database, security and acceptance gates passed.

At every session:
1. Read this handover first.
2. Check only current GitHub workflow statuses/commit.
3. Compare the current commit to the evidence commit above.
4. Resume from section 1; do not repeat completed checks without a documented reason.
5. Update this handover after each meaningful change with commit SHA, run IDs, evidence URLs, status and exact next step.

**Security:** Never put passwords, OTPs, API keys, service-role keys, DB passwords, cookies, card PINs or signed URLs in this document or chat.
