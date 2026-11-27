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
- Encrypted full logical backup এবং isolated restore test চালায়।- Remote migration history inspect করে।- বর্তমান সংশোধনের পর remote migration history শুধু inspect করে; স্বয়ংক্রিয় `migration repair` আর চালায় না।
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
- `.github/workflows/secure-supabase-db-update.yml`-এ আগে required migration check কেবল ২৬টি file যাচাই করত; শেষ ৪টি migration যোগ করে সম্পূর্ণ ৩০টি যাচাই করা হয়েছে।- Commit: `1b33f3eea0beedb9b02d5108c507a7210b2a5887`।

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
- Scale ambition: ১ কোটি (১০,০০০,০০০)+ বাস্তব customer দীর্ঘমেয়াদি লক্ষ্য; বর্তমান অর্জন বা নিশ্চয়তা নয়। staged growth ও evidence ছাড়া customer count বা capacity দাবি করা যাবে না।- সাধারণ Member protection: কাজ পাওয়ার জন্য deposit/recharge/unlock fee বাধ্যতামূলক নয়; paid plan ঐচ্ছিক এবং কাজ/আয়ের নিশ্চয়তা নয়। Customer-funded order-এ provider settlement ও segregated funding verify না হওয়া পর্যন্ত কাজ শুরু নয়।
- কাজ শুরুর আগে scope, price/currency, deadline, acceptance, revision, cancellation, dispute/refund এবং Member payable প্রকাশ করতে হবে। Member payable, customer refund liability ও platform operating funds পৃথক রাখতে হবে।
- Screenshot/client-side payment status নয়; signed/server-side provider settlement, idempotency, duplicate/fraud checks, audit trail, chargeback/refund workflow, kill switch এবং support process আবশ্যক।- কোনো সফটওয়্যার সম্পূর্ণ loss-free guarantee দিতে পারে না; তবে Member-কে নিজের টাকা দিয়ে customer shortfall পূরণ করানো যাবে না এবং unfunded order-এ কাজ শুরু করানো যাবে না। Reserve, funded-order gate ও dispute controls launch blockers।
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


### ১৮.১ Admin commission হার প্রস্তাব (২৭ নভেম্বর ২০২৬)

- Owner-এর নির্দেশে প্রতি completed/accepted paid work order-এর Admin commission **২০% প্রস্তাবিত** হিসেবে নথিভুক্ত।
- এটি এখনো enabled নয়; calculation basis, provider fee, tax, refund/chargeback reversal ও rounding policy নির্ধারণ এবং customer/Member disclosure ছাড়া কোনো টাকা কাটা বা ledger-এ commission post করা যাবে না।
- অনুমোদিত হলে কাজ শুরুর আগেই rate ও Member net payable দেখাতে হবে; accepted/completed + settled/reconciled হওয়ার পর আলাদা Company Revenue Ledger-এ post হবে; USD/BDT পৃথক থাকবে।
- Detailed policy: `docs/PAYOUT_METHODS_ADMIN_APPROVAL_AND_PLATFORM_COMMISSION_BN.md`।


## ১৯. ২৭ নভেম্বর ২০২৬ — Release Readiness যাচাই ও লাইভ করার গেট

- Owner routine engineering updates-এর মাধ্যমে Release-Ready প্রস্তুতির কাজ এগিয়ে নিতে বলেছেন। সেই অনুযায়ী `docs/RELEASE_READINESS_MASTER_WORLD_VIP_BN.md` যোগ করা হয়েছে; এতে যাচাইকৃত CI evidence, Production blockers, provider/custody prerequisites এবং ধাপে ধাপে release sequence নথিভুক্ত।
- PR #20-এর সর্বশেষ পর্যবেক্ষিত head: `c23d565217cd53cb443fe6fb1bed51d8b64565a8`; PR এখনও Draft/Open/Unmerged।
- 27 Nov CI: disposable PostgreSQL 16 finance-ledger/payout-refund runtime run `45872393975` success; migration safety run `45872394002` success; Auto Work static safety run `45872393894` success।
- Runtime test কেবল isolated DB-তে ledger ও payout/refund migrations পরীক্ষা করে; এটি full migration chain বা Production schema apply-এর প্রমাণ নয়।
- বাকি release blocker: full-chain clean disposable DB validation, Production read-only schema/RLS audit, provider-specific sandbox/webhook, lawful merchant onboarding, real segregated custody/refund reserve, daily reconciliation, actual payout/refund rails, worker service, plan/pricing/commission details, security/load/end-to-end acceptance tests।
- ২০% Admin commission এখনও proposal-only; payout methods ও bank self-enrollment specification-only; কোনো live money movement/commission posting নয়।
- Routine source/docs/test updates চলতে পারে। Production migration apply, migration-history repair, public deployment, live billing/payout এবং bank/provider account/KYC change আলাদা explicit approval ছাড়া করা যাবে না। Migration apply-এর exact phrase: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`।


### ১৯.১ Release-readiness CI refresh (২৭ নভেম্বর ২০২৬)

- Documentation release-readiness update-এর পর PR head `2ba5af6027f2f8fecd23ae5ce837079ca6e7b44d`-এ নতুন CI আবার যাচাই করা হয়েছে।
- Disposable PostgreSQL 16 finance runtime run `45874411633`: **success**।
- Supabase Migration Safety run `45874411687`: **success**।
- Auto Work Static Safety run `45874411490`: **success**।
- এই ফলাফল isolated finance migration runtime ও static source safety নিশ্চিত করে; full ordered migration chain Production schema-তে apply হবে, provider settlement/custody বা live payout কাজ করছে—এগুলো প্রমাণ করে না। Release status এখনও NOT READY / NOT LIVE।


### ১৯.২ Owner-এর payout/KYC সহজীকরণ নির্দেশনা (২৭ নভেম্বর ২০২৬)

- Owner routine updates-এ বাকি release/payment readiness এগিয়ে নিতে বলেছেন; live KYC/Merchant/bank approval bypass করার অনুরোধও করেছেন। Live transfer-এর ক্ষেত্রে provider/bank/legal বাধ্যতামূলক approval bypass করা যাবে না। সহজ payout UI, Admin approval queue এবং synthetic mock sandbox করা যাবে; mock test real money নয়। Official sandbox কেবল provider-এর অনুমোদিত sandbox access/terms অনুযায়ী।
- Payout specification-এ no-bypass rule এবং ২০% commission-এর proposal-only distributable-margin calculation যোগ হয়েছে: settled gross − provider fees − tax − full Member payable − refund reserve funding − approved direct operating cost; positive margin-এর ২০%, অন্যথায় শূন্য। Owner/legal/tax approval ছাড়া এটি সক্রিয় নয়।
- Full migration-chain disposable Supabase-compatible run এবং Production read-only audit এখনও বাকি; production credentials/DB access নিরাপদ secret-backed environment-এ না থাকলে তা সম্পন্ন দাবি করা যাবে না।
- Real custody/reserve, daily bank/provider reconciliation, worker deployment, signed webhook ও live payout/refund rail external provider/bank access ও অনুমোদন ছাড়া complete নয়। এই update-এ কোনো Production/live action হয়নি।


## ১২. ২৭ নভেম্বর ২০২৬ — Server-authorized Admin Dashboard source update

- Added `www/admin-dashboard.js` and loaded it from `www/index.html` on the planning branch. The separate Admin Dashboard checks the authenticated Supabase session and server-returned `get_my_admin_access` role before showing the privileged view.
- The view reads the 4,000-project Registry, worker summary and recent task counts through `admin_project_automation_overview`; it is read-only and cannot enable schedules, enqueue tasks or start workers.
- Added `scripts/verify-admin-dashboard.py` and wired it into `.github/workflows/verify-supabase-migrations.yml`.
- Implementation notes and exact release limitations: `docs/ADMIN_DASHBOARD_IMPLEMENTATION_STATUS_BN.md`.
- **Not Live / not yet verified:** these changes are on Draft PR #20 only. They have not been merged or deployed. Required Supabase migrations/RBAC/Owner bootstrap are not thereby applied to Production; no Production database or live deployment action was taken. The new UI cannot prove the live backend is connected until staging/Production RPC calls are tested with separate Owner/Admin/Member accounts.
- Worker execution remains NOT READY; no worker service is deployed. Dashboard intentionally provides read-only visibility and leaves execution disabled.


## ১৩. ২৭ নভেম্বর ২০২৬ — Staging Auth/RBAC workflow ও Worker foundation

- Added `.github/workflows/validate-staging-supabase.yml`: Staging-only full ordered migration preview/apply, fresh login for three separate Owner/Admin/Member test accounts, Owner-RPC role assignment, role/RPC access assertions, and Staging Edge Function deployment. It refuses the known Production project ref.
- Staging GitHub Actions secrets required: `STAGING_SUPABASE_ACCESS_TOKEN`, `STAGING_SUPABASE_DB_URL`, `STAGING_SUPABASE_PROJECT_REF` (must differ from Production), `STAGING_SUPABASE_URL`, `STAGING_SUPABASE_ANON_KEY`, and separate `STAGING_OWNER_EMAIL/PASSWORD`, `STAGING_ADMIN_EMAIL/PASSWORD`, `STAGING_MEMBER_EMAIL/PASSWORD`. Never paste these into chat.
- Added `supabase/functions/project-automation-worker/index.ts` and `.github/workflows/verify-project-automation-worker.yml`. Worker foundation registers and heartbeats using service-role RPCs but intentionally stays idle; no approved business task handlers exist, so it does not claim tasks or execute revenue work. Function is disabled unless `MWVIP_WORKER_ENABLED=true` is set in the target Supabase project.
- Added `docs/STAGING_AUTH_AND_WORKER_READINESS_BN.md` for exact scope and limitations.
- **Not yet run:** no Staging secrets/project credentials are available in this conversation; workflows have been added but not dispatched. Therefore no actual Staging migration, three-account test, or Staging Edge Function deploy is claimed complete.
- **Not Live:** PR #20 remains Draft/Open/Unmerged. No Production migration, Production Worker deploy, public deployment, or real money operation was performed. Production migration still requires explicit exact approval and backup/restore evidence.

---

## ১৪. ২৭ নভেম্বর ২০২৬ — Staging Workflow hardening ও পরবর্তী কাজের একক রেকর্ড
### আজ সম্পন্ন — Source/Workflow/Documentation
- .github/workflows/validate-staging-supabase.yml-এর Staging preflight আরও শক্ত করা হয়েছে:
  - STAGING_SUPABASE_DB_URL PostgreSQL URL কি না যাচাই করে;
  - pooler username-এ .<STAGING_SUPABASE_PROJECT_REF> suffix আছে কি না যাচাই করে, যাতে ভুল project/ref-এর DB URL ধরা যায়;
  - পরিচিত Production project ref lztbbrzeuyjkuiyzrsxp Staging হিসেবে ব্যবহার করলে workflow বন্ধ হয়;
  - Owner, Admin ও Member login তিনটি আলাদা Supabase Auth user ID কি না যাচাই করে;
  - role verification output path সংশোধন করা হয়েছে।
- Workflow-টি Staging-এ full migration chain, Owner/Admin/Member authentication ও RBAC assertions, তারপর Staging Edge Function deployment-এর জন্য প্রস্তুত। এটি Production target করার workflow নয়।
- Staging workflow-এর প্রয়োজনীয় Secret-গুলোর নাম ও নিরাপদ setup নির্দেশনা এই handover-এর আগের Staging section-এ আছে; কোনো Secret value এখানে বা Chat-এ রাখা যাবে না।
- Worker foundation-এর সীমা স্পষ্ট রাখা হয়েছে: service-role registration ও heartbeat আছে; allow-listed business task handler না থাকায় worker এখনো task claim/execute করে না; revenue চালু করে না; default disabled।
- এই নথির আগের Staging/Worker section-গুলোই বিস্তারিত implementation record; একই migration বা feature আবার তৈরি করার প্রয়োজন নেই।

### আজকের GitHub অবস্থা — যাচাই করা
- Repository: rakib12301111-droid/master-world-vip
- Branch: planning/4000-automated-project-economy
- PR #20: https://github.com/rakib12301111-droid/master-world-vip/pull/20
- সর্বশেষ যাচাইকৃত PR head (এই handover update-এর আগে): 84eb0ba4d17c8511e8468a980ec5854a76b90172
- PR state: Open, Draft, Unmerged; merge হয়নি।
- ওই head-এর জন্য workflow run ও combined status তালিকা খালি পাওয়া গেছে। তাই এই সর্বশেষ workflow-hardening commit-এর নতুন CI সফল হয়েছে—এমন দাবি করা হচ্ছে না।
- এই handover update branch-এ আলাদা commit হিসেবে যোগ হবে; commit SHA update সম্পন্ন হওয়ার পর পরবর্তী handover record-এ নথিভুক্ত থাকবে।

### এখনো অসম্পন্ন — স্পষ্টভাবে আলাদা রাখা হলো
1. Staging project ও প্রয়োজনীয় GitHub Actions Secrets এখনো নিশ্চিত/প্রদান করা হয়নি; তাই validate-staging-supabase.yml dispatch বা বাস্তব Staging migration/Auth/RBAC test চালানো হয়নি।
2. Staging-এ Owner/Admin/Member তিন-account login ও permission test সফল হওয়ার প্রমাণ নেই।
3. Staging Edge Function deploy হয়নি; Worker-এর বাস্তব business task handler নেই এবং worker execution disabled।
4. Full ordered migration chain-এর clean disposable/Staging validation সম্পন্ন হয়েছে বলে নতুন কোনো প্রমাণ নেই।
5. বর্তমান Production read-only schema/RLS audit ও recoverable backup/restore evidence আবার যাচাই করা বাকি; আগের backup/audit record-কে নতুন Staging বা release evidence হিসেবে গণ্য করা যাবে না।
6. Provider sandbox ও signed webhook, lawful merchant onboarding, safeguarded USD/BDT custody, refund reserve, daily reconciliation, বাস্তব payout/refund rail, plan pricing, security/load/end-to-end tests অসম্পন্ন।
7. ২০% Admin commission কেবল proposal; সক্রিয় নয়। কোনো real customer payment, Member payout, refund transfer, commission collection বা project revenue নেই।

### নিরাপত্তা ও অনুমোদনের অপরিবর্তিত সীমা
- Production migration apply, migration-history repair, destructive SQL, live data change, real billing/payment/payout এবং public deployment এই update-এ করা হয়নি।
- Production migration-এর আগে আলাদা স্পষ্ট approval phrase APPLY-MASTER-WORLD-VIP-MIGRATIONS এবং সব পূর্বশর্ত—clean full-chain test, read-only Production audit, valid backup ও successful restore rehearsal, release readiness—পূরণ করতে হবে। Phrase একা readiness-এর বিকল্প নয়।
- Public/live deployment-এর জন্যও পৃথক explicit approval এবং Release Readiness pass প্রয়োজন।
- bKash/Nagad/bank/provider KYC, merchant বা legal approval bypass করা যাবে না।
- কোনো secret, password, token, OTP বা encryption passphrase handover-এ লেখা যাবে না।

### পরবর্তী সেশনের শুরু — একই কাজ পুনরায় নয়
1. প্রথমে এই handover এবং বর্তমান PR/branch head পড়ুন; আগের migration, registry, ledger, payout workflow, Admin Dashboard বা Staging workflow পুনরায় তৈরি করবেন না।
2. GitHub Settings → Secrets and variables → Actions-এ কেবল Staging-এর নিজস্ব project credentials ও তিনটি পৃথক test account-এর Secret যোগ হয়েছে কি না যাচাই করুন। Secret value Chat-এ চাইবেন/নেবেন না।
3. Secret প্রস্তুত থাকলে একই branch-এ validate-staging-supabase.yml একবার dispatch করুন; run ID, job/step ফলাফল ও log দেখে প্রতিটি সফল/ব্যর্থ ধাপ নথিভুক্ত করুন। ব্যর্থ হলে error ঠিক করে প্রয়োজনীয় ধাপটুকু পুনরায় চালান—পুরো feature/migration অকারণে আবার তৈরি নয়।
4. Staging pass হলে allow-listed business task type, input validation, authorization, idempotency, budget/timeout/retry, audit ও sandbox test-সহ Worker handler বাস্তবায়ন/যাচাই এগিয়ে নিন; arbitrary code execution নয় এবং production worker disabled রাখুন।
5. Backup/restore ও Production read-only audit-এর বর্তমান প্রমাণ সংগ্রহ করে Release Readiness checklist আপডেট করুন। সব gate pass না করা পর্যন্ত Production migration বা public deployment নয়।

**আজকের চূড়ান্ত অবস্থা:** Source ও workflow preparation এগিয়েছে; Staging run এখনো হয়নি; PR #20 Draft/Open/Unmerged; Production অপরিবর্তিত; MASTER WORLD VIP Live নয় এবং আয়/পেমেন্ট চালু নয়। পরবর্তী কাজের একমাত্র starting point হবে উপরের “পরবর্তী সেশনের শুরু” তালিকা।

### ১৪.১ এই handover update-এর commit confirmation
- Handover file update commit: b85162987db2ddafedc33b87bb646682e256a8d9.
- Update-এর পর PR #20 head একই commit SHA-তে যাচাই করা হয়েছে: Open / Draft / Unmerged.
- Updated handover file: https://github.com/rakib12301111-droid/master-world-vip/blob/planning/4000-automated-project-economy/PROJECT_HANDOVER_MASTER_BN.md.
- এই নথির সর্বশেষ যাচাইকৃত blob SHA: 8e1385803dce10592c467c14d2c4644ec68295cb.


## ১৫. ২৭ নভেম্বর ২০২৬ — Live করার অনুরোধ, বর্তমান যাচাই ও পরবর্তী সেশনের শুরুর স্থান

### Owner-এর সর্বশেষ নির্দেশ
- Owner বলেছেন MASTER WORLD VIP-কে আপডেটের মাধ্যমে সম্পন্ন করে Live করতে এবং সব তথ্য এই `PROJECT_HANDOVER_MASTER_BN.md` ফাইলে রাখতে।
- Owner আজকের কাজ এখানেই থামিয়ে পরের দিন সঠিক জায়গা থেকে শুরু করতে চান; একই কাজ পুনরায় না করার নির্দেশ বহাল।
- এই Live করার লক্ষ্যকে গুরুত্ব দিয়ে কাজ এগোবে, কিন্তু Release Gate পাশ কাটিয়ে Production-এ ঝুঁকিপূর্ণ পরিবর্তন করা যাবে না। Routine source/docs/tests চলতে পারে; Production migration apply, migration-history repair, Production data write, real payment/payout এবং public/live release-এর নির্দিষ্ট নিরাপত্তা ও আলাদা অনুমোদন-সীমা বহাল।

### এই সেশনে যাচাই করা GitHub অবস্থা
- PR #20: https://github.com/rakib12301111-droid/master-world-vip/pull/20 — Open, Draft, Unmerged। যাচাইকৃত head: `97153d42e311748ecb2193d8914ae4eabca1bfe5`; base: `bfa7b582223b0c1caa9c1efd59858a3e94c66a3b`।
- Release Readiness নথির সিদ্ধান্ত এখনও **NOT READY FOR PRODUCTION / NOT LIVE**। PR-এ সম্পূর্ণ migration chain, Production read-only audit/backup-restore, payment provider sandbox/custody/payout rails, worker ও end-to-end readiness এখনো প্রমাণিত নয়।
- GitHub Actions-এর সাম্প্রতিক তালিকায় planning branch-এর commit `9f0a4c7cf2f3b7aeb50f9a5fd40b6ed163493741`-এ Worker verification, isolated PostgreSQL finance runtime, migration safety, Auto Work static safety এবং update-system check সফল দেখা গেছে। এগুলো ওই নির্দিষ্ট commit ও নির্দিষ্ট পরীক্ষার ফল; বর্তমান PR head `97153d4...`-এর পূর্ণ Release Readiness প্রমাণ করে না।
- GitHub Pages-এর `main` branch-এ আগের public homepage deployment সফল ছিল (run `45879349896`)। এটি শুধু homepage deployment-এর প্রমাণ; পূর্ণ MASTER WORLD VIP application, automation, payment বা revenue system Live হওয়ার প্রমাণ নয়।
- Staging validation workflow-এর বর্তমান সংজ্ঞা দেখা হয়েছে। এটি Staging secrets যাচাই, Staging-এ ordered migrations, Owner/Admin/Member RBAC পরীক্ষা এবং disabled অবস্থায় worker deploy করার জন্য। এই সেশনে Staging workflow সফলভাবে চালানোর কোনো নতুন প্রমাণ পাওয়া যায়নি; প্রয়োজনীয় Staging secrets/project প্রস্তুত আছে—এমন দাবিও করা হচ্ছে না। Secret values কখনো chat-এ চাইবে না।

### সুখবর — যা সত্যিই সফল হয়েছে
- Public GitHub Pages homepage আগে সফলভাবে publish হয়েছে।
- Planning branch-এ isolated PostgreSQL finance-ledger/payout-refund runtime test এবং একাধিক static safety workflow আগের নির্দিষ্ট commits-এ সফল হয়েছে।
- Worker source-এর verification workflow সফল হয়েছে; তবে Worker এখনও registration/heartbeat স্তরে, approved task handler ছাড়া বাস্তব কাজ বা আয় চালায় না।
- এই সাফল্যগুলো অগ্রগতি, কিন্তু পূর্ণ প্ল্যাটফর্ম Live বা আয় শুরু হওয়ার ঘোষণা নয়।

### পরবর্তী সেশনে ঠিক এখান থেকে শুরু — পুনরাবৃত্তি নয়
1. প্রথমে এই handover, PR #20-এর সর্বশেষ head এবং GitHub Actions-এর নতুন run status আবার পরীক্ষা করতে হবে; ইতিমধ্যে তৈরি migrations, ledger, payout/refund workflows, dashboard ও Staging workflow নতুন করে তৈরি করা যাবে না।
2. GitHub repository Settings → Secrets and variables → Actions-এ Staging-এর প্রয়োজনীয় secrets আছে কি না Owner নিজে পরীক্ষা করবেন; কোনো secret value chat-এ পাঠাবেন না।
3. Secrets ও আলাদা Staging project প্রস্তুত থাকলে কেবল `validate-staging-supabase.yml` workflow-এর `workflow_dispatch` ব্যবহার করে Staging validation চালাতে হবে; না থাকলে নিরাপদ source/tests/docs কাজ চালাতে হবে এবং Staging deployment হয়েছে বলে দাবি করা যাবে না।
4. Staging migration chain ও Auth/RBAC পরীক্ষা সফল হলে ফলাফল নথিভুক্ত করে পরের release blockers—Production read-only audit, backup/restore evidence, provider sandbox, custody/reconciliation, payout/refund rails, real worker handlers, pricing/security/E2E—একটি করে সমাধান করতে হবে।
5. সব Release Gate প্রমাণসহ পাস না করা পর্যন্ত Production migration apply বা public/live release করা যাবে না। Production migration-এর আলাদা অনুমোদন phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS`; phrase-টি একা যথেষ্ট নয়—আগে সব পূর্বশর্ত ও backup/restore evidence লাগবে। Public deployment ও live payment/payout-এর আলাদা অনুমোদনও বহাল।

### সময় ও সেশন সমাপ্তি
- এই সেশনের সময় যাচাই: বাংলাদেশ সময় ২৭ নভেম্বর ২০২৬, রাত ১:১০ (প্রায় ১:১০:৫৪, UTC+06:00)।
- Owner শুভরাত্রি জানিয়েছেন; পরের সেশনে উপরের ধাপ ১ থেকে সর্বশেষ অবস্থা যাচাই করে শুরু করতে হবে।
- বর্তমান অবস্থা: পূর্ণ প্ল্যাটফর্ম Production Live নয়; বাস্তব payment/payout বা আয় চালু হওয়ার প্রমাণ নেই।


## ১৬. ২৭ নভেম্বর ২০২৬ — পূর্ণ প্রকল্প পুনঃযাচাই সেশন (চলমান; কোনো Live অনুমোদন নয়)

### Owner-এর ১০ ঘণ্টার নির্দেশ ও বাস্তব সীমা
- Owner শুরু থেকে শেষ পর্যন্ত পুরো MASTER WORLD VIP যাচাই, ভুল সংশোধন, পরীক্ষা এবং কাজ শেষ হলে পরবর্তী অসম্পন্ন কাজ চালিয়ে যাওয়ার নির্দেশ দিয়েছেন; একই কাজ পুনরায় না করার শর্ত বহাল।
- এই ChatGPT কথোপকথন নিজে থেকে একটানা ১০ ঘণ্টা ব্যাকগ্রাউন্ডে কাজ চালাতে বা প্রতি ঘণ্টায় নিজে থেকে নতুন বার্তা পাঠাতে পারে না। Hourly automation cadence-ও উপলভ্য নয়। তাই ১০ ঘণ্টা সম্পূর্ণ কাজ হয়েছে বা প্রতি ঘণ্টার update নিশ্চিত—এমন দাবি করা যাবে না।
- বর্তমান সেশনে বাস্তবে যাচাই করা তথ্য ও সীমাবদ্ধতা নিচে লেখা হলো; পরবর্তী সেশনে এখান থেকে এগোতে হবে।

### ২৭ নভেম্বরের পুনঃযাচাই
- Planning branch: `planning/4000-automated-project-economy`; সাম্প্রতিক commit search-এ সর্বশেষ দেখা commit `9c504237e8698ccacc891dc82a8aa23d98747585` — “Document Staging access tests and worker service gates”।
- একই branch-এর আগের commit `88fadcb5e13acf768495f7bc031683f8b44b0f70`-এ Worker Deno type-check workflow যোগ হয়েছে।
- PR #20 খোলা Draft PR; PR description-এ 4,000-project foundation, dual-currency ledger, guarded payout/refund এবং release gate বর্ণিত। বর্তমান পূর্ণ Production readiness প্রমাণিত নয়।
- PR #19-এর বিবরণে daily encrypted backup + disposable restore test (02:30 UTC), weekly read-only schema/migration audit (Monday 03:15 UTC), এবং 6-hourly read-only DB health monitor প্রস্তাব করা হয়েছে। PR #19 Draft/Unmerged থাকায় এই schedule main branch-এ কার্যকর হয়েছে বলে ধরে নেওয়া যাবে না।
- 02:30 UTC = বাংলাদেশ সময় সকাল ৮:৩০; Monday 03:15 UTC = বাংলাদেশ সময় সোমবার সকাল ৯:১৫। এগুলো PR-এ বর্ণিত পরিকল্পিত সময়, বাস্তব সফল run-এর প্রমাণ নয়।
- বর্তমান branch head `9c504...`-এর জন্য connector-এর commit-workflow-run এবং combined-status query কোনো run/status ফেরত দেয়নি। এটি “ব্যর্থ” প্রমাণ করে না; বরং ওই query থেকে ফল পাওয়া যায়নি। Worker commit-এর run/status query-ও এই সেশনে remote protocol error-এ সম্পন্ন হয়নি।
- Staging workflow/Secrets বাস্তবে dispatch বা pass হয়েছে—এমন নতুন প্রমাণ এই সেশনে পাওয়া যায়নি। Secrets কখনো chat-এ চাওয়া বা প্রকাশ করা যাবে না।
- Release Readiness নথি এখনও **NOT READY FOR PRODUCTION / NOT LIVE** বলে। Production migration, public deployment, live billing/payment/payout, provider account/KYC পরিবর্তন বা real money transfer করা হয়নি।

### সংশোধন ও পরবর্তী কাজের নির্ভুল ক্রম
1. PR #19-এর head/branch এবং সংশ্লিষ্ট workflow YAML সরাসরি খুলে schedule, timezone, permissions, secret names, backup encryption, restore target ও read-only transaction semantics line-by-line যাচাই করতে হবে। PR #19 merge না হওয়া পর্যন্ত schedule সক্রিয় নয়।
2. PR #20-এর latest head/diff, Staging workflow-এর প্রকৃত secret contract এবং handover/spec-এর secret নামের সামঞ্জস্য যাচাই করতে হবে; কোনো secret value chat-এ নয়।
3. GitHub Actions-এর repository-wide recent runs UI/API থেকে actual run IDs, workflow names, branch/SHA, conclusion, job/step status সংগ্রহ করতে হবে। Commit-filtered query empty হলে “No run” সিদ্ধান্ত নয়; অন্য read-only query দিয়ে cross-check করতে হবে।
4. Full ordered migration chain clean disposable PostgreSQL/Supabase-compatible Staging-এ চালাতে হবে; শুধু finance migrations-এর isolated test-কে full-chain pass বলা যাবে না।
5. Owner/Admin/Member Auth/RBAC, RLS, worker Deno type-check এবং Staging Edge Function deploy test আলাদা করে যাচাই করতে হবে। Worker-এর approved business handlers না থাকলে production execution/revenue বন্ধ থাকবে।
6. Backup/restore rehearsal, Production read-only audit, provider sandbox, safeguarded custody, reconciliation, payout/refund rails, pricing, security/load/E2E evidence সম্পন্ন না হওয়া পর্যন্ত Release Readiness NOT READY থাকবে।
7. Routine source/docs/disposable test সংশোধন চালানো যাবে; Production migration apply, migration-history repair, destructive SQL, Production data write, public deployment, live billing/payment/payout এবং provider/bank account পরিবর্তন আলাদা explicit approval ও readiness gate ছাড়া করা যাবে না।

### এই সেশনের নির্দিষ্ট ফল
- কোনো Production বা live পরিবর্তন করা হয়নি।
- এই যাচাইয়ে কোনো নতুন passing workflow run প্রমাণিত হয়নি; পূর্বে নথিভুক্ত passing run-গুলো তাদের নির্দিষ্ট commit/scope-এ সীমাবদ্ধ।
- এই section বর্তমান অগ্রগতির handover; এটি ১০ ঘণ্টার কাজ সম্পন্ন হওয়ার ঘোষণা নয়।


## ১৭. ২৭ নভেম্বর ২০২৬ — Backup/Audit/Health schedule-এর কোড সংশোধন

### এই সেশনে পাওয়া প্রকৃত অসামঞ্জস্য
- PR #19-এর বিবরণে Daily backup/restore, Monday read-only audit এবং six-hourly health monitor-এর কথা থাকলেও planning branch-এ পরীক্ষা করা backup ও read-only audit workflow YAML-এ তখন `schedule:` trigger ছিল না। শুধু `workflow_dispatch` এবং main-branch path-based push trigger ছিল। ফলে PR description একা দেখে schedule চালু আছে বলা ভুল হতো।

### করা source update
- `.github/workflows/backup-restore-preview.yml`: cron `30 2 * * *` যোগ হয়েছে — প্রতিদিন 02:30 UTC / বাংলাদেশ সময় সকাল 08:30। এটি encrypted logical backup, disposable clean database restore test, read-only remote migration history এবং `db push --dry-run` preview চালায়; Production migration apply করে না। প্রয়োজনীয় Actions secrets: `SUPABASE_DB_URL`, `BACKUP_ENCRYPTION_PASSPHRASE`।
- `.github/workflows/read-only-db-audit.yml`: cron `15 3 * * 1` যোগ হয়েছে — প্রতি সোমবার 03:15 UTC / বাংলাদেশ সময় সকাল 09:15। এটি migration history, schema, columns, constraints, indexes, grants, RLS policies, functions ও triggers read-onlyভাবে সংগ্রহ করে। প্রয়োজনীয় Actions secret: `SUPABASE_DB_URL`।
- নতুন `.github/workflows/database-health-monitor.yml` তৈরি হয়েছে: cron `0 */6 * * *` — প্রতি ৬ ঘণ্টায়। এটি PostgreSQL version, public table count, invalid/not-ready indexes, unvalidated constraints ও migration-history table presence read-only transaction-এ পরীক্ষা করে; issue থাকলে run fail করে এবং non-secret report artifact দেয়। প্রয়োজনীয় Actions secret: `SUPABASE_DB_URL`।

### গুরুত্বপূর্ণ সক্রিয়করণ সীমা
- এই cron trigger-গুলো এখন planning branch-এর source-এ আছে। GitHub scheduled workflow সাধারণত repository-এর default branch-এর workflow file থেকে চালায়; তাই PR merge/default branch-এ থাকা এবং Actions enabled না হওয়া পর্যন্ত এই schedule-গুলো বাস্তবে চলবে না। PR #19/#20 merge বা public deployment এই update-এ করা হয়নি।
- Schedule যুক্ত হওয়া মানে কোনো run ইতিমধ্যে সফল হয়েছে—এমন নয়। প্রথম scheduled/manual run-এর run ID, job/step outcome, backup artifact, restore verification ও audit artifact না পাওয়া পর্যন্ত “পরীক্ষা সফল” বলা যাবে না।
- Backup workflow-এ Production DB-তে logical dump এবং migration read/preview আছে; এটি DB content read করে। তবে workflow-টি Production migration apply, repair বা data write করে না।
- কোনো secret value chat-এ চাইবেন/লিখবেন না। Backup secret অনুপস্থিত হলে run fail হবে; secret configure করা Owner-এর কাজ GitHub Actions Secrets-এ।

### এই update-এর পর অবস্থা
- তিনটি workflow file planning branch-এ পুনরায় fetch করে cron trigger উপস্থিতি যাচাই করা হয়েছে।
- GitHub Actions workflow parser/runtime run এই মুহূর্তে চালানো/পাস হয়েছে—এমন প্রমাণ নেই; পরবর্তী ধাপ হলো PR CI/Workflow validation এবং merge ছাড়া manual dispatch করা সম্ভব কি না যাচাই।
- Production data, migration history, live deployment, payment/payout বা provider settings পরিবর্তন করা হয়নি।


## ১৮. ২৭ নভেম্বর ২০২৬ — আজকের GitHub পরীক্ষা ও ধারাবাহিকতা হালনাগাদ

এই অংশটি ২৭ নভেম্বরের বর্তমান যাচাইয়ের ফল। আগের handover sections অপরিবর্তিত রাখা হয়েছে।

### Repository / PR অবস্থা
- Repository: `rakib12301111-droid/master-world-vip`
- PR #19 — `automation/scheduled-safety-monitoring`; head `5cd0f45220ad33e9cc98c2d9aeb2ee72188fac35`; Draft/Open/Unmerged। এই branch-এর জন্য Actions runs তালিকায় কোনো run পাওয়া যায়নি। তাই PR #19-এর schedule/health workflow বাস্তবে সফলভাবে চলছে—এমন প্রমাণ নেই।
- PR #20 — `planning/4000-automated-project-economy`; যাচাইয়ের সময় head `56ae2952a0cf4affe04d14b2b8f8a6476e8278ed`; Draft/Open/Unmerged। PR #20 merge করা হয়নি।
- PR #20 head-এর জন্য সরাসরি SHA-filtered Actions run পাওয়া যায়নি। সর্বশেষ যাচাইকৃত PR CI run-গুলো আগের code-equivalent commit `9f0a4c7cf2f3b7aeb50f9a5fd40b6ed163493741`-এ সফল হয়েছিল; বর্তমান documentation-only head-এর জন্য নতুন run ছাড়া ওই ফলকে নতুন head-এর CI বলা যাবে না।

### PR #20-এ সর্বশেষ যাচাইকৃত CI evidence
নিচের সবগুলো Run ২৬ নভেম্বর ২০২৬-এ `9f0a4c7cf2f3b7aeb50f9a5fd40b6ed163493741` commit-এ Pull Request event-এ `success`:
- Migration Safety: Run `45879443133` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45879443133
- Disposable PostgreSQL finance-ledger runtime: Run `45879443167` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45879443167
- Auto Work Static Safety: Run `45879443153` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45879443153
- Update-system check: Run `45879443137` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45879443137
- Worker Deno/static verification: Run `45879443174` — https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45879443174
- আলাদা করে আগের Admin Dashboard batch-এর disposable PostgreSQL Run `45878490800`, Migration Safety Run `45878490751`, Auto Work Static Safety Run `45878490762` এবং Update-system Run `45878490881`-ও success ছিল।
- এগুলো static/disposable test evidence; Production schema, real Staging Auth/RBAC বা live worker execution-এর প্রমাণ নয়।

### Commit `9c504237e8698ccacc891dc82a8aa23d98747585`-এর প্রকৃত Actions ফল
- Referral Rewards scheduled workflow Run `45879613849` এবং `45926250050` — দুটিই failed; উভয় ক্ষেত্রেই `Validate protected secrets` ধাপে failure হয়েছে এবং `Process verified eligible referrals` ধাপ skipped হয়েছে। অর্থাৎ reward processing/payout সম্পন্ন হয়নি; কোনো টাকা পাঠানোর প্রমাণ নেই। Secret value কখনো log বা chat-এ প্রকাশ করা যাবে না।
- GitHub Pages build/deployment Run `45879349584` success এবং `Deploy MASTER WORLD VIP to GitHub Pages` Run `45879349896` success; দ্বিতীয় Run-এ live release verification-ও success। এটি `main` branch-এর `9c504...` commit-এর public Pages deployment evidence; PR #20 merge বা Production database migration apply-এর প্রমাণ নয়।
- উল্লিখিত 9c504 commit-এ PR #20 branch-এর Staging readiness documentation যোগ হয়েছিল; ওই commit-এর Staging workflow dispatch বা real Staging acceptance test হয়েছে—এমন প্রমাণ পাওয়া যায়নি।

### Staging / Worker readiness — এখনো BLOCKED
- `.github/workflows/validate-staging-supabase.yml` এবং Staging readiness documentation PR #20 branch-এ আছে।
- Required Staging Actions secrets ও আলাদা non-Production Supabase Staging project এই execution-এ যাচাই/উপলব্ধ নয়। তাই Staging workflow dispatch করা হয়নি; migration, তিনটি পৃথক Owner/Admin/Member Auth/RBAC acceptance test বা Staging Edge Function deploy সম্পন্ন হয়নি।
- Worker Edge Function এখনো registration/heartbeat foundation; approved business-task handler নেই। Worker idle/disabled থাকবে; task claim, customer work execution বা revenue processing চালু নয়।
- ৪,০০০ Project হলো পরিকল্পিত registry capacity; ২,০০০ USD + ২,০০০ BDT slots বাস্তবে seeded/active হয়েছে—এমন প্রমাণ নেই। Execution readiness false, budget zero, real customer/order/payment/payout/revenue live নয়।

### PR #19 schedule-এর বাস্তব সক্রিয়তা
- Backup/restore daily 02:30 UTC, read-only audit Monday 03:15 UTC এবং health monitor প্রতি ৬ ঘণ্টার schedule PR #19 branch-এ source-level proposal হিসেবে আছে।
- PR #19 branch-এর জন্য কোনো Actions run পাওয়া যায়নি। GitHub scheduled workflow default branch থেকে কার্যকর হয়; PR merge/default branch-এ না থাকায় এই schedule-গুলো active production schedule বলে গণ্য করা যাবে না।
- PR #19 merge করলে main-এর GitHub Pages push deployment trigger হওয়ার ঝুঁকি আছে। আলাদা অনুমোদন ছাড়া PR merge/live deployment করা যাবে না।

### Production safety boundary
- Production database migration apply, migration-history repair, destructive SQL বা live data write করা হয়নি।
- Production migration-এর জন্য আলাদা exact approval `APPLY-MASTER-WORLD-VIP-MIGRATIONS`, সর্বশেষ recoverable backup এবং restore evidence বাধ্যতামূলক। এই handover update নিজে কোনো Production approval নয়।
- Public Pages deployment-এর উপরের Run evidence আলাদা; ভবিষ্যৎ public release/deployment-এর আগে নির্দিষ্ট scope ও অনুমোদন gate বজায় থাকবে।
- Staging secrets, password, token, OTP বা encryption passphrase এই handover-এ লেখা হয়নি।

### পরবর্তী কাজ — এখান থেকেই শুরু করতে হবে
1. এই handover update-এর পর নতুন PR #20 commit-এর CI runs পরীক্ষা করে সব নতুন workflow-এর বাস্তব result নথিভুক্ত করা।
2. PR #20-তে Staging secrets/project Owner কর্তৃক GitHub Actions Secrets-এ প্রস্তুত হলে কেবল manual Staging workflow চালানো; Production project ref reject হচ্ছে তা নিশ্চিত করা।
3. Staging migration + তিন পৃথক Auth/RBAC role test + Admin overview authorization + Edge Function Staging deploy-এর logs/acceptance result যাচাই করা।
4. Worker-এর জন্য বাস্তব business-task handler, idempotency, budget guard, approved external integration এবং end-to-end tests তৈরি না হওয়া পর্যন্ত worker idle রাখা।
5. PR #19 schedule workflow-এর YAML/CI validation এবং default-branch activation gate পর্যালোচনা; merge নয়।
6. Production read-only schema audit ও full-chain disposable migration test-এর বর্তমান evidence সংগ্রহ; কোনো Production apply নয়।

**এই update-এর সময় কোনো Staging secret value পড়া/প্রকাশ, Production migration apply, payout, referral reward transfer, PR merge বা নতুন public deployment চালানো হয়নি।**


## ১৯. ২৭ নভেম্বর ২০২৬ — Staging target binding ও Worker response hardening

### Source-level audit-এ পাওয়া ঝুঁকি ও সংশোধন
- `.github/workflows/validate-staging-supabase.yml`-এ আগে DB URL-এর username শুধু configured project ref-এর suffix দিয়ে যাচাই হতো। এখন আরও কঠোরভাবে:
  - Project ref ২০ অক্ষরের lowercase alphanumeric হতে হবে এবং Production ref `lztbbrzeuyjkuiyzrsxp` প্রত্যাখ্যাত হবে।
  - DB host অবশ্যই Supabase Session Pooler host `*.pooler.supabase.com` হতে হবে।
  - Port অবশ্যই `5432`, database path অবশ্যই `/postgres`, URL-এ query/fragment থাকা যাবে না।
  - Username অবশ্যই `postgres.<STAGING_SUPABASE_PROJECT_REF>` এবং password অনুপস্থিত হলে workflow বন্ধ হবে।
  - Auth API URL অবশ্যই `https://<STAGING_SUPABASE_PROJECT_REF>.supabase.co`-এর সঙ্গে হুবহু মিলবে; unexpected port/path/credentials/query/fragment reject হবে।
- `supabase/functions/project-automation-worker/index.ts`-এ response body থেকে worker key সরানো হয়েছে। RPC error body আর caller-কে ফেরত দেওয়া হয় না; generic error response দেওয়া হয়।
- Worker এখনো শুধু registration/heartbeat করে; task claim বা business handler নেই। `MWVIP_WORKER_ENABLED=true` না থাকলে disabled থাকে; revenue/payment/payout চালু করে না।

### নতুন verification source
- `scripts/verify-staging-worker-safety.py` যোগ হয়েছে। এটি Staging target binding, Production ref rejection, তিনটি পৃথক Auth identity, worker disable gate, service-role authorization, no-task-claim এবং secret/error-response leakage না থাকার static invariant পরীক্ষা করবে।
- `.github/workflows/verify-supabase-migrations.yml`-এ verifier step ও সংশ্লিষ্ট path triggers যোগ হয়েছে।
- Dedicated `.github/workflows/verify-project-automation-worker.yml` যোগ হয়েছে; এতে Deno v2 type-check এবং একই safety verifier চালানোর কথা।
- সংশ্লিষ্ট GitHub commits:
  - Staging URL binding: `ece5e77d5d368e08468db8af9ba57387d953d8f3`
  - Worker response hardening: `a050af4160c70b15a1ecb8eb53be44bf4c9ef41f`
  - Static verifier: `a874a78ac2aaf16d42a88097d2020409dbc6d217`
  - Migration-safety CI integration: `aeff5d0b0c2935681c30a2d74e8ed51d2dfbf7af`
  - Dedicated Deno workflow: `45e4597c5f4b2ce592a2711a32c02c66360f49e9`

### বাস্তব যাচাইয়ের অবস্থা
- PR #20 বর্তমান head: `45e4597c5f4b2ce592a2711a32c02c66360f49e9`; Draft/Open/Unmerged।
- এই head SHA-তে নতুন GitHub Actions run এখনো পাওয়া যায়নি। তাই নতুন static verifier/Deno type-check pass হয়েছে বলা যাবে না।
- Staging secrets/project এই execution-এ পাওয়া যায়নি; Staging workflow dispatch হয়নি। কোনো Staging migration apply, Auth/RBAC acceptance test বা Edge Function deployment হয়নি।
- Production database, live migration history, payments/payouts বা public deployment এই source update-গুলোতে পরিবর্তন করা হয়নি।

### পরবর্তী কাজ — এই অবস্থান থেকে চালিয়ে যেতে হবে
1. PR #20-এর নতুন head-এর CI ফলাফল না আসা পর্যন্ত নতুন verifier/type-check-কে pending হিসেবে ধরতে হবে; run evidence এলে এই handover-এ Run ID যোগ করতে হবে।
2. Owner GitHub Actions Secrets-এ আলাদা Staging project-এর প্রয়োজনীয় secrets configure করলে manual Staging workflow চালিয়ে full migration + Owner/Admin/Member + Admin RPC acceptance test করতে হবে।
3. Staging acceptance pass না হওয়া পর্যন্ত Worker disabled/idle থাকবে; কোনো customer task বা revenue execution নয়।
4. PR #19 schedule branch এখনো আলাদা Draft PR; default branch-এ merge বা public deployment আলাদা অনুমোদন ছাড়া নয়।
5. Production migration gate `APPLY-MASTER-WORLD-VIP-MIGRATIONS` অপরিবর্তিত থাকবে।


## 27 নভেম্বর ২০২৬ — Automation Engine SQL preflight correction

- PR #20 branch: `planning/4000-automated-project-economy`।
- Latest reviewed automation migration: `supabase/migrations/20261126110000_project_automation_engine.sql`।
- Source review-এ `scheduler_reap_expired_project_task_leases()` function-এর opening dollar-quote delimiter malformed (`as $`) পাওয়া যায়; এটি PostgreSQL parser error ঘটাতে পারত।
- সংশোধন করে valid `as $$ ... $$` করা হয়েছে।
- Fix commit: `9443290b521eb8f14b299c0a3a1691cdc79098f3`।
- Fix commit-এর জন্য বর্তমানে কোনো GitHub Actions workflow run বা commit status পাওয়া যায়নি; তাই correction committed, কিন্তু CI/runtime validation এখনো **PENDING**।
- PR #20 Draft/Open/Unmerged; PR #19 Draft/Open/Unmerged। Main branch-এ সর্বশেষ পর্যবেক্ষিত commit `9c504237e8698ccacc891dc82a8aa23d98747585`; PR #20-এর automation/staging additions main-এ merged নয়।
- Staging workflow `.github/workflows/validate-staging-supabase.yml` কেবল manual dispatch-এ চলে এবং পৃথক Staging secrets ও তিনটি isolated Owner/Admin/Member test account চায়। Staging run-এর প্রমাণ নেই; secrets উপস্থিত কি না GitHub Actions-এর secret values না পড়ে নিশ্চিত করা যায়নি।
- Worker source বর্তমানে fail-closed: `MWVIP_WORKER_ENABLED=true` না হলে disabled; enabled হলেও approved business task handler count zero থাকায় task claim করে না। এটি live task execution নয়।
- Production schema/migrations অপরিবর্তিত; কোনো Production migration apply, live deployment, payment/payout বা revenue activation করা হয়নি।
- পরবর্তী কাজ: fix commit-এ Migration Safety + disposable PostgreSQL full-chain runtime tests-এর বাস্তব run/log যাচাই; staging secrets/test accounts প্রস্তুত হলে staging-only validation; Admin RBAC/Owner bootstrap ও provider/custody/payout prerequisites আলাদা করে যাচাই। Production migration apply-এর আগে exact approval `APPLY-MASTER-WORLD-VIP-MIGRATIONS` এবং recoverable backup/restore evidence বাধ্যতামূলক।


## ২৭ নভেম্বর ২০২৬ — Payment/Payout, Order Finance ও Production Live-এর Owner নির্দেশ

Owner নির্দেশ: নিচের কাজগুলোকে MASTER WORLD VIP-এর বাধ্যতামূলক Live-readiness scope হিসেবে এগিয়ে নিতে হবে। এই নির্দেশে implementation planning, source updates, sandbox/test work অনুমোদিত; এটি Production migration, real-money transfer, provider onboarding/contract acceptance বা public release-এর exact approval নয়।

### A. bKash / Nagad / Bank Payment-Payout
- bKash, Nagad ও Bank-এর জন্য আলাদা server-side provider adapter architecture, beneficiary ownership verification, masked destination, encrypted/tokenized sensitive data, signed webhook verification, idempotency, retry/replay protection, rate/amount limits, audit trail এবং daily settlement reconciliation তৈরি ও পরীক্ষা করতে হবে।
- bKash/Nagad withdrawal: Admin approval ছাড়া provider transfer call নয়। Admin approval হলেও official merchant/disbursement API, provider permission, KYC ও settlement terms বাধ্যতামূলক।
- Bank auto-payout কেবল bank/payment partner-এর অনুমোদিত corporate/API/mandate rail, verified beneficiary, KYC/AML/fraud checks, limits ও reconciliation সক্রিয় থাকলে; risk alert হলে fail-closed/manual review।
- Provider credentials/merchant account/contract/sandbox access Owner-কে provider-এর official process-এ সংগ্রহ করে GitHub Actions/Supabase secret store-এ configure করতে হবে। Secret chat, source code, logs বা handover-এ রাখা যাবে না। Credential না থাকলে synthetic mock sandbox-ই চলবে; mock result কখনো real transfer নয়।
- Provider approval, KYC/legal/tax review, custody/safeguarded funds ও signed settlement evidence না পাওয়া পর্যন্ত real payment/payout NOT LIVE থাকবে।

### B. Customer Order, Revenue, Member Payment ও ২০% Admin commission
- Existing append-only double-entry ledger ও guarded payout/refund source-এর ওপর end-to-end test যোগ/সম্পন্ন করতে হবে: order funding, currency isolation (USD/BDT), idempotent payment/webhook, provider fee, tax, refund/chargeback reserve, Member payable, Admin approval, payout settlement, reversal, reconciliation এবং duplicate/replay/overdraft/negative-balance rejection।
- Customer-এর টাকা সত্যিই settled না হওয়া পর্যন্ত order funded নয়; কাজ accepted না হওয়া পর্যন্ত Member payout payable নয়; provider/bank settlement ও reconciliation evidence ছাড়া payout paid নয়। Ledger entry cash custody বা টাকা পাঠানোর প্রমাণ নয়।
- Admin commission ২০% এখনো প্রস্তাব, সক্রিয় deduction নয়। বর্তমান design অনুযায়ী প্রস্তাবিত base হলো distributable platform margin: settled gross − provider fees − applicable tax − full Member payable − refund/chargeback reserve funding − approved direct operating cost। Margin শূন্য/ঋণাত্মক হলে commission শূন্য। Owner final approval, legal/tax review, rounding/reversal policy এবং order-এর আগে Member/customer disclosure না হওয়া পর্যন্ত ২০% কাটা/post করা যাবে না।
- প্রতিটি order-এ gross, currency, fee, tax, reserve, operating cost, Member net payable, proposed/approved commission basis ও amount আগে দেখাতে হবে; accepted order-এর terms immutable snapshot হবে। USD/BDT আলাদা ledger-এ থাকবে; FX conversion/netting নয়।
- Member Auto Work/paid package এখনো disabled; Member deposit, package fee বা অন্য সদস্যের টাকা দিয়ে payout/refund করা যাবে না।

### C. Staging → Production → Live release gates
1. PR #20 branch-এ SQL fix-সহ সব CI/static checks এবং disposable PostgreSQL full migration-chain/runtime finance tests বাস্তবে pass; Run ID ও logs handover-এ নথিভুক্ত।
2. আলাদা non-Production Staging Supabase project/secrets এবং পৃথক Owner/Admin/Member test identity প্রস্তুত; Staging migration, RLS/RBAC, Admin-only approval, worker, webhook simulation, reconciliation ও rollback/restore acceptance pass।
3. bKash/Nagad/Bank official sandbox integration, signed webhook tests, beneficiary verification, duplicate/replay/failure/refund/chargeback scenarios pass; provider contract/KYC/legal/tax approval evidence যাচাই।
4. Independent accounting reconciliation, funded reserve/custody evidence, incident response, alerting, limits ও emergency kill switch pass।
5. Production migration-এর আগে latest recoverable backup এবং আলাদা restore test evidence; exact Owner approval APPLY-MASTER-WORLD-VIP-MIGRATIONS না পাওয়া পর্যন্ত apply নয়।
6. Production apply ও live deployment পৃথক controlled steps; migration approval-কে payment transfer, payout activation বা public release approval হিসেবে ধরা যাবে না। প্রতিটি ধাপে আলাদা scope/approval ও post-deploy smoke test লাগবে।

### বর্তমান বাস্তব অবস্থা / অনুমোদনের ব্যাখ্যা
- Existing ledger/payout database source এবং disposable PostgreSQL runtime test-এর আগের successful evidence আছে; কিন্তু latest SQL fix commit-এর নতুন CI/runtime run এখনো pending।
- Official bKash/Nagad/Bank provider credentials, merchant/API agreement, sandbox access, verified bank custody/settlement rail এই execution-এ সরবরাহ/যাচাই হয়নি; তাই real integration ও money movement live নয়।
- Staging secrets/project এবং role test identities প্রস্তুত/যাচাই হয়নি; Staging acceptance test pending।
- PR #20 Draft/Open/Unmerged; Production schema/migrations apply হয়নি।
- Owner-এর এই instruction-কে requirements ও safe implementation work-এর অনুমতি হিসেবে নথিভুক্ত করা হলো; exact Production migration approval token এখানে দেওয়া হয়নি। Production apply, payout transfer বা public live release করা হয়নি।

### পরবর্তী execution order
1. Latest commit CI + full-chain disposable PostgreSQL runtime finance tests চালিয়ে evidence নথিভুক্ত।
2. Mock provider adapters/webhook simulator ও end-to-end order/commission/payout tests বাস্তবায়ন; official sandbox credentials পেলে provider-specific adapter যোগ।
3. Staging project/secrets প্রস্তুত হলে isolated staging migration + role/RLS + worker + finance acceptance tests।
4. Provider/legal/custody/settlement evidence ও final ২০% policy approval সংগ্রহ।
5. Restore-tested backup এবং exact Production migration approval পাওয়ার পরেই controlled Production apply; তারপর আলাদা live deployment approval ও smoke tests।


## ২৭ নভেম্বর ২০২৬ — সর্বশেষ অগ্রগতি ও অনুমোদন-গেট

- **নতুন সংশোধনের CI পরীক্ষা: PENDING** — সর্বশেষ documentation/source commit-এর পর প্রযোজ্য CI ও disposable PostgreSQL full-chain runtime run-এর সফল Run ID/logs এখনো যাচাই করা হয়নি। Pending-কে pass বা fail বলা যাবে না।
- **Staging Database পরীক্ষা: PENDING** — আলাদা Staging project, secrets ও isolated Owner/Admin/Member test identity প্রস্তুত এবং যাচাইকৃত নয়; কোনো সফল Staging acceptance evidence নেই।
- **Production Migration: NOT RUN / BLOCKED** — Production schema-তে কোনো migration apply করা হয়নি। Backup/restore evidence, Staging acceptance এবং migration review ছাড়া apply করা যাবে না।
- APPLY-MASTER-WORLD-VIP-MIGRATIONS হলো কেবল Production Database Migration Apply-এর exact approval gate। এই বার্তায় token-এর কাজ জানতে চাওয়া হয়েছে; তাই এটিকে Production apply-এর অনুমোদন হিসেবে গণ্য করা হয়নি। Token দিলেও provider payout, real-money transfer, commission activation বা public Live Deployment স্বয়ংক্রিয়ভাবে অনুমোদিত হবে না।
- **Live Deployment: PENDING / NOT LIVE** — Production migration-এর পরেও আলাদা deployment approval, provider/legal readiness ও post-deploy smoke test প্রয়োজন।
- নিরাপদ পরবর্তী ক্রম: (১) source সংশোধন শেষ ও CI/runtime pass, (২) Staging project/secrets ও acceptance pass, (৩) provider-approved sandbox এবং order-to-payout test pass, (৪) backup/restore ও security review, (৫) আলাদা Production migration approval, (৬) পৃথক Live deployment approval।


## ২৭ নভেম্বর ২০২৬ — নিরাপদ পরীক্ষার ব্যবস্থা আপডেট

### এই আপডেটে করা Source/Workflow পরিবর্তন
- Finance Runtime workflow-এ PR-triggered validation-এর বিদ্যমান path বজায় রেখে payout/refund static safety script চালানোর ধাপ যোগ করা হয়েছে; disposable PostgreSQL test-এ ledger এবং guarded payout/refund migration/runtime SQL যাচাই করার উদ্দেশ্য নির্ধারিত।
- সম্পূর্ণ migration chain-এর fresh ও audited legacy-shape disposable database validation workflow-এ PR trigger যোগ করা হয়েছে; Production database target নয়।
- Staging validation workflow-এ PR trigger যোগ করা হয়েছে। Workflow নিজেই Staging project ref Production-এর সঙ্গে এক হতে দেয় না; required isolated Staging secrets/account না থাকলে প্রথম secret check-এই থামবে।
- নতুন `verify-disposable-backup-restore.yml` workflow যোগ করা হয়েছে। এটি synthetic test data-র encrypted backup নিয়ে আলাদা disposable PostgreSQL database-এ restore ও row-count যাচাই করবে; Production database বা real customer data ব্যবহার করে না।

### সর্বশেষ বাস্তব পরীক্ষার ফল (এই branch head: `e1c526ab6fe516ba766e1479a613e4790b62587e`)
- **CI / Migration Safety / Finance Runtime: PENDING** — সর্বশেষ branch head-এর জন্য GitHub Actions workflow run/check পাওয়া যায়নি। আগের commit `9f0a4c7cf2f3b7aeb50f9a5fd40b6ed163493741`-এ Finance Runtime run `45879443167` ও Migration Safety run `45879443133` SUCCESS ছিল; এগুলো বর্তমান head-এর পরীক্ষার প্রমাণ নয়।
- **Disposable Backup/Restore: PENDING** — test-only workflow যোগ হয়েছে, কিন্তু বর্তমান head-এর জন্য run/result পাওয়া যায়নি।
- **Staging Database: PENDING** — guarded PR workflow যোগ হয়েছে; বর্তমান head-এ কোনো Staging run/result পাওয়া যায়নি। Staging secrets/test identities উপস্থিত কি না যাচাই করা হয়নি।
- **Production Migration: NOT RUN** — কোনো Production schema change/apply হয়নি; exact migration approval এবং সব prerequisite gate বহাল।
- **Live Deployment: NOT RUN / NOT LIVE** — public deployment বা real payment/payout চালু হয়নি।

### নিরাপত্তা সীমা
- নতুন workflows-এ disposable PostgreSQL fixture ব্যবহার করে backup/restore ও migration runtime যাচাইয়ের ব্যবস্থা; Production migration workflow চালানো হয়নি।
- Staging workflow কেবল আলাদা Staging project ref যাচাইয়ের পর Staging target-এ কাজ করবে; Production project ref reject করে।
- কোনো test run-এর result না পাওয়া পর্যন্ত status PENDING-ই থাকবে; আগের commit-এর SUCCESS নতুন commit-এ স্থানান্তর করা যাবে না।

## ২৭ নভেম্বর ২০২৬ — CI চালু করার Trigger সংশোধন ও বাস্তব Run (সর্বশেষ আপডেট)

### এই আপডেটে করা কাজ
- Finance Runtime workflow-এ planning branch-এর push trigger যোগ করা হয়েছে; শুধু PR path event-এর ওপর নির্ভরশীলতা কমানো হয়েছে।
- সম্পূর্ণ Disposable Migration Validation workflow-এ একই planning branch push trigger যোগ করা হয়েছে।
- Synthetic Disposable Backup/Restore workflow-এ planning branch push trigger যোগ করা হয়েছে।
- পরিবর্তনগুলো একই PR #20 branch-এ commit করা হয়েছে; Production branch বা database-এ কোনো পরিবর্তন নয়।

### বাস্তব GitHub Actions Run — ২৭ নভেম্বর ২০২৬
- Finance Runtime: Run **45955906370**, commit `777766977ee55fb7ca7c3a882f7ca3e249969f3b`, status সর্বশেষ পর্যবেক্ষণে **IN_PROGRESS**। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955906370
- Full Disposable Migration Validation: Run **45955911378**, commit `fd6c61e5d345d13d0ed4e36685f5ca0b0998cfb0`, status সর্বশেষ পর্যবেক্ষণে **IN_PROGRESS**। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955911378
- Synthetic Backup/Restore: Run **45955918336**, commit `4bd170e47182ba84f0badf51a54acf94bac931be`, status সর্বশেষ পর্যবেক্ষণে **IN_PROGRESS**। Job শুরু হয়েছে; PostgreSQL service container initialization চলছিল। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955918336
- উপরের তিনটি Run তিনটি ধারাবাহিক workflow-trigger commit-এ শুরু হয়েছে; এগুলোকে একই SHA-তে চালানো পরীক্ষা বলে দাবি করা যাবে না। প্রতিটি Run-এর চূড়ান্ত conclusion ও logs পুনরায় যাচাই করতে হবে।
- PR #20 বর্তমান head ছিল `4bd170e47182ba84f0badf51a54acf94bac931be`; PR Draft/Open/Unmerged।
- Staging Database: **PENDING / NOT RUN**। পৃথক Staging project ও required secrets/test identities-এর উপস্থিতি নিশ্চিত হয়নি; কোনো Staging migration apply বা Auth/RBAC acceptance test চালানো হয়নি।
- Production Migration: **NOT RUN**। Production database-এ কোনো migration apply হয়নি।
- Live Deployment: **NOT RUN / NOT LIVE**। কোনো public release/deployment বা real payment/payout হয়নি।

### পরবর্তী যাচাই
1. তিনটি চলমান Run-এর final status, প্রতিটি job/step ও failure log যাচাই করে ফল এখানে যোগ করতে হবে।
2. Staging-এর জন্য আলাদা project, project-ref-bound DB URL এবং পৃথক Owner/Admin/Member test accounts প্রস্তুত হলে GitHub Actions Secrets-এ configure করতে হবে; secret value কখনো chat-এ পাঠানো যাবে না।
3. Staging workflow কেবল Staging target-এ চালাতে হবে। Missing secret বা Production ref হলে fail-closed হওয়াই প্রত্যাশিত।
4. Disposable tests সফল হলেও তা Production schema readiness, real payment provider approval বা custody প্রমাণ করে না।
5. Production migration approval gate, backup/restore evidence, Staging acceptance এবং পৃথক Live Deployment approval অপরিবর্তিত থাকবে।

## ২৭ নভেম্বর ২০২৬ — CI ফলাফল, Failure Fix ও পুনঃপরীক্ষা

### সফল পরীক্ষা
- **Finance Runtime — SUCCESS:** Run `45955906370`, commit `777766977ee55fb7ca7c3a882f7ca3e249969f3b`। Disposable PostgreSQL 16-এ payout/refund static safety এবং finance ledger + guarded payout/refund runtime SQL ধাপ সফল। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955906370
- **Synthetic Backup/Restore — SUCCESS (সংশোধনের পর):** Run `45956031760`, commit `309e1c8c5998538835620ca6d273b1ed03d484fb`। দুইটি fake order row-এর encrypted logical backup, decrypt, separate database restore এবং row/amount check সফল। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45956031760
- Backup workflow-এর আগের Run `45955918336` failure হয়েছিল কারণ runner-এর নতুন pg_dump/pg_restore client PostgreSQL 16 restore target-এ `transaction_timeout` সেটিং পাঠায়, যা PG16 চেনে না। Workflow-এ এখন PostgreSQL 16 image-এর matching pg_dump/pg_restore ব্যবহার করা হয়েছে। সফল retry-তে Restore step-ও SUCCESS।

### Full migration-chain validation
- প্রথম Run `45955911378` failure: `20261126110000_project_automation_engine.sql`-এর `scheduler_reap_expired_project_task_leases()` function-এ malformed opening delimiter `as $` এবং closing delimiter `end $;` ছিল। Log-এ PostgreSQL syntax error near `$` পাওয়া গেছে। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955911378
- SQL source-এ ওই function-এর delimiter সঠিক `as $$` / `end $$;` করা হয়েছে। Fix commit: `0f1eef4c61e17d092233d18abe677897179cef89`।
- Fix commit-এর জন্য নতুন Full Disposable Migration Validation Run **45956160044** তৈরি হয়েছে; সর্বশেষ পর্যবেক্ষণে **IN_PROGRESS** (PostgreSQL service container initialization পর্যায়ে)। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45956160044
- এই migration run-এর চূড়ান্ত ফল না আসা পর্যন্ত সম্পূর্ণ migration chain **PENDING**। প্রথম failure-কে pass হিসেবে গণ্য করা যাবে না।

### Staging / Production / Live
- **Staging Database: PENDING / NOT RUN** — আলাদা Staging project, project-bound DB URL, required GitHub Actions secrets এবং তিনটি পৃথক Owner/Admin/Member test identity প্রস্তুত/যাচাইকৃত নয়। Secret values এই execution-এ পড়া বা চ্যাটে প্রকাশ করা হয়নি।
- **Production Migration: NOT RUN** — কোনো Production migration apply বা migration-history repair হয়নি।
- **Live Deployment: NOT RUN / NOT LIVE** — public deployment, real payment/payout বা customer revenue activation হয়নি।
- PR #20 Draft/Open/Unmerged; সব source changes planning branch-এ। Production নিরাপত্তা gate অপরিবর্তিত।

### পরবর্তী কাজ
1. Run `45956160044`-এর final conclusion, job/step ও log যাচাই; ব্যর্থ হলে নির্দিষ্ট SQL error ঠিক করে একই test পুনরায় চালানো।
2. Staging credentials ও identities প্রস্তুত না হওয়া পর্যন্ত Staging workflow চালানো/তার ফল অনুমান করা যাবে না।
3. সব disposable/static tests pass হলেও Production apply বা Live Deployment স্বয়ংক্রিয়ভাবে অনুমোদিত হবে না; পৃথক approval ও release prerequisites বাধ্যতামূলক।


## ২৭ নভেম্বর ২০২৬ — Migration Validation গণনা-ত্রুটি সংশোধন ও নতুন Run

### Run `45956160044`-এর Log থেকে নিশ্চিত ফল
- Run `45956160044` (commit `0f1eef4c61e17d092233d18abe677897179cef89`) **FAILURE** হয়েছে। SQL delimiter সংশোধনের পর ৩৬টি migration ফাইল সফলভাবে execute হয়েছে; workflow-এর শেষে পুরোনো hard-coded expected count `30` থাকায় check ব্যর্থ হয়েছে: `Expected 30 migration files in fresh database; found 36`। অর্থাৎ এই Run-এ SQL apply-তে error ধরা পড়েনি, কিন্তু workflow validation সম্পূর্ণ pass করেনি; fresh/legacy দুই target-এর acceptance check-ও সম্পূর্ণ হয়নি।
- এই failure Production database-এ নয়; disposable PostgreSQL test service-এ ঘটেছে।

### Source correction
- `.github/workflows/validate-migrations-disposable.yml-এ hard-coded ৩০-এর বদলে `supabase/migrations/*.sql` থেকে migration file count dynamic করা হয়েছে। একই dynamic list fresh ও audited legacy-shape disposable database—দুইটিতেই apply হবে; actual count echo করা হবে।
- Fix commit: `56f198fdff7add5c649e0dc96247d3b66170ee4a`।
- নতুন Migration Validation Run **45956925398** একই fix commit-এ শুরু হয়েছে; সর্বশেষ যাচাইয়ে **IN_PROGRESS**। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45956925398 । Final result না আসা পর্যন্ত migration-chain status PENDING থাকবে।

### অন্যান্য পরীক্ষার যাচাইকৃত ফল
- Finance Runtime Run `45955906370` — **SUCCESS**, commit `777766977ee55fb7ca7c3a882f7ca3e249969f3b`; disposable PostgreSQL runtime/static payout-refund safety checks। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45955906370
- Synthetic Backup/Restore Run `45956031760` — **SUCCESS**, commit `309e1c8c5998538835620ca6d273b1ed03d484fb`; দুইটি synthetic row-এর encrypted backup এবং পৃথক disposable database-এ decrypt/restore ও row/amount verification। এটি Production backup নয়। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45956031760
- Backup/Restore-এর আগের Run `45955918336` PostgreSQL client/server version mismatch-এর কারণে failure হয়েছিল; matching PostgreSQL 16 tools দিয়ে পরের Run সফল হয়েছে।

### Staging / Worker / Production gate
- Staging workflow source-এ আছে; কিন্তু আলাদা Staging project এবং ১১টি required secret/test credential বাস্তবে configure করা হয়েছে—এমন কোনো প্রমাণ নেই। তাই Staging migration/Auth/RBAC test **NOT RUN**; Owner/Admin/Member permission acceptance **PENDING**। Secret value চ্যাটে দেওয়া যাবে না।
- Worker source এখনো Registration + Heartbeat foundation; বাস্তব approved task handler নেই। Worker execution/deploy **BLOCKED / NOT LIVE**।
- PR #20 **OPEN / DRAFT / UNMERGED**।
- Production migration **NOT RUN**; Production migration-history repair **NOT RUN**; Live Deployment **NOT RUN**; real payment/payout **NOT RUN**।

### পরবর্তী কাজ
1. Run `45956925398`-এর final status, job/step এবং logs যাচাই; failure হলে নির্দিষ্ট error অনুযায়ী সংশোধন করে পুনরায় disposable validation।
2. আলাদা Staging project ও documented ১১টি secret প্রস্তুত হলে Staging workflow dispatch করে Owner/Admin/Member RBAC পরীক্ষা।
3. Worker-এর জন্য অনুমোদিত business task definitions, idempotency, budget/limits, retry/dead-letter, audit trail ও kill switch বাস্তবায়ন এবং disposable/staging test; তার আগে worker idle থাকবে।
4. Revenue/payment provider-এর official sandbox/contract/legal/KYC readiness এবং mock-to-sandbox end-to-end test।
5. Production migration ও Live Deployment পৃথক explicit approval gate-এ থাকবে।


## ২৭ নভেম্বর ২০২৬ — Staging write/deploy trigger নিরাপত্তা শক্ত করা

- Code review-এ দেখা গেছে Staging workflow-তে `workflow_dispatch`-এর পাশাপাশি `pull_request` trigger ছিল, অথচ workflow migrations apply করে এবং Staging Edge Function deploy করে। PR event থেকে এই write/deploy স্বয়ংক্রিয়ভাবে হওয়া অনাকাঙ্ক্ষিত ঝুঁকি তৈরি করত।
- `.github/workflows/validate-staging-supabase.yml` থেকে `pull_request` trigger সরিয়ে **manual `workflow_dispatch` only** করা হয়েছে। এখন Staging DB apply বা worker deploy কেবল ইচ্ছাকৃত manual dispatch-এ হবে।
- `docs/STAGING_AUTH_AND_WORKER_READINESS_BN.md`-এ manual-only gate নথিভুক্ত হয়েছে।
- সংশ্লিষ্ট commits: workflow `f8930d78b0eef49a173d5c815bf3eed4fc6d1fad`; documentation `ab5fa9d98d87b4cadc64d92fe37d3a3f964dbe62`।
- এটি source-level safety correction; Staging workflow dispatch করা হয়নি, কারণ আলাদা Staging project/credentials উপস্থিতির প্রমাণ নেই।

## ২৭ নভেম্বর ২০২৬ — বর্তমান যাচাইয়ের সীমা

- Disposable migration workflow fix commit `56f198fdff7add5c649e0dc96247d3b66170ee4a`-এ Run `45956925398` সর্বশেষ চেকের সময় **IN_PROGRESS**; এটি শেষ না হওয়া পর্যন্ত full migration validation PASS নয়।
- ওই run পরবর্তী documentation-only এবং Staging-trigger-hardening commits-কে অন্তর্ভুক্ত করে না; এটি নির্দিষ্ট fix commit-টির validation।
- বর্তমান PR head আলাদা হতে পারে; handover update নিজে migration workflow trigger করে না।
- Worker handler তৈরি এখনো BLOCKED: business task catalog, accepted input/output contract, budget, external API authorization, idempotency keys, retry/dead-letter policy এবং per-task security boundary অনুমোদিত/নির্দিষ্ট নয়। কোনো arbitrary business action handler অনুমান করে তৈরি করা নিরাপদ নয়। Worker registration/heartbeat idle-ই থাকবে।
- GitHub Actions Secrets-এর actual configured state এই read-only repository integration থেকে দেখা যায় না। তাই ১১টি Staging secret উপস্থিত/সঠিক—এমন দাবি করা যাবে না; repository owner GitHub Settings → Secrets and variables → Actions-এ configure করবেন। Values কখনো chat-এ পাঠাবেন না।
- Production migration, migration-history repair, Live Deployment, payment/payout execution সবই NOT RUN।


## ২৭ নভেম্বর ২০২৬ — Full Disposable Migration Validation SUCCESS

- Run `45956925398` — **SUCCESS**, commit `56f198fdff7add5c649e0dc96247d3b66170ee4a`। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45956925398
- Job `validate-all-migrations` এবং সব গুরুত্বপূর্ণ step SUCCESS: disposable PostgreSQL service initialize, fresh DB bootstrap, audited legacy-schema fixture bootstrap, সব migration apply, expected application objects verify।
- Log-এ নিশ্চিত: `MIGRATION_FILE_COUNT=36`; fresh disposable DB-তে ৩৬/৩৬ migration এবং audited legacy-shape disposable DB-তে ৩৬/৩৬ migration apply হয়েছে। Legacy compatibility checks-এ UUID IDs ও `manifest_url` preserve এবং semver constraint `NOT VALID` verification pass করেছে।
- এই Run-এর `PRODUCTION_DATABASE_CHANGED=false`; কোনো Production DB target ব্যবহার হয়নি। এটি disposable validation-এর সফল প্রমাণ, Production apply-এর অনুমতি বা Staging acceptance-এর বিকল্প নয়।
- Run-টি migration workflow dynamic-count fix commit `56f198fdff7add5c649e0dc96247d3b66170ee4a`-এ হয়েছে। পরবর্তী Staging manual-only trigger/doc এবং handover commits এতে অন্তর্ভুক্ত নয়; সেগুলো migration SQL বদলায়নি।
- বর্তমান PR #20 head `ebf9105ebc1190121dea14dccf03ed93b44ffc90`; PR **OPEN / DRAFT / UNMERGED**।

### ২৭ নভেম্বর ২০২৬ — সর্বশেষ সামগ্রিক অবস্থা

- Finance Runtime disposable test: **SUCCESS** (Run `45955906370`, older commit `777766977ee55fb7ca7c3a882f7ca3e249969f3b`)।
- Synthetic Backup/Restore: **SUCCESS** (Run `45956031760`, older commit `309e1c8c5998538835620ca6d273b1ed03d484fb`)।
- Full migration chain on fresh + audited legacy-shape disposable DB: **SUCCESS** (Run `45956925398`, 36/36 each, commit `56f198fdff7add5c649e0dc96247d3b66170ee4a`)।
- Staging migration/Auth/RBAC: **NOT RUN**; ১১টি secrets এবং আলাদা Staging project configured আছে—এমন প্রমাণ নেই। Staging workflow এখন manual-only।
- Owner/Admin/Member live Staging permission acceptance: **PENDING**।
- Worker business task handlers: **NOT IMPLEMENTED / BLOCKED**; registration/heartbeat idle foundation only।
- Revenue/payment provider sandbox, real collection, commission activation, payout execution: **NOT LIVE**।
- Production Migration / migration-history repair / Live Deployment: **NOT RUN**।


## ২৭ নভেম্বর ২০২৬ — Planning branch Worker Static Safety CI SUCCESS

- Worker static CI trigger-এ planning branch push যুক্ত করা হয়েছে, যাতে worker source/safety workflow পরিবর্তন এই branch-এও স্বয়ংক্রিয়ভাবে যাচাই হয়। Commit `b3122886f35069fcd232a9fddd378306ddbaeb99`।
- Run `45957124627` — **SUCCESS**। Job `worker-static-check`: Deno Edge Function type-check SUCCESS এবং `scripts/verify-staging-worker-safety.py` SUCCESS। Run: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45957124627
- এটি Worker source-এর type/static safety প্রমাণ; বাস্তব Staging Auth/RBAC, task execution, external connector, revenue বা payout পরীক্ষা নয়।
- Worker এখনো Registration + Heartbeat idle foundation; approved task handler না থাকায় queue claim বন্ধ থাকবে।


## ২৭ নভেম্বর ২০২৬ — Task Execution Framework ও Synthetic Revenue Acceptance বাস্তবায়ন

### নতুন নিরাপত্তা Migration
- নতুন migration: `supabase/migrations/20261127100000_worker_execution_kill_switch_and_handler_allowlist.sql`। Commit `ca27552a50fd42a7f67deb1216d8c3640faf2578`-এ budget reservation hardening-সহ বর্তমান সংস্করণ রয়েছে।
- Global `project_automation_runtime_control.emergency_stop` default `true`; Owner/Admin-only audited RPC `admin_set_project_automation_kill_switch(boolean,text)` reason বাধ্যতামূলক করে। Stop চালু থাকলে নতুন claim শূন্য। In-flight lease finish/audit করতে পারে।
- Database handler allowlist-এ শুধু `system_health_check` enabled, `read_only`; অন্য task type claim হবে না।
- Task claim-এর সময় remaining per-task budget `budget_reserved` এবং project-level `daily_reserved` হিসেবে atomically reserve হয়। Constraint `daily_spent + daily_reserved <= daily_budget`; finish বা expired lease recovery reservation release করে, actual cost daily spend-এ যোগ করে।
- Claim event audit, success/retry/dead-letter audit, expired lease recovery audit এবং kill-switch change audit হয়। Existing unique idempotency key, lease token, max attempts, exponential backoff, dead-letter ও one-running-task-per-project constraint বজায় আছে।

### Worker Code ও Static CI
- `supabase/functions/project-automation-worker/index.ts` এখন claim ও execute path implement করে; তবে একমাত্র handler `system_health_check` — read-only, customer/member data access নয়, external side effects নয়, financial effects নয়। Unknown task type fail-closed।
- Worker এখনও `MWVIP_WORKER_ENABLED=true` ছাড়া disabled; database emergency stop default true; project registry/schedule-ও default disabled। তাই এই code change নিজে থেকে কোনো business execution চালু করে না।
- `scripts/verify-staging-worker-safety.py` এবং `scripts/verify-project-automation-engine.py` update করা হয়েছে; worker CI-তে Deno type-check, Staging isolation, task engine, budget reservation, retry/dead-letter, audit ও kill-switch static assertions চলে।
- Worker CI Run `45958179014` — **SUCCESS**, commit `b560c4354f7b4a1abeaf62a1e089634228eec8bc`। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45958179014

### Synthetic Task Runtime ও Revenue Acceptance
- `supabase/tests/project-automation-kill-switch-runtime.sql`: default emergency stop, stop অবস্থায় zero claim, client role execute denial ও read-only handler allowlist যাচাই।
- `supabase/tests/revenue-order-to-member-settlement-runtime.sql`: synthetic customer order pending_payment → funded → in_progress → delivered → accepted → completed; fake provider settlement references; তিনটি locked fund allocation; balanced double-entry journal; duplicate journal idempotency; Member payable; synthetic payout request/journal; final Member balance ও ledger integrity যাচাই।
- একই test-এ task claim/lease completion, duplicate idempotency key, claim-time budget reservation, retry, max attempts-এ dead-letter, daily spend/reservation release এবং audit events যাচাই করা হয়।
- Disposable full-chain Run `45958078575` — **SUCCESS**, commit `ca27552a50fd42a7f67deb1216d8c3640faf2578`। Fresh ও audited legacy-shape disposable PostgreSQL-এ migration apply, kill-switch test এবং synthetic order-to-member settlement/task runtime acceptance সফল। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45958078575
- আরও কঠোর explicit budget-reservation assertion-সহ Run `45958106239` (commit `48133a9ac5e4133bde35b33a676e147e2605cb67`) সর্বশেষ handover লেখার সময় **IN_PROGRESS**। এটি শেষ না হওয়া পর্যন্ত সেই assertion-এর ফল pending। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45958106239
- Run `45957942265`-এ আগের সংস্করণের synthetic order-to-member settlement এবং task claim/idempotency/retry/dead-letter/audit tests-ও SUCCESS হয়েছিল; budget reservation column/assertion যোগ হওয়ার আগের সংস্করণ। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45957942265

### Revenue/Payment Test-এর সীমা
- সব payment/payout transaction reference synthetic fixture; কোনো external provider API, bKash, Nagad, bank, Production DB বা real funds ব্যবহার হয়নি।
- এটি internal order lifecycle, accounting, idempotency, payout request gating ও ledger arithmetic-এর disposable acceptance test; বাস্তব payment collection, fund custody, provider settlement বা real payout-এর প্রমাণ নয়।
- Admin commission ২০% proposal only; activated/collected নয়।

### Staging ও Production gate অপরিবর্তিত
- আলাদা Staging Supabase project, ১১টি Staging secrets এবং পৃথক Owner/Admin/Member Auth test users না থাকায় Staging migration/Auth/RBAC acceptance **NOT RUN**। Secrets-এর configured state এই integration থেকে পড়া যায় না।
- বাস্তব business task handler এখনো **NOT IMPLEMENTED**; শুধু safe read-only health handler আছে। Customer/member data mutation, content generation, external API connector, financial task handler চালু নয়।
- Official provider sandbox/API, merchant/legal/KYC/AML/tax approval, signed webhook, beneficiary verification ও reconciliation এখনও pending।
- Production Migration, migration-history repair, Worker Production deployment, Live Deployment, real collection/refund/payout **NOT RUN**।
- নতুন migration শুধু planning branch-এ; Production database পরিবর্তিত হয়নি।

### নতুন documentation
- `docs/WORKER_TASK_EXECUTION_AND_REVENUE_ACCEPTANCE_BN.md` — architecture, execution gates, synthetic tests, live-readiness blockers ও security decision।

### PR / Branch
- PR #20 Open / Draft / Unmerged। Branch: `planning/4000-automated-project-economy`। সর্বশেষ head handover commit-এর পরে পুনরায় যাচাই করতে হবে।


## ২৭ নভেম্বর ২০২৬ — Final explicit budget-reservation runtime check SUCCESS

- Run `45958106239` — **SUCCESS**, commit `48133a9ac5e4133bde35b33a676e147e2605cb67`। Link: https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45958106239
- Fresh ও audited legacy-shape disposable PostgreSQL—দুই target-এ migration chain apply এবং সব verification step SUCCESS।
- Runtime test-এ task claim-এর পর `daily_reserved=2` reserve হওয়া, task finish/retry/dead-letter-এর পর `daily_reserved=0`, `daily_spent=0.75`, duplicate task idempotency, retry max=2-তে dead-letter, audit event এবং synthetic order→Member payout settlement—সব assertion SUCCESS।
- Worker Static CI Run `45958179014` — SUCCESS, commit `b560c4354f7b4a1abeaf62a1e089634228eec8bc`; Deno type-check এবং Staging/worker/task-engine safety static checks SUCCESS।
- PR #20 current observed head: `d850e47b8eb8461fc9e87a3e6998261c07c92e2d`; state `OPEN`; draft `true`; URL https://github.com/rakib12301111-droid/master-world-vip/pull/20 ।
- এই successful Run-ও কেবল disposable test database-এ। Production database unchanged; Staging, real provider, real funds ও Live Deployment পরীক্ষা/চালু হয়নি।


---

## ২৭ নভেম্বর ২০২৬ — Business Task Catalog, Commission Policy ও Provider Sandbox Handover Update

### এই সেশনে repository-তে যোগ করা হয়েছে
- `docs/WORKER_BUSINESS_TASK_CATALOG_BN.md` — Worker-এর ব্যবসায়িক Task Definition baseline।
- `docs/COMMISSION_POLICY_DECISION_BN.md` — প্রস্তাবিত ২০% Admin commission-এর Distributable Platform Margin formula, উদাহরণ, rounding, immutable snapshot, posting/reversal ও approval gates।
- `docs/PAYMENT_PROVIDER_SANDBOX_ACCEPTANCE_BN.md` — official provider adapter contract, webhook/idempotency/reconciliation acceptance matrix, mock-only test boundary ও go-live gates।

### Business Worker Task Catalog
- Candidate tasks নির্দিষ্ট করা হয়েছে: work order validation, project usage digest, reminder scheduling, delivery integrity check, acceptance timeout escalation, referral attribution reconciliation, payout preflight, payment event reconciliation, commission preview এবং daily finance reconciliation।
- প্রতিটি task-এর input/purpose, permitted effect, evidence/acceptance ও risk level সংজ্ঞায়িত।
- Common envelope-এ schema version, tenant scope, server-side authorization, idempotency/input hash, timeout, retry, budget cap, audit ও secret/PII redaction বাধ্যতামূলক।
- Rollout order: read-only → controlled internal records → finance-adjacent reconciliation/preview।
- **গুরুত্বপূর্ণ:** এগুলো specification; কোনো business handler বাস্তবায়িত বা allowlist-এ enabled হয়নি। Database allowlist-এ এখনো কেবল `system_health_check`। Worker, project schedule ও emergency-stop default বন্ধ/নিরাপদ অবস্থায় থাকবে।

### Admin ২০% Commission — সিদ্ধান্ত খসড়া
- Owner-এর ২০% হারটি proposal হিসেবেই রাখা হয়েছে।
- সুপারিশকৃত basis: Distributable Platform Margin = settled gross − provider fee − applicable tax − full Member payable − refund/chargeback reserve allocation − approved direct order cost।
- Commission = positive margin × 20%; margin শূন্য/ঋণাত্মক হলে commission শূন্য।
- Member payable বা refund reserve থেকে commission নেওয়া যাবে না; BDT ও USD আলাদা currency ledger-এ থাকবে।
- Order acceptance-এর আগে disclosure, immutable policy snapshot, settled/reconciled completion, idempotent double-entry posting ও reversal policy বাধ্যতামূলক।
- **Status: decision draft only; Owner final approval, legal/accounting/tax review ও disclosure ছাড়া rate/formula সক্রিয় করা হয়নি।**

### Payment Provider Sandbox
- SSLCommerz/bKash/Nagad/Bank-এর official sandbox credentials, merchant/provider approval, contract ও webhook signing key এই সেশনে পাওয়া যায়নি।
- Official provider API call বা official sandbox test চালানো হয়নি।
- Adapter contract ও test matrix নথিভুক্ত: signed webhook, timestamp/replay protection, amount/currency/order matching, status inquiry, settlement evidence, refund/payout idempotency এবং reconciliation mismatch-এ fail-closed।
- Mock provider test হলে TEST-ONLY, synthetic IDs, isolated database/project এবং fake balance-এ সীমাবদ্ধ থাকবে; mock pass কখনো official provider acceptance নয়।

### Commit trail
- Task catalog: `a4280370ce96fcd979c7afecbfa48d451e87ace1`
- Commission policy draft: `321aa714e6be6847953ede7b2250096e3fc89d15`
- Provider sandbox plan: `7aa6942fc5a96860f1e51e7a34209464bc5cc20c`
- এই handover update-এর commit পরবর্তী যাচাইয়ে নথিভুক্ত করতে হবে।

### অবশিষ্ট কাজ / Go-live blockers
1. Catalog-এর Phase A থেকে read-only handler implement করে schema/RBAC/tenant isolation/idempotency/budget/audit/kill-switch tests চালানো।
2. আলাদা Staging Supabase project ও ১১টি Staging GitHub Actions secret এবং পৃথক Owner/Admin/Member test identity configure করা; তারপর manual Staging workflow চালিয়ে migration/Auth/RBAC/Worker acceptance যাচাই।
3. নির্বাচিত provider থেকে official sandbox access, merchant approval, docs, credentials ও signed webhook key সংগ্রহ; তারপর provider-specific adapter এবং official sandbox contract tests।
4. Owner-এর ২০% commission calculation basis/rate-এর লিখিত final approval; legal/accounting/tax review ও customer/Member disclosure।
5. Production migration, Production Worker execution, real payment/payout এবং Live Deployment—প্রতিটির পৃথক approval, security review, Staging acceptance ও backup/restore evidence।

**এই আপডেট কোনো Worker execution, payment, payout, commission posting, Production migration বা Live Deployment চালু করেনি। কোনো বাস্তব আয়/৪,০০০ Project-এর ব্যবসায়িক কাজ সম্পন্ন হয়েছে—এমন দাবি করা যাবে না।**
