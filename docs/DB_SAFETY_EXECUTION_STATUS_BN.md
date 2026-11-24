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
