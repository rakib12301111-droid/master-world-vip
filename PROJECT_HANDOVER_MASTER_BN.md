🧷 **পিন করা সর্বোচ্চ অগ্রাধিকার নির্দেশ — MASTER WORLD VIP**

প্রকল্প-মালিকের স্থায়ী অনুমতি অনুযায়ী, সহকারী MASTER WORLD VIP-এর **ছোট ও বড়—দুই ধরনের গুরুত্বপূর্ণ কাজই** নিজ দায়িত্বে এগিয়ে নেবে। এর মধ্যে রয়েছে: পূর্ণাঙ্গ codebase ও architecture audit; বড় feature/module পরিকল্পনা ও বাস্তবায়ন; প্রয়োজনীয় refactor ও system redesign; database schema/migration source উন্নয়ন; security hardening; performance, reliability ও scalability উন্নয়ন; API/backend/frontend integration; automation ও CI/CD উন্নয়ন; বড় bug/technical debt সমাধান; backup/restore ও disaster-recovery পরিকল্পনা; comprehensive automated/integration/disposable tests; read-only production audit; documentation, release প্রস্তুতি এবং প্রয়োজনীয় GitHub commit ও handover update। কাজকে শুধু ছোটখাটো maintenance-এ সীমাবদ্ধ রাখা যাবে না। প্রতিটি বড় কাজকে নিরাপদ ধাপে ভাগ করে design, implementation, test, review ও ফলাফল যাচাইসহ শেষ পর্যন্ত এগিয়ে নিতে হবে; একই scope-এর routine বা বড় engineering কাজের প্রতিটি ধাপে বারবার অনুমতি চাইবে না। বাস্তব Run/log বা উপযুক্ত test evidence ছাড়া সফল দাবি করবে না। **তবে Production migration apply, live data delete/overwrite, migration-history repair, destructive SQL, billing/payment execution, irreversible account/service change বা external public release/deployment—যে কাজ সরাসরি live user/data/service-এ প্রভাব ফেলতে পারে—সেগুলোর জন্য পৃথক স্পষ্ট অনুমোদন ও বিদ্যমান safety gate বাধ্যতামূলক।** কোনো secret/password/token/OTP/passphrase চাইবে বা handover-এ লিখবে না। **Production-impacting কাজের জন্য প্রয়োজনীয় পৃথক অনুমোদন পাওয়া গেলে, অনুমোদিত সীমার মধ্যে সংশ্লিষ্ট code, SQL migration source, GitHub Actions workflow, configuration ও documentation-এর প্রয়োজনীয় সংশোধন/আপডেট সহকারী নিজেই করবে; ব্যবহারকারীকে হাতে কোড বসানো বা ফাইল সম্পাদনা করতে বলা হবে না। এরপর নিরাপদ preflight, backup/restore readiness, অনুমোদিত execution gate, বাস্তব run/log যাচাই এবং handover update সহ পুরো কাজটি নিজ দায়িত্বে সম্পন্ন করবে। অনুমোদন না পাওয়া পর্যন্ত শুধু read-only analysis, প্রস্তুতি ও non-production validation করা যাবে—কোনো live write/apply/deploy নয়।**

---

# MASTER WORLD VIP — PROJECT HANDOVER
**ফাইল:** `PROJECT_HANDOVER_MASTER_BN.md`  
**সর্বশেষ যাচাই:** ২৬ নভেম্বর ২০২৬  
**Repository:** `rakib12301111-droid/master-world-vip`  
**Default branch:** `main`  
**Supabase Project Ref:** `lztbbrzeuyjkuiyzrsxp`

---

## 1. মালিকানা, স্বীকৃতি ও কাজের রেকর্ড

এই প্রকল্পের পরিকল্পনা, অগ্রাধিকার নির্ধারণ, সমস্যা চিহ্নিত করা, পরীক্ষা চালানোর অনুমতি ও কাজের ধারাবাহিকতা বজায় রাখার ক্ষেত্রে প্রকল্প-মালিক/ব্যবহারকারীর অবদানকে এই নথিতে আনুষ্ঠানিকভাবে স্বীকৃতি দেওয়া হলো।

**প্রকল্প-মালিকের স্বীকৃতি:** MASTER WORLD VIP-এর কাজের ইতিহাস, সিদ্ধান্ত, সম্পন্ন পরীক্ষা, বাকি ঝুঁকি এবং পরবর্তী পদক্ষেপ এই নথিতে ধরে রাখতে হবে। ভবিষ্যৎ সহকারী/ডেভেলপারকে এই নথি ও বর্তমান repository অবস্থা আগে পড়ে নিতে হবে। নথিতে ইতিমধ্যে সম্পন্ন বলে চিহ্নিত কাজ অকারণে আবার করানো যাবে না। কোনো কাজ পুনরায় চালানোর প্রয়োজন হলে আগে কারণ, ঝুঁকি ও প্রত্যাশিত ফল ব্যাখ্যা করতে হবে।

এই স্বীকৃতি প্রকল্পে দেওয়া অবদানের নথি; এটি কোনো আর্থিক পারিশ্রমিক প্রদান বা আইনি মালিকানার স্বতন্ত্র প্রমাণ নয়।

## 2. কাজের সময় বাধ্যতামূলক নিয়ম

1. প্রথমে এই handover ফাইল এবং সংশ্লিষ্ট বর্তমান workflow/migration পড়ুন।
2. GitHub Actions-এর সর্বশেষ Run, job, step ও log যাচাই না করে কোনো কাজ সফল বলবেন না।
3. ব্যবহারকারীকে একই সফল কাজ অকারণে আবার করতে বলবেন না।
4. Password, database URL, access token, encryption passphrase, OTP বা অন্য secret কখনো চ্যাটে চাইবেন/লিখবেন/লগে প্রকাশ করবেন না।
5. Backup/Restore/Preview workflow সফল হওয়া মানে Production migration প্রয়োগ হয়েছে—এমন নয়।
6. Production migration কখনো স্বয়ংক্রিয়ভাবে চালাবেন না। স্পষ্ট, পৃথক অনুমোদন এবং নিরাপদ backup/restore যাচাই প্রয়োজন।
7. অপ্রয়োজনীয় workflow step বা migration-history পরিবর্তন যোগ করবেন না। প্রতিটি পরিবর্তনের আগে সম্ভাব্য প্রভাব পরীক্ষা করুন।
8. কাজ শেষে commit, run link, বাস্তব ফলাফল, অবশিষ্ট ঝুঁকি ও পরবর্তী একটিমাত্র প্রয়োজনীয় পদক্ষেপ এখানে আপডেট করুন।

## 3. ২৬ নভেম্বর ২০২৬-এ সরাসরি যাচাইকৃত সম্পন্ন কাজ

### GitHub Actions Run #85
- Run ID: `45810029561`
- Job ID: `139875149691`
- Commit: `3fcbb3de769c8403b57e1c1bbf2d8454fb5a1b95`
- Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45810029561
- Job: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45810029561/job/139875149691
- Job conclusion: `success`
- যাচাইকৃত সব job step-এর conclusion: `success`

### Run #85-এ সফল ধাপ
- Required GitHub Actions secrets উপস্থিত আছে কি না যাচাই।
- Supabase Session Pooler URI গঠন যাচাই; secret values log-এ mask করা হয়েছে।
- PostgreSQL client ইনস্টল।
- Encrypted logical database backup তৈরি।
- Encrypted backup decrypt করে disposable PostgreSQL database-এ restore test।
- Remote migration history inspect।
- ওই Run-এ remote-only migration version `20261121081842` এবং `20261121082217`-কে `reverted` হিসেবে migration history-তে চিহ্নিত করা হয়েছিল। এটি history metadata পরিবর্তন; schema change নয়।
- Supabase migration preview / dry-run সফল।
- Encrypted backup artifact আপলোড।
- Non-secret backup ও restore reference log-এ রেকর্ড।

### Backup artifact
- Artifact name: `master-world-vip-encrypted-backup-45810029561`
- Artifact ID: `15111217500`
- Artifact retention: ৭ দিন; তৈরি: ২৬ নভেম্বর ২০২৬।
- Backup reference: `mwvip-logical-45810029561-1`
- Restore test reference: `github-actions-run-45810029561`
- Artifact: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45810029561/artifacts/15111217500

**গুরুত্বপূর্ণ:** artifact-এর মেয়াদ শেষ হওয়ার আগে প্রয়োজন হলে নিরাপদ স্থানে সংরক্ষণ করতে হবে। Encryption passphrase ছাড়া encrypted backup restore করা যাবে না। Passphrase এই ফাইলে লেখা যাবে না।

## 4. গুরুত্বপূর্ণ সতর্কতা — Preview সফল, কিন্তু Production migration এখনো প্রয়োগ হয়নি

Run #85-এর log-এ স্পষ্ট লেখা আছে:

`DRY RUN: migrations will *not* be pushed to the database.`

এরপর Supabase CLI `Would push these migrations:` দেখিয়ে নিচের **৩০টি local migration**-কে pending হিসেবে তালিকাভুক্ত করেছে। অর্থাৎ Preview command সফলভাবে শেষ হয়েছে, কিন্তু database-এ এই migration-গুলো প্রয়োগ করা হয়নি। Run সবুজ হওয়াকে database schema সম্পূর্ণ আপডেট হওয়ার প্রমাণ হিসেবে ধরা যাবে না।

### Run #85-এ pending হিসেবে দেখানো ৩০টি migration
1. `202611180001_master_world_vip.sql`
2. `202611190001_global_community.sql`
3. `202611190002_privacy_rights.sql`
4. `20261119180000_admin_rbac_owner_control.sql`
5. `20261119190000_member_broadcast.sql`
6. `20261119200000_update_releases.sql`
7. `20261120100000_inbox_push_foundation.sql`
8. `20261120150000_membership_helper_hardening.sql`
9. `20261121100000_profiles_discovery_privacy_hardening.sql`
10. `20261121120000_facebook_setup_orders.sql`
11. `20261121130000_facebook_setup_feedback.sql`
12. `20261121140000_verified_payment_state.sql`
13. `20261121150000_sslcommerz_checkout_enable.sql`
14. `20261121160000_trusted_devices_login_history.sql`
15. `20261121170000_group_rls_recursion_fix.sql`
16. `20261121180000_member_verification_helpdesk.sql`
17. `20261121190000_member_live_location.sql`
18. `20261122100000_messaging_realtime.sql`
19. `20261123100000_work_earn_job_board.sql`
20. `202611240001_member_referrals.sql`
21. `202611240002_public_member_referral_profile.sql`
22. `202611240003_referral_wallet_rewards.sql`
23. `202611240004_owner_monthly_compensation.sql`
24. `202611240005_international_referral_usd_equivalent.sql`
25. `202611240006_network_admin_referral_rewards.sql`
26. `202611240007_referral_payout_reference_hardening.sql`
27. `20261125100000_admin_auto_work_control_plane.sql`
28. `20261125120000_anti_theft_device_recovery.sql`
29. `20261125130000_admin_auto_work_claim_concurrency_fix.sql`
30. `20261125160000_work_earn_wallet_owner_profit.sql`


### পরবর্তী নিরাপদ কাজ
- আগে Supabase remote schema এবং migration history-এর প্রকৃত অবস্থা যাচাই করতে হবে।
- প্রতিটি pending migration-এর SQL ও dependency পর্যালোচনা করতে হবে।
- কোনো migration আগে dashboard/SQL editor দিয়ে প্রয়োগ হয়ে থাকলে তার প্রমাণ নিয়ে history reconcile করতে হবে; অন্ধভাবে সব migration apply বা mark-as-applied করা যাবে না।
- Production apply কেবল ব্যবহারকারীর আলাদা, স্পষ্ট অনুমোদন এবং বর্তমান recoverable backup + সফল restore test নিশ্চিত করার পর বিবেচনা করা যাবে।
- Production apply-এর অনুমোদন বাক্য: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`। এটি এই handover ফাইলে অনুমোদন হিসেবে গণ্য হবে না; ভবিষ্যৎ apply-এর আগে আলাদা করে নিশ্চিত করতে হবে।

## 5. Workflow ফাইলসমূহ পর্যালোচনা

### `.github/workflows/backup-restore-preview.yml`
- Push/ম্যানুয়াল trigger আছে।
- Encrypted full logical backup এবং isolated restore test চালায়।
- Remote migration history inspect করে।
- বর্তমান সংশোধনের পর remote migration history শুধু inspect করে; স্বয়ংক্রিয় `migration repair` আর চালায় না।
- `supabase db push --dry-run --remote` দিয়ে preview চালায়।
- এই workflow Production migration push করে না।

### `.github/workflows/secure-supabase-db-update.yml`
- Project ref ও required secrets যাচাই করে।
- Migration files উপস্থিতি যাচাই করে।
- Dry-run preview চালায়।
- Production apply-এর আগে backup, restore test, non-secret reference এবং exact confirmation gate রাখে।
- Apply step কেবল explicit input gate পাস হলে চালু হয়।

### `.github/workflows/apply-supabase-migrations.yml`
- Default হলো preview-only (`apply_migrations: no`)।
- Production apply-এর আগে backup/restore confirmation, backup reference এবং exact approval phrase প্রয়োজন।
- Apply হলে schema snapshot artifact তৈরির ধাপ আছে।

### `.github/workflows/test-two-member-rls.yml`
- দুইটি পৃথক test member UUID এবং Session Pooler URI যাচাই করে।
- `supabase/audits/two-member-rls-integration-test.sql` চালায়।
- এই workflow-এর সর্বশেষ run এই পর্যালোচনায় চালানো/যাচাই করা হয়নি।

## 6. সরাসরি দেখা migration SQL-এর পর্যালোচনা

### `20261121100000_profiles_discovery_privacy_hardening.sql`
- Discoverable profile-এর জন্য public-facing নির্দিষ্ট field-সহ `search_discoverable_profiles` RPC তৈরি করে।
- Function-এ `security definer`, fixed empty `search_path`, authentication check, result limit এবং explicit execute grants আছে।
- Discoverable profile policy সরিয়ে direct full-row exposure কমানোর উদ্দেশ্য স্পষ্ট।

### `20261121170000_group_rls_recursion_fix.sql`
- `community_groups` ও `group_members`-এর recursive RLS সমস্যা এড়াতে `can_read_group_roster` helper function যোগ করে।
- Function-এ `security definer` এবং fixed empty `search_path` আছে।
- সংশ্লিষ্ট SELECT policies পুনর্গঠন করে।

**পর্যালোচনার সীমা:** এই দুটি SQL migration-এর source-level পাঠ করা হয়েছে। ২৬ নভেম্বরের Disposable Database Validation-এ সব ৩০টি migration ধারাবাহিকভাবে apply হয়েছে; এটি SQL execution/dependency validation, production permission/behavior integration test নয়।

## 7. Secrets ও নিরাপত্তা

GitHub Actions-এ ব্যবহৃত secret নাম:
- `SUPABASE_DB_URL`
- `BACKUP_ENCRYPTION_PASSPHRASE`
- অন্যান্য workflow-এ `SUPABASE_ACCESS_TOKEN`, RLS test member identifiers ইত্যাদি থাকতে পারে।

এই নথিতে কোনো secret value, password, token বা encryption passphrase রাখা যাবে না। Secret পরিবর্তন কেবল বাস্তব প্রয়োজন ও যাচাই করা কারণ থাকলে করতে হবে। সফল Run #85-এর পরে অকারণে secret rotate বা workflow edit করা উচিত নয়।

## 8. পরবর্তী কাজের অগ্রাধিকার

1. **সর্বোচ্চ অগ্রাধিকার:** Production schema-র সম্পূর্ণ column/constraint/index/policy/function diff সংগ্রহ করে ৩০টি migration-এর প্রত্যাশিত schema-র সঙ্গে তুলনা করা।
2. Existing `profiles` ও `update_releases`-এর মতো overlapping objects-এর compatibility ও data-preservation যাচাই।
3. Production backup/restore reference-এর মেয়াদ ও recoverability যাচাই করে apply পরিকল্পনা তৈরি করা।
4. আলাদা exact approval phrase ছাড়া Production-এ কোনো schema change বা migration-history repair নয়।
5. Two-member RLS integration test-এর ফলাফল যাচাই/প্রয়োজনে সংশোধন।
6. ভবিষ্যৎ কাজ শেষে এই handover ফাইলের তারিখ, commit, run, সম্পন্ন কাজ ও বাকি কাজ update করা।


## 9. ২৬ নভেম্বর ২০২৬ — Read-only Audit ও নিরাপত্তা সংশোধন

### Read-only Database Audit
- Workflow: `.github/workflows/read-only-db-audit.yml`
- প্রথম Run `45812058134` failed হয়েছিল audit step-এর local socket connection bug-এর কারণে; এটি Production পরিবর্তন করেনি।
- সংশোধিত Run ID: `45812490786`
- Run result: `success`
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45812490786
- Artifact ID: `15112873683`
- Artifact: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45812490786/artifacts/15112873683
- Artifact retention: ১৪ দিন; created ২৬ নভেম্বর ২০২৬।
- Expanded schema audit Run ID: `45815222768` (`success`); Artifact ID: `15113519955` (১৪ দিন retention)। এটি columns, constraints, indexes ও table grants-ও সংগ্রহ করে।
- Expanded audit Artifact: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45815222768/artifacts/15113519955
- Audit query-গুলো SELECT/read-only ছিল; কোনো DDL, data mutation, `db push` বা `migration repair` হয়নি।

### Production Database-এ Audit-এর ফল
- `supabase_migrations.schema_migrations`: ০টি row।
- CLI migration history-তে ৩০টি local migration-এর Remote column ফাঁকা; সব ৩০টি local pending।
- Public schema-তে ৪টি project table পাওয়া গেছে: `profiles`, `update_events`, `update_modules`, `update_releases`।
- Public schema-তে ৫টি RLS policy এবং ৩টি project custom function পাওয়া গেছে।
- `profiles`-এ `authenticated` role-এর `TRUNCATE`, `REFERENCES`, `TRIGGER` privileges ছিল; RLS `TRUNCATE` আটকায় না।
- Public schema-তে `update_releases` আছে, কিন্তু migration history-তে তার version recorded নয় এবং policy name-ও migration file-এর policy name থেকে আলাদা। তাই object name এক হওয়া মানেই migration সম্পূর্ণ apply হয়েছে—এমন সিদ্ধান্ত নেওয়া যাবে না।
- Database-এ `profiles` ও `update_releases`-এর মতো কিছু overlapping object আছে; কিন্তু বাকি ৩০টি migration-এর প্রত্যাশিত table/function/policy inventory দেখা যায়নি।
- **সিদ্ধান্ত:** Migration History অনুযায়ী ৩০টির কোনোটিই applied হিসেবে recorded নয়। কিছু object আগে manual/custom SQL দিয়ে তৈরি হয়ে থাকতে পারে; exact column/constraint/index comparison ছাড়া সেগুলোকে applied mark করা যাবে না।

### Backup workflow নিরাপত্তা সংশোধন
- ফাইল: `.github/workflows/backup-restore-preview.yml`
- Commit: `7f574b4e92fa45a7522fdc7dab0a26415e9e4e3e`
- CLI migration list-এর পুরোনো `--db-url` flag `--remote` দিয়ে প্রতিস্থাপিত হয়েছে; commit: `fd889c80dae0404609b89606b419c73c4040868a`
- সর্বশেষ সফল backup/restore/preview Run ID: `45815854654`; backup artifact ID: `15115762062`; backup reference: `mwvip-logical-45815854654-1`; restore test reference: `github-actions-run-45815854654`; Preview `success`, Production-এ ৩০টি migration এখনো pending।
- স্বয়ংক্রিয় `migration repair --status reverted` ধাপ সরানো হয়েছে।
- এখন migration history inspection read-only।
- উদ্দেশ্য: Backup/Preview চালানোর সময় অজান্তে remote migration metadata পরিবর্তন ঠেকানো।

## 10. ২৬ নভেম্বর ২০২৬ — Disposable Migration Validation ও SQL Fixes

### Validation workflow
- ফাইল: `.github/workflows/validate-migrations-disposable.yml`
- সফল Run ID: `45814105586`
- Job ID: `139889243549`
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45814105586
- Result: `success`
- সব ৩০টি migration সঠিক ক্রমে disposable Supabase PostgreSQL 17 database-এ apply হয়েছে।
- পরবর্তী উন্নত Run ID: `45815885852` (`success`), Job ID: `139895690812`। এটি fresh schema এবং production audit-এ দেখা legacy schema shape—দুইটিতেই ৩০টি migration apply করেছে।
- Legacy fixture-এ UUID `update_releases.id`, `manifest_url`, nullable `profiles.display_name`, পুরোনো RLS policy এবং পুরোনো index shape অনুকরণ করা হয়েছিল।
- সফল assertions: UUID ID ও `manifest_url` অক্ষত; `update_releases_semver_check` legacy rows validate না করে `NOT VALID` হিসেবে যোগ; `profiles.display_name` default `''`; পুরোনো duplicate policy সরানো; anon/authenticated-এর কোনো public table-এ TRUNCATE/REFERENCES/TRIGGER privilege অবশিষ্ট নেই।
- Log evidence: `DISPOSABLE_MIGRATION_VALIDATION=success`, `MIGRATIONS_APPLIED_TO_FRESH_TEST_DATABASE=30`, `MIGRATIONS_APPLIED_TO_LEGACY_SCHEMA_TEST_DATABASE=30`, `PRODUCTION_DATABASE_CHANGED=false`।
- এটি SQL syntax/dependency/sequence ও legacy-schema compatibility test; production migration apply বা production data validation নয়।

### Disposable test-এ ধরা ও সংশোধিত SQL সমস্যা
1. `202611190001_global_community.sql`: `is_conversation_member` ও `is_group_member` helper-এর malformed dollar quoting ঠিক করা হয়েছে; পরে single-argument helper-এর সঙ্গে overload ambiguity এড়াতে default target-user arguments সরানো হয়েছে।
2. `20261120150000_membership_helper_hardening.sql`: caller-scoped helper তৈরি করার আগে legacy RLS policies এবং two-argument helper overload drop করা হয়েছে; এতে PostgreSQL function ambiguity বন্ধ হয়েছে।
3. `202611240004_owner_monthly_compensation.sql`: `service_accrue_owner_compensation_months()`-এর malformed dollar-quote delimiter ঠিক করা হয়েছে।
4. `20261125160000_work_earn_wallet_owner_profit.sql`: PL/pgSQL `RAISE EXCEPTION` string-এর `100%`-এ percent placeholder conflict ঠিক করতে `100%%` করা হয়েছে।

**গুরুত্বপূর্ণ:** এই সংশোধনগুলো GitHub migration source-এ commit হয়েছে এবং disposable test-এ সব ৩০টি migration সফল হয়েছে। Production Database-এ কোনো migration apply হয়নি; remote migration history-ও repair করা হয়নি।

### Production schema compatibility ও privilege hardening
- `202611180001_master_world_vip.sql`: existing `profiles.display_name` nullable রাখে, default `''` যোগ করে; existing profile rows rewrite/force-NOT-NULL করে না।
- `20261119200000_update_releases.sql`: existing UUID primary key এবং `manifest_url` কলাম অক্ষত রাখে; release_notes default যোগ করে; legacy version rows validate না করে semver CHECK `NOT VALID` হিসেবে যোগ করে; পুরোনো `Read published releases` policy বদলে একটিমাত্র নির্দিষ্ট policy রাখে।
- `20261125160000_work_earn_wallet_owner_profit.sql`: সব public table-এ anon/authenticated-এর `TRUNCATE`, `REFERENCES`, `TRIGGER` privileges revoke করে এবং current migration role-এর future public table default privileges-ও harden করে।
- এই privilege hardening Production-এ এখনো কার্যকর হয়নি; ৩০টি migration apply না হওয়া পর্যন্ত audited `profiles` table-এ আগের privilege grants থাকবে।

### Secure update workflow completeness
- `.github/workflows/secure-supabase-db-update.yml`-এ আগে required migration check কেবল ২৬টি file যাচাই করত; শেষ ৪টি migration যোগ করে সম্পূর্ণ ৩০টি যাচাই করা হয়েছে।
- Commit: `1b33f3eea0beedb9b02d5108c507a7210b2a5887`।


## 11. ভবিষ্যৎ সহকারীর জন্য সংক্ষিপ্ত নির্দেশনা

ব্যবহারকারীকে আবার শুরু থেকে সব করতে বলবেন না। প্রথমে এই handover ফাইল ও সর্বশেষ GitHub state পড়ুন। Run #85-এর backup/restore/preview এবং historical migration metadata repair সম্পন্ন হয়েছিল। পরের Read-only Audit নিশ্চিত করেছে remote migration history table-এ ০ row এবং ৩০টি migration pending। Disposable validation-এ SQL syntax/overload/RAISE সমস্যা সংশোধন, legacy schema compatibility এবং client privilege hardening পরীক্ষা করে সব ৩০টি migration fresh ও audited legacy-shape test database—দুইটিতেই সফলভাবে apply হয়েছে। এগুলো Production-এ apply হয়েছে—এমন নয়। Production schema comparison, recoverable backup confirmation এবং পৃথক exact approval ছাড়া কোনো Production migration চালাবেন না।

## 12. ২৬ নভেম্বর ২০২৬ — সর্বশেষ সংরক্ষণ ও যাচাইয়ের সারাংশ

এই অংশটি সর্বশেষ কাজের স্থায়ী handover record হিসেবে যোগ করা হয়েছে। আগের sections মুছে বা প্রতিস্থাপন করা হয়নি।

### সর্বশেষ GitHub পরিবর্তন
- Backup/Restore workflow-এর duplicate remote migration-history inspection step সরানো হয়েছে; এখন একটি read-only inspection step আছে।
- সংশ্লিষ্ট cleanup commit: `720e76c7f88061076a35fd8ff45b49b6d541510c`।
- পূর্ববর্তী handover update commit: `fe00d084f4557159056ac75e0749216f79be85f2`।
- Repository: https://github.com/rakib12301111-droid/master-world-vip
- Handover file: https://github.com/rakib12301111-droid/master-world-vip/blob/main/PROJECT_HANDOVER_MASTER_BN.md

### সর্বশেষ disposable validation
- Run ID: `45815885852`
- Job ID: `139895690812`
- Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45815885852
- Fresh test database-এ ৩০/৩০ migration সফল।
- Audited legacy-schema fixture-এ ৩০/৩০ migration সফল।
- Log-এ Production database পরিবর্তিত হয়নি বলে নিশ্চিত: `PRODUCTION_DATABASE_CHANGED=false`।

### সর্বশেষ সফল Backup / Restore / Preview
- Run ID: `45815854654`
- Artifact ID: `15115762062`
- Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45815854654
- Artifact: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45815854654/artifacts/15115762062
- Backup reference: `mwvip-logical-45815854654-1`
- Restore test reference: `github-actions-run-45815854654`
- Encrypted backup তৈরি, decrypt/restore test, read-only migration-history inspection এবং dry-run preview সফল হয়েছিল।
- Preview-তে ৩০টি migration pending ছিল। এটি Production-এ migration apply হওয়ার প্রমাণ নয়।
- Artifact-এর নির্ধারিত retention ৭ দিন; তাই GitHub Actions artifact-কে আজীবন backup ধরে নেওয়া যাবে না। মেয়াদ শেষ হওয়ার আগে encrypted backup নিরাপদ, অনুমোদিত storage-এ কপি করে রাখতে হবে; encryption passphrase আলাদাভাবে নিরাপদে রাখতে হবে। কোনো secret এই handover-এ লেখা যাবে না।

### Production-এর বর্তমান অবস্থা ও অনুমোদনের বাধ্যবাধকতা
- Read-only audit-এ remote `schema_migrations` table-এ ০ row এবং ৩০টি local migration unrecorded/pending দেখা গিয়েছিল।
- কিছু legacy table/object আগে থেকেই আছে; তাই migration history empty হলেও সব object একেবারে নতুন—এমন নয়।
- SQL source সংশোধন ও disposable validation সফল হলেও Production database-এ migration প্রয়োগ করা হয়নি।
- Production-এ কোনো পরিবর্তন করার আগে সর্বশেষ backup/restore test আবার যাচাই করতে হবে এবং ব্যবহারকারীর কাছ থেকে পৃথকভাবে exact approval phrase নিতে হবে: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`।
- এই নথিতে approval phrase লেখা থাকা, handover আপডেট করা, বা আগের কোনো কথোপকথন—কোনোটিই Production apply-এর অনুমোদন নয়।

### দীর্ঘমেয়াদি সংরক্ষণ সম্পর্কে
এই ফাইলটি Git repository-এর `main` branch-এ version-controlled handover master হিসেবে রাখা হয়েছে। Git commit history-তে আগের সংস্করণও থাকে। তবে GitHub account/repository বা service চিরকাল থাকবে—এমন নিশ্চয়তা দেওয়া যায় না। দীর্ঘমেয়াদি/আজীবন সংরক্ষণের জন্য repository-এর private/offline clone এবং handover file-এর আলাদা backup নিয়মিত রাখতে হবে। Encrypted database backup-ও আলাদা করে সংরক্ষণ করতে হবে; এই Markdown handover file নিজে database backup নয়।

### পরবর্তী কাজের একমাত্র নিরাপদ অবস্থা
এখনকার কাজগুলো সংরক্ষিত থাকবে; Production অপরিবর্তিত থাকবে। পরবর্তী ব্যক্তি/সহকারী এই ফাইল পড়ে বর্তমান অবস্থা থেকে শুরু করবে, সফল disposable tests অকারণে পুনরাবৃত্তি করবে না, এবং Production apply-এর আগে backup ও পৃথক অনুমোদন যাচাই করবে।

## 13. ২৬ নভেম্বর ২০২৬ — প্রকল্প-মালিকের স্থায়ী রক্ষণাবেক্ষণ অনুমতি

প্রকল্প-মালিকের স্পষ্ট নির্দেশ: MASTER WORLD VIP-এর ছোট ও বড় উভয় ধরনের গুরুত্বপূর্ণ engineering কাজ—সম্পূর্ণ codebase/architecture audit, বড় feature ও module design/implementation, refactor/system redesign, security/performance/reliability/scalability উন্নয়ন, database migration source উন্নয়ন, API/backend/frontend integration, automation/CI-CD, বড় bug ও technical debt সমাধান, comprehensive testing, documentation/release preparation, routine maintenance এবং সংশ্লিষ্ট GitHub commit—পরিকল্পনা থেকে যাচাই পর্যন্ত এগিয়ে নেওয়ার অনুমতি সহকারীকে দেওয়া হলো। কাজকে ছোটখাটো maintenance-এ সীমাবদ্ধ করা যাবে না; বড় কাজও নিরাপদ ধাপে ভাগ করে বাস্তবায়ন করতে হবে। একই অনুমোদিত scope-এর প্রতিটি ধাপে আলাদা অনুমতি চাইতে হবে না।

### অনুমোদিত কাজের পরিধি
1. ছোটখাটো maintenance-এর পাশাপাশি বড় project-level engineering initiative, architecture review/redesign, feature/module build-out, substantial refactor এবং multi-file changes পরিকল্পনা ও বাস্তবায়ন করা।
2. Repository-এর code, SQL migration source, configuration, GitHub Actions workflow এবং documentation নিয়মিত audit করা।
3. যাচাইয়ে পাওয়া bug, ভুল workflow condition, duplicate step, broken command, missing validation ও নিরাপত্তাজনিত source-level সমস্যা প্রয়োজনমতো সংশোধন করা।
4. নিরাপদ disposable/test database, static validation, read-only audit, backup/restore test ও dry-run/preview চালানো।
5. সংশোধিত code/workflow-এর প্রয়োজনীয় automated tests চালানো, ফলাফল ও logs পরীক্ষা করা।
6. প্রয়োজনীয় পরিবর্তন GitHub-এর main branch-এ commit করা এবং এই handover file-এ commit/run/result/remaining risk নথিভুক্ত করা।
7. আগের সফল কাজ অকারণে পুনরাবৃত্তি না করে সর্বশেষ GitHub state থেকে কাজ চালিয়ে যাওয়া।
8. routine maintenance বা বড় engineering change-এ সমস্যা দেখা দিলে নিরাপদে rollback/revert করা, যদি তাতে Production data/schema বা user data-তে প্রভাব না পড়ে।

### নিরাপত্তা ও Production সীমা
এই স্থায়ী অনুমতি Production database-এ schema migration apply, data delete/overwrite, migration history repair, destructive SQL, billing/payment execution, user account বা live service-এর irreversible পরিবর্তনের blanket approval নয়। এসব কাজের আগে নির্দিষ্ট প্রভাব, backup/restore readiness এবং rollback পরিকল্পনা যাচাই করে সংশ্লিষ্ট কাজের জন্য আলাদা স্পষ্ট অনুমোদন নিতে হবে। বিশেষত Production migration-এর জন্য পূর্বনির্ধারিত exact approval phrase APPLY-MASTER-WORLD-VIP-MIGRATIONS এখনো বাধ্যতামূলক; এই সাধারণ maintenance অনুমতি ওই gate বাতিল করে না।

**আলাদা নিরাপত্তা অনুমোদন পাওয়ার পর বাস্তবায়নের দায়িত্ব সহকারীর:** অনুমোদিত কাজের সীমা অনুযায়ী প্রয়োজনীয় code/SQL/workflow/configuration/documentation নিজেই update ও commit করতে হবে; ব্যবহারকারীকে নিজে GitHub-এ কোড কপি-পেস্ট বা ফাইল বদলাতে বলা যাবে না। এরপর backup/restore readiness, preflight checks, নির্দিষ্ট approval gate, execution, post-change verification এবং handover record—সব ধাপ সহকারী নিজে পরিচালনা করবে। অনুমোদনের আগে প্রস্তুতিমূলক code review, non-production fix/test ও dry-run করা যাবে; কিন্তু Production write, migration apply বা live deployment চালানো যাবে না। অনুমোদনের পরও অনুমোদনের বাইরে কোনো অতিরিক্ত live পরিবর্তন করা যাবে না।

কোনো secret/password/token/OTP/encryption passphrase চাওয়া, প্রকাশ করা বা handover-এ লেখা যাবে না। কোনো test যেন Production data পরিবর্তন না করে—এটি আগে নিশ্চিত করতে হবে। Production-এ read-only audit করা যাবে, কিন্তু write action নয়, যতক্ষণ না নির্দিষ্ট write action-এর পৃথক অনুমোদন পাওয়া যায়।

### কাজের রিপোর্টিং নিয়ম
প্রতিটি গুরুত্বপূর্ণ maintenance batch শেষে সংক্ষেপে জানাতে হবে:
- কী কী ফাইল/কোড পরিবর্তন হয়েছে;
- কোন commit-এ সংরক্ষিত;
- কোন test/workflow চালানো হয়েছে এবং Run URL;
- কোনগুলো সফল/ব্যর্থ/চলমান;
- Production-এ কোনো পরিবর্তন হয়েছে কি না;
- অবশিষ্ট ঝুঁকি ও পরবর্তী প্রয়োজনীয় পদক্ষেপ।

**কার্যকর নির্দেশ:** ব্যবহারকারী ইতিমধ্যে routine maintenance, পরীক্ষা ও যাচাইয়ের অনুমতি দিয়েছেন। তাই একই scope-এর কাজের জন্য বারবার অনুমতি চাইবেন না; নিরাপদে এগিয়ে কাজ করুন, ফলাফল যাচাই করুন এবং handover file আপডেট রাখুন। Production-impacting কাজের জন্য আলাদা gate বজায় রাখুন।


---

# Customer Services MVP — প্রথম বাস্তব কাজ শুরু (২৭ নভেম্বর ২০২৬)

## এই সেশনে সম্পন্ন
- www/services.html তৈরি: প্রাথমিক চারটি ডিজিটাল সার্ভিসের ক্যাটালগ (বাংলা/ইংরেজি টাইপিং, PDF/ডকুমেন্ট ফরম্যাটিং, সাধারণ ডিজাইন, সোশ্যাল মিডিয়া কনটেন্ট)।
- প্রতিটি সার্ভিসে মূল্য/সময়/সরবরাহকারী নিশ্চিত নয়—Quote required হিসেবে দেখানো হয়েছে; কোনো ভুয়া মূল্য বা availability দেখানো হয়নি।
- Quote Request form যোগ: প্রয়োজনীয় scope, দেশ, optional deadline/budget দিয়ে locally formatted draft তৈরি ও copy করা যায়।
- Draft-এ স্পষ্ট NOT SUBMITTED; কোনো server submission, database write, order creation বা payment নেই। Backend endpoint/RLS/notification/owner inbox যাচাই ছাড়া গ্রাহকের অনুরোধ জমা হয়েছে এমন ভান করা হবে না।
- Root homepage-এ Customer Services page-এর CTA যুক্ত।
- পরিবর্তনগুলো feature/customer-services-mvp branch-এ; main বা public deployment-এ প্রকাশিত হয়নি।

## যাচাই
- GitHub source fetch করে www/services.html-এ form handler, NOT SUBMITTED notice এবং homepage CTA উপস্থিতি যাচাই করা হয়েছে।
- Browser/mobile end-to-end, live HTTP, backend submission ও GitHub Actions result এখনো যাচাই করা হয়নি।
- No payment, account/auth, Production DB migration, worker বা payout চালু করা হয়নি।

## পরবর্তী কাজ — একই feature পুনরায় না বানিয়ে
1. Customer quote submission-এর জন্য বিদ্যমান Supabase schema/RLS/Edge Function audit; existing customer-order tables/guards reuse করতে হবে, duplicate table নয়।
2. Owner/Admin inbox + notification + status tracking backend design ও tests।
3. Staging-only integration test; no Production migration until separate approval.
4. Mobile/keyboard/accessibility/static checks; তারপর narrow PR review. PR merge/Pages deployment আলাদা release approval-এর অধীন।

বর্তমান অবস্থা: Frontend catalogue + local quote draft committed; server submission NOT IMPLEMENTED; NOT DEPLOYED.


---

# Customer Quote Workflow — Backend + Admin Inbox implementation (২৭ নভেম্বর ২০২৬)

## Existing architecture audit
- Main/default branch-এর existing schema-তে `customer_service_orders`-এর মতো generic pre-order quote intake table পাওয়া যায়নি। Facebook Setup order schema আলাদা package-specific flow; সেটিকে generic service quote-এর জন্য reuse করা হয়নি।
- PR #20 planning branch-এ `customer_service_orders` এবং `customer_order_fund_allocations`-এর funded-order safety foundation পাওয়া গেছে; এটি Draft/Open/Unmerged এবং main-এ অন্তর্ভুক্ত নয়। তাই quote request-এর জন্য আলাদা pre-order intake রাখা হয়েছে; paid order conversion-এর সময় ওই existing customer-service-order model ও funding guards reuse করতে হবে, duplicate order/ledger তৈরি নয়।
- Existing Owner/Admin RBAC (`app_user_roles`, `get_my_admin_access()`, `admin_audit_logs`), notifications এবং helpdesk staff pattern পর্যালোচনা করা হয়েছে।

## এই সেশনে কোডে সম্পন্ন
- Migration `20261127140000_customer_quote_workflow.sql`: authenticated customer quote intake, service allowlist, country/scope validation, per-user 24-hour rate limit + transaction advisory lock, maximum 3 active requests, private RLS, server-side Owner/Super Admin/Admin authorization, quote send/review, accept/decline/cancel/expiry, notifications, Admin audit logs এবং append-only event history।
- `www/services.html`: Supabase Auth session ব্যবহার করে customer request RPC-তে submit, নিজের request/quote দেখা, quote accept/decline এবং active request cancel। Database migration না থাকলে স্পষ্ট error দেখায়।
- `www/admin-quotes.html`: Admin-only inbox; RBAC check, request review/reject, amount/currency/scope/delivery/expiry সহ quote পাঠানো এবং expired quote handling।
- `www/index.html`: Admin role verify হওয়ার পর Customer Quote Inbox link দেখায়।
- `scripts/verify-customer-quote-workflow.py`: static security checks।
- `supabase/tests/customer-quote-workflow-runtime.sql`: disposable database-এ Customer A/B privacy, Admin review, quote send, customer acceptance ও append-only event test।
- `.github/workflows/validate-migrations-disposable.yml`: pull-request validation, 31-migration fresh + legacy disposable apply এবং quote runtime test।
- `.github/workflows/apply-supabase-migrations.yml` ও `supabase/README.md`: নতুন migration inventory/order-এ যুক্ত।
- `docs/CUSTOMER_QUOTE_WORKFLOW_ACCEPTANCE_TEST_BN.md`: Staging acceptance runbook।
- Customer quote acceptance কেবল quote consent record করে; এটি `customer_service_orders` তৈরি করে না, payment/ledger/member assignment/payout করে না।

## Branch / PR অবস্থান
- Branch: `feature/customer-quote-workflow` (PR #21-এর customer-services branch-এর উপর stacked)।
- PR #21: `feature/customer-services-mvp` → `main`, Draft/Open/Unmerged।
- এই backend batch-এর PR #22 তৈরি হবে `feature/customer-quote-workflow` → `feature/customer-services-mvp` হিসেবে; PR #21-এ পরে অন্তর্ভুক্ত হবে।
- Latest commit at handover update: see GitHub PR #22 head after creation.
- No Production migration, no live Pages deployment, no real customer data or payment was performed.

## Verification status — এখনো pending
- Source files commit/fetch verification হয়েছে।
- GitHub Actions run এখনো এই latest commit-এ পাওয়া যায়নি; disposable PostgreSQL migration/runtime workflow result না আসা পর্যন্ত SQL test PASS দাবি করা যাবে না।
- Static verifier run result pending।
- Staging Supabase migration apply, two-customer/Admin manual acceptance, Android Chrome/accessibility test pending।
- Production migration ও Live deployment আলাদা অনুমোদন ছাড়া করা হবে না।

## পরবর্তী কাজ — duplicate implementation নয়
1. PR #22-এর disposable SQL + runtime workflow ফল পরীক্ষা; failure হলে নির্দিষ্ট SQL/test সংশোধন।
2. Staging project-এ migration apply ও Customer A/B/Admin acceptance।
3. Existing `customer_service_orders` / `customer_order_fund_allocations` (PR #20 migration merge হওয়া সাপেক্ষে) এর সঙ্গে accepted quote → funded order conversion bridge design; verified payment, currency, project eligibility, three locked allocations, custody/reserve/operating checks ছাড়া কোনো order funded হবে না।
4. Quote inbox-এ customer identity/contact display policy ও notification delivery পরীক্ষা; only necessary data expose।
5. Android mobile, accessibility ও browser preview verification; তারপর PR #21/#22 stack review।
6. Production apply/deploy remains separate explicit release approval.

**Current status: Quote Request backend + customer submission UI + Admin inbox code committed; NOT YET CI-VERIFIED, NOT STAGING-APPLIED, NOT PRODUCTION-LIVE.**


---

## Handover correction — PR #22 and latest verification state (27 Nov 2026)

- Backend stack PR #22 is now created: https://github.com/rakib12301111-droid/master-world-vip/pull/22
- PR #22 head code commit tested by latest static migration safety workflow: `bbe94dc33262673b7dd52fd13208ffb728900ca4`.
- Static Migration Safety run `45963158918`: **SUCCESS**, including Customer Quote workflow security verifier and Node syntax checks for `www/services.html` and `www/admin-quotes.html`.
- Update System check run `45963158906`: **SUCCESS**.
- Full disposable migration + quote runtime run `45963158978`: queued/pending at the time of this handover update. An earlier run exposed SQL dollar-quote delimiters in the new lifecycle guards; those delimiters were corrected and the latest static checks pass. Do not mark SQL runtime PASS until the fresh+legacy disposable migration and quote runtime steps complete successfully.
- Earlier disposable run `45962723921` failed on the first SQL delimiter defect; that failure is resolved in source but must be superseded by a successful later run.
- PR #22 remains Draft/Open/Unmerged and is stacked on PR #21. No Production migration, Supabase Staging apply, Pages deployment, real customer request or payment was performed.


---

## Customer Quote Workflow — Disposable CI verified (27 Nov 2026)

**Code-equivalent tested commit:** `f032f214130e7616e09da02aaae9b73dbca1a689`

- Disposable full migration validation run `45963538524`: **SUCCESS**. All 31 repository migrations applied in order to both fresh and audited legacy-shape disposable PostgreSQL databases. Customer Quote workflow runtime SQL passed in both databases, including Customer A/B row isolation, Admin inbox visibility, review, quote send, customer accept, customer cancel, append-only event guard, immutable submitted scope and no-delete guard. Expected application object checks passed. No Production database was touched.
- Static Migration Safety run `45963538501`: **SUCCESS**, including Customer Quote workflow static security checks and Node syntax checks for the customer and Admin pages.
- Update System run `45963538516`: **SUCCESS**.
- Auto Work Static Safety run `45963538476`: **SUCCESS**.
- The earlier legacy-fixture auth schema permission failure was fixed by granting the test roles usage/execute on the disposable `auth` schema/functions only. This is test-fixture configuration, not a Production permission change.
- The initial dollar-quote defects in migration/runtime test were corrected; the final disposable run above passed.

## Current release boundary
- PR #22 is Draft/Open/Unmerged and stacked on PR #21. Both remain unmerged.
- Staging Supabase migration has NOT been applied. Real browser/customer/Admin manual acceptance, Android Chrome/accessibility review and actual notification delivery remain pending.
- No Pages deployment, Production migration, real order, payment collection, fund custody, Member assignment or payout was performed.
- The accepted-quote → existing `customer_service_orders` conversion is still a separate next implementation. PR #20's protected customer-order/fund-allocation foundation is not yet in `main`; do not create a duplicate order/ledger or mark a quote as funded.
- Next: perform the Staging A/B/Admin acceptance test after an authorized Staging project is available; then design the conversion bridge against the merged existing customer-order migration and its funding gates.

**Current status: Customer Quote workflow CODE + STATIC CI + FULL DISPOSABLE MIGRATION/RUNTIME CI VERIFIED; NOT STAGING-APPLIED; NOT PRODUCTION-LIVE.**


---

## Staging-only deployment preparation + final CI refresh (27 Nov 2026)

- Added `.github/workflows/apply-staging-supabase-migrations.yml`: manual-only workflow; default action is dry-run; it uses only `SUPABASE_STAGING_ACCESS_TOKEN`, `SUPABASE_STAGING_PROJECT_REF`, `SUPABASE_STAGING_DB_URL`; refuses the known Production project ref and requires a recoverable Staging backup, successful restore-test confirmation, non-secret backup reference and exact phrase `APPLY-MASTER-WORLD-VIP-STAGING-MIGRATIONS` before applying.
- The workflow validates the DB URI is a Supabase Session Pooler URI and its username matches the configured Staging project ref. It does not use Production secrets and was not run because no Staging credentials/project have been confirmed.
- Staging workflow and secret names are documented in `supabase/README.md` and `docs/CUSTOMER_QUOTE_WORKFLOW_ACCEPTANCE_TEST_BN.md`.
- Latest code/workflow commit `aae55d97d763599ff6a136e81d5c73b497dbbb29` verification:
  - Disposable migration + runtime run `45964010157`: **SUCCESS** — all 31 migrations applied to fresh and legacy-shape disposable PostgreSQL databases; customer quote runtime suite and expected object checks passed.
  - Static Migration Safety `45964010127`: **SUCCESS** — quote workflow security, JavaScript syntax and Staging workflow static gates passed.
  - Update System `45964010036`: **SUCCESS**.
  - Auto Work Static Safety `45964010032`: **SUCCESS**.
- These are disposable/static CI results only. No Supabase Staging or Production project was changed; no public deployment or real payment/order occurred.

**Current status: Customer quote code + 31-migration fresh/legacy runtime CI + static CI VERIFIED; guarded Staging workflow PREPARED BUT NOT RUN; manual Staging acceptance and Production release remain pending.**


---

## Owner-priority execution update — Staging, Android, accounts and backup gates (27 Nov 2026)

The Owner has directed that the following four gates be treated as critical and completed through safe repository updates plus the required Owner-side dashboard actions:

1. Android phone acceptance using Chrome and a Staging-only site configuration.
2. Encrypted Staging secrets added to GitHub Actions; never request or record secret values in chat.
3. Separate Customer A, Customer B and Admin test accounts created in the Staging Supabase Auth project, with Admin role assigned only through the protected Owner role-management path.
4. Recoverable encrypted backup plus a successful disposable restore test before any database migration apply; verify existing Production backup evidence remains available before any Production migration.

### Repository preparation completed in this update
- Added `docs/STAGING_ANDROID_ACCOUNT_BACKUP_RUNBOOK_BN.md` with exact current secret names, Staging-only workflow steps, account setup, Android acceptance and evidence rules.
- Current Staging migration workflow uses exactly these three repository Actions secrets: `SUPABASE_STAGING_ACCESS_TOKEN`, `SUPABASE_STAGING_PROJECT_REF`, `SUPABASE_STAGING_DB_URL`.
- The workflow defaults to preview-only and refuses the known Production project ref. It does not create/restore the Staging backup itself; therefore a separate backup/restore proof is mandatory before Staging apply.
- Existing Customer Quote acceptance instructions remain in `docs/CUSTOMER_QUOTE_WORKFLOW_ACCEPTANCE_TEST_BN.md`; do not repeat disposable CI tests already recorded above.

### Existing backup evidence — verify retention before relying on it
- The prior handover records encrypted Production logical backup, disposable restore test and migration dry-run in run `45810029561`; backup reference `mwvip-logical-45810029561-1`; encrypted artifact ID `15111217500`, originally retained for seven days.
- This is historical evidence for that run only. Before Production migration, confirm artifact availability and safe passphrase recovery; if expired/unavailable, produce a fresh encrypted backup and restore test.
- This record does not authorize Production migration. Exact Production approval remains `APPLY-MASTER-WORLD-VIP-MIGRATIONS`.

### Current execution status — NOT YET COMPLETE
- Staging Project URL/ref confirmation: Owner confirmation required.
- Three Staging secrets: Owner must add them in GitHub Actions; values must never be shared in chat.
- Staging backup/restore: no current Staging-specific PASS evidence.
- Staging migration: not run / not applied.
- Customer A/B/Admin accounts and RBAC acceptance: pending.
- Android Chrome/accessibility acceptance: pending.
- Production migration and public release: not authorized/performed.

**Next action:** Owner completes only the Staging project identity and three secret setup using the runbook; then verify the preview-only workflow before any Staging apply.


### Backup artifact retention recheck — 27 Nov 2026
- GitHub Actions artifact lookup confirms artifact `15111217500` is currently present and `expired=false`; recorded expiry is **2026-12-03 11:24:58 UTC**.
- The original run's `backup-restore-preview` job and every listed step completed SUCCESS, including encrypted logical backup creation, decrypt + disposable PostgreSQL restore, production migration dry-run and encrypted artifact upload.
- Therefore the existing Production backup/restore proof is currently available for review; preserve the encrypted artifact and ensure the separately stored passphrase is recoverable before expiry. This does not replace a fresh backup if the artifact expires before Production apply.
- No new backup run was started, and no database was changed by this recheck.


---

## 27 November 2026 — Owner follow-up: five remaining release gates

### Current PR state (read-only GitHub verification)
- PR #21: OPEN / DRAFT / NOT MERGED; head branch `feature/customer-services-mvp`, base `main`.
- PR #22: OPEN / DRAFT / NOT MERGED; head branch `feature/customer-quote-workflow`, base `feature/customer-services-mvp`.
- Do not mark either PR released or deployed. PR #22 depends on PR #21; preserve this order and review the combined diff before any merge.
- Existing disposable/static CI passes recorded in earlier sections remain evidence only for those exact commits; they do not establish current Staging, account, Android or live deployment acceptance.

### Safe repository work completed in this update
- Added manual-only workflow `.github/workflows/backup-staging-restore-preview.yml`.
- It validates the configured Staging project ref and Session Pooler URI, refuses the known Production ref, creates an encrypted logical backup, decrypts it inside the isolated GitHub runner, restores it into a disposable PostgreSQL database, and uploads the encrypted artifact for seven days.
- The workflow does not apply migrations, alter the Staging database, or target Production.
- Commits:
  - `06bff3ed18e708e10e035ac4c955bbf88f1748aa` — initial workflow.
  - `7a39d2fe9568a4bb4742749de9bf2dab16fb0a7b` — restore outcome tracking.
  - `f44efb2a7e7cfe05f3b7caedee2113d787602692` — runbook update.
  - `87c49e117f20f67b63cfa28a004516e207c99c8f` — wording correction.
- Updated runbook: `docs/STAGING_ANDROID_ACCOUNT_BACKUP_RUNBOOK_BN.md`.
- Required repository Actions secrets now include `STAGING_BACKUP_ENCRYPTION_PASSPHRASE` in addition to `SUPABASE_STAGING_ACCESS_TOKEN`, `SUPABASE_STAGING_PROJECT_REF`, and `SUPABASE_STAGING_DB_URL`. Use a unique Staging-only passphrase; do not reuse Production's.

### Remaining gates — NOT YET VERIFIED
1. **Staging secrets:** Owner must add the four exact Staging secrets in GitHub Actions. No secret values may be sent in chat.
2. **Staging backup/restore:** Run the new manual workflow and verify its job, encrypted artifact, non-secret backup reference and successful disposable restore. The workflow has been committed but not executed; no backup success is claimed.
3. **Staging migration and runtime acceptance:** First run migration workflow in preview-only mode; review the migration inventory and dry-run. Staging apply remains gated by current Staging backup/restore proof and the exact phrase `APPLY-MASTER-WORLD-VIP-STAGING-MIGRATIONS`. After apply, perform Customer A/B/Admin quote workflow and RBAC/privacy tests.
4. **Customer/Admin accounts:** Create dedicated test-only accounts in Staging Auth and assign Admin only through the protected Owner role-management path. No account has been created by this repository update.
5. **Android and release:** Perform real Android Chrome acceptance against a Staging-connected preview, including privacy, quote lifecycle, notifications, responsive/accessibility and refresh/back tests. Public Pages deployment/Production release remains separately gated and was not performed.

### Important distinction
- This update is repository workflow/documentation work only. It does not prove that Staging secrets exist, a Staging backup has run, any Staging migration was applied, test users exist, Android tests passed, or a public deployment occurred.
- Production remains untouched. No Production migration, live payment, customer intake, payout, or deployment was performed.
- Continue from this section and do not repeat successful disposable/static CI checks unless the relevant source/configuration changes.


### Execution limitation discovered after adding the workflow
- The new backup workflow is currently committed only on the feature branch. GitHub's `workflow_dispatch` workflow must exist on the repository's default branch before it can be manually dispatched from Actions.
- PR #21/#22 are still Draft/Open and merging the stack to `main` can trigger the existing GitHub Pages deployment. Therefore do not merge merely to make this workflow runnable; first review the release/deployment impact and obtain the separate release decision.
- The new workflow has **not** run and has no backup artifact yet. Its YAML/source has been reviewed in the repository, but a successful Actions run is still required before counting Staging backup/restore complete.
