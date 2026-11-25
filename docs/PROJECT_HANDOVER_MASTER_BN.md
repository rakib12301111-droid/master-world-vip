# MASTER WORLD VIP — মূল Project Handover (বাংলা)

**সর্বশেষ পুনর্গঠন:** 2026-11-25 (বাংলাদেশ সময়)  
**বিদ্যমান Repository:** `rakib12301111-droid/master-world-vip`  
**Website:** `rakib12301111-droid.github.io/master-world-vip`  
**এই নথির কাজ:** একমাত্র authoritative resume point। নতুন session-এ প্রথমে এই ফাইল পড়তে হবে, তারপর actual main HEAD ও প্রয়োজনীয় workflow evidence যাচাই করতে হবে। নতুন project/repository শুরু করা যাবে না।

## 1. ব্যবহারকারীর নির্দেশ — বাধ্যতামূলক

1. এখানে **সম্পূর্ণ কাজ** এবং **অসম্পূর্ণ কাজ** আলাদা রাখতে হবে। অসম্পূর্ণ foundation-কে completed বলা যাবে না।
2. Fully completed কাজের evidence শুধু `docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md`-এ থাকবে। ঐ ফাইলে clickable evidence link নেই; শুধু internal run/commit IDs থাকবে।
3. একবার সম্পন্ন কাজের link ব্যবহারকারীকে আর পাঠানো যাবে না। পুরোনো task/run/commit links chat-এ পুনরায় দেবেন না। ব্যবহারকারী status জানতে চাইলে সংক্ষিপ্ত সারাংশ দিন।
4. একই source/configuration-এর PASS check পুনরায় চালাবেন না। Source বদলালে শুধু affected check এবং প্রয়োজনীয় dependent verification চালাবেন।
5. এই handover এবং no-repeat register-ই current status-এর authoritative source। পুরোনো history archive বা feature register থেকে stale status কপি করবেন না।
6. কোনো secret, password, OTP, API key, service-role key, DB password, cookie, signed URL, payment PIN বা encryption passphrase chat/source/handover-এ রাখা যাবে না।
7. কোনো feature-কে LIVE বলতে হলে code + required deployment + production DB/provider configuration + security + বাস্তব acceptance tests সব প্রাসঙ্গিকভাবে PASS হতে হবে।

## 2. বর্তমান repository audit snapshot

- Audit baseline main HEAD, handover rewrite-এর আগে: `57d0192bd8b7780bb8cf40f2faae51cf38e617fc`.
- Baseline commit message: completed-only no-repeat register যোগ করা হয়েছে।
- এই handover rewrite নিজেই main-এ নতুন commit তৈরি করবে; তাই উপরের SHA-কে পরবর্তী session-এর current HEAD ধরে নেওয়া যাবে না। প্রতিবার GitHub থেকে actual `main` HEAD পড়ুন।
- Current audited tree inventory: **30 SQL migration**, **15 GitHub Actions workflow**, **30 docs/** supporting documents (28 pre-existing documents plus the new no-repeat register and preserved history archive)।
- Inventory count কেবল file existence বোঝায়; production database-এ migration apply বা feature LIVE বোঝায় না।
- Existing repository-তেই additive, reviewed changes হবে। নতুন repo/project নয়।

## 3. সম্পূর্ণ ও যাচাইকৃত কাজ — শুধু এগুলোই completed

এই তালিকা ইচ্ছাকৃতভাবে সংক্ষিপ্ত। নির্দিষ্ট scope-এ প্রমাণিত PASS ছাড়া অন্য feature এখানে যোগ করা যাবে না।

- GitHub Pages release: audit baseline `d396b694a951a22b0a67714b9fdb9cc3842cca3f`-এর run `45609294228`-এ Build, Deploy ও final live Verify—তিনটি job-ই SUCCESS।
- Repository static safety suite: run `45608178784`, tested commit `f4a063d1cd7ae04b2f37e77d6768b91d42d50809`; static migration-safety job এবং 17টি substantive validation step SUCCESS।
- Update-system code validation: run `45608007267`; Deno lint, push-sender type-check এবং unit tests SUCCESS।
- Finance/Owner/Community/membership helper security checks সংশ্লিষ্ট scope-এ PASS হয়েছে; বিস্তারিত no-repeat record-এ আছে।

**গুরুত্বপূর্ণ সীমা:** এগুলো নির্দিষ্ট code/static/deployment scope-এর completion। এগুলো production DB migration, real payment, live OTP, GPS recovery, provider integration বা সব app feature সম্পূর্ণ হওয়ার প্রমাণ নয়। Completed evidence-এর link ব্যবহারকারীকে পুনরায় পাঠাবেন না।

## 4. অসম্পূর্ণ / BLOCKED — completed নয়

### 4.1 Database, backup ও production migration — BLOCKED

- Production Supabase migration apply হয়েছে—এমন প্রমাণ নেই। 30টি migration repository-তে আছে, কিন্তু production apply NOT VERIFIED / NOT DONE।
- সর্বশেষ inspected DB safety run `45603230313` FAILED। Job `backup-restore-preview`-এর প্রথম secret/URI validation step-এ failure: `SUPABASE_DB_URL must be a PostgreSQL URI`; PostgreSQL client install, database connection, backup, restore ও migration dry-run সব skipped।
- Older run `45468408735`-এ URI structure validation পাসের পর PostgreSQL password authentication FAILED; encrypted backup তৈরি হয়নি।
- Run `45480161082` FAILED এবং jobs API-তে zero jobs ফেরত এসেছে; এই run backup/restore করেছে—এমন evidence নেই। কারণ অনুমান করবেন না।
- আগের credential exposure concern থাকায় database password rotate এবং GitHub Actions secret `SUPABASE_DB_URL` নিরাপদে update করা আবশ্যক। Secret value chat-এ চাইবেন না/লিখবেন না।
- `BACKUP_ENCRYPTION_PASSPHRASE` কেবল GitHub Actions secret এবং আলাদা নিরাপদ password manager/offline storage-এ থাকবে।
- Owner নিরাপদে rotation ও secret correction নিশ্চিত না করা পর্যন্ত backup workflow আবার চালাবেন না।
- এরপর encrypted backup → decrypt → disposable PostgreSQL restore → restored table count > 0 → migration dry-run → encrypted artifact preservation—সব PASS এবং evidence না পাওয়া পর্যন্ত production apply নিষিদ্ধ।
- Supabase project ref review ও Owner bootstrap identity যাচাই, ordered pending migration list review, আলাদা দুই test member দিয়ে RLS/privacy acceptance বাধ্যতামূলক।
- Production apply-এর আগে ব্যবহারকারীর exact authorization phrase আবশ্যক: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`। Phrase ছাড়া apply নয়।

### 4.2 Feature ও integration readiness

নিচের feature-গুলো repository-তে code/UI/schema/documentation foundation থাকতে পারে, কিন্তু সবগুলোকে এখনো incomplete/partial ধরে চলুন; প্রত্যেকটির নিজস্ব production evidence ছাড়া LIVE নয়:

1. Registration/Login, Auth email OTP delivery, password reset, member profile ও Member Hub।
2. Friends, public member discovery, groups, private direct chat, group chat ও real-time delivery।
3. Unified Inbox, read/unread, broadcast, Web Push, FCM ও real-device notification।
4. Owner/Admin RBAC, Security Center, audit logs, staff tools, server-side code tools ও actual live health।
5. Privacy consent, export/correction/deletion request fulfilment, retention policy ও legal review।
6. Member verification, private helpdesk, staff review, private messages, audit/status notifications।
7. Referral codes/attribution, direct + Owner-network rewards, FX/country verification, funded reward processor, two-member/deep-tree tests ও actual payout।
8. Work & Earn live job execution, verified client settlement, member wage protection, Member Wallet ও real cash withdrawal।
9. Owner 20% distributable net profit ledger, actual settled revenue reconciliation ও transfer।
10. Owner monthly minimum compensation ledger, scheduled production accrual, funding verification ও actual transfer reconciliation।
11. Company Revenue Ledger, provider collection, real revenue evidence ও allocation bridge।
12. Admin Auto Work queue/worker/provider/storage/budget এবং safe deployment।
13. Member Auto Work package checkout/execution **DISABLED**; 100% liquid refund reserve, separate operating fund, isolated infrastructure ও legal/provider gates ছাড়া চালু নয়।
14. Anti-Theft native Android/iOS enrollment, authenticated device binding, trusted GPS ingestion, timestamped location, map, background execution ও real-device tests।
15. Facebook Public Discovery ও **MASTER WORLD VIP Lifetime Facebook Security & Recovery System**—শুধু official Meta-supported recovery, approved APIs, privacy, dedicated helpline/in-app inbox announcements ও compliant promotion। Facebook password/OTP/session cookie সংগ্রহ নয়; lifetime recovery/immunity guarantee নয়।
16. AI Text/Voice provider, AI Image Search licensed source, server-side secret, deployment ও usage/abuse controls।
17. SSLCommerz/payment gateway merchant setup, server-verified webhook, settled transaction, refund, chargeback ও payout acceptance।
18. bKash/Nagad/bank payout connector; UI/ledger/manual reference actual transfer নয়।
19. MW VIP FREE GLOBAL INTERNET: provider contract, regulatory approval, hardware/terminal, gateway/backhaul, funded data capacity ও real connectivity।
20. Emergency helplines, offline emergency/games, voice drafts, country news, crisis alerts, all-country directory—static checks পাস হলেও external data/service ও real-world acceptance আলাদা।
21. Android WebView/debug APK foundation; signed release, key protection, install/update/device tests, Play listing/approval এখনো আলাদা।
22. External provider integrations, security/privacy/legal review, accessibility, small-screen/device tests ও final end-to-end acceptance।

Supporting details are kept in `docs/FEATURE_COMPLETION_REGISTER_BN.md`, `docs/START_TO_FINISH_AUDIT_BN.md`, `docs/DB_SAFETY_EXECUTION_STATUS_BN.md`, feature-specific acceptance documents and policy files. These supporting docs do not override this handover's current status.

## 5. স্থায়ী security ও money rules

- Registration/referral participation free; কোনো member deposit, hidden fee বা mandatory purchase নয়।
- Referral cash release কেবল confirmed genuine platform income/sponsor/donor funding থাকলে; unfunded entitlement Pending, not withdrawable.
- Direct + Owner network reward liability 200% total; পুরো liability fund না হলে দুটোই pending।
- Owner personal funding বাধ্যতামূলক নয়; member wages বা member deposit থেকে reward নয়।
- Member wage protected; refund বা Owner profit-এর জন্য earned wage clawback/offset নয়।
- Owner profit 20% কেবল distributable net platform revenue থেকে; gross receipt, member wage, refund reserve বা unsettled money নয়।
- Owner/Admin monthly minimum target ৳১,০০০ policy/ledger foundation; funding ও real transfer ছাড়া paid নয়।
- Company Revenue, Referral Reward Fund, Member Work Wallet, Owner Profit, Owner Compensation ও Refund Reserve পৃথক ledger/obligation।
- Member Auto Work package checkout/execution disabled; 100% liquid refund reserve + separate operating budget + isolated infrastructure + legal/provider/security acceptance ছাড়া চালু নয়।
- Payment status browser redirect/screenshot/member reference দিয়ে Paid নয়; provider server-to-server verification আবশ্যক।
- Location sharing opt-in, revocable ও OS permission-based; phone number/SIM/IP দিয়ে কারও GPS reveal নয়। Offline/stale sample কখনো LIVE নয়।
- Facebook account credentials/OTP/recovery code সংগ্রহ নয়; Meta official recovery only।
- No fake income, fake ad impressions/clicks, fake signups, artificial engagement, CAPTCHA bypass বা unauthorized activity।
- Free-tier quota শেষ হলে fail-closed/pause; অনুমোদন ও spending cap ছাড়া paid fallback নয়।

## 6. No-repeat policy — বাধ্যতামূলক

1. কাজ শুরুর আগে `docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md` পড়ুন।
2. Completed register-এ থাকা কাজ/চেক source/configuration অপরিবর্তিত থাকলে পুনরায় করবেন না।
3. User-কে completed task-এর পুরোনো link/run link/commit link পুনরায় দেবেন না।
4. New code change হলে শুধু সংশ্লিষ্ট test এবং প্রয়োজনীয় dependent deployment/verification চালান।
5. Failed check-কে targeted fix ছাড়া rerun করবেন না; successful unrelated checks repeat নয়।
6. Skipped, empty status, zero-job, build-only বা deploy-only evidence কখনো PASS নয়।
7. Feature register-এ foundation/partial/blocked-কে complete/live করা যাবে না।
8. Handover update করার পর actual main HEAD আবার পড়ুন; এই documentation commit নিজেও Pages workflow trigger করতে পারে।

## 7. পরবর্তী কাজ — একমাত্র resume sequence

1. GitHub থেকে actual current `main` HEAD পড়ুন; এই ফাইলে থাকা audit baseline SHA-কে current ধরে নেবেন না।
2. ওই exact HEAD-এর সর্বশেষ Pages workflow run দেখুন। Build, Deploy ও final live Verify—তিনটি job-ই PASS কি না নিশ্চিত করুন। এই handover update-এর পর Pages workflow আবার trigger হবে।
3. Source/validator অপরিবর্তিত থাকলে static safety suite `45608178784` পুনরায় চালাবেন না।
4. Owner database password rotation ও `SUPABASE_DB_URL` correction নিশ্চিত না হওয়া পর্যন্ত DB backup workflow স্থগিত রাখুন।
5. Rotation/secret update নিশ্চিত হলে backup/restore/dry-run pipeline একবার চালান; সব gates PASS না হলে production apply নয়।
6. তারপর Owner bootstrap, দুই আলাদা test member, RLS/privacy ও feature-specific acceptance; শেষে শুধু প্রমাণিত status update করুন।

## 8. Evidence & archive rules

- Completed-only register: `docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md`.
- Previous long handover preserved as historical archive: `docs/PROJECT_HANDOVER_HISTORY_ARCHIVE_BN.md`. Archive is not authoritative; do not copy stale status from it.
- Detailed feature register: `docs/FEATURE_COMPLETION_REGISTER_BN.md`.
- Start-to-finish checklist: `docs/START_TO_FINISH_AUDIT_BN.md`.
- DB safety runbook/status: `docs/DB_SAFETY_EXECUTION_STATUS_BN.md` and `docs/SUPABASE_BACKUP_RESTORE_TEST_BN.md`.
- এই ফাইলে completed work-এর clickable links রাখা হবে না। Evidence IDs completed register-এ থাকবে; ব্যবহারকারীকে completed links পুনরায় দেওয়া হবে না।

**Project decision:** Existing MASTER WORLD VIP repository সংরক্ষিত থাকবে। Handover ও no-repeat record এখন আলাদা, completed evidence-only তালিকা আলাদা। Repository-level audit/update সম্পন্ন হওয়া মানে পুরো product complete নয়। Production migration, money movement, real providers, native device features ও final acceptance প্রমাণসহ শেষ না হওয়া পর্যন্ত project status **IN PROGRESS / NOT FULLY LIVE** থাকবে।

**Resume phrase:** “MASTER WORLD VIP — প্রথমে docs/PROJECT_HANDOVER_MASTER_BN.md এবং docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md পড়ুন; actual main HEAD ও latest Pages run যাচাই করুন; completed কাজের link পুনরায় দেবেন না; শুধু পরবর্তী অসম্পূর্ণ gate থেকে শুরু করুন।”


## 9. Session update — Admin Auto Work visibility diagnosis (2026-11-25, Bangladesh time)

### User-visible symptom and confirmed evidence
- Owner reports being automatically logged into the Owner account, but the Admin Auto Work panel is not visible.
- The Admin & Security Center reports: **Access Not configured** and the PostgREST schema-cache error: `Could not find the function public.get_my_admin_access without parameters in the schema cache`.
- Repository inspection confirms `www/index.html` already contains `section#adminAutoWorkPanel` with `hidden` enabled by default. Client code calls `client.rpc('get_my_admin_access')` and reveals the panel only after a server-verified role of `owner`, `super_admin` or `admin` is returned. Therefore an automatic login session alone does not establish the database Owner role.
- Existing RBAC migration `supabase/migrations/20261119180000_admin_rbac_owner_control.sql` defines `public.get_my_admin_access()` and Owner bootstrap logic. The bootstrap email in the migration is a placeholder/configuration value and MUST be checked against the verified Auth user in the correct Supabase project before use; do not assume it is correct.
- Admin Auto Work depends on the RBAC tables/functions. Its two migrations are `20261125100000_admin_auto_work_control_plane.sql` then `20261125130000_admin_auto_work_claim_concurrency_fix.sql`. Correct dependency order: RBAC/Owner bootstrap first, then these two migrations.

### Current status — BLOCKED, not completed/live
- This is not evidence that the user is logged into the wrong app account. The observed blocker is that the live Supabase schema cache does not expose the no-argument RBAC RPC. Possible causes include migrations not applied to the selected project or schema cache not refreshed; verify project ref and migration history before deciding.
- The panel markup/code exists in the repository, but live database role verification has not passed. Do not label the Admin Auto Work panel as live/visible in production until verified.
- Even after the panel appears, the existing overview is a read-only control-plane status view. All five modules remain disabled by default; no server worker, provider-specific connectors, customer contracts, storage connector or payout integration is verified/deployed. Do not claim automatic jobs are executing or income is being generated.

### Mandatory next sequence
1. Read this handover and the no-repeat register; inspect actual current `main` HEAD and latest relevant workflow only. Do not repeat completed PASS checks without a source/config change or expired evidence.
2. Confirm access to the correct Supabase project and verify the project's ref. Confirm the authenticated Owner identity in Supabase Auth without sharing credentials or secrets in chat.
3. **Database safety gate first:** the previously recorded backup/restore workflow failed validation because `SUPABASE_DB_URL` was not a valid PostgreSQL URI; an older attempt failed PostgreSQL password authentication. Owner must rotate the DB password if needed and securely correct GitHub Actions secrets. Never ask for or expose secret values in chat. Do not rerun backup until Owner confirms secure correction.
4. Complete encrypted backup, decrypt check, disposable PostgreSQL restore with restored table count > 0, and migration dry-run. Preserve encrypted backup and non-secret backup reference. If any gate fails, stop; no production migration.
5. Review the exact pending migration list and the target project. Verify the Owner's actual verified Auth email against the RBAC bootstrap value; change placeholder/configuration only after identity confirmation. Never bootstrap an unverified or guessed email.
6. After all backup/restore gates pass, use the guarded migration process and required authorization. Apply RBAC/Owner bootstrap first, then the two Admin Auto Work migrations in order. Production apply still requires the exact phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS` and a non-secret backup reference; never request secrets in chat.
7. If migrations succeed, refresh/reload the PostgREST schema cache if necessary, then verify `get_my_admin_access()` returns the expected Owner role. Test role isolation with separate Owner/Admin/member accounts. Then refresh the app and confirm the panel is visible to authorized roles only.
8. Keep panel status **NOT READY / CONTROL-PLANE ONLY** until reviewed server-side worker, provider connectors, contracts, storage, budgets, monitoring, security tests and settlement reconciliation are deployed and accepted. Paid APIs remain disabled without explicit Owner approval and BDT spend cap. Member Auto Work remains disabled.

### Completion classification
- **Already present in repository:** Admin Auto Work panel markup and role-gated client display logic; RBAC migration source; two Auto Work migration source files; rollout documentation.
- **Newly diagnosed, not a completed production fix:** live RPC missing from schema cache and Owner access therefore not configured.
- **Not yet completed:** live Supabase RBAC migration/Owner bootstrap, Auto Work migrations, visible-panel acceptance test, actual worker/connectors, provider approvals and live execution.
- No new completed test evidence was created in this session. Do not add this diagnosis to the completed-work register as a PASS. Keep it here and in the rollout status document as BLOCKED.

**Next exact starting point:** ask whether the Owner can access the correct Supabase Dashboard/SQL Editor; then follow the database backup/restore gate above. Do not make production DB changes until all gates and explicit authorization are satisfied.


## 10. Session pause / next highest priority — GitHub SUPABASE_DB_URL secret (2026-11-25, Bangladesh time)

### User request and exact resume point
- User paused work and explicitly requested that this task be the **first item / highest priority** when resuming.
- Exact UI state: GitHub repository `Settings → Secrets and variables → Actions → Repository secrets → SUPABASE_DB_URL → pencil/Edit → Update secret`. The user reports the edit form is open and the `Value` field is blank/ready for input. Do not ask them to repeat the prior navigation.
- User previously reported updating `SUPABASE_DB_PASSWORD` and `SUPABASE_DB_URL` yesterday. The secrets list showed `SUPABASE_DB_URL` last updated 18 hours ago and `SUPABASE_DB_PASSWORD` 4 days ago. A timestamp does not prove the stored URI is correct.
- Supabase Connect screen confirmed this project's Session Pooler structure: `postgresql://`, host `aws-0-ap-south-1.pooler.supabase.com`, port `5432`, database `postgres`, username `postgres.lztbbrzeuyjkuiyzrsxp`. Replace the password placeholder locally with the current DB password; URL-encode special characters. Never put the actual URI/password in chat or repository docs.
- Latest inspected backup workflow run #69 failed at initial URI validation with `SUPABASE_DB_URL must be a PostgreSQL URI`; no artifact was created and backup/restore/migration dry-run did not run. User has not yet confirmed saving the corrected URI.

### First action on resume
1. Resume at the already-open GitHub `Update secret` form. In `Value`, enter the complete Session Pooler URI using the current DB password (URL-encode special characters if needed), then save. Do not type “Session Pooler Connection String” as the value. Do not share the secret.
2. After user confirms save, inspect latest backup workflow history before launching anything. If a successful post-correction run exists, verify its jobs and encrypted artifact; do not duplicate it.
3. If no successful run exists, run the backup/restore/migration-preview workflow once. Require encrypted dump, decrypt, disposable restore with table count > 0, migration dry-run and encrypted artifact upload. Stop on failure; production migrations remain prohibited until all safety gates pass and explicit authorization plus non-secret backup reference are provided.

### Income / automatic work — honest current status
- Project remains **IN PROGRESS / NOT FULLY LIVE**. Admin Auto Work remains **NOT READY / CONTROL-PLANE ONLY**; live Owner RBAC RPC/migrations are not verified/applied, and worker/provider/storage/budget/settlement integrations are not deployed and accepted.
- There is currently no verified live job execution, confirmed revenue stream, or payout path. The platform cannot currently be represented as generating or paying income. No income amount, date, or job availability can be promised. Do not rely on expected platform income for living expenses or stop other work based on it.
- Income readiness requires production DB safety, Owner/RBAC setup, actual worker and approved providers, real customer-funded work, wage protection, server-verified settlement, and real withdrawal acceptance. Never fabricate earnings or simulate payouts.

**Current exact resume point:** GitHub `SUPABASE_DB_URL` secret edit form, `Value` field; first priority when the user returns.


## 11. সর্বোচ্চ অগ্রাধিকারপ্রাপ্ত ফিচার — MASTER WORLD VIP 24/7 Automatic Work & Earning System

### Owner-এর সিদ্ধান্ত
- Owner এই ফিচারটিকে MASTER WORLD VIP-এর অন্যতম সেরা এবং সর্বোচ্চ অগ্রাধিকারপ্রাপ্ত feature হিসেবে স্বীকৃতি দিয়েছেন।
- লক্ষ্য: সদস্যকে সারাক্ষণ অনলাইনে থাকতে হবে না; নিরাপদ server-side automation ২৪ ঘণ্টা eligible, অনুমোদিত ও যাচাইকৃত কাজের queue পর্যবেক্ষণ/সম্পাদন করবে। সদস্য offline বা ঘুমিয়ে থাকলেও কাজ সম্পন্ন হতে পারে।
- আয় কেবল বাস্তব client/provider কাজের deliverable গ্রহণ এবং সংশ্লিষ্ট অর্থ server-to-server যাচাই করে settle হওয়ার পর হিসাব হবে। Queue item, AI output, API call, job success বা free quota নিজে আয় নয়।
- এটি একটি product goal/approved design direction; production deployment বা earnings-এর দাবি নয়।

### এই session-এ পুনরায় যাচাই করা repository foundation (main HEAD `132fef12c3a425e5dfbfc82c13b6f9cebedc1b85`)
1. `www/index.html`-এ বিদ্যমান Admin & Security Center-এর ভিতরে `#adminAutoWorkPanel` আছে। এটি শুরুতে hidden এবং server-verified Owner/Super Admin/Admin role ছাড়া দেখানো হয়। Panel শুধু read-only overview; Start/Run action নয়।
2. `supabase/migrations/20261125100000_admin_auto_work_control_plane.sql`-এ পাঁচটি module, provider registry, job queue, audit table, RLS, Admin RPC, worker claim/finish RPC এবং default-disabled module setup আছে।
3. একই migration-এ `admin_auto_work_one_running_per_module_idx` নামে partial unique index আছে; এটি একই module-এ একাধিক running job ঠেকানোর database-level guard। অতএব এই নির্দিষ্ট index আবার যোগ/একই কাজের migration তৈরি করবেন না।
4. `supabase/migrations/20261125130000_admin_auto_work_claim_concurrency_fix.sql` worker claim query-তে চলমান job পরীক্ষা যোগ করে; এটি বিদ্যমান partial unique index-এর অতিরিক্ত hardening।
5. `docs/ADMIN_AUTO_WORK_EARN_IMPLEMENTATION_BN.md`, `docs/ADMIN_AUTO_WORK_FREE_STORAGE_BN.md`, `docs/ADMIN_AUTO_WORK_ROLLOUT_STATUS_BN.md`, `docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md`-এ architecture, free-tier policy, storage, member isolation ও launch gates নথিভুক্ত।
6. Supabase README এবং guarded migration workflow-এ Auto Work migrations তালিকাভুক্ত আছে।

### Current status — PARTIAL FOUNDATION / NOT LIVE
- এই audit-এ কোনো নতুন production DB migration apply, worker deployment, provider connection, customer contract, file storage setup, real job execution, customer settlement বা payout test করা হয়নি।
- পূর্বের confirmed blocker বহাল: live DB-তে Owner RBAC RPC/schema-cache access configured নয়; DB backup/restore pipeline-এর secret correction ও successful restore এখনও prerequisite। Migration source file থাকা মানে production DB-তে apply হওয়া নয়।
- কোনো server-side worker/scheduler deployed নয়। Browser/PWA বা সদস্যের ফোনকে 24/7 execution host হিসেবে ধরা যাবে না।
- কোনো provider adapter/API, approved client contract, private object-storage bucket, independent backup destination, server-side provider secrets, live customer-funded work source বা real bKash/Nagad/bank payout integration verified নয়।
- পাঁচটি module disabled by default; `admin_auto_work_overview()` ইচ্ছাকৃতভাবে `execution_ready=false` ফেরত দেয়।
- Member Auto Work execution/package checkout DISABLED; shared Admin/Owner capacity, credentials, queue বা quota ব্যবহার করা যাবে না। Human-reviewed Work & Earn আলাদা feature।
- Free-tier quota শেষ হলে fail-closed/pause/queue; paid service-এ silent fallback নয়। Free plan 24/7 uptime বা নির্দিষ্ট দৈনিক কাজ/আয় নিশ্চিত করে না।

### Implementation plan — এই feature-এর জন্য পরবর্তী ক্রম
1. **Safety prerequisite:** বর্তমান DB safety sequence সম্পন্ন করুন—Owner-এর secure `SUPABASE_DB_URL` correction confirmation, encrypted backup, decrypt, disposable restore (table count > 0), migration dry-run। কোনো secret chat-এ নয়। এই gate পাস না হলে production migration নয়।
2. Correct Supabase project ref, verified Owner Auth identity এবং migration history নিশ্চিত করুন। RBAC/Owner bootstrap, তারপর Auto Work migrations dependency order-এ review করুন। Production apply-এর আগে exact required authorization phrase এবং non-secret backup reference বাধ্যতামূলক।
3. Staging-এ server-side worker design/implementation: durable queue poller, worker heartbeat, per-module concurrency, lease timeout/reclaim, idempotency, bounded retry/backoff, cancellation, provider timeout, sanitized error log, quota/cost enforcement, global emergency stop এবং module-level pause/resume।
4. Five module-এর প্রত্যেকটির জন্য আলাদা approved provider/client adapter, documented API/terms, Bangladesh eligibility, contract/permission reference, server-side secret, acceptance criteria এবং customer-funded rate যাচাই করুন। Provider না থাকলে ওই module disabled থাকবে।
5. Private object storage + signed short-lived access, MIME/size/quota/checksum/retention controls এবং independent encrypted backup/restore test ছাড়া customer file processing চালু নয়।
6. Settlement pipeline: client acceptance → provider/server-to-server payment verification → fees/tax/refund/chargeback handling → protected payable ledger → actual payout reconciliation। Job succeeded মানেই member/admin earning settled নয়।
7. Staging acceptance tests: একই module-এ concurrent duplicate claim আটকানো; পাঁচ module-এ সর্বোচ্চ পাঁচ running job; retry/idempotency; worker restart/lease expiry; provider outage; quota exhaustion; budget cap; global stop; unauthorized access; private file cross-user denial; duplicate webhook/refund/chargeback; settled-only ledger. Evidence PASS না হলে production নয়।
8. সব gates PASS, legal/privacy/provider review এবং Owner approval-এর পর সীমিত canary; পর্যবেক্ষণ শেষে ধাপে ধাপে চালু। কোনো দৈনিক আয় বা 24/7 uptime guarantee নয়।

### Exact resume point for this feature
- সর্বোচ্চ অগ্রাধিকার feature: **MASTER WORLD VIP – 24/7 Automatic Work & Earning System**।
- Database backup/restore + Owner/RBAC production safety gate হলো এই feature-এর deployment prerequisite; এটি পাস না হওয়া পর্যন্ত worker/production migration চালু নয়।
- প্রথমে আগের section 10-এ বর্ণিত GitHub `SUPABASE_DB_URL` secret edit/save confirmation থেকে resume করতে হবে; user save নিশ্চিত করলে workflow history আগে inspect করুন, successful run থাকলে পুনরাবৃত্তি নয়।
- এরপর এই section 11-এর ক্রমে staging worker/provider implementation করুন। Existing UI, migrations, unique index, docs এবং completed static checks পুনরায় বানাবেন/চালাবেন না; শুধু source/config change হলে affected tests।
- পরবর্তী Section 12-এ এই feature-এর জন্য নতুন ১৪টি static safety check-এর verified PASS evidence যোগ করা হয়েছে; no-repeat register-এর Section 2.5-এ তার run ID ও tested commit নথিভুক্ত। ওই একই ১৪টি check source/config অপরিবর্তিত থাকলে পুনরায় চালাবেন না.


## 12. নতুন Auto Work static safety check — verified PASS (2026-11-25)

### Added
- `scripts/verify-admin-auto-work.py`: dedicated 14-check static validator for Auto Work security/readiness invariants.
- `.github/workflows/verify-auto-work-safety.yml`: isolated GitHub Actions workflow; it runs only when Auto Work source/config/docs change or manually dispatched. It does not require production secrets and does not touch Supabase production.
- First test attempt failed because the new validator's provider-approval text matcher did not account for SQL parentheses. This was a validator-only false negative; the SQL migration was not changed. The matcher was corrected and the check rerun successfully.
- Latest verified Auto Work static run: `45641251920`, tested source commit `779ebcc1dec6b5bb763a6d6cb81b4abb57a84c1b`; job `auto-work-static-safety` SUCCESS, all 14 checks PASS.
- Evidence is recorded in `docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md`. Do not rerun this static suite unless one of its tested source/config files changes or evidence expires.

### What this PASS proves — and what it does not
- It proves only that the repository currently contains the expected static safety patterns: five disabled-by-default modules, provider contract/Owner approval checks, RLS/browser table denial, service-role-only worker RPCs, per-module unique running-job index, claim concurrency guard, budget/idempotency gates, fail-closed overview, role-gated read-only UI, migration inventory and member automation disabled.
- It does **not** prove production DB migration, Owner/RBAC live access, deployed scheduler/worker, provider API, private storage, 24/7 uptime, client work, settled revenue or payout. Feature remains **PARTIAL FOUNDATION / NOT LIVE**.

### Current next action
- Continue from section 10's already-open `SUPABASE_DB_URL` secret correction; wait for Owner confirmation that it was saved. Inspect backup workflow history before running it. Do not request or display secret values.
- After DB safety/Owner gates, implement and test the real server-side worker and one approved provider in staging. Keep all modules disabled and no paid fallback until gates pass.


## 13. Latest audit, completed-work index and realistic delivery estimate (2026-11-25)

### Latest repository state
- Latest main HEAD before this handover update: `2821cedea6c6c121ca37f86899b2d93820fc1361`.
- Authoritative completed-work evidence is in `docs/COMPLETED_WORK_NO_REPEAT_REGISTER_BN.md`; use Sections 2.1–2.5 for existing verified release/static/code checks. Do not duplicate those entries or repeat their workflows without a relevant source/config change.
- Auto Work-specific verified completion: Section 12 above and no-repeat register Section 2.5; isolated workflow run `45641251920`, tested commit `779ebcc1dec6b5bb763a6d6cb81b4abb57a84c1b`, all 14 static checks PASS.
- Pages workflow run `45641382050` was pending at last inspection after documentation-only updates. Do not record it as deployed or complete. The latest successful Pages publication known before those documentation-only commits was run `45640956922` on commit `82fbe343d52beb5725ffab9d79470d47c9561ff7`.

### Completed for 24/7 Auto Work (repository/source scope only)
- Owner-approved product goal and priority recorded.
- Existing Admin Auto Work read-only control-plane UI and role-gated visibility logic inspected.
- Five module definitions, provider registry, queue/audit schema, RLS and service-role-only worker RPC source inspected.
- Default-disabled modules and fail-closed `execution_ready=false` behavior inspected.
- Existing per-module one-running-job unique index and additional claim concurrency guard inspected; do not recreate them.
- Dedicated 14-check static safety validator and isolated GitHub Actions workflow added; latest run passed all 14.
- Handover and no-repeat register updated to preserve exact evidence and avoid repeated work.

### Still not complete / blocking real 24/7 earning
- User confirmation that GitHub Actions `SUPABASE_DB_URL` secret has been securely corrected and saved.
- Encrypted backup, decrypt, disposable restore with nonzero table count and migration dry-run.
- Verified Owner Auth identity/RBAC bootstrap and production migrations (with explicit authorization).
- Deployed server-side scheduler/worker with heartbeat, lease/reclaim, retry/idempotency, stop controls and monitoring.
- At least one approved, available provider/client with contract, permission, Bangladesh eligibility and customer-funded real work.
- Private storage, quota/cost caps, privacy/security review.
- Server-to-server customer settlement, refund/chargeback handling, protected member payable ledger and successful real payout reconciliation.
- Staging acceptance tests and controlled production canary. Until then all modules stay disabled; no passive/daily income promise.

### Time estimate — planning only, not a delivery promise
- A reliable calendar completion date cannot yet be calculated because the database safety gate, Owner authorization, provider/client contract, real job supply and payout path are external blockers not under repository coding control.
- After the DB backup/restore gate passes, a first staging worker for one approved module may take roughly 1–3 weeks of focused engineering and testing, assuming provider documentation/access and test data are ready. This is a planning range only, not a guarantee.
- Production-ready multi-module 24/7 operation may take longer (several additional weeks or more) depending on provider approvals, customer-funded demand, security/legal review, storage, settlement and payout acceptance. If no real provider/client contract exists, launch timing remains unknown and income remains zero/unverified.
- Do not promise any daily income or ask the Owner to stop other work. Keep free-tier-only and fail-closed behavior; no paid fallback without explicit approval and a spend cap.

### Exact next step — unchanged
- Wait for Owner to confirm the already-open GitHub `SUPABASE_DB_URL` secret edit was saved. Do not ask for the secret itself.
- After confirmation, inspect backup workflow history first. Reuse a successful post-correction run if it already exists; otherwise execute the gated backup/restore preview once and stop on any failure.
- Continue only after that gate passes. The 14 Auto Work static checks are already complete and must not be repeated without source/config changes.
