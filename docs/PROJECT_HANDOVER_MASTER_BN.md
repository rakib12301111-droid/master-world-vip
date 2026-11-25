# MASTER WORLD VIP — Master Project Handover (Bangla)

**Last updated:** 2026-11-25 (Bangladesh time)  
**Repository:** https://github.com/rakib12301111-droid/master-world-vip  
**Production website:** https://rakib12301111-droid.github.io/master-world-vip/  
**Purpose:** This is the single source of truth for project continuity. Read this file first at every new work session. Do not repeat a successful check unless the relevant code/configuration changed, the evidence is stale/expired, or a dependent failure requires it.

## 1. Exact resume point — start here next time

**Do not restart the project or rerun all checks.** Continue from the latest commit on the existing default branch (main). At every resume, read the current branch HEAD and compare it with the evidence recorded in this file. The historical application-code baseline for the 2026-11-25 finance verification is `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`.

Next actions, in order:

1. First check the newest Actions runs for the current main-branch HEAD; never assume an old SHA is still HEAD. The handover-only updates also trigger Pages workflows, so inspect their latest run status.
2. The Pages verifier now validates manifest JSON, checks cache v37, prints exact failed line/command, and its Owner-only marker was corrected in commit `306318f71473e3f94862fcd7449ad81cc386849a`. Run the newest Pages workflow and confirm all Build/Deploy/Verify jobs pass.
3. The known PWA cache assertion mismatch was corrected: `scripts/verify-global-communication.py` now expects `mwvip-pwa-v37`, matching `www/sw.js`. Verify the affected workflow run; do not rerun unrelated PASS checks.
4. Run only the affected verification workflows once after the targeted fixes. Reuse the finance 22/22, Community readiness, Owner health 9/9 and membership-helper PASS evidence unless relevant source/validator changes.
5. Only after static and Pages live-release verification pass, continue with the guarded database backup/restore/dry-run gates. Do not apply production migrations automatically.

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


---

# 8. পূর্ণ প্রকল্প ইতিহাস — শুরু থেকে 2026-11-25 পর্যন্ত

এই অংশটি আগের Feature Completion Register, Start-to-Finish Audit, Continuity Handover, বর্তমান repository tree এবং Git commit history মিলিয়ে তৈরি। GitHub commit history-তে 2026-11-13-এর Initial commit থেকে 2026-11-25-এর বর্তমান HEAD পর্যন্ত 694টি commit record (pages 1–7) গণনা/ইনভেন্টরি করা হয়েছে; individual micro-commit তালিকাভুক্ত না করে feature/phase অনুযায়ী একত্র করা হয়েছে। একই কাজের ছোট corrective commit আলাদা করে পুনরাবৃত্তি না করে সম্পন্ন কাজগুলো feature/phase অনুযায়ী একত্র করা হয়েছে। এটি repository-তে সংরক্ষিত কাজের ইতিহাস; কথোপকথনের বাইরে কোনো অদৃশ্য কাজ সম্পন্ন হয়েছে—এমন দাবি নয়।

## 8.1 শুরু — 2026-11-13 থেকে 2026-11-14

- MASTER WORLD VIP repository ও প্রথম HTML landing page তৈরি।
- প্রথম static preview থেকে responsive website/app foundation-এ রূপান্তর।
- GitHub Pages deployment workflow যুক্ত।
- Integrated dashboard এবং Supabase Auth/member profile integration-এর প্রাথমিক কাঠামো।
- Registration, Login ও member profile-এর starter integration।
- Supabase public client configuration; browser-এ কেবল publishable/anon key ব্যবহারের নীতি।
- Core database schema ও Row Level Security (RLS) foundation।
- Privacy consent-এর local preference controls।
- Authenticated AI Edge Function starter।
- Installable PWA foundation: manifest, icons, service worker, offline app shell।
- Android WebView wrapper, Android manifest/theme/Gradle project, SDK ও APK build workflow।
- App splash screen ও navy/gold visual identity-এর প্রাথমিক কাজ।

## 8.2 Core platform, setup, community ও privacy — 2026-11-18 থেকে 2026-11-19

- Core platform-এর প্রথম Supabase migration: 202611180001_master_world_vip.sql।
- Supabase One-Click/Safe Setup flow, consent-first preferences, setup wizard এবং progress tracking।
- Update Center, staged rollout/update manifest, app version check এবং semantic version tests।
- Member-approved PWA update activation/Allow Now flow; service-worker cache refresh controls।
- Global Community foundation: member discovery/search, friend requests, direct chat, public groups/group chat।
- Community database schema এবং RLS membership protections।
- Privacy rights/consent history ও data-rights request backend/UI foundation।
- Owner-controlled Admin RBAC, Admin & Security Center, Owner-only role controls।
- Admin member broadcast ও broadcast inbox foundation; app version 3.3.0 update work।
- Update release metadata table ও in-app update information।
- Community, privacy, RBAC, broadcast ও release metadata-র migration/workflow order সংরক্ষণ।

## 8.3 Messaging, security, payments, helpdesk ও emergency services — 2026-11-20 থেকে 2026-11-21

- Unified Inbox, conversation loading, message read markers ও member messaging flow।
- Web Push subscription controls, push sender Edge Function, webhook/deployment foundation এবং push security checks।
- Realtime messaging migration ও live refresh/polling fallback।
- Registration/Login validation, session state, error handling, password reset/logout ও member profile load hardening।
- Trusted Devices ও app-observed Login History UI/database foundation; trusted device ব্যবহারে explicit consent।
- Security Center navigation, Supabase Auth session connection, MFA controls এবং global session sign-out foundation।
- Profile discovery privacy hardening; public search-এ অনুমোদিত public fields-ই প্রকাশের নীতি।
- Facebook setup assistance service order UI/backend, customer feedback/complaint storage এবং Admin moderation controls।
- Payment flow foundation: SSLCommerz checkout Edge Function, provider callback/IPN validation, verified-payment state, idempotent callback handling, risk checks এবং browser return-এ নিরাপদ pending state।
- Sandbox/test validation দিয়ে কোনো order-কে Paid করা যাবে না—এই সুরক্ষা।
- Member Verification & Private Helpdesk: private member request, staff review, private message thread, needs-info/reply, status history/events, notifications, anti-spam/rate limits এবং RLS acceptance checks।
- Live Number Location Map: opt-in sharing, verified phone lookup, timestamp/freshness এবং privacy controls-এর foundation।
- Emergency helpline directory, source verification policy, Bangladesh 999 call link ও complaint escalation guidance।
- Offline emergency guidance/games, offline drafts, voice notes, online/offline status, country news ও global crisis alerts।
- All-country selectors এবং multilingual safety information।
- Owner-only live service health endpoint/checks; browser থেকে service-role/private secrets প্রকাশ না করার checks।
- Owner-only Server Code Box / server code staging flow; SQL preview-only behavior, privileged deployment restrictions।
- Android release signing setup, keystore validation, signed APK workflow ও checksum validation foundation।
- Migration inventory completeness, duplicate-version checks, shell continuation, RLS/index audits এবং two-member privacy test workflows-এর বহু hardening pass।

## 8.4 Member Hub, Work & Earn, messaging acceptance ও global internet — 2026-11-22 থেকে 2026-11-23

- Member Hub/Profile UI: display name, username, bio, HTTPS avatar URL, country ও member-search visibility edit/reload।
- Public member search-এ member-provided bio দেখানো।
- Member discovery, friend requests, accepted-friend-only direct chat, groups/group chat, inbox/read markers, broadcast এবং realtime/polling fallback একত্র করা।
- Work & Earn job board UI: job search/categories, task posting, member application, own-post management, incoming application review, accept/reject actions।
- Work & Earn migration 20261123100000_work_earn_job_board.sql: authenticated-only access, RLS, one-application-per-member constraint এবং Owner/Admin review RPC foundation।
- Two-member RLS এবং bidirectional messaging acceptance test scripts/workflows।
- Supabase secure migration workflow, migration dry-run, read-only RLS/index audit এবং encrypted backup/restore-preview workflow foundation।
- IPv4-compatible Supabase Session Pooler ব্যবহারের correction; migration/backup workflow-এর secret validation ও connection parsing hardening।
- MW VIP FREE GLOBAL INTERNET requirements: Google/YouTube/Facebook/WhatsApp/web access-এর ৳0 member price target; actual upstream provider, lawful contract, hardware, gateway, funding ও coverage প্রয়োজন—এই সীমাবদ্ধতা নথিভুক্ত।
- Global Internet app page/navigation, provider-pending Connect/Disconnect UI, app-host connectivity diagnostic, সাত ধাপের rollout checklist, Update Center ও update-manifest linkage।
- Global Internet UI কখনো fake satellite connection দেখায় না; provider/API/terminal/gateway/funded data capacity সংযুক্ত নয়।

## 8.5 Referral, public member identity, rewards, Gmail OTP ও Owner compensation — 2026-11-24

- Referral attribution/code/statistics, Member Referral Center, Admin referral overview এবং public member referral identity/profile route।
- Referral policy: free signup/referral, কোনো deposit বা বাধ্যতামূলক purchase নয়; eligible direct referral-এর ৳50 BDT, 24-hour good-standing (continuous online থাকা নয়), email verification/profile completion, anti-fraud/self-referral/duplicate protections।
- Referral wallet/reward foundation: append-only ledger, funding records, eligibility checks, unique reward/idempotency, server-side scheduled processor, pause-by-default এবং funded-budget gate।
- Member referral wallet UI; bKash/Nagad withdrawal request UI; Admin budget/pause/review/approve/reject/manual-paid controls। Paid status-এর জন্য actual transfer reference দরকার; এটি স্বয়ংক্রিয় bKash/Nagad transfer নয়।
- Two-member referral privacy/acceptance SQL ও manual workflow।
- Public member referral badge/profile RPC।
- International referral USD-equivalent policy ও Owner-controlled USD/BDT rate/source/reference audit; country verification/review controls।
- Direct member 100% standard referral reward + Owner network 100% additional reward-এর migration/UI/pending entitlement foundation; total reward liability 200%—শুধু confirmed funding থাকলে release। এটি funded/live payout নয়।
- Referral payout reference integrity: paid reference required, reviewer/timestamp, duplicate reference prevention।
- Referral SQL dollar-quote/newline corrections; guarded migration preflight এখন expected migration file existence যাচাই করে।
- In-app Gmail signup OTP input, Verify/Resend UI এবং Supabase Auth verifyOtp/resend wiring; email template/dashboard configuration ও real inbox test ছাড়া delivery verified নয়।
- Owner/Admin monthly compensation policy/ledger foundation, minimum monthly compensation policy documentation, Owner-only dashboard/RPC, monthly accrual workflow এবং acceptance tests।
- Zero personal-cost policy: Owner ব্যক্তিগতভাবে reward fund seed করতে বাধ্য নন; member deposit/fee নয়; only genuine settled company income/sponsor/donor allocation may fund rewards; unfunded amount Pending থাকবে।
- Zero-cost policy website release-এর একটি নির্দিষ্ট Pages run 45436255175-এ build/deploy/live verification সফল হওয়ার রেকর্ড আছে; ওই নির্দিষ্ট policy update-এর deployment evidence, বর্তমান release verification-এর বিকল্প নয়।
- Company Revenue এবং Referral Reward Fund আলাদা রাখার policy; actual Company Revenue Ledger/provider collection/allocation bridge এখনও implement/live নয়।

## 8.6 Admin Auto Work, anti-theft recovery, member financial protection ও Owner profit — 2026-11-25

- Admin Auto Work-এর পাঁচটি module design/DB control-plane foundation:
  1. AI Data Processing
  2. AI Translation & Document Processing
  3. PDF Automation
  4. Image Processing
  5. Website Monitoring & Automated Reporting
- Admin-only job control/status dashboard, per-module one-active-job constraint, five total concurrent jobs, queue/claim/concurrency hardening এবং Owner-only controls।
- Admin Auto Work migration 20261125100000_admin_auto_work_control_plane.sql এবং concurrency fix 20261125130000_admin_auto_work_claim_concurrency_fix.sql।
- Free-first infrastructure/storage plan, Cloudflare R2 Standard candidate, independent backup/storage decision, quota/budget/worker limits ও zero-cost server policy documentation।
- Admin Auto Work live নয়: server/worker/provider/API/storage/backup connectors deployed/configured/verified নয়; status UI/SQL foundation continuous job execution বা income তৈরি করে না।
- Member Auto Work paid package execution/checkout আপাতত disabled/paused; Admin workload isolation ও সাধারণ সদস্যের আর্থিক সুরক্ষা অগ্রাধিকার।
- ভবিষ্যৎ package launch-এর জন্য 100% actual liquid refund reserve, আলাদা operating budget, dedicated isolated infrastructure, reconciliation, provider/legal approval, hard caps, emergency stop, member wage protection এবং independent acceptance tests বাধ্যতামূলক।
- Human-reviewed, genuinely funded Work & Earn tasks আলাদা পথে ভবিষ্যতে চলতে পারে; registration/online থাকার জন্য কোনো আয় নয়।
- Owner profit rate: 20% of distributable net platform revenue; gross client payment, member wages, package price, refund reserve বা unsettled funds নয়।
- Work & Earn Member Wallet ও Owner Profit আলাদা append-only ledger; Owner-only audited rate; server-only provider-verified settlement; atomic/idempotent posting; acceptance-time rate selection; fail-closed reconciliation।
- Migration 20261125160000_work_earn_wallet_owner_profit.sql, acceptance test, UI panels এবং 22টি finance-specific static checks।
- Anti-Theft & Phone Recovery (Android+iOS) panel/foundation: Google Find Hub, Apple Find My, Owner-only recovery framing, device enrollment এবং recovery-device/location-sample schema foundation।
- Anti-Theft recovery live নয়: Android/iOS native app permissions, device enrollment, provider/OS integrations, production migration ও real-device acceptance tests pending। কোনো ফোন নম্বর/SIM দিয়ে গোপনে GPS বের করা যাবে না।
- Premium Member Dashboard UI/module foundation যুক্ত; real backend availability/production acceptance আলাদা gate।
- PWA cache/version, release manifest, Update Center audit link এবং deployment verification-এ বহু correction/verification commits।

## 8.7 বর্তমান repository-তে থাকা প্রধান feature foundation — এক নজরে

নিচের প্রতিটি item-এর ক্ষেত্রে “foundation” মানে code/UI/schema/docs/workflow repository-তে আছে; এটি নিজে production-live নয়।

1. Landing page, responsive PWA, branding, icons, service worker, offline app shell।
2. Android WebView app/build workflow এবং secure signed-release foundation।
3. Supabase Auth registration/login/profile foundation ও Gmail OTP UI।
4. Member Hub/Profile editing ও public member discovery।
5. Global Community: search, friends, direct chat, groups, group chat, inbox, read state, broadcast।
6. Realtime messaging ও Web Push sender/subscription foundation।
7. Owner/Admin RBAC, Admin & Security Center, audit logs ও privileged server-side controls।
8. Privacy consent, data-rights request, profile visibility ও RLS privacy controls।
9. Trusted Devices, Login History, MFA/session security foundation।
10. Member Verification & Private Helpdesk।
11. Live Number Location Map (consent-based)।
12. Facebook setup assistance orders, payment state, customer feedback/complaint ও Admin moderation।
13. SSLCommerz checkout/provider verification foundation (real merchant configuration/settlement acceptance pending)।
14. Emergency helplines, offline guidance/games, drafts/voice notes, country news/crisis alerts।
15. Update Center, release manifest, update checker, staged rollout ও safe update activation।
16. Work & Earn job board।
17. Referral attribution, public referral identity, rewards wallet, Admin review ও manual payout-request flow।
18. International referral FX/country verification and Owner network reward foundation।
19. Owner monthly compensation ledger/dashboard/scheduled accrual foundation।
20. Company Revenue vs Referral Reward Fund separation policy।
21. Admin Auto Work five-module control plane/status dashboard।
22. Member Auto Work protected package policy; checkout/execution paused।
23. Member Work Wallet ও Owner Profit 20% net-revenue ledger foundation।
24. Anti-Theft Phone Recovery Android+iOS panel/schema foundation।
25. Premium Member Dashboard foundation।
26. Global Internet provider-pending page/diagnostics/rollout checklist।
27. Owner-only live service health and Server Code staging/preview tools।
28. Secure Supabase migration, backup/restore preview, dry-run, RLS/index audit and two-member test workflows।

## 8.8 Repository database migration inventory — বর্তমান tree-তে 30টি SQL migration

নিচের সব migration repository-তে আছে; কোনোটি production Supabase-এ applied হয়েছে—এমন প্রমাণ ধরে নেওয়া যাবে না। এগুলো ordered inventory হিসেবে রাখা হলো:

1. 202611180001_master_world_vip.sql
2. 202611190001_global_community.sql
3. 202611190002_privacy_rights.sql
4. 20261119180000_admin_rbac_owner_control.sql
5. 20261119190000_member_broadcast.sql
6. 20261119200000_update_releases.sql
7. 20261120100000_inbox_push_foundation.sql
8. 20261120150000_membership_helper_hardening.sql
9. 20261121100000_profiles_discovery_privacy_hardening.sql
10. 20261121120000_facebook_setup_orders.sql
11. 20261121130000_facebook_setup_feedback.sql
12. 20261121140000_verified_payment_state.sql
13. 20261121150000_sslcommerz_checkout_enable.sql
14. 20261121160000_trusted_devices_login_history.sql
15. 20261121170000_group_rls_recursion_fix.sql
16. 20261121180000_member_verification_helpdesk.sql
17. 20261121190000_member_live_location.sql
18. 20261122100000_messaging_realtime.sql
19. 20261123100000_work_earn_job_board.sql
20. 202611240001_member_referrals.sql
21. 202611240002_public_member_referral_profile.sql
22. 202611240003_referral_wallet_rewards.sql
23. 202611240004_owner_monthly_compensation.sql
24. 202611240005_international_referral_usd_equivalent.sql
25. 202611240006_network_admin_referral_rewards.sql
26. 202611240007_referral_payout_reference_hardening.sql
27. 20261125100000_admin_auto_work_control_plane.sql
28. 20261125120000_anti_theft_device_recovery.sql
29. 20261125130000_admin_auto_work_claim_concurrency_fix.sql
30. 20261125160000_work_earn_wallet_owner_profit.sql

## 8.9 Repository automation/workflow inventory — বর্তমান tree-তে 15টি workflow

1. .github/workflows/accrue-owner-compensation.yml
2. .github/workflows/android-apk.yml
3. .github/workflows/android-release.yml
4. .github/workflows/apply-supabase-migrations.yml
5. .github/workflows/audit-supabase-indexes-rls.yml
6. .github/workflows/backup-restore-preview.yml
7. .github/workflows/check-update-system.yml
8. .github/workflows/database-migration-dry-run.yml
9. .github/workflows/deploy-update-functions.yml
10. .github/workflows/pages.yml
11. .github/workflows/process-referral-rewards.yml
12. .github/workflows/secure-supabase-db-update.yml
13. .github/workflows/test-referral-wallet-two-members.yml
14. .github/workflows/test-two-member-rls.yml
15. .github/workflows/verify-supabase-migrations.yml

Workflow file থাকা মানে তার schedule/secret/provider integration সফলভাবে live চলছে—এমন নয়।

# 9. সম্পন্ন, আংশিক, ব্যর্থ ও বাকি — নির্ভুল অবস্থা

## 9.1 Repository-তে code/docs/schema হিসেবে সম্পন্ন

- উপরের 28টি feature area-র code/UI/schema/documentation/workflow foundation repository-তে আছে, সংশ্লিষ্ট feature register ও migrations দ্বারা নথিভুক্ত।
- 30টি SQL migration বর্তমান tree-তে আছে এবং guarded migration inventory-তে অন্তর্ভুক্ত করার কাজ করা হয়েছে।
- 15টি GitHub Actions workflow file বর্তমান tree-তে আছে।
- Registration/Login flow-এর validation, email OTP UI, password reset/logout ও member profile loading source foundation আছে।
- Work & Earn job board, referral wallet/reward engine foundation, Owner monthly compensation, Admin Auto Work control plane, anti-theft recovery panel এবং Work & Earn/Owner Profit ledger foundation commit করা হয়েছে।
- Security static validators, PWA cache validators, deployment checks, RLS/index audit, two-member test workflows এবং acceptance/runbook documents repository-তে আছে।

## 9.2 নির্দিষ্ট automated verification evidence

- Migration safety run 45603357136:
  - PASS: inline JavaScript syntax।
  - PASS: membership helper migration।
  - PASS: Community live readiness।
  - PASS: Owner-only live service health (9/9)।
  - PASS: Work & Earn wallet/Owner profit finance static checks (22/22)।
  - FAIL: scripts/verify-global-communication.py-এর PWA cache refreshed assertion।
  - পরবর্তী কয়েকটি step skipped; এগুলো PASS নয়।
  - Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357136
- Pages run 45603357353:
  - Build SUCCESS; Deploy SUCCESS; final “Verify live GitHub Pages release” FAIL।
  - Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357353
- Current HEAD 6da0d818a4d7af265596a7a4972b00b84fdbbaa0 Pages run 45605229377:
  - Build SUCCESS; Deploy SUCCESS; final “Verify live GitHub Pages release” FAIL।
  - Failed job: published website content, Update Center audit link, manifest এবং PWA cache verification step; log-এ নির্দিষ্ট কোন grep/assertion fail করেছে তা আলাদা করে print হয়নি।
  - Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45605229377
- Current HEAD Pages build/deployment workflow run 45605228960: SUCCESS; এটি final live-release verification failure-কে override করে না।
  - Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45605228960
- Work & Earn finance validator-এ 22/22 checks PASS; একই finance code/validator না বদলালে অকারণে পুনরায় চালানো যাবে না।
- Earlier specific zero-personal-cost policy release run 45436255175 build/deploy/final verification PASS ছিল; এটি শুধু ওই historical release-এর evidence।

## 9.3 Backup/restore/database pipeline — গুরুত্বপূর্ণ blocker

- Backup workflow run 45468408735 FAILED:
  - Secret presence validation: PASS।
  - Session Pooler URI syntax validation: PASS।
  - Supabase database authentication/backup creation: FAIL — PostgreSQL password authentication failed।
  - Encrypted backup artifact তৈরি হয়নি।
  - Disposable restore ও migration dry-run SKIPPED।
  - Production migration NOT RUN।
- আগের workflow log-এ database credential প্রকাশিত হওয়ার ঝুঁকি নথিভুক্ত; সংশ্লিষ্ট Supabase database password rotate করে নতুন সম্পূর্ণ Session Pooler URI GitHub secret SUPABASE_DB_URL-এ দিতে হবে। Secret value কখনো chat-এ নয়।
- Password rotation এবং secret update নিশ্চিত না হওয়া পর্যন্ত backup workflow আবার চালানো যাবে না।
- নতুন backup, decrypt, disposable restore, restored table count, migration dry-run ও artifact upload সব PASS না হওয়া পর্যন্ত production migration নিষিদ্ধ।
- Production migration apply করা হয়নি—এটি এখনো NOT DONE।

## 9.4 Production / external integration — এখনো বাকি

- Supabase production migrations apply হয়নি; live schema/RLS acceptance test প্রমাণ নেই।
- Supabase Auth Site URL/Redirect URLs, Email provider/template এবং real inbox OTP delivery end-to-end verified নয়।
- Owner bootstrap identity এবং দুইটি আলাদা test member দিয়ে RLS/privacy/chat/referral/helpdesk acceptance tests-এর complete PASS evidence নেই।
- Referral processor Edge Function/cron secrets, actual reward fund, confirmed company income/sponsor fund এবং real reward payout live নয়।
- bKash/Nagad/bank automatic payout connector নেই; UI-তে manual payout request/review/reference flow থাকলেও actual transfer integration নয়।
- SSLCommerz checkout/provider account/merchant onboarding, webhook secrets, real settled payment/refund/chargeback acceptance test verified নয়।
- Owner monthly compensation scheduled accrual live run verified নয়; policy/ledger foundation বাস্তব payment নয়।
- Admin Auto Work worker, provider adapters, server/queue, R2 bucket, independent backup provider, operating budget ও actual client income নেই।
- Member Auto Work package checkout/execution disabled; 100% liquid refund reserve ও dedicated infrastructure নেই।
- Anti-theft recovery native Android/iOS device enrollment, OS/provider integration, background location/permissions এবং real-device test হয়নি।
- Global Internet satellite/mobile provider contract, terminal, gateway/backhaul, lawful regulatory approval, funded data capacity ও actual connectivity নেই।
- AI Text/Voice provider deployment, licensed AI Image Search provider, approved Meta API integration/review, Web Push/FCM real-device acceptance এবং Play Store release/approval বাকি।
- Company Revenue Ledger/provider collection/allocation bridge বাস্তবে নেই।
- Privacy policy/legal review, data export/delete workflow ও jurisdictional compliance sign-off অসম্পূর্ণ।
- Facebook security/recovery assistance শুধুমাত্র official Meta-supported flow-এর মধ্যে; lifetime recovery/immunity guarantee দেওয়া যাবে না।

# 10. প্রকল্পের স্থায়ী নিরাপত্তা ও মালিকের সিদ্ধান্তসমূহ

- প্রকল্পটি সবসময় existing repository rakib12301111-droid/master-world-vip-তেই চালাতে হবে; নতুন repository/project শুরু করা যাবে না।
- Website URL: https://rakib12301111-droid.github.io/master-world-vip/
- Referral registration/member participation free; কোনো member deposit, hidden fee বা mandatory purchase নয়। Reward কেবল বাস্তব confirmed funding থাকলে; unfunded entitlement Pending।
- Direct referral reward-এর approved base amount বাংলাদেশে ৳৫০ BDT; international referral policy-তে USD $50-equivalent local BDT amount, Owner-controlled verified USD/BDT rate/source/reference ও country verification লাগে। Member referral reward প্রথম ৬–৭ মাস OFF রাখার সিদ্ধান্ত বহাল; no member deposit. Direct + Owner-network 100% + 100% reward design-এর total 200% liability পুরোপুরি funded না হলে দুটোই Pending থাকবে।
- Owner/Admin monthly minimum compensation target: ৳১,০০০ BDT per month. Eligible settled commission ৳১,০০০-এর বেশি হলে higher amount; কম হলে shortfall শুধু unpaid/outstanding internal payable, cash বা withdrawable balance নয়। Owner panel open/refresh-এ November 2026 থেকে idempotent month rows generate/backfill foundation আছে; monthly GitHub schedule 00:10 UTC on day 1 committed, but live scheduled execution and real funding/transfer remain unverified.
- Owner ব্যক্তিগত অর্থ দিয়ে reward fund seed করতে বাধ্য নন; settled company income/sponsor/donor allocation ছাড়া reward release নয়।
- Company Revenue, Referral Reward Fund, Member Work Wallet, Owner Profit, Owner/Admin Compensation এবং refund reserve আলাদা ledger/obligation হিসেবে রাখতে হবে।
- Member-এর earned wage সুরক্ষিত; refund বা Owner profit-এর জন্য wage clawback/offset নয়।
- Owner profit 20% কেবল distributable net platform revenue-এর ওপর; member wage, gross receipt, refund reserve বা unsettled money নয়।
- Member Auto Work paid packages disabled; 100% liquid refund reserve ও আলাদা operating budget/infrastructure/legal/provider gates ছাড়া checkout/job start নয়।
- Admin Auto Work Admin-only; Member workload Admin reserved resources block/slow করতে পারবে না।
- Location sharing opt-in, revocable এবং device permission-based; phone number/SIM alone দিয়ে GPS reveal নয়।
- Facebook account password, OTP, login code, session cookie, recovery code কখনো MASTER WORLD VIP বা helpdesk-এ নেওয়া যাবে না; Meta official recovery only।
- Payment status provider server-to-server verification ছাড়া Paid/Settled করা যাবে না; browser redirect, screenshot বা member-entered reference যথেষ্ট নয়।
- No fake income, fake ad views/clicks, fake signups, artificial engagement, CAPTCHA bypass, unauthorized account activity বা guaranteed earnings।
- Free quota শেষ হলে pause/fail-closed; user approval ও spending cap ছাড়া paid fallback/charge নয়।
- কোনো secret value, password, OTP, API key, service-role key, DB password, cookie, card PIN, signed URL বা encryption passphrase handover file/chat-এ রাখা যাবে না।

# 11. ভবিষ্যৎ কাজের জন্য “কখনো পুনরায় করবেন না” তালিকা

1. একই code/config-এর জন্য ইতিমধ্যে PASS হওয়া finance 22/22 static checks, Community readiness, Owner health 9/9, membership helper check বা Pages build step অকারণে আবার চালাবেন না।
2. একই commit-এ পুরো suite বারবার চালাবেন না; প্রথমে failing assertion ঠিক করুন, তারপর শুধু প্রয়োজনীয় affected workflow একবার চালান।
3. Skipped test-কে PASS লিখবেন না।
4. Pages Build/Deploy SUCCESS-কে final release verification PASS বলে ধরবেন না।
5. Migration file repository-তে আছে বলে production DB-তে applied ধরে নেবেন না।
6. UI, dashboard, status panel বা migration foundation দেখে provider/service/worker/payment live ধরে নেবেন না।
7. Wallet ledger balance-কে bKash/Nagad/bank cash withdrawal complete বলে দেখাবেন না।
8. Backup workflow secret validation PASS-কে backup success বা restore success বলে ধরবেন না।
9. Backup/restore/dry-run evidence ছাড়া production migration চালাবেন না; exact authorization phrase-এর বিকল্প নেই।
10. Member Auto Work package checkout/collection পুনরায় চালু করবেন না যতক্ষণ না সব refund reserve, operating budget, isolation, legal/provider ও acceptance gates পাস হয়।
11. একই feature আবার নতুন করে বানাবেন না; আগে এই handover, feature register ও existing code/migrations দেখুন।
12. নতুন project/repository তৈরি করবেন না; current repository-তে additive, reviewed changes করুন।

# 12. পরবর্তী কাজের সুনির্দিষ্ট ক্রম — বর্তমান HEAD থেকে

1. Current HEAD 6da0d818a4d7af265596a7a4972b00b84fdbbaa0-এর পরে নতুন commit হয়েছে কি না আগে যাচাই করুন।
2. Pages run 45605229377-এর failed job-এর exact assertion শনাক্ত করুন; live published www/index.html, Update Center audit link, www/update-manifest.json, www/sw.js cache version এবং expected markers source commit-এর সঙ্গে তুলনা করুন। Build/Deploy step ইতিমধ্যে PASS—ওগুলো অকারণে পুনরায় পরীক্ষা নয়।
3. Migration safety run 45603357136-এর একমাত্র known failing assertion—PWA cache version refreshed—scripts/verify-global-communication.py ও actual www/sw.js version মিলিয়ে targeted fix করুন। Source version ঠিক না করে শুধু validator pass করাবেন না।
4. সংশ্লিষ্ট source/validator change হলে affected verification workflow একবার চালান; finance code না বদলালে 22/22 finance static test evidence reuse করুন।
5. Backup blocker: Owner database password rotate ও GitHub secret update নিশ্চিত না হওয়া পর্যন্ত backup workflow চালাবেন না। এরপর encrypted backup → disposable restore → migration dry-run → artifact preservation সব PASS করে evidence লিখুন।
6. Complete ordered pending migration list, project ref এবং Owner bootstrap identity review করুন; দুটি আলাদা test member দিয়ে staging/RLS acceptance tests চালান।
7. কেবল তখনই user-এর exact authorization phrase APPLY-MASTER-WORLD-VIP-MIGRATIONS নিয়ে guarded production apply gate বিবেচনা করুন। Phrase ছাড়া apply নয়।
8. প্রতিটি meaningful update-এর পর এই ফাইলের Last updated, HEAD SHA, workflow run URLs/status, completed/pending state এবং next action সংশোধন করুন।

**Resume phrase:** “MASTER WORLD VIP — docs/PROJECT_HANDOVER_MASTER_BN.md সম্পূর্ণ পড়ে, বর্তমান GitHub HEAD ও workflow evidence মিলিয়ে, PASS হওয়া কাজ পুনরায় না করে, section 12-এর পরবর্তী কাজ থেকে শুরু করুন।”


## 8.10 Feature Register-এর সব Stage-এর cross-check — কোনো module বাদ নয়

আগের Feature Completion Register-এর `Feature register` table এবং Update Center manifest-এর stage list-এর সঙ্গে master handover মিলিয়ে নিচের সম্পূরক inventory যোগ করা হলো। এগুলো আলাদা feature/module; 8.7-এর 28টি area-র মধ্যে কয়েকটি আগে শুধু সংক্ষেপে উল্লেখ ছিল।

| Feature / Stage | Repository-তে যা আছে | বাকি / সঠিক অবস্থা |
|---|---|---|
| One-Click Safe Setup / Workspace Settings | Yes / Review / Later consent flow, local preference store, Dashboard status card, Settings page | Browser/Android-এ save/reload, language/theme পুরো UI-তে সঠিকভাবে প্রয়োগ এবং Pages verification acceptance বাকি; optional analytics, OS permission, external connection ও legal consent default off |
| Main Dashboard / PWA shell | Responsive dashboard, navigation, PWA manifest, icons, service worker, offline shell | Android real-device install/update/offline acceptance বাকি |
| Supabase Auth / Registration / Login | Signup, login, password reset/logout, session/profile loading, email OTP UI + verify/resend wiring | Auth URL/provider/template, real inbox OTP, production migration ও two-account RLS acceptance বাকি |
| Global Community | Member search, friend request accept/decline/cancel, accepted-friend-only direct chat RPC, public groups/group chat | Production migration, two-account privacy/membership test ও real message delivery acceptance বাকি |
| Unified Inbox / Notifications / Push | Inbox, unread/read markers, per-user push subscription, service-worker notification display/click, send-push Edge Function foundation | VAPID/database webhook/Edge Function deployment, Android Chrome/PWA real push test; native APK-তে আলাদা FCM integration |
| Admin Member Broadcast | Owner/Super Admin/Admin restricted broadcast UI, recipient inbox record, server-side permission and 3/hour rate-limit foundation | Migration apply, owner bootstrap and member-isolation/delivery acceptance বাকি |
| Privacy / GDPR / Consent / Data Rights | Consent sync/events, privacy-rights request queue, access/correction/deletion request UI/backend foundation | Published privacy/cookie/retention policy, real request fulfilment, deletion/export/correction workflow, processor/contact/legal review বাকি; GDPR certification দাবি নয় |
| AI Text & Voice Assistant | AI assistant Edge Function starter/foundation | Provider/model, server-side API secret, deploy, voice input/output, limits/abuse/error acceptance বাকি |
| AI Image Search + License | AI Center placeholder/UI foundation | Licensed provider, source/attribution/license metadata, server-side integration and rights tests বাকি |
| Facebook Public Discovery | Facebook Center UI and consent/privacy guidance | Meta app, approved Graph API permission/review and compliant public-data integration বাকি; scraping/password/OTP collection নিষিদ্ধ |
| Active User Finder | Consent-based AI/manual workflow concept | Explicit opt-in availability, expiry, block/report, rate limit and privacy-safe implementation not complete; phone/SIM activity inference or covert location prohibited |
| Referral / Global Promotion | Referral codes/attribution, public member referral profile, direct + Owner-network reward ledgers, FX/rate UI, pending reward wallet, Admin review/processor foundation | Production migrations, function/cron, confirmed funding, FX/country verification, two-member/deep-tree and 24-hour qualification acceptance, actual payout connector বাকি |
| Owner/Admin Compensation | ৳1,000 monthly minimum policy and separate Owner compensation ledger/UI/scheduled accrual foundation | Migration, secret, Owner role, monthly live run, verified eligible settled income and actual transfer reconciliation bাকি |
| Android APK / Release | WebView Android project, debug/release workflows, signing/checksum foundation | Signed release build, physical-device install/update/security test এবং release evidence বাকি |
| Google Play Store | Roadmap only | Developer account, signed AAB, store listing, privacy/data safety declarations, screenshots, policy review and Play approval বাকি; app Play Store-এ published নয় |
| Landing Page / Website | GitHub Pages site and PWA shell in repository | Current Pages live-release verification must pass; production feature acceptance separate |
| Premium Member Dashboard | Black/gold dashboard UI/module, authenticated profile and private referral-wallet RPC integration | Current Pages deployment/module load, logged-out/logged-in state, profile privacy, RPC availability and Android refresh acceptance বাকি |
| Start-to-Finish Audit / Update Center | Audit document link, update manifest, version comparison and user-approved PWA update activation | Live manifest must be valid JSON; published audit link, current cache version and Update Center behavior must pass deployment/browser tests |

### Manifest ও release metadata audit finding — 2026-11-25

- Full audit-এ `www/update-manifest.json`-এ একটি syntax defect পাওয়া যায়: Anti-Theft stage-এর object শেষ হওয়ার পরে পরবর্তী stage-এর আগে comma/closing brace অনুপস্থিত ছিল। ফলে manifest **valid JSON ছিল না**। এটি code update `4b5b3c1155670f30fcd0ce77792c8265c194dbb0`-এ ঠিক করা হয়েছে; JSON parse করে 17টি top-level stage যাচাই করা হয়েছে।
- Manifest-এর note-এ PWA cache v36 লেখা ছিল, কিন্তু actual `www/sw.js` cache source ছিল `mwvip-pwa-v37`; manifest note v37-এর সঙ্গে align করা হয়েছে।
- Pages verification workflow-এ manifest JSON parse validation, cache v37 marker check এবং failure line/command দেখানোর ERR trap যোগ হয়েছে — commit `c42438dcbecb661e4e933b7dcf9f3bd5bc475175`।
- Global communication validator-এ stale expectation `mwvip-pwa-v34` পাওয়া যায়; actual service worker v37। Validator expectation v37-এ align করা হয়েছে — commit `2278383df96dbd85caa9d5520af2164381e18ad2`।
- এই code fixes commit হয়েছে, কিন্তু সংশ্লিষ্ট নতুন GitHub Actions runs PASS না হওয়া পর্যন্ত full verification complete বলা যাবে না।
- Repository-তে দুটি পুরোনো, মূল app-এর সঙ্গে যুক্ত নয় এমন HTML artefact পাওয়া গেছে: `www/index.html।` এবং `www/www/index.html`। Search-এ বর্তমান app code/workflow থেকে এগুলোর কোনো reference পাওয়া যায়নি। এগুলো stale duplicate/legacy candidate; কোনো live feature-এর source হিসেবে গণ্য করা যাবে না। আলাদা review ছাড়া delete করা হয়নি।

## 9.5 এই পূর্ণ অডিটে নতুন পাওয়া correction ও verification queue

1. `www/update-manifest.json` invalid JSON ছিল; উপরে উল্লেখিত commit-এ repair এবং JSON parse check করা হয়েছে।
2. Manifest-এর cache note v36 ছিল, actual service worker v37; note v37 করা হয়েছে।
3. `scripts/verify-global-communication.py` v34 খুঁজছিল, কিন্তু service worker v37; expectation v37 করা হয়েছে।
4. Pages workflow এখন manifest JSON parse করবে এবং ব্যর্থ হলে exact line/command log করবে। নতুন workflow run না হওয়া পর্যন্ত deployment verification pending।
5. Feature Register-এ `Last reviewed: 2026-11-24` এবং Update Center manifest-এ পুরোনো status text রয়েছে; এই master handover-ই সর্বশেষ consolidated source of truth। Feature Register ও manifest-এর পরবর্তী maintenance-এ একই status sync করতে হবে।
6. Production Supabase backup/restore/preview/apply, Auth real OTP, two-member RLS, provider integration, payout, native Android/iOS, Play Store, Global Internet এবং Auto Work worker-এর কোনো pending gate-কে এই static source audit complete করে না।



## 8.11 পূর্বের অনুমোদিত কিন্তু আগের handover-এ অনুল্লেখিত Facebook feature requirement

**নির্ধারিত feature name (অ্যাপের ভেতরের নাম):** `MASTER WORLD VIP Lifetime Facebook Security & Recovery System`

- 2026-11-25-এর user-approved requirement: feature-টি existing MASTER WORLD VIP app/website-এর ভেতরে থাকবে; বাইরের app/project name পরিবর্তন করা যাবে না এবং নতুন app/website তৈরি করা যাবে না।
- Member-দের জন্য free support/service হিসেবে পরিকল্পনা করা হয়েছিল।
- Existing app-এর Facebook area-তে Facebook account connection/creation entry point থাকবে, কিন্তু কেবল Meta-এর official authorization/API/Terms যতটুকু অনুমতি দেয় ততটুকুই। Unauthorized account creation, private data scraping, password/OTP/session-cookie collection বা Meta login/recovery bypass নয়।
- Dedicated helpline, in-app Inbox announcements/messages, homepage/banner promotion এবং Facebook/YouTube/অন্যান্য external advertising placement অন্তর্ভুক্ত করার requirement আছে।
- Existing Facebook Setup Assistance order/payment/feedback UI হলো আলাদা foundation; সেটি এই named Lifetime Facebook Security & Recovery System-এর implementation complete প্রমাণ করে না।
- **Status: requirement approved and recorded; named service-এর full UI/helpline/inbox promotion/external campaign/Meta-authorized account workflow এখনো separately implemented and acceptance-tested বলে প্রমাণ নেই।**
- “Lifetime” নামটি user-approved product label হলেও Facebook account কখনো suspend হবে না, সব পরিস্থিতিতে ফেরত পাওয়া যাবে, বা MASTER WORLD VIP Meta-এর সিদ্ধান্ত override করতে পারবে—এমন guarantee দেওয়া যাবে না। Account control/recovery final authority Meta; support কেবল official recovery ও permitted assistance পর্যন্ত সীমাবদ্ধ।

## 9.6 আগের handover-এ বাদ পড়া historical successful evidence

### Android APK build — পাঁচটি ধারাবাহিক successful run

- `Build MASTER WORLD VIP APK` workflow runs #14–#18 সবগুলো **SUCCESS**:
  - #14: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/44888286358
  - #15: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/44888327031
  - #16: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/44889976997
  - #17: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/44889983610
  - #18: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/44890002887
- Run #18-এর সব ধাপ PASS: source checkout, Java, Android SDK setup/packages, Gradle, debug APK build এবং artifact upload।
- Run #18 artifact: `master-world-vip-debug-apk`, artifact ID `14700719014`, SHA-256 `84f9c2725dd5c5d8c530a6758eb49ccb8e96675cacf7073f3462deff21427cc6`; GitHub metadata অনুযায়ী expiry 2026-12-05 09:32 UTC।
- **সঠিক সীমা:** এটি installable **debug APK build artifact**-এর প্রমাণ; production-signed release APK/AAB, physical Android install/security test, Play Store upload বা approval-এর প্রমাণ নয়। Artifact download/install আলাদাভাবে verify না করা পর্যন্ত user device-এ app installed বলা যাবে না।

### Update system automated checks

- `Check MASTER WORLD VIP update system` run #166: **SUCCESS**, run ID `45608007267` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45608007267
- Repository history-তে এই workflow-এর 114টি recorded run-ই success; এটি update-system lint/unit validation evidence, full Pages live-release or production Supabase acceptance test নয়।

### Secure Edge Function deployment workflow

- `MASTER WORLD VIP - Deploy Secure Update Functions` run #31, ID `45405963963`: all jobs/steps SUCCESS, including deployment-secret validation, Supabase CLI setup, “Deploy all MASTER WORLD VIP Edge Functions”, and deployment command completion.
- Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45405963963
- **সঠিক সীমা:** এটি ওই commit-এ deployment command সফল হওয়ার evidence; সব Edge Function-এর real provider configuration, production database schema compatibility, secret freshness, runtime health ও end-to-end behavior এখনো পৃথকভাবে verify করতে হবে।

## 9.7 PWA cache validator correction — সব stale reference audit

একই PWA service worker source `mwvip-pwa-v37` হলেও কয়েকটি independent static validator পুরোনো `v34` ধরে রেখেছিল। এগুলো targetedভাবে align করা হয়েছে:

- `scripts/verify-global-communication.py` — commit `2278383df96dbd85caa9d5520af2164381e18ad2`
- `scripts/verify-emergency-games.py` — commit `85a3f073719a510f5adfb41e863e4d2667bb43b5`
- `scripts/verify-crisis-alerts.py` — commit `3485ac600c28637dd89e906ff1d6e3cbc65235ac`
- `scripts/verify-helpline-directory.py` — commit `f78b1d05dd9d2d7f378436286de4998b9ed7f089`
- `scripts/verify-global-country-directory.py` — commit `f4a063d1cd7ae04b2f37e77d6768b91d42d50809`

Latest migration safety run `45608178784` on source commit `f4a063d1cd7ae04b2f37e77d6768b91d42d50809` **SUCCESS**. All 17 steps passed, including JavaScript syntax, membership helper, Community readiness, Owner health, global communication, offline emergency/games, official helplines, crisis alerts, all-country directory, push sender, referral rewards, Owner compensation and Work & Earn finance. Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45608178784

## 9.8 Latest Pages verification blocker and targeted correction

- Pages run `45608178700` on source commit `f4a063d1cd7ae04b2f37e77d6768b91d42d50809`: Build SUCCESS, Deploy SUCCESS, final live verification FAIL.
- New diagnostic trap identified the exact mismatch: workflow expected literal `Owner-only Recovery`, while actual page heading is `Anti-Theft Recovery — হারানো / চুরি হওয়া ফোন (Owner-only)`. This is a case/text mismatch in the verifier, not proof that the recovery backend is live or incomplete.
- Corrected verifier to check the actual source marker `Owner-only)` in commit `306318f71473e3f94862fcd7449ad81cc386849a`.
- **VERIFIED SUCCESS:** Pages run `45608470948` on commit `aa45363d713909d0a5829dc35a0550cc9b72b5ca` completed Build SUCCESS, Deploy SUCCESS and final “Verify live GitHub Pages release” SUCCESS. The corrected Owner-only marker, live HTML, audit link/document, valid manifest JSON, manifest stage markers and PWA cache v37 all passed the workflow checks.
  Run link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45608470948
- The repository manifest parses as valid JSON and contains 17 top-level stages. The Pages run verifies the published copy's syntax/markers; it does not prove Supabase migrations, email OTP delivery, provider services or end-to-end feature acceptance.

