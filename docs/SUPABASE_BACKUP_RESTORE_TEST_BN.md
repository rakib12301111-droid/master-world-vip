# MASTER WORLD VIP — Supabase Backup ও Restore Test গাইড

শেষ পর্যালোচনা: 2026-11-22

## উদ্দেশ্য

Production Supabase project-এ migration চালানোর আগে বর্তমান database-এর recoverable backup এবং আলাদা test environment-এ সফল restore যাচাই করা। **GitHub workflow-এর checkbox নিজে backup তৈরি বা restore করে না।** কোনো পরীক্ষা না করে `restore_tested=true` দেওয়া যাবে না।

## ধাপ ১ — Backup খুঁজুন

1. Supabase Dashboard খুলুন: https://supabase.com/dashboard/project/lztbbrzeuyjkuiyzrsxp
2. বাম পাশের **Database → Backups** খুলুন।
3. সর্বশেষ সফল backup/restore point-এর তারিখ ও সময়, ধরন এবং Dashboard-এ দেখানো backup identifier/reference নোট করুন।
4. Backup তালিকা না থাকলে project plan/backup capability যাচাই করুন। Free plan-এ নিয়মিত managed daily backup নাও থাকতে পারে; সেক্ষেত্রে Supabase CLI দিয়ে logical backup export এবং নিরাপদ off-site সংরক্ষণের ব্যবস্থা করতে হবে।
5. Backup ID/reference ছাড়া অনুমান করে কোনো মান লিখবেন না।

**গোপনীয়তা:** Database password, connection string, access token, signed URL বা backup download URL GitHub issue/chat/commit-এ দেবেন না। কেবল non-secret backup ID/reference ব্যবহার করুন।

## ধাপ ২ — Production-এ হাত না দিয়ে Restore Test

### বিকল্প A: Paid plan ও physical backup থাকলে (প্রস্তাবিত)

1. Source project-এর **Database → Backups → Restore to a New Project** tab খুলুন।
2. উপযুক্ত backup নির্বাচন করুন এবং Supabase-এর দেখানো সম্ভাব্য খরচ/compute ব্যয় পর্যালোচনা করুন।
3. নতুন project-এ restore শুরু করুন। **মূল Production project-এ Restore চাপবেন না।**
4. Restore শেষ হলে নতুন project-এর Database/SQL Editor-এ গিয়ে যাচাই করুন:
   - প্রয়োজনীয় schema, tables, views, functions ও indexes উপস্থিত;
   - গুরুত্বপূর্ণ application tables-এর row count যুক্তিসঙ্গত;
   - RLS policies এবং grants উপস্থিত;
   - Auth schema/users-এর প্রত্যাশিত অবস্থা আছে;
   - migration history (`supabase_migrations.schema_migrations`) প্রত্যাশিত অবস্থায় আছে।
5. প্রয়োজনীয় extensions, Auth/API settings, Edge Functions, Realtime settings এবং Storage objects আলাদাভাবে যাচাই/পুনঃকনফিগার করুন। Restore-to-new-project database copy সব external settings, Edge Functions বা Storage object কপি করে না।
6. নতুন project-এ read-only smoke test এবং প্রয়োজনীয় application/RLS test চালান। Production URL/key যেন test build-এ না থাকে তা নিশ্চিত করুন।
7. Test project ref, backup identifier, restore completion time এবং test ফলাফল নিরাপদে নথিবদ্ধ করুন। Test শেষ হলে test project রাখার খরচ বিবেচনা করে নিরাপদে বন্ধ/মুছুন।

### বিকল্প B: Local logical restore

যদি Restore-to-New-Project সুবিধা না থাকে, Supabase-এর CLI backup/restore নির্দেশনা অনুসরণ করে আলাদা local PostgreSQL/Supabase environment-এ logical dump restore করুন। Backup file ও credentials নিরাপদে রাখুন; local restore সফলভাবে চালু করে SQL দিয়ে schema/table/data যাচাই করুন। Local restore Production database-এ চালাবেন না।

## ধাপ ৩ — Restore Test প্রমাণ নথিবদ্ধ করুন

নিচের তথ্যগুলো নিজের নিরাপদ নথিতে লিখুন:

- Backup ID/reference (গোপন নয় এমন identifier)
- Restore target: আলাদা test project ref অথবা local test environment
- Restore সম্পন্ন হওয়ার তারিখ/সময়
- Schema/table/data/RLS smoke-test ফলাফল
- Restore-এর কোনো error বা অসম্পূর্ণ অংশ

GitHub Actions-এ `restore_tested=true` দেওয়ার আগে বাস্তবে এই ধাপগুলো সম্পন্ন হতে হবে। Restore test reference হিসেবে test project ref বা internal test record ID দিন; কোনো password, token, connection string বা signed URL নয়।

## ধাপ ৪ — Production Apply gate

Secure Database Update workflow-তে Apply কেবল তখনই চালানো যাবে যখন:

- `backup_confirmed=true`
- `restore_tested=true`
- `backup_reference`-এ আসল non-secret backup identifier আছে
- `restore_test_reference`-এ সফল restore test-এর non-secret reference আছে
- `confirm_project=MASTER-WORLD-VIP`
- `confirm_apply=APPLY-MASTER-WORLD-VIP-MIGRATIONS`
- `apply_migrations=true`

প্রথমে অবশ্যই `apply_migrations=false` দিয়ে Preview চালিয়ে সব pending migration পর্যালোচনা করতে হবে। Preview সফল হওয়া Restore Test-এর বিকল্প নয়।

## Official Supabase guidance

- Database backups: https://supabase.com/docs/guides/platform/backups
- Restore to a new project: https://supabase.com/docs/guides/platform/clone-project
- Backup and restore using CLI: https://supabase.com/docs/guides/platform/migrating-within-supabase/backup-restore


## GitHub Actions automated pipeline (2026-11-23)

Repository-তে `.github/workflows/backup-restore-preview.yml` যোগ করা হয়েছে। এটি manual dispatch-এ:

1. Supabase Session Pooler দিয়ে database-এর full logical dump নেয়;
2. dump-টি AES-256-CBC/PBKDF2 দিয়ে encrypt করে;
3. disposable PostgreSQL 17 service-এ decrypt করে restore চালায়—Production-এ নয়;
4. সব pending migration-এর `supabase db push --dry-run` preview চালায়;
5. encrypted backup artifact ৭ দিন রাখে এবং non-secret backup/restore run reference দেখায়।

চালানোর আগে GitHub repository → Settings → Secrets and variables → Actions-এ নিচের secret থাকতে হবে:

- `SUPABASE_DB_URL`: Supabase IPv4-compatible Session Pooler connection string;
- `SUPABASE_ACCESS_TOKEN`: Supabase Personal Access Token (`sbp_` দিয়ে শুরু);
- `BACKUP_ENCRYPTION_PASSPHRASE`: শক্তিশালী, অনন্য backup encryption passphrase।

এই secret-গুলোর মান কখনো chat/issue/commit-এ দেবেন না। Workflow run সফল না হওয়া পর্যন্ত backup বা restore test সফল হয়েছে বলা যাবে না। Restore step PostgreSQL 17-এ কোনো Supabase-specific extension/role/schema incompatibility পেলে fail করবে; সেটিকে সফল restore হিসেবে গণ্য করা যাবে না এবং Production Apply gate খোলা যাবে না।

এই pipeline Production migration apply করে না। সফল backup+restore+preview-এর পরে আলাদা অনুমোদিত migration workflow এবং দুই সদস্যের RLS integration test চালাতে হবে। `RLS_TEST_MEMBER_A_UUID`, `RLS_TEST_MEMBER_B_UUID`, এবং ঐ workflow-এর প্রয়োজনীয় DB credential secrets আগে থেকেই নিরাপদে configured থাকতে হবে।
