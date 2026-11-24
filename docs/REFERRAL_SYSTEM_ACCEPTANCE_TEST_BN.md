# MASTER WORLD VIP Referral System — বাস্তব পরীক্ষা নির্দেশিকা

**অবস্থা:** কোড ও test workflow repository-তে আছে; production migration, secrets, funding এবং বাস্তব payout এখনো যাচাই হয়নি।

## ১. Production-এর আগে বাধ্যতামূলক প্রস্তুতি
1. Supabase-এর recoverable backup নিন এবং আলাদা test project/environment-এ restore সফল হয়েছে নিশ্চিত করুন।
2. GitHub Actions-এর SUPABASE_ACCESS_TOKEN এবং IPv4-compatible Session Pooler SUPABASE_DB_URL secrets ঠিক আছে কি না যাচাই করুন।
3. apply-supabase-migrations.yml-এ migration dry-run চালিয়ে সব pending migration review করুন। Production apply কেবল backup/restore gate এবং exact authorization phrase দিয়ে হবে।
4. Migration 202611240003_referral_wallet_rewards.sql, 202611240005_international_referral_usd_equivalent.sql এবং 202611240006_network_admin_referral_rewards.sql-সহ সব pending migration apply ও schema/RLS verify না হওয়া পর্যন্ত wallet UI-কে Live বলবেন না।
5. Supabase Edge Function process-referral-rewards deploy হয়েছে নিশ্চিত করুন। Function Secrets-এ REFERRAL_CRON_SECRET দিন।
6. GitHub Actions Secrets-এ একই গোপন মান REFERRAL_CRON_SECRET এবং project URL SUPABASE_URL দিন। Secret কখনো chat, source code বা browser-এ রাখবেন না।
7. Reward চালুর আগে কেবল বাস্তবে পাওয়া ও নিশ্চিত platform revenue/sponsor fund বরাদ্দ করুন। প্রতিটি referral-এর জন্য direct member reward + Owner network reward—দুইটির মোট ২০০% amount cover করার মতো budget লাগবে। ভুয়া reference বা অনুপস্থিত টাকা কখনো funding হিসেবে যোগ করবেন না।
8. Owner panel-এ নির্ভরযোগ্য উৎস, তারিখ/reference-সহ USD/BDT rate সংরক্ষণ করুন। Admin Country Review queue-তে profile country-এর প্রমাণ দেখে country verify করুন। উদাহরণস্বরূপ rate 130 হলে বিদেশি reward ৳৬,৫০০; এটি কেবল উদাহরণ, live quote নয়।

## ২. দুই সদস্য দিয়ে Referral পরীক্ষা
- Member A ও Member B নামে দুটি পৃথক সাধারণ (non-admin) account তৈরি করুন।
- দুজনের email verification সম্পন্ন করুন এবং profile display name পূরণ করুন।
- Member A লগইন করে Referral Center থেকে নিজের Referral Link কপি করবেন।
- Member B সম্পূর্ণ নতুন email দিয়ে ওই link থেকে signup করবেন।
- প্রথম ২৪ ঘণ্টার আগে Member A-এর Wallet-এ কোনো reward যোগ হওয়া চলবে না।
- Member B-এর signup-এর ২৪ ঘণ্টা পূর্ণ হওয়ার পর scheduled processor eligibility যাচাই করবে। Email verified, profile complete, account not currently banned, valid attribution এবং country verification থাকলে member-এর ১০০% direct ও single verified Owner-এর ১০০% network entitlement তৈরি হবে। দুইটির মোট ২০০% cleared budget থাকলেই দুই wallet credit একসঙ্গে হবে।
- একই processor আবার চালালেও দ্বিতীয় credit হবে না; ledger-এ প্রযোজ্য country, USD base amount ও FX rate সংরক্ষিত থাকবে।
- Email unverified, profile incomplete, self-referral, duplicate attribution, banned account, referrer country missing or not Admin-verified, foreign rate missing বা পর্যাপ্ত BDT budget না থাকলে reward credit হবে না।
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

## ৬. Network Owner reward-এর বিশেষ পরীক্ষা
- A→B→C→D→E→Z referral chain তৈরি করুন; প্রতিটি account-এর attribution আলাদা করে যাচাই করুন।
- প্রত্যেক স্তরে referrer কেবল নিজের direct referral reward-এর ১০০% পাবে।
- একমাত্র verified Owner account প্রতিটি eligible referral event-এর জন্য অতিরিক্ত ১০০% পাবে; tree depth বাড়লেও Owner-এর eligible event count বাড়বে।
- এক referral-এর জন্য ledger-এ `member_direct` এবং `owner_network`—দুটি পৃথক entry থাকবে; duplicate processor run-এ তৃতীয় entry তৈরি হবে না।
- দুই reward-এর মোট ২০০% budget না থাকলে দুটিই Pending থাকবে; আংশিক credit হবে না। Budget যোগ হলে পরবর্তী processor run-এ দুইটি একসঙ্গে credit হবে।
- Exactly one Owner role না থাকলে reward release বন্ধ থাকবে। Owner network credit Owner wallet-এ দেখা যাবে; সাধারণ সদস্য অন্যের wallet বা network commission দেখতে পারবে না।
