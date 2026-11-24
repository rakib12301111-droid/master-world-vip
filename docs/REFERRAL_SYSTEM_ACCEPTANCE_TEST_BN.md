# MASTER WORLD VIP Referral System — বাস্তব পরীক্ষা নির্দেশিকা

**অবস্থা:** কোড ও test workflow repository-তে আছে; production migration, secrets, funding এবং বাস্তব payout এখনো যাচাই হয়নি।

## ১. Production-এর আগে বাধ্যতামূলক প্রস্তুতি
1. Supabase-এর recoverable backup নিন এবং আলাদা test project/environment-এ restore সফল হয়েছে নিশ্চিত করুন।
2. GitHub Actions-এর SUPABASE_ACCESS_TOKEN এবং IPv4-compatible Session Pooler SUPABASE_DB_URL secrets ঠিক আছে কি না যাচাই করুন।
3. apply-supabase-migrations.yml-এ migration dry-run চালিয়ে সব pending migration review করুন। Production apply কেবল backup/restore gate এবং exact authorization phrase দিয়ে হবে।
4. Migration 202611240003_referral_wallet_rewards.sql এবং 202611240005_international_referral_usd_equivalent.sql-সহ সব pending migration apply ও schema/RLS verify না হওয়া পর্যন্ত wallet UI-কে Live বলবেন না।
5. Supabase Edge Function process-referral-rewards deploy হয়েছে নিশ্চিত করুন। Function Secrets-এ REFERRAL_CRON_SECRET দিন।
6. GitHub Actions Secrets-এ একই গোপন মান REFERRAL_CRON_SECRET এবং project URL SUPABASE_URL দিন। Secret কখনো chat, source code বা browser-এ রাখবেন না।
7. Reward চালুর আগে বাস্তবে আলাদা করে রাখা পর্যাপ্ত BDT Reward Fund Owner-এর মাধ্যমে ledger-এ রেকর্ড করুন। বিদেশি referral-এর জন্য US$৫০ × বর্তমান BDT/USD rate যত হয়, অন্তত সেই পরিমাণ budget থাকতে হবে। ভুয়া reference বা অনুপস্থিত টাকা কখনো funding হিসেবে যোগ করবেন না।
8. Owner panel-এ নির্ভরযোগ্য উৎস, তারিখ/reference-সহ USD/BDT rate সংরক্ষণ করুন। উদাহরণস্বরূপ rate 130 হলে বিদেশি reward ৳৬,৫০০; এটি কেবল উদাহরণ, live quote নয়।

## ২. দুই সদস্য দিয়ে Referral পরীক্ষা
- Member A ও Member B নামে দুটি পৃথক সাধারণ (non-admin) account তৈরি করুন।
- দুজনের email verification সম্পন্ন করুন এবং profile display name পূরণ করুন।
- Member A লগইন করে Referral Center থেকে নিজের Referral Link কপি করবেন।
- Member B সম্পূর্ণ নতুন email দিয়ে ওই link থেকে signup করবেন।
- প্রথম ২৪ ঘণ্টার আগে Member A-এর Wallet-এ কোনো reward যোগ হওয়া চলবে না।
- Member B-এর signup-এর ২৪ ঘণ্টা পূর্ণ হওয়ার পর scheduled processor পরবর্তী run-এ eligibility যাচাই করবে। Email verified, profile complete, account not currently banned, valid attribution এবং পর্যাপ্ত reward budget থাকলে একবারই credit হবে। বাংলাদেশে থাকা referrer পাবে ৳৫০; বাংলাদেশ-বহির্ভূত referrer পাবে US$৫০ × সংরক্ষিত rate অনুযায়ী BDT।
- একই processor আবার চালালেও দ্বিতীয় credit হবে না; ledger-এ প্রযোজ্য country, USD base amount ও FX rate সংরক্ষিত থাকবে।
- Email unverified, profile incomplete, self-referral, duplicate attribution, banned account, referrer country missing, foreign rate missing বা পর্যাপ্ত BDT budget না থাকলে reward credit হবে না।
- Member A যেন Member B-এর Wallet/withdrawal details দেখতে না পারেন; Member B-ও যেন Member A-এর data দেখতে না পারেন।

## ৩. Withdrawal পরীক্ষা
1. Member A-এর Available Balance অন্তত ৳৫০ হলে bKash অথবা Nagad নম্বর দিয়ে আবেদন করুন।
2. আবেদন Pending হবে এবং একই টাকা দিয়ে দ্বিতীয় আবেদন করা যাবে না।
3. Admin request Approve বা Reject করবেন।
4. Approve হলে Admin বাস্তবে সংশ্লিষ্ট bKash/Nagad নম্বরে টাকা পাঠাবেন।
5. প্রকৃত transfer reference পাওয়ার পরই Admin Mark Paid করবেন। Reference ছাড়া Paid করা যাবে না।
6. bKash/Nagad official merchant/API integration না হওয়া পর্যন্ত এটি manual payout workflow; automatic cashout নয়।

## ৪. Two-member security workflow
test-referral-wallet-two-members.yml চালাতে GitHub Actions Secrets-এ:
- SUPABASE_DB_URL — IPv4-compatible Session Pooler connection string
- RLS_TEST_MEMBER_A_UUID — Member A-এর Auth UUID
- RLS_TEST_MEMBER_B_UUID — Member B-এর Auth UUID

দুটি UUID আলাদা এবং ordinary member account হতে হবে। এই test script read/privacy/permission assertions চালায়; এটি কোনো fund, withdrawal বা payment তৈরি করে না।

## ৫. সীমাবদ্ধতা ও সতর্কতা
- Scheduled qualification সর্বোচ্চ প্রায় ১৫ মিনিটের ব্যবধানে workflow run হলে সম্পন্ন হবে; GitHub scheduled workflow delay হতে পারে।
- ২৪ ঘণ্টা মানে registration timestamp থেকে ২৪ ঘণ্টা, ২৪ ঘণ্টা অনলাইনে থাকা নয়।
- বর্তমান withdrawal flow আবেদন, Admin review এবং manual payout record করে। Official bKash/Nagad merchant approval, API credentials, webhook signature verification এবং reconciliation ছাড়া automated payment চালু নয়।
- Referral reward কেবল তখনই issue হবে, যখন আগে থেকে বাস্তব funding রয়েছে, FX rate প্রযোজ্য ক্ষেত্রে সংরক্ষিত, এবং Owner rewards enabled করেছেন। Bangladesh reward ৳৫০; foreign reward USD 50 equivalent in BDT. No reward is a guaranteed cash payment without actual funds.
- Production migration apply বা test workflow চালাতে কোনো password, OTP, wallet PIN, service-role key বা secret chat-এ পাঠাবেন না।