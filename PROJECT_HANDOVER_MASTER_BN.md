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
- পুরোনো remote-only migration version `20261121081842` এবং `20261121082217`-কে `reverted` হিসেবে migration history-তে চিহ্নিত করা হয়েছে।
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
- নির্দিষ্ট দুইটি পুরোনো remote-only version `reverted` করে।
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
- এই audit workflow-এর সর্বশেষ run এই পর্যালোচনায় চালানো/যাচাই করা হয়নি।

## 6. সরাসরি দেখা migration SQL-এর পর্যালোচনা

### `20261121100000_profiles_discovery_privacy_hardening.sql`
- Discoverable profile-এর জন্য public-facing নির্দিষ্ট field-সহ `search_discoverable_profiles` RPC তৈরি করে।
- Function-এ `security definer`, fixed empty `search_path`, authentication check, result limit এবং explicit execute grants আছে।
- Discoverable profile policy সরিয়ে direct full-row exposure কমানোর উদ্দেশ্য স্পষ্ট।

### `20261121170000_group_rls_recursion_fix.sql`
- `community_groups` ও `group_members`-এর recursive RLS সমস্যা এড়াতে `can_read_group_roster` helper function যোগ করে।
- Function-এ `security definer` এবং fixed empty `search_path` আছে।
- সংশ্লিষ্ট SELECT policies পুনর্গঠন করে।

**পর্যালোচনার সীমা:** এই দুটি SQL migration-এর source-level পাঠ করা হয়েছে; Supabase production database-এ বাস্তব permission/behavior integration test করা হয়নি। বাকি migration SQL-এর সম্পূর্ণ নিরাপত্তা/কার্যকারিতা audit এখনো সম্পন্ন বলে দাবি করা যাবে না।

## 7. Secrets ও নিরাপত্তা

GitHub Actions-এ ব্যবহৃত secret নাম:
- `SUPABASE_DB_URL`
- `BACKUP_ENCRYPTION_PASSPHRASE`
- অন্যান্য workflow-এ `SUPABASE_ACCESS_TOKEN), RLS test member identifiers ইত্যাদি থাকতে পারে।

এই নথিতে কোনো secret value, password, token বা encryption passphrase রাখা যাবে না। Secret পরিবর্তন কেবল বাস্তব প্রয়োজন ও যাচাই করা কারণ থাকলে করতে হবে। সফল Run #85-এর পরে অকারণে secret rotate বা workflow edit করা উচিত নয়।

## 8. পরবর্তী কাজের অগ্রাধিকার

1. **সর্বোচ্চ অগ্রাধিকার:** ৩০টি pending migration কেন remote history-তে applied হিসেবে দেখা যাচ্ছে না, তা যাচাই করা।
2. প্রতিটি migration-এর বর্তমান remote schema-এর সঙ্গে সামঞ্জস্য ও নিরাপত্তা পর্যালোচনা।
3. প্রয়োজনে staging/disposable database-এ migration apply test।
4. আলাদা অনুমোদন ছাড়া production-এ কোনো schema change নয়।
5. Two-member RLS audit workflow-এর সর্বশেষ ফলাফল যাচাই।
6. ভবিষ্যৎ কাজ শেষে এই handover ফাইলের তারিখ, commit, run, সম্পন্ন কাজ ও বাকি কাজ update করা।

## 9. ভবিষ্যৎ সহকারীর জন্য সংক্ষিপ্ত নির্দেশনা

ব্যবহারকারীকে আবার শুরু থেকে সব করতে বলবেন না। প্রথমে এই নথি পড়ুন এবং সর্বশেষ GitHub state যাচাই করুন। Run #85-এর Backup/Restore/History Repair/Preview সফল হয়েছে—এটি ইতিমধ্যে সম্পন্ন। কিন্তু Preview-তে ৩০টি migration pending দেখানো হয়েছে—এটি এখনো সমাধান করা বাকি। এই দুই তথ্য একসঙ্গে ধরে কাজ করুন। ব্যবহারকারীকে না জানিয়ে production migration চালাবেন না।
