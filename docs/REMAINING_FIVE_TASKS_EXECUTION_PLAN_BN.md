# MASTER WORLD VIP — বাকি পাঁচটি কাজের বাস্তবায়ন পরিকল্পনা

**তারিখ:** ২৭ নভেম্বর ২০২৬  
**কাজের Branch:** `feature/customer-quote-workflow`  
**উদ্দেশ্য:** বিদ্যমান প্রকল্প অক্ষত রেখে Staging থেকে Android acceptance পর্যন্ত নিরাপদে এগোনো। এই নথি কোনো কাজ সম্পন্ন হওয়ার দাবি নয়; প্রতিটি ধাপের বাস্তব প্রমাণ আলাদাভাবে যোগ করতে হবে।

## বর্তমান যাচাইকৃত ভিত্তি

- PR #21: `feature/customer-services-mvp` → `main`; Open/Draft। এই পর্যালোচনায় PR #21-এর head commit-এর CI ফল পাওয়া যায়নি।
- PR #22: `feature/customer-quote-workflow` → PR #21-এর branch; Open/Draft, Unmerged।
- PR #22 head `2040b1107221b45091ea5e9406a104c7d7b3a599`-এ ২৭ নভেম্বর ২০২৬ তারিখে চারটি check সফল: `validate-all-migrations`, `validate`, `auto-work-static-safety`, `static-migration-safety`। এগুলো repository/CI validation; Staging বা Production acceptance নয়।
- Staging backup/restore preview workflow যোগ করা হয়েছে: `.github/workflows/backup-staging-restore-preview.yml`। এটি কেবল আলাদা disposable PostgreSQL-এ encrypted backup restore যাচাই করে; Staging/Production-এ migration apply করে না।
- PR merge করা হয়নি; Production migration বা public deployment করা হয়নি।

## পাঁচটি বাকি কাজ

### ২. Staging project ও connection প্রস্তুতি
**কোড/ডকুমেন্টেশন:** Staging-কে Production থেকে পৃথক project ref দিয়ে যাচাই; workflow-এ Production ref প্রত্যাখ্যানের guard রাখা।  
**বাস্তব প্রমাণ:** Staging project ref, Session Pooler URI validation এবং GitHub Actions run।  
**অবরোধ:** Supabase dashboard-এ project ref ও connection secret সহকারীর কাছে দৃশ্যমান নয়।

### ৩. Staging GitHub Actions Secrets
Repository → Settings → Secrets and variables → Actions-এ নিচের চারটি নাম থাকতে হবে:
- `SUPABASE_STAGING_ACCESS_TOKEN`
- `SUPABASE_STAGING_PROJECT_REF`
- `SUPABASE_STAGING_DB_URL`
- `STAGING_BACKUP_ENCRYPTION_PASSPHRASE`

শুধু Staging-এর মান ব্যবহার করতে হবে। কোনো secret value চ্যাটে পাঠানো যাবে না। Secret উপস্থিতির প্রমাণ GitHub-এর masked workflow run থেকে নিতে হবে; secret API/মান পড়ার চেষ্টা নয়।

### ৪. Staging backup, restore ও migration validation
নিরাপদ ক্রম:
1. Staging backup workflow dispatch করা।
2. Encrypted backup artifact তৈরি হয়েছে কি না দেখা।
3. আলাদা disposable PostgreSQL-এ decrypt ও restore test সফল কি না দেখা।
4. Staging migration preview/dry-run ও migration dependency checks দেখা।
5. Preview সফল হলে আলাদা Staging apply অনুমোদন নেওয়া; তারপরই Staging migration apply ও schema verification।

**Production-এ কোনো apply নয়।** Staging apply-এর জন্য পৃথক exact approval phrase: `APPLY-MASTER-WORLD-VIP-STAGING-MIGRATIONS`। শুধু “আপডেট করুন” কথাটি live migration অনুমোদন নয়।

### ৫. Customer/Admin বাস্তব Acceptance
Staging-এ আলাদা Owner, Admin, Customer এবং Worker test account দিয়ে:
- login/session ও RBAC;
- customer order তৈরি, quote/assignment, worker claim;
- কাজ জমা, যাচাই, status transitions;
- notification ও audit trail;
- wallet/commission/refund reserve হিসাবের non-cash test;
- unauthorized access, duplicate request ও cross-account isolation পরীক্ষা।

**সফলতার প্রমাণ:** test run/log, sanitized test record ও pass/fail matrix। বাস্তব টাকা, payment capture বা payout নয়।

### ৬. Android acceptance ও Live Deployment readiness
- Android Chrome/PWA install, login, navigation, offline/cache update, notification permission ও responsive UI পরীক্ষা।
- Service Worker/cache upgrade ও rollback behaviour পরীক্ষা।
- Release build/signing configuration যাচাই; আসল keystore বা signing secret ছাড়া signed release সফল দাবি নয়।
- সব acceptance ও security gate pass হওয়ার পর release review। PR merge/Pages deployment-এর আগে আলাদা release decision আবশ্যক; merge করলে public site বদলাতে পারে।

## কাজের নিয়ম ও গণনা

- কোনো secret, password, token, OTP বা passphrase নথিতে/চ্যাটে রাখা যাবে না।
- Production migration, live data mutation, payment/payout এবং public deployment এই পরিকল্পনার স্বয়ংক্রিয় অংশ নয়।
- CI success-কে Staging, Customer/Admin, Android বা Live success হিসেবে গণনা করা যাবে না।
- প্রতিটি কাজের status হবে: **কোড প্রস্তুত / বাহ্যিক প্রস্তুতি বাকি / Run অপেক্ষমাণ / Run সফল / Acceptance সফল**।
- বর্তমান অবস্থায় পাঁচটি কাজের কোনোটিই সম্পূর্ণ বলে গণনা করা হচ্ছে না। Workflow ও documentation প্রস্তুতির অংশ আছে; বাস্তব Staging run, acceptance ও release বাকি।
- নতুন প্রমাণ এলে root `PROJECT_HANDOVER_MASTER_BN.md`-এ run URL, commit, artifact ID, ফলাফল ও তারিখ যোগ করতে হবে।
