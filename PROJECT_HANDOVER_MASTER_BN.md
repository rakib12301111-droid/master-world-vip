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


## 14. ২৮ নভেম্বর ২০২৬ — Staging restore container diagnostics

- PR #25: https://github.com/rakib12301111-droid/master-world-vip/pull/25
- শিরোনাম: Diagnose Staging restore container startup failure
- অবস্থা: **Merged**
- Merge commit: `e949aa1f90c8f6a1aa1c8296345e09aaa60a5e45`
- পরিবর্তন: GitHub Actions service-container startup-এর বদলে workflow step-এ pinned `supabase/postgres:17.6.1.136` image স্পষ্টভাবে pull/run, health wait এবং failure হলে Docker logs দেখানোর ব্যবস্থা।
- উদ্দেশ্য: আগের Run-এ `One or more containers failed to start` / `Failed to initialize container supabase/postgres:17.6.1.136` সমস্যার সুনির্দিষ্ট কারণ বের করা।
- **এখনো যাচাই হয়নি:** Merge-এর পর Staging workflow নতুন করে চালানো হয়নি; তাই container startup, encrypted backup, isolated restore, migration dry-run, Auth/RBAC এবং পুরো workflow-এর সবুজ ফলাফল এখনো প্রমাণিত নয়।
- Production database-এ কোনো migration/apply করা হয়নি।
- পরবর্তী পদক্ষেপ: GitHub Actions-এ `MASTER WORLD VIP — Staging migrations and access-control acceptance` workflow-এর `Run workflow` দিয়ে `main` branch-এ manual run শুরু করতে হবে; এরপর প্রতিটি job/step ও log যাচাই করে ফলাফল এখানে যোগ করতে হবে।


## 15. ২৮ নভেম্বর ২০২৬ — Staging Run #2 ব্যর্থতা ও নিরাপদ ডায়াগনস্টিক সংশোধন

- Run ID: `46061219987`
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46061219987
- Commit checked out: `9ecc77d17aca34c8c0e210abace2199adf870f59`
- Job: `Encrypted Staging backup and isolated restore proof`
- Job ID: `140715676843`
- Failure step: `Validate Staging-only backup inputs without printing secrets`
- Exact safe error: `Staging DB URL credentials are not bound to the confirmed Staging project ref`
- Root cause narrowed to one of two checks: parsed Session Pooler username does not exactly equal `postgres.<Staging project ref>`, or parsed password is empty. The log intentionally does not reveal either credential.
- Docker restore container, encrypted backup, isolated restore, migration preview/apply and Auth/RBAC stages were not reached; downstream migration job was skipped.
- Production database unchanged.
- Corrective diagnostic commit: `17c48038963684d986812290ab68fa5fe11f9a90`
- Change: split the combined credential check into separate safe error messages for username mismatch vs empty password; no credential values are printed.
- **Next:** run the Staging workflow on `main` once more. The next failure, if any, will identify which field needs correction without exposing secrets. If username mismatch is reported, update GitHub Secret `STAGING_SUPABASE_DB_URL` using Supabase Connect > Session pooler URI, with username `postgres.<Staging project ref>`; if password empty is reported, recreate the URI with the Staging database password and URL-encode special characters. Never share the URI/password in chat.
- Run #2 does not test PR #25's Docker change because it failed at the earlier DB URL preflight.


## 16. ২৮ নভেম্বর ২০২৬ — Staging Run #3: Username mismatch নিশ্চিত

- Run ID: `46061518224`; Run number: 3; conclusion: `failure`.
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46061518224
- Checked-out commit: `08fc57d7ea0881ec39147b23996588490186d42c`.
- Job: `Encrypted Staging backup and isolated restore proof`; Job ID: `140716657177`.
- Failure step: `Validate Staging-only backup inputs without printing secrets`.
- Exact safe error: `Staging DB URL username mismatch. In Supabase Connect > Session pooler, use the exact username postgres.<Staging project ref>; do not use the direct-connection username.`
- This proves the parsed URI username does not equal the expected Session Pooler username. The password-empty condition was not the failing condition in this run.
- No credential value was printed or stored in this handover.
- PostgreSQL client install, Docker restore container, encrypted backup, isolated restore, artifact upload, migration dry-run/apply, Auth/RBAC and Edge Function stages were not reached; the downstream `staging-migrations` job was skipped.
- Production database unchanged; no Production migration was applied.
- Workflow code's separate username/password diagnostics are now confirmed active in Run #3. This run still checks out commit `08fc57d`, which includes the diagnostic change.
- **Next required correction (GitHub Secret, not code):** update `STAGING_SUPABASE_DB_URL` from Supabase Dashboard → Staging project → Connect → Session pooler → URI. Ensure the username portion is exactly `postgres.awatzrapqrteybgspqlq` (not `postgres` alone and not a direct-connection username); retain the Staging database password in the URI and URL-encode special characters. Save only in GitHub Actions Repository Secret. Never send the URI or password in chat.
- Do not weaken or remove the exact username-to-project-ref validation; it is a Staging isolation safety control.
- After the secret is corrected, rerun the Staging workflow and inspect logs. Only then can the Docker/backup/restore/preview stages be evaluated.


## 17. ২৮ নভেম্বর ২০২৬ — Staging Run #4: Session Pooler URI format validation failure

- Run ID: `46061905490`; Run number: 4; conclusion: `failure`.
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46061905490
- Checked-out commit: `2ca752a797d6398ddbf465ec2410357bb118e443`.
- Job: `Encrypted Staging backup and isolated restore proof`; Job ID: `140717923983`.
- Failure step: `Validate Staging-only backup inputs without printing secrets`.
- Exact safe error: `Staging DB URL must use a Supabase Session Pooler URI`.
- This error occurs before username/password comparison. The supplied value did not pass the URI scheme/host check: it must parse as `postgres://` or `postgresql://` and its hostname must end with `.pooler.supabase.com`. Do not infer that the username or password is now correct; those checks were not reached.
- Likely correction: recreate/copy the complete URI specifically from Supabase Dashboard → Staging project `awatzrapqrteybgspqlq` → Connect → Session pooler → URI (not Direct connection, not Transaction pooler, not a host-only snippet). Paste only the URI value into GitHub Repository Secret `STAGING_SUPABASE_DB_URL`, without surrounding quotes, labels, spaces, or line breaks. Confirm the URI uses the Session Pooler host and port 5432; username must be `postgres.awatzrapqrteybgspqlq`; password is the Staging database password with special characters URL-encoded. Never disclose the URI/password in chat.
- No credentials were printed or recorded.
- PostgreSQL client installation, Docker container startup, encrypted backup, isolated restore, artifact upload, migration preview/apply, Auth/RBAC and Edge Function stages were not reached; downstream `staging-migrations` job was skipped.
- Production database unchanged; no Production migration applied.
- Do not weaken the Session Pooler/port/project-ref checks. After updating the Secret from the exact Session Pooler URI, run the workflow again and inspect the next safe preflight result.


## 18. ২৮ নভেম্বর ২০২৬ — Session Pooler সমস্যা: Supabase official docs অনুযায়ী সংশোধিত নির্দেশনা ও বর্তমান blocker

### সর্বশেষ প্রমাণিত GitHub অবস্থা
- Staging validation workflow-এর সর্বশেষ run এখনো Run #4 (Run ID: `46061905490`), ফলাফল `failure`; Run #4-এর পর নতুন Staging validation run পাওয়া যায়নি।
- Run #4-এর ত্রুটি: `Staging DB URL must use a Supabase Session Pooler URI`। এটি URI scheme/host validation-এ ব্যর্থ; username/password validation পর্যন্ত পৌঁছায়নি।
- Workflow source-এর প্রথম preflight-এ scheme `postgres://` বা `postgresql://`, host suffix `.pooler.supabase.com`, port `5432`, path `/postgres`, query/fragment অনুপস্থিত এবং username `postgres.<STAGING_PROJECT_REF>` যাচাই করা হয়। Secret value কখনো log করা হয় না।
- Project ref: `awatzrapqrteybgspqlq`; Staging Dashboard URL: https://supabase.com/dashboard/project/awatzrapqrteybgspqlq

### Supabase official docs থেকে গুরুত্বপূর্ণ স্পষ্টীকরণ
- Official docs: https://supabase.com/docs/guides/database/connecting-to-postgres
- Shared Session Pooler URI-এর ধরন: `postgresql://postgres.<PROJECT-REF>:[PASSWORD]@[POOLER-HOST]:5432/postgres`।
- Pooler host-এর cluster index ও region মিলিয়ে নিজে host বানানো যাবে না। Supabase বলছে একটি region-এ একাধিক pooler cluster থাকতে পারে; Connect dialog থেকে সম্পূর্ণ host/URI কপি করতে হবে।
- Session mode হলো shared pooler-এর port `5432`; Transaction mode port `6543`—এই workflow-এর জন্য Transaction mode সঠিক নয়।
- Password placeholder-টি Staging database password দিয়ে বদলাতে হবে; reserved character percent-encode করতে হবে। Password Dashboard-এ আর দেখা না গেলে তবেই reset বিবেচনা করতে হবে; reset করলে পুরোনো password-নির্ভর connection ভেঙে যাবে।
- Official troubleshooting: https://supabase.com/kb/troubleshooting/tenant-or-user-not-found

### কে কী করতে পারবে
- Repository code ও handover documentation আপডেট করা সম্ভব; কিন্তু GitHub Actions Secret-এর মান GitHub API/এই সংযুক্ত GitHub tool দিয়ে পড়া বা বদলানো যায় না। Secret encrypted/hidden; Supabase Dashboard-এর Connect dialog-ও ব্যবহারকারীর authenticated browser session-এ। তাই assistant নিজে Secret-এর URI কপি/সেভ করতে বা user-এর হয়ে Dashboard button চাপতে পারবে না।
- ব্যবহারকারীকে কেবল একবার নিজে Supabase Connect → Session pooler থেকে full URI কপি করে GitHub Secret `STAGING_SUPABASE_DB_URL`-এ সংরক্ষণ করতে হবে। URI/password chat-এ পাঠানো যাবে না।
- Secret save হওয়ার পর GitHub Actions workflow manual dispatch ব্যবহারকারীকেই করতে হবে; বর্তমান connected GitHub actions-এ workflow_dispatch trigger action নেই। এরপর assistant run/job/log পরীক্ষা করতে পারবে।

### নিরাপত্তা অবস্থা
- Run #4-এ backup, Docker restore container, encrypted backup, isolated restore, artifact upload, migration preview/apply, Auth/RBAC ও Edge Function ধাপগুলো শুরু হয়নি; downstream job skipped।
- Production database-এ কোনো পরিবর্তন হয়নি। Production migration approval gate অপরিবর্তিত: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`।
- পরবর্তী ধাপ: Secret-এ Dashboard থেকে কপি করা সঠিক সম্পূর্ণ Session Pooler URI সংরক্ষণ → Staging workflow চালানো → preflight, backup/restore ও পরবর্তী ধাপের logs যাচাই। কোনো validation শিথিল করা যাবে না।

## 19. ২৮ নভেম্বর ২০২৬ — Staging Auth preflight-এর নিরাপদ error diagnostics

- Workflow: `.github/workflows/validate-staging-supabase.yml`
- পরিবর্তনের commit: `c98f67d536d39637036d110b2385eea822f109c9`
- পরিবর্তন: OWNER-এ প্রথম ব্যর্থ হলেই থেমে না গিয়ে OWNER, ADMIN ও MEMBER—তিনটি Staging Auth account-ই পরীক্ষা করবে; প্রতিটির HTTP status ও নিরাপদ error category আলাদা করে দেখাবে।
- Diagnostic category: API key rejected, email unconfirmed, credentials/account mismatch, rate limit, network/TLS/timeout অথবা অচেনা Auth error। Response body, email, password, API key বা JWT log করা হয় না।
- কোনো account ব্যর্থ হলে স্পষ্টভাবে জানাবে যে Migration Preview/Apply চালানো হয়নি; সব তিনটি account পরীক্ষা শেষ করেই preflight failure exit করবে।
- Workflow source GitHub থেকে পুনরায় fetch করে পরিবর্তিত Auth preflight block যাচাই করা হয়েছে; আগের generic error message আর নেই।
- **এখনো চালানো/প্রমাণিত নয়:** নতুন commit-এর পর GitHub Actions workflow run, Auth diagnostic ফলাফল, backup/restore, migration preview/apply, Owner RPC role assignment, Admin RPC access ও queue-worker ধাপ। GitHub connector দিয়ে encrypted Actions Secrets পড়া/পরিবর্তন করা যায় না; Auth credential/API key-এর প্রকৃত মানও chat-এ প্রকাশ করা যাবে না।
- **বর্তমান blocker:** Auth preflight এখন প্রকৃত নিরাপদ error category প্রকাশ করবে। পরবর্তী Staging run-এ কোন account এবং কোন category ব্যর্থ তা দেখে সংশ্লিষ্ট Secret বা Supabase Auth configuration ঠিক করতে হবে। Secret ঠিক না হওয়া পর্যন্ত পরবর্তী ধাপগুলো নিরাপত্তার কারণে চলবে না।
- Production database-এ কোনো পরিবর্তন হয়নি; Production migration gate অপরিবর্তিত।

## 20. ২৮ নভেম্বর ২০২৬ — Staging Auth Diagnostic আরও নির্ভুল করা

- Workflow `.github/workflows/validate-staging-supabase.yml`-এ নতুন commit `99898b74556410b5d64aab4335677525d28f5de5`।
- Auth response-এর নিরাপদ diagnostic এখন Supabase-এর একাধিক সম্ভাব্য field (`error_code`, `code`, `error`, `msg`, `message`, `error_description`) পরীক্ষা করে। ফলে Supabase Auth সংস্করণভেদে error field আলাদা হলেও invalid API key, unconfirmed email, invalid credentials/account missing এবং rate limit শ্রেণিবদ্ধ করার সুযোগ বাড়ে।
- অচেনা error-এর ক্ষেত্রে raw response/message log করা হয় না; শুধু HTTP status ও `unclassified` category দেখায়। Email, password, API key, response body বা JWT প্রকাশ করা হয় না।
- আগের তিন-অ্যাকাউন্ট preflight বজায় আছে: OWNER, ADMIN, MEMBER—সবগুলো পরীক্ষা; যেকোনো ব্যর্থতায় migration preview/apply বন্ধ।
- ব্যবহারকারী জানিয়েছেন OWNER Email/Password এবং Staging Auth account-এর সঙ্গে মিল ঠিক আছে। এটি ব্যবহারকারীর নিশ্চিতকরণ; GitHub encrypted Secret-এর প্রকৃত মান assistant পড়তে পারে না।
- Workflow ও handover code update সম্পন্ন; কিন্তু নতুন commit-এর পর Actions run চালানো/ফলাফল যাচাই করা হয়নি। তাই Auth diagnostic pass, backup/restore, migration, role/RPC এবং queue-worker ধাপগুলো এখনো সম্পন্ন বলে গণ্য নয়।
- পরবর্তী ধাপ: GitHub Actions থেকে `validate-staging-supabase.yml`-এর `main` branch-এ নতুন run চালিয়ে নতুন Auth Diagnostic ফলাফল দেখা। কোনো Production secret/database/migration স্পর্শ করা হয়নি; Staging-only সীমা বহাল।


## 21. ২৮ নভেম্বর ২০২৬ — Staging Run #5: Backup/Restore সফল, Auth preflight-এ blocker

- Run ID: `46077272231`; Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46077272231
- Run checked-out commit: `24917e39ee778233ada41a3102fdd6ad30a7f514`
- Backup/Restore job ID: `140767830277`; conclusion: `success`
- Migration job ID: `140768283420`; conclusion: `failure`
- Backup job-এর সব ধাপ PASS: Staging Session Pooler input validation, OpenSSL install, isolated PostgreSQL container health, Staging connection preparation, encrypted logical backup creation, decrypt + isolated restore, non-empty restored schema check, encrypted backup/evidence artifact upload এবং disposable container cleanup।
- Migration job-এর Staging secret/project-ref validation PASS; ৩০টি ordered migration file পাওয়া গেছে এবং duplicate version নেই।
- Auth preflight OWNER, ADMIN ও MEMBER—তিন account-এই ব্যর্থ: নিরাপদ log category `Credentials rejected or account not found in this Staging project`। কোনো email/password/response body/JWT log করা হয়নি।
- নিরাপত্তা অনুযায়ী Auth preflight ব্যর্থ হওয়ায় Migration Preview, Migration Apply, Owner RPC role assignment, role/RPC verification এবং queue-worker deploy/report steps skipped হয়েছে।
- এই run-এ Production project/database স্পর্শ করা হয়নি; কোনো Production migration হয়নি।
- **পরবর্তী একমাত্র blocker:** GitHub Repository Secrets-এর `STAGING_OWNER_EMAIL`, `STAGING_OWNER_PASSWORD`, `STAGING_ADMIN_EMAIL`, `STAGING_ADMIN_PASSWORD`, `STAGING_MEMBER_EMAIL`, `STAGING_MEMBER_PASSWORD`—প্রতিটি অবশ্যই Staging project `awatzrapqrteybgspqlq`-এর Auth Users-এ থাকা সংশ্লিষ্ট account-এর exact email ও বর্তমান password হতে হবে। তিনটি account একসঙ্গে invalid হওয়ায় আগে নিশ্চিত করতে হবে যে এগুলো Production/অন্য project-এর নয় এবং password reset/পরিবর্তনের পর পুরোনো Secret পড়ে নেই। Supabase Dashboard → Staging project → Authentication → Users-এ তিন account উপস্থিত ও email confirmed কি না যাচাই করুন; password জানা না থাকলে ঐ Staging account-এর password reset করে একই নতুন password GitHub Secret-এ সংরক্ষণ করুন। Secret value chat-এ দেবেন না।
- Code validation দুর্বল করা, Auth preflight বাদ দেওয়া, migration bypass করা বা Production-এ কাজ চালানো যাবে না। Secret ঠিক হওয়ার পর নতুন Staging workflow run-এ Auth PASS না হওয়া পর্যন্ত Migration/Role কাজ শুরু হবে না।
- **প্রমাণিত সম্পন্ন:** encrypted Staging backup + isolated restore test।
- **এখনো অসম্পন্ন:** Staging migration dry-run/apply, Owner/Admin/Member role assignment and verification, Admin RPC access acceptance, queue-worker source/deploy assessment।


## 22. ২৮ নভেম্বর ২০২৬ — Supabase Invitation গ্রহণে Microsoft Edge account prompt (নতুন ব্যবহারকারী রিপোর্ট)

- ব্যবহারকারী জানিয়েছেন, Supabase invitation email-এ Accept invitation চাপার পর Android-এ Microsoft Edge নির্বাচন/ইনস্টল করেছেন; এরপর Edge-এ Microsoft account তৈরির সময় “We can't create your account ... unusual activity” বার্তা দেখেছেন।
- এই বার্তাটি Microsoft account তৈরির ব্যর্থতা; এটি Supabase Auth invitation acceptance বা Staging Auth-এর ফলাফল নয়। Supabase invitation গ্রহণের জন্য Microsoft account প্রয়োজন নেই।
- নিরাপদ পরবর্তী পদক্ষেপ: Gmail থেকে invitation email পুনরায় খুলে Accept invitation লিংকটি সরাসরি Chrome-এ খুলুন; Android-এর Open with chooser-এ Chrome নির্বাচন করুন। Edge-এ Microsoft sign-in/account creation চাইলে Microsoft account তৈরি করবেন না; সেটি এড়িয়ে Chrome ব্যবহার করুন। Invitation link মেয়াদোত্তীর্ণ হলে Staging Supabase Auth Users থেকে নতুন invitation পাঠাতে হবে।
- Invitation গ্রহণ সফল হয়েছে কি না যাচাইয়ের নির্ভরযোগ্য উপায়: Staging project awatzrapqrteybgspqlq → Authentication → Users-এ সংশ্লিষ্ট Auth user-এর অবস্থা/Email confirmed দেখা। Email/password বা invitation token chat-এ পাঠানো যাবে না।
- Workflow-তে Owner, Admin ও Member—তিনটি পৃথক Staging Auth user-এর সঠিক email/password দিয়ে password-grant login বাধ্যতামূলক। ব্যবহারকারী এখন পর্যন্ত একটি Gmail-এ invitation পাঠিয়েছেন; একটি invitation দিয়ে তিনটি পৃথক test identity পূরণ হয় না। Owner/Admin/Member account তৈরি ও password নিশ্চিত না হওয়া পর্যন্ত Auth preflight ব্যর্থ থাকবে এবং migration preview/apply, role/RPC acceptance নিরাপত্তার কারণে চলবে না।
- কোড পরিবর্তন করা হয়নি: Microsoft account prompt ব্রাউজার/ডিভাইসের sign-in flow; GitHub workflow বা application code দিয়ে তা ঠিক করা যায় না। Auth preflight bypass করা, একটি Gmail-কে তিনটি role হিসেবে ব্যবহার করা, অথবা invitation-কে confirmed/password-ready account ধরে নেওয়া নিরাপদ নয়।
- সর্বশেষ প্রমাণিত workflow ফলাফল অপরিবর্তিত: Run #5 (46077272231) encrypted Staging backup + isolated restore PASS; Owner/Admin/Member password Auth preflight FAIL; migration ও role/RPC ধাপ skipped। Production database অপরিবর্তিত।

## 23. ২৮ নভেম্বর ২০২৬ — Staging Validation Run #15: Backup/Restore PASS, তিন Auth login FAIL

- GitHub Actions-এর official run number: **#15**; Run ID: `46077272231`; commit: `24917e39ee778233ada41a3102fdd6ad30a7f514`.
- Run URL: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46077272231
- Job `Encrypted Staging backup and isolated restore proof`: **SUCCESS**। Session Pooler URI validation, isolated PostgreSQL restore, non-empty schema proof এবং encrypted backup artifact upload—সব ধাপ সফল।
- Job `staging-migrations`: **FAILURE**। Staging secret/project binding check PASS; ordered migration set validation PASS (৩০টি migration file; duplicate version নেই)।
- ব্যর্থ ধাপ: `Preflight existing confirmed Owner, Admin and Member Auth accounts before any migration`।
- Log-এ OWNER, ADMIN ও MEMBER—তিনটির জন্যই একই safe category: `Credentials rejected or account not found in this Staging project`। কোনো email/password/API key/JWT প্রকাশ করা হয়নি।
- Migration Preview, Apply, role assignment, role/RPC verification ও queue-worker assessment—সবই Auth preflight failure-এর কারণে skipped। কোনো migration চালানো হয়নি।
- **এটি নতুন আলাদা Run ID নয়**: পূর্ববর্তী নোটে এই ID-কে Run #5 বলা হয়েছিল; GitHub Actions API-তে official run_number হলো **15**। সঠিক রেফারেন্স এখন Run #15 (ID একই)।
- **পরবর্তী প্রয়োজনীয় কাজ—শুধু Staging Auth account/secret মিল ঠিক করা:** Supabase Dashboard → Staging project `awatzrapqrteybgspqlq` → Authentication → Users-এ আলাদা Owner, Admin ও Member test account আছে এবং প্রত্যেকটির email confirmed কি না যাচাই করুন। এরপর GitHub Repository Secrets-এর `STAGING_OWNER_EMAIL/PASSWORD`, `STAGING_ADMIN_EMAIL/PASSWORD`, `STAGING_MEMBER_EMAIL/PASSWORD`-এ সেই একই account-এর exact email ও বর্তমান password রাখুন। Password অজানা হলে সংশ্লিষ্ট Staging account-এর password reset করে নতুন password কেবল GitHub Secret-এ সংরক্ষণ করুন। কোনো secret বা password chat-এ দেবেন না।
- Supabase invitation email-এ Accept invitation পাঠানো মানেই password login প্রস্তুত/confirmed নয়; invitation accept করে account complete করতে হবে। একটি Gmail invitation তিনটি আলাদা test identity-এর বিকল্প নয়।
- **কোড পরিবর্তন করে Auth gate পাশ করানো যাবে না**: invalid credentials-কে success দেখানো, preflight skip করা, তিন role এক user-এ মেশানো বা migration safety gate সরানো নিষিদ্ধ। GitHub encrypted Secrets-এর প্রকৃত মান assistant পড়তে/পরিবর্তন করতে পারে না; ব্যবহারকারী Secret আপডেট করার পর নতুন manual Staging run প্রয়োজন।
- Production project `lztbbrzeuyjkuiyzrsxp` স্পর্শ করা হয়নি; Production migration হয়নি।
- **প্রমাণিত সম্পন্ন:** Staging encrypted backup + isolated restore।
- **এখনো অসম্পন্ন:** Auth preflight, Staging migration dry-run/apply, Owner/Admin/Member role acceptance, Admin RPC acceptance এবং queue-worker assessment।
