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


## ১১. ২৬ নভেম্বর ২০২৬ — ৪,০০০ প্রজেক্টের কেন্দ্রীয় অটোমেশন ও দ্বৈত-মুদ্রা আয় পরিকল্পনা

- Owner-এর সর্বশেষ নির্দেশ: মোট ৪,০০০ project slot; MW-USD-0001–2000 থেকে বাস্তব settled USD revenue এবং MW-BDT-0001–2000 থেকে বাস্তব settled BDT revenue লক্ষ্য। সব project একই central automation control plane-এর অধীনে থাকবে, তবে USD/BDT ledger, provider, FX, tax/fee ও payout reconciliation আলাদা থাকবে।
- Admin-এর জন্য একটি Free Admin entitlement এবং একটি Paid Admin plan; সাধারণ Member paid plan কিনে verified payment settlement ও entitlement check-এর পর plan-সংশ্লিষ্ট automation চালাবেন। Plan purchase কোনো কাজ/আয়/লাভ নিশ্চিত করে না।
- নতুন specification: docs/4000_PROJECT_AUTOMATION_AND_DUAL_CURRENCY_REVENUE_BN.md। এটি লক্ষ্য/architecture specification; ৪,০০০ project implementation বা live income নয়।
- বর্তমান repository-তে AI assistant, Work & Earn, referral wallet, payment-state/checkout migration source ও wallet/profit RPC foundation আছে। কিন্তু Company Revenue Ledger, complete plan checkout→verified webhook→entitlement activation, ৪,০০০ project registry/orchestrator, production USD/BDT revenue/payout integration এবং production acceptance tests এখনো যাচাইকৃতভাবে Live নয়।
- Member Auto Work paid package checkout/execution existing safety policy অনুযায়ী Disabled/Not Live থাকবে; ১০০% liquid refund reserve, separate operating budget, isolated infrastructure, provider/legal/security gates ও tests ছাড়া চালু নয়। নতুন পরিকল্পনা এই gate override করে না।
- Production migration apply, billing/payment execution ও live deployment-এর জন্য আলাদা explicit approval বাধ্যতামূলক।


## ১২. ২৬ নভেম্বর ২০২৬ — ৪,০০০ প্রজেক্টের Free + Paid access clarification ও অটোমেশন অগ্রগতি

- Owner স্পষ্ট করেছেন: ৪,০০০টির প্রতিটি project-এ দুটি option থাকবে—Free Option এবং Paid Automatic Plan। Admin Free Option ব্যবহার করতে পারবেন এবং চাইলে Paid Plan কিনবেন; সাধারণ Member-এর paid automation চালু হবে কেবল verified paid-plan settlement-এর পর। Paid tier count/price/feature matrix এখনো নির্ধারিত নয়; এই নির্দেশে দুটি option মানে Free + Paid, দুটি paid tier নয়।
- **যাচাইকৃত automation foundation:** GitHub Actions-এ daily backup/restore preview, weekly read-only DB audit এবং প্রতি ৬ ঘণ্টায় DB health monitoring workflow source রয়েছে। এগুলো infrastructure/database safety automation; customer earning projects বা payment-to-plan activation নয়.
- **যাচাইকৃত product foundation:** AI Assistant Edge Function, Work & Earn board/migration, referral wallet/reward foundation, verified-payment/checkout migration source এবং Work & Earn wallet/Owner-profit settlement migration source repository-তে আছে।
- **বড় অটোমেশন এখনো বাকি:** ৪,০০০ project registry ও orchestration/worker fleet, per-project scheduler/queue/budget controls, Company Revenue Ledger, complete Premium/AI plan catalog and checkout-to-entitlement flow, USD/BDT settlement & payout integrations, Admin/Member entitlement enforcement এবং end-to-end/load/security acceptance tests.
- **Current verified progress:** foundation and specification stage only; ৪,০০০ earning project চালু নয়, paid plan purchase/activation production-live নয়, কোনো নতুন আয় বা payout প্রমাণিত নয়। Production DB apply, billing/payment execution এবং live deployment পৃথক অনুমোদন ছাড়া করা যাবে না।


## ১২. ২৬ নভেম্বর ২০২৬ — ধাপ ২: Central 4,000 Project Automation Engine (source foundation)

- Feature branch: `planning/4000-automated-project-economy`; PR #20 remains Draft/Open and is not merged.
- Added `supabase/migrations/20261126110000_project_automation_engine.sql` with per-project scheduler settings, worker registry/heartbeat, idempotent task queue, task leases, bounded retries/dead-letter state, audit trail and admin overview.
- Central controller overview aggregates all registered projects, scheduler state, worker state and recent task status. Scheduler enqueue is a server-role-only entry point and only creates tasks for projects whose registry execution flag and approved positive budget are already enabled.
- Worker claim/finish operations require service_role, an active recent heartbeat, a valid lease token, currency compatibility and project/task daily budget checks. One running task per project is enforced.
- New projects receive no scheduler settings, workers or tasks from this migration. Execution remains blocked because Step 1 registry seeds execution_enabled=false and budget_cap=0. No external connector, revenue collection, payment or payout is included.
- Added `supabase/audits/project_automation_engine_read_only.sql` and `scripts/verify-project-automation-engine.py`; added the verifier to the migration-safety GitHub Actions workflow.
- **Verification status:** GitHub Actions run for this exact commit is pending; static verification and SQL disposable-database application have not yet been confirmed. The migration is not applied to Production. PR #20 remains Draft/Open/Unmerged.
- **Next:** run static checks and disposable database migration validation; correct any failures; then design Step 3 Free/Paid entitlement activation without enabling member paid automation or collecting fees until existing refund-reserve, payment-provider and legal/security gates pass.

- **CI evidence update:** PR migration-safety workflow Run `45866578250` completed successfully; the new `Verify central project automation engine safety` step passed (job `140070826818`, step 8). The separate Auto Work static workflow Run `45866578261` also passed. This is static source verification only; no disposable PostgreSQL apply or Production migration apply is confirmed.


## ১৩. Owner-এর নতুন বাধ্যতামূলক product requirement — বাস্তব গ্রাহক ও Member financial safety (২৬ নভেম্বর ২০২৬)

- Customer-led demand: বাস্তব customer-রা project-এ কাজের order/service request/subscription আনবেন; ভুয়া customer/order/task/revenue নিষিদ্ধ। প্রতিটি project-এর জন্য customer acquisition, catalog/discovery, order intake, payment, delivery, acceptance, support, refund/dispute flow তৈরি ও মাপতে হবে।
- Scale ambition: ১ কোটি (১০,০০০,০০০)+ বাস্তব customer দীর্ঘমেয়াদি লক্ষ্য; বর্তমান অর্জন বা নিশ্চয়তা নয়। staged growth ও evidence ছাড়া customer count বা capacity দাবি করা যাবে না।
- সাধারণ Member protection: কাজ পাওয়ার জন্য deposit/recharge/unlock fee বাধ্যতামূলক নয়; paid plan ঐচ্ছিক এবং কাজ/আয়ের নিশ্চয়তা নয়। Customer-funded order-এ provider settlement ও segregated funding verify না হওয়া পর্যন্ত কাজ শুরু নয়।
- কাজ শুরুর আগে scope, price/currency, deadline, acceptance, revision, cancellation, dispute/refund এবং Member payable প্রকাশ করতে হবে। Member payable, customer refund liability ও platform operating funds পৃথক রাখতে হবে।
- Screenshot/client-side payment status নয়; signed/server-side provider settlement, idempotency, duplicate/fraud checks, audit trail, chargeback/refund workflow, kill switch এবং support process আবশ্যক।
- কোনো সফটওয়্যার সম্পূর্ণ loss-free guarantee দিতে পারে না; তবে Member-কে নিজের টাকা দিয়ে customer shortfall পূরণ করানো যাবে না এবং unfunded order-এ কাজ শুরু করানো যাবে না। Reserve, funded-order gate ও dispute controls launch blockers।
- এই requirements docs/4000_PROJECT_AUTOMATION_AND_DUAL_CURRENCY_REVENUE_BN.md-এর Section 10-এ যোগ করা হয়েছে। ১ কোটি customer এখনও target, actual user/customer count নয়।
- Production migration, real payment/payout, public launch বা irreversible action-এর জন্য পৃথক approval/safety gate অপরিবর্তিত।


## ১৪. ২৬ নভেম্বর ২০২৬ — ধাপ ৩: Free + Paid Plan ও customer-paid order foundation

- Added migration `20261126120000_free_paid_plan_customer_order_gates.sql`:
  - Admin ও Member-এর পৃথক Free/Paid plan catalog;
  - server-verified payment metadata ছাড়া paid subscription Active হতে পারে না;
  - customer service order-এর মূল্য অবশ্যই positive; free browsing/quote আর paid service delivery আলাদা;
  - funded/in-progress কাজের আগে provider settlement, segregated order funds, refund reserve ও operating budget verification বাধ্যতামূলক;
  - Member payable + refund liability + operating cost customer gross price-এর মধ্যে cover না হলে কাজ fail-closed;
  - own-record read policies এবং service-role-only writes।
- Paid plan price/period/features অনুমান করে বসানো হয়নি; কোনো plan row seed/enable করা হয়নি।
- Added `scripts/verify-plan-customer-order-gates.py` and wired into Supabase migration-safety workflow.
- **Status:** source foundation only. Provider checkout/webhook, actual reserve custody, plan activation, order worker, payout, production apply and end-to-end runtime tests are NOT LIVE / NOT VERIFIED. No customer payment or income was collected/generated.
- Customer Free Option cannot mean free work delivery. Customer service work must be a positive-price funded order; Free may cover browsing/quote or explicitly approved non-delivery access only.


## ১৫. ২৬ নভেম্বর ২০২৬ — Member-এর অর্থ সুরক্ষা (সর্বোচ্চ অগ্রাধিকার)

- Step 3 migration-এ `customer_order_fund_allocations` যোগ: প্রতিটি অর্ডারের Member payable, refund/chargeback reserve এবং operating cost-এর জন্য তিনটি পৃথক currency-matched locked allocation।
- অর্ডার funded/in-progress হওয়ার আগে তিনটি allocation ঠিক অর্ডারের হিসাবের সঙ্গে মেলা ও locked থাকা, provider settlement, project activation, scope terms, external segregation, refund reserve এবং operating budget verification বাধ্যতামূলক।
- Member payable platform operating money নয়; Member-এর নিজের deposit/recharge বা customer shortfall পূরণের দায় নেই। Member payout কেবল reconciled settled funds থেকে হওয়া উচিত।
- বাস্তব safeguarded custody account, signed webhook, daily reconciliation, dispute/chargeback workflow এবং payout integration এখনও তৈরি/যাচাইকৃত নয়। Database row বাস্তব bank custody-এর প্রমাণ নয়; Member-এর অর্থ এখনো এই কোড দ্বারা বাস্তবে সংরক্ষিত হয়নি।
- নতুন static verifier-এ এই সুরক্ষা পরীক্ষা যুক্ত করা হয়েছে। Production apply নিষিদ্ধ/অনুমোদিত হয়নি।


## ১৬. ২৬ নভেম্বর ২০২৬ — Member Loss-Prevention Hard Security

- Added `supabase/migrations/20261126130000_member_loss_prevention_hardening.sql`.
- Customer order-এর financial terms ও identity পরিবর্তন নিষিদ্ধ; funded order-এর scope এবং settlement/segregation evidence immutable; allocation row update/delete নিষিদ্ধ; allow-listed order lifecycle ও no-backward-transition guard যোগ; funded/financially resolved order delete নিষিদ্ধ।
- Database triggers service-role write-সহ database mutation path-এ প্রযোজ্য; correction path হলো order cancel করে নতুন order, পুরোনো allocation rewrite নয়।
- Static verifier `scripts/verify-plan-customer-order-gates.py` নতুন guard পরীক্ষা করে; Supabase migration safety workflow-এ এটি চালানো হয়।
- **সীমাবদ্ধতা:** এটি software-level tamper-resistance/fail-closed control; real custody, reserve funding, solvency, provider signature, refund/payout বা Member ক্ষতিপূরণের বাস্তব নগদ সামর্থ্য নয়। Runtime disposable PostgreSQL validation এবং external safeguarded custody/audit/payout integration বাকি। Production apply/merge/deploy হয়নি।


## ১৭. ২৬ নভেম্বর ২০২৬ — Double-entry Ledger ও payout/refund runtime foundation

- Added `20261126140000_append_only_double_entry_finance_ledger.sql`: USD/BDT পৃথক chart of accounts, append-only balanced journals/lines, idempotent posting, Member-specific payable overdraft prevention এবং ledger integrity RPC।
- Added `20261126150000_guarded_member_payout_refund_workflows.sql`: service-only Member payout/customer refund requests, immutable terms, allowed state transitions, pending amount reservation, এবং paid state-এর আগে provider settlement + reconciliation + matching journal বাধ্যতামূলক।
- Added static verifiers `verify-member-finance-ledger.py`, `verify-member-payout-refund.py`; disposable PostgreSQL 16 runtime workflow `verify-member-finance-ledger-runtime.yml` ও test scripts।
- **কোনো Live rail নয়:** internal journal/request নিজে bank balance, safeguarded custody, refund reserve বা টাকা পাঠানোর প্রমাণ নয়। Provider-specific signed webhook, bank/custodian, actual payout/refund connectors ও independent daily reconciliation এখনও বাকি। Production apply/merge/deploy করা হয়নি।


### ১৭.১ Verification result

- Disposable PostgreSQL 16 runtime workflow run `45872273474`: **success** — ledger ও payout/refund migrations test database-এ apply হয়েছে; balanced/idempotent journal, currency mismatch rejection, immutable journal, Member overdraft guard, pending payout reservation এবং paid-state journal evidence পরীক্ষা পাস।
- Migration Safety CI `45872273373`: **success**; Auto Work Static Safety `45872273321`: **success**।
- Runtime test Production-এ নয়; Production migration apply, bank custody, live payment/payout/refund বা revenue চালু হয়নি।

## ১৮. ২৭ নভেম্বর ২০২৬ — বিকাশ/নগদ/ব্যাংক payout ও Admin commission requirement

- Owner requirement: Member-এর payout method হিসেবে বিকাশ, নগদ ও ব্যাংক অ্যাকাউন্ট যোগ করার সহজ option থাকবে। Member নিজের payout destination যোগ করতে পারবে; sensitive account data encrypted/tokenized ও masked রাখতে হবে; OTP/PIN/password সংগ্রহ করা যাবে না।
- বিকাশ/নগদ withdrawal request Admin approve না করা পর্যন্ত transfer হবে না। Approval-এর পরও official provider payout rail, eligibility, settlement ও reconciliation checks বাধ্যতামূলক। Provider/company/KYC/legal permission bypass করা যাবে না।
- Bank account Member নিজে যোগ করতে পারবে। Verified ownership, KYC/AML/fraud checks এবং bank/payment partner-এর অনুমোদিত rail সক্রিয় থাকলে policy-based automatic payout Admin-এর প্রতিটি request-এর আলাদা approval ছাড়াই হতে পারে। এটি bank/provider permission ছাড়া transfer করার অনুমতি নয়। High-risk/new destination/limit breach হলে manual review ও fail-closed।
- প্রতিটি paid completed work-এ configurable Admin commission থাকবে। কোনো percentage hard-code করা হয়নি; কাজ শুরুর আগে commission rate/basis, provider fee, reserve, operating cost ও Member net payable দেখাতে হবে। Rate order acceptance-এ immutable snapshot; commission আলাদা company-revenue ledger-এ, USD/BDT পৃথকভাবে।
- Full design: docs/PAYOUT_METHODS_ADMIN_APPROVAL_AND_PLATFORM_COMMISSION_BN.md.
- Status: requirement/specification only. bKash/Nagad/bank adapter, account ownership verification, live transfer, automatic payout, commission calculation/collection এখনো implemented/live নয়। Production migration/deployment বা real money movement হয়নি।
