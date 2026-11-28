# Staging Owner Email / Auth Rate-Limit Remediation

**তারিখ:** ২৮ নভেম্বর ২০২৬  
**শুধু Target:** Supabase Staging `awatzrapqrteybgspqlq`  
**Production:** `lztbbrzeuyjkuiyzrsxp` — এই কাজের বাইরে; অপরিবর্তিত

## সরাসরি যাচাইকৃত অবস্থা

- Staging Auth-এ Owner account আছে: `r94043908+owner@gmail.com`।
- Supabase Auth User ID: `3601abbe-d194-473a-be6c-e90644fdba4f`।
- Supabase dashboard-এ `Confirmed` ফাঁকা এবং `Last signed in` ফাঁকা ছিল।
- Dashboard logs-এ একাধিক HTTP `429` দেখা গেছে।
- Supabase dashboard থেকে confirmation পাঠানোর চেষ্টায় সুনির্দিষ্ট বার্তা: `email rate limit exceeded`।
- Gmail সংযোগে অনুসন্ধান করে এই Owner ঠিকানার জন্য Staging confirmation email পাওয়া যায়নি। `rakib12301111@gmail.com`-এ পাওয়া Staging invite Member-এর; পুরোনো confirmation mail-টি Production project `lztbbrzeuyjkuiyzrsxp`-এর, তাই সেটি Owner/Staging confirmation হিসেবে ব্যবহার করা যাবে না।
- Owner confirmation ও password login এখনও **unverified**।

## মূল কারণ ও সীমা

বর্তমান প্রমাণে Staging Supabase Auth email-sending rate limit অতিক্রম করেছে। এটি Gmail mailbox-এর সমস্যা প্রমাণ করে না। GitHub source code দিয়ে Supabase hosted Auth-এর project-level email quota বা SMTP provider configuration পরিবর্তন করা যায় না। বারবার Send confirmation চাপলে সমস্যা আরও বাড়তে পারে।

## এই আপডেটে কোড-স্তরের সুরক্ষা

`.github/workflows/validate-staging-supabase.yml`-এর Auth preflight এখন HTTP 429 পেলেই অবিলম্বে বন্ধ হবে। আগে Owner/Admin/Member তিনটি login request-ই চেষ্টা করা হতো; rate-limit হলে বাকি request না পাঠিয়ে workflow থামানো হবে। এটি rate limit তুলে দেয় না; অতিরিক্ত retry ঠেকায়।

## প্রয়োজনীয় অপারেশনাল সমাধান

1. Supabase Dashboard-এ Staging project-ই নির্বাচিত আছে নিশ্চিত করতে হবে।
2. Authentication → SMTP Settings-এ custom SMTP configured/verified কি না পরীক্ষা করতে হবে। প্রয়োজন হলে প্রকল্প-মালিকের নিজস্ব mail provider-এর SMTP তথ্য Supabase Dashboard-এ নিজে বসাতে হবে; কোনো password বা SMTP secret GitHub source-এ রাখা যাবে না।
3. Authentication → Rate Limits / Email limits-এ বর্তমান email send limit ও reset window পরীক্ষা করতে হবে। Dashboard-এ যে limit/reset সময় দেখায় সেটিই অনুসরণ করতে হবে; নির্দিষ্ট reset সময় অনুমান করা যাবে না।
4. Limit reset হওয়ার আগে আর confirmation/resend/invite request নয়।
5. তারপর Owner-এর confirmation একবার পাঠিয়ে Gmail Inbox/Spam/All Mail-এ খুঁজতে হবে। নিশ্চিতকরণ link-এ Staging host `awatzrapqrteybgspqlq.supabase.co` আছে কি না যাচাই করতে হবে। Production host-এর link ব্যবহার করা যাবে না।
6. Supabase User Overview-তে `Confirmed` timestamp না আসা পর্যন্ত Owner confirmed বলা যাবে না।
7. Owner confirmed হলে তিনটি আলাদা Staging account-এর current password/secret মিলিয়ে workflow manual run করতে হবে। Auth preflight PASS না হওয়া পর্যন্ত migration/role acceptance চালু হবে না।

## নিষেধাজ্ঞা

- কোনো Owner/Admin/Member account delete বা recreate নয়।
- Password reset বা GitHub Secret change অনুমান করে নয়; exact credential mismatch প্রমাণিত হলে তবেই।
- Auth preflight bypass নয়।
- Production Auth, database, secrets, email settings বা migration-এ কোনো পরিবর্তন নয়।
- কোনো secret, SMTP password, API key বা confirmation token log/commit/chat-এ রাখা যাবে না।

## Status

- HTTP 429 immediate-stop guard: **committed in this PR branch**.
- Hosted Supabase SMTP/rate-limit configuration: **dashboard-side verification required**.
- Owner confirmation: **PENDING**.
- Owner/Admin/Member password login acceptance: **PENDING**.
- Production migration: **DISABLED / NOT TOUCHED**.
