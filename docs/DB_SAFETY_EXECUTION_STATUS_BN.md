# MASTER WORLD VIP — Database Safety Execution Status (বাংলা)

সর্বশেষ যাচাই: 2026-11-24
Repository: https://github.com/rakib12301111-droid/master-world-vip

## বর্তমান বাস্তব অবস্থা

এই নথি Git repository-র workflow ও documentation দেখে তৈরি। GitHub Actions secret-এর মান, Supabase Dashboard-এর backup list, বা production database-এর live state এই repository read-access থেকে দেখা যায় না। তাই কোনো secret configured, backup created, restore passed, বা migration applied হয়েছে—এমন দাবি করা হচ্ছে না।

| ধাপ | যাচাইয়ের অবস্থা | পরবর্তী কাজ |
|---|---|---|
| Workflow ও migration safety code | Repository-তে আছে | নতুন run দিয়ে পুনরায় যাচাই |
| GitHub Actions secret values | গোপন; এখানে পড়া যায় না | Settings → Secrets and variables → Actions-এ secret নাম/উপস্থিতি যাচাই |
| Supabase Session Pooler connection | অজানা | সঠিক IPv4-compatible Session Pooler URI secret-এ দিন |
| Encrypted logical backup | সফলতার প্রমাণ নেই | Backup workflow সফলভাবে চালান |
| Disposable PostgreSQL restore | সফলতার প্রমাণ নেই | একই workflow-এর restore step PASS নিশ্চিত করুন |
| Migration dry-run | বর্তমান backup workflow-এ আছে | preview output পর্যালোচনা করুন |
| Owner identity/bootstrap verification | production-এ যাচাই হয়নি | apply-এর আগে নির্ধারিত Owner identity যাচাই |
| Production migration | ইচ্ছাকৃতভাবে pending | সব gate পূরণ ও আলাদা অনুমোদনের আগে চালাবেন না |
| Two-member RLS/Referral tests | test workflows আছে; live PASS প্রমাণ নেই | দুটি আলাদা test member UUID secret দিন এবং migration-এর পরে run করুন |

## Secret inventory — নাম ও কোন workflow-এ লাগে

শুধু GitHub repository → Settings → Secrets and variables → Actions-এ যোগ করতে হবে। Secret value কখনো source code, issue, chat, log বা commit-এ লিখবেন না।

| Secret name | ব্যবহার | মন্তব্য |
|---|---|---|
| `SUPABASE_DB_URL` | Encrypted backup/restore preview, secure migration workflow, referral two-member test | IPv4-compatible Supabase Session Pooler URI; port 5432; database path `/postgres` |
| `BACKUP_ENCRYPTION_PASSPHRASE` | Encrypted backup workflow | শক্তিশালী, অনন্য passphrase; আলাদা password manager/offline secure place-এ রাখুন |
| `SUPABASE_ACCESS_TOKEN` | `database-migration-dry-run.yml` | Supabase Personal Access Token; `sbp_` দিয়ে শুরু |
| `SUPABASE_DB_PASSWORD` | `database-migration-dry-run.yml`, `test-two-member-rls.yml` | Project database password; GitHub Secret-এ রাখুন |
| `RLS_TEST_MEMBER_A_UUID` | Two-member RLS ও Referral test | প্রথম test account-এর Auth user UUID |
| `RLS_TEST_MEMBER_B_UUID` | Two-member RLS ও Referral test | দ্বিতীয়, আলাদা test account-এর Auth user UUID |

Referral reward processor-এর জন্য আলাদা integration পর্যায়ে `SUPABASE_URL` ও `REFERRAL_CRON_SECRET`-এর মতো প্রয়োজনীয় secret Supabase Edge Function এবং GitHub Actions-এ configure করতে হবে। বর্তমান backup কাজের জন্য এগুলো বিকল্প নয়।

## নিরাপদ কাজের ক্রম

1. Secret-এর নাম উপস্থিত কি না GitHub Settings-এ দেখুন; value কারও সঙ্গে শেয়ার করবেন না।
2. Supabase Dashboard-এ project ref `lztbbrzeuyjkuiyzrsxp` এবং Database → Backups-এ সর্বশেষ recoverable backup যাচাই করুন।
3. `.github/workflows/backup-restore-preview.yml` manual workflow চালান।
4. সব ধাপ PASS নিশ্চিত করুন: secret validation, PostgreSQL client, Session Pooler connection, encrypted dump, decrypt, disposable restore, migration dry-run, artifact upload।
5. Encrypted backup artifact ৭ দিনের মধ্যে download করে GitHub-এর বাইরে নিরাপদ encrypted/offline storage-এ রাখুন। GitHub Actions artifact একমাত্র দীর্ঘমেয়াদি backup নয়।
6. Restore report-এ non-secret run ID, backup reference, restored table count, preview result এবং failure থাকলে তার কারণ নথিবদ্ধ করুন।
7. Migration dry-run output ও pending migration list review করুন; Owner/bootstrap account সঠিক কি না আলাদাভাবে যাচাই করুন।
8. দুটি আলাদা test member account তৈরি/নির্বাচন করুন। তাদের UUID secret হিসেবে দিন; কখনো password বা OTP নয়।
9. Restore, preview ও Owner review সফল না হওয়া পর্যন্ত Production Apply করবেন না।
10. Apply-এর জন্য workflow-তে আলাদা করে প্রকল্প নিশ্চিতকরণ, backup/restore references, boolean confirmations এবং exact authorization phrase প্রয়োজন। এটি production database পরিবর্তন করে—প্রতিটি শর্ত বাস্তবে পূরণ না হলে চালাবেন না।
11. Apply-এর পরে two-member RLS, referral, chat, group, broadcast, location consent ও helpdesk tests চালান।
12. Feature register-এ কেবল প্রমাণিত PASS/Deployment ফলাফলকে complete/live হিসেবে লিখুন।

## গুরুত্বপূর্ণ নিরাপত্তা নিয়ম

- Backup encryption passphrase হারালে encrypted artifact restore করা যাবে না; আলাদা নিরাপদ জায়গায় রাখুন।
- GitHub artifact retention ৭ দিন; long-term backup হিসেবে ধরে নেবেন না।
- Backup workflow disposable PostgreSQL service-এ restore করে, production database-এ নয়।
- Supabase-specific extension/role incompatibility-তে restore fail করলে সেটি ব্যর্থ restore; migration gate বন্ধ থাকবে।
- Production migration চালানো এবং backup/restore পরীক্ষা আলাদা কাজ।
- কোনো secret value, OTP, database password, signed URL বা encryption key chat-এ দেবেন না।
- Backup/restore ও dry-run PASS হলেও Production Apply স্বয়ংক্রিয়ভাবে হবে না।

## Update 2026-11-25 — চার ধাপের বর্তমান অগ্রগতি

এই তারিখে repository workflow ও পূর্ববর্তী execution evidence পুনরায় পর্যালোচনা করা হয়েছে। আগের Database Safety Pipeline Run #1–#4 ব্যর্থ হয়েছিল; সর্বশেষ Run #4-এ `SUPABASE_DB_URL` এবং `BACKUP_ENCRYPTION_PASSPHRASE` অনুপস্থিত ছিল। তাই backup তৈরি হয়নি, restore test চলেনি, এবং migration preview-ও সম্পন্ন হয়নি। কোনো non-secret backup reference বা restore-test reference পাওয়া যায়নি।

| ক্রম | বাধ্যতামূলক ধাপ | 2026-11-25 অবস্থা | প্রমাণ/পরবর্তী পদক্ষেপ |
|---|---|---|---|
| ১ | Recoverable encrypted full backup | BLOCKED | GitHub Actions Secrets-এ `SUPABASE_DB_URL` ও `BACKUP_ENCRYPTION_PASSPHRASE` নিরাপদে configure করতে হবে; তারপর `backup-restore-preview.yml` সফলভাবে চালাতে হবে। |
| ২ | আলাদা disposable PostgreSQL-এ restore test | NOT RUN | ধাপ ১-এর backup তৈরি হওয়ার পর একই workflow-এর restore step PASS এবং restored table count যাচাই করতে হবে। |
| ৩ | Production migration dry-run | NOT RUN | একই workflow-এর `supabase db push --dry-run` সফল হতে হবে; pending migration list review করতে হবে। |
| ৪ | নির্দিষ্ট Owner authorization | NOT GIVEN FOR THIS APPLY | প্রথম তিন ধাপ সফল ও review হওয়ার পরই exact phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS` দিয়ে আলাদা guarded production apply অনুমোদন চাইতে হবে। |

**নিরাপত্তা সিদ্ধান্ত:** চারটি ধাপের কোনোটিই সফল হয়েছে বলে চিহ্নিত করা হয়নি। Production migration চালানো হয়নি এবং চালানো যাবে না। আগের কোনো authorization phrase থাকলেও তা এই নতুন run-এর backup/restore/preview evidence-এর বিকল্প নয়।

**করণীয়:** GitHub → Settings → Secrets and variables → Actions-এ `SUPABASE_DB_URL` (IPv4-compatible Session Pooler, port 5432, database `/postgres`) এবং `BACKUP_ENCRYPTION_PASSPHRASE` secret যোগ/যাচাই করুন। Secret value chat-এ দেবেন না। তারপর Actions → “MASTER WORLD VIP - Encrypted Backup, Restore Test & Migration Preview” → Run workflow চালান। Artifact ৭ দিনের মধ্যে GitHub-এর বাইরে নিরাপদ encrypted storage-এ সংরক্ষণ করুন।


## Update 2026-11-25 — নতুন Backup Workflow Run যাচাই

Commit `64350b9922e1ef493e5dd89aa02827f639f89e44`-এর পর স্বয়ংক্রিয়ভাবে চালু হওয়া Run `45468408735` পরীক্ষা করা হয়েছে।

- Workflow: `.github/workflows/backup-restore-preview.yml`
- Run result: **FAILED**
- Secret presence validation: PASS
- Session Pooler URI syntax validation: PASS
- Supabase database authentication / backup creation: FAIL — PostgreSQL `password authentication failed`
- Encrypted backup artifact: তৈরি হয়নি
- Disposable restore test: SKIPPED
- Migration dry-run: SKIPPED
- Production migration: NOT RUN

### জরুরি credential remediation

আগের run log-এ extracted database credential প্রকাশিত হওয়ার ঝুঁকি শনাক্ত হয়েছে। তাই সংশ্লিষ্ট Supabase database password-কে compromised হিসেবে বিবেচনা করতে হবে। Owner-কে Supabase Dashboard থেকে database password rotate করে GitHub Actions secret `SUPABASE_DB_URL`-এ নতুন সম্পূর্ণ Session Pooler URI দিতে হবে। পুরোনো password আর ব্যবহার করা যাবে না। নতুন credential chat, issue, commit বা screenshot-এ প্রকাশ করা যাবে না।

Workflow-তে extracted username/password mask করার code যোগ হয়েছে; তবে এটি আগের log থেকে তথ্য মুছে দেয় না এবং authentication failure ঠিকও করে না।

**পরবর্তী gate:** Owner password rotate করে Secret update নিশ্চিত না করা পর্যন্ত backup workflow পুনরায় চালাবেন না। নতুন run-এ backup, restore, dry-run ও artifact upload—সব PASS না হওয়া পর্যন্ত ধাপ ১–৩ অসম্পন্ন থাকবে। Production migration সম্পূর্ণ নিষিদ্ধ থাকবে।
