# MASTER WORLD VIP — Referral Reward Policy (বাংলা)

সিদ্ধান্তের অবস্থা: **ব্যবহারকারীর অনুমোদিত নীতিমালা; production-এ এখনো চালু নয়।**
অনুমোদিত: ২০২৬-১১-২৪

## অনুমোদিত নিয়ম

- আমন্ত্রণকারী সদস্যের referral খরচ: **৳০**; নতুন সদস্যের registration-ও **ফ্রি**।
- কোনো deposit, VIP package, paid activation বা বাধ্যতামূলক কেনাকাটা লাগবে না।
- **বাংলাদেশে থাকা যোগ্য আমন্ত্রণকারী সদস্য:** প্রতি সফল সরাসরি referral-এ **৳৫০ BDT**।
- **বিদেশে থাকা সাধারণ সদস্য:** নিজের সরাসরি সফল referral-এ standard reward-এর ১০০% পাবেন, অর্থাৎ **US$৫০-এর সমপরিমাণ BDT**। উদাহরণ: ১ USD = ৳১৩০ হলে ৳৬,৫০০; এটি শুধু উদাহরণ, live rate নয়।
- বিদেশি পুরস্কারের BDT মূল্য হিসাবের সময় ব্যবহৃত USD/BDT রেটের ভিত্তিতে নির্ধারিত হবে এবং সেই রেট, উৎস ও reference ledger-এ সংরক্ষিত থাকবে। পুরস্কার ক্রেডিট হওয়ার পর সেই ক্রেডিটের রেট বদলাবে না।
- এই সংস্করণে wallet ও withdrawal amount BDT-তে থাকবে; বিদেশি সদস্যের US$৫০ মূল্য BDT-তে রূপান্তর করে দেখানো হবে। অন্য দেশের payout currency/provider যোগ করা আলাদা কাজ।
- দেশের ভিত্তি হবে আমন্ত্রণকারী সদস্যের profile country; তবে reward দেওয়ার আগে Owner/Admin-কে তথ্য যাচাই করে server-side verified করতে হবে। Country ফাঁকা বা যাচাই না হলে reward আটকে থাকবে; VPN/IP/profile text দেখে স্বয়ংক্রিয়ভাবে দেশ অনুমান করা যাবে না।
- নতুন অ্যাকাউন্ট রেজিস্ট্রেশনের পর কমপক্ষে **২৪ ঘণ্টা** ভালো অবস্থায় থাকতে হবে; ২৪ ঘণ্টা অনলাইনে থাকা বাধ্যতামূলক নয়।
- নতুন সদস্যের email verification এবং profile completion থাকতে হবে।
- Referral code/link দিয়ে signup-এর সময় attribution server-side সংরক্ষিত হবে।
- Self-referral, duplicate/fake account, automated signup বা attribution manipulation নিষিদ্ধ; একই নতুন সদস্যের জন্য একবারের বেশি reward নয়।
- Referral qualification, credit ও payout state server-side, idempotent এবং audit-logged হতে হবে।

## বিনিময় হার, funding ও payout

- USD/BDT হার Owner-নিয়ন্ত্রিত server-side setting-এ source ও reference/date-সহ বসাতে হবে। বর্তমান migration-এ স্বয়ংক্রিয় live FX provider নেই; ভুল/পুরোনো হার যেন live rate বলে দেখানো না হয়।
- প্রতিটি যোগ্য referral-এ সরাসরি আমন্ত্রণকারী সদস্য ১০০% standard reward এবং একমাত্র verified Owner পুরো নেটওয়ার্কের যেকোনো স্তরের প্রতিটি referral-এ অতিরিক্ত ১০০% standard reward পাবেন। দুটো আলাদা ledger entry হবে; একই referral-এ মোট দায় standard reward-এর ২০০%।
- Budget অপর্যাপ্ত হলে member এবং Owner—দুই entitlement-ই Pending থাকবে; পুরো ২০০% amount-এর confirmed funds না থাকলে কোনো একপক্ষকে partial cash credit দেওয়া হবে না। Pending amount withdrawable balance নয়। কোনো সদস্যের deposit/fee নেওয়া যাবে না।
- Ledger-এ referral ID, member ID, BDT amount, country, USD base amount, applied FX rate, status, timestamps ও payout reference রাখতে হবে।
- বর্তমান withdrawal workflow বাংলাদেশি bKash/Nagad নম্বর ও manual Admin reconciliation-এর জন্য। এটি বিদেশি local-wallet payout বা automatic transfer নয়।
- PIN, OTP, wallet password বা অপ্রয়োজনীয় পরিচয়পত্র কখনো চাওয়া যাবে না।

## Implementation ও acceptance checklist

1. Server-side 24-hour qualification, verified email, complete profile, good-standing, self-referral ও duplicate checks.
2. Bangladesh BDT 50 এবং foreign USD 50-equivalent BDT হিসাব; applied FX rate ledger-এ lock করা।
3. Owner-only FX rate update with source/reference audit; rate না থাকলে foreign reward hold। Owner/Admin country verification review queue দিয়ে country যাচাই না হওয়া পর্যন্ত reward hold।
4. Country missing হলে reward hold; country নিজে থেকে অনুমান নয়।
5. Append-only funded wallet ledger, budget checks ও idempotent processor।
6. দুইটি পৃথক account দিয়ে referral, privacy, fraud, missing-country, missing-FX-rate, insufficient-budget ও duplicate-job tests।
7. Actual payout reconciliation ছাড়া paid status নয়।

## Implementation status — 2026-11-24

- Existing BDT 50 referral wallet foundation remains in migration `202611240003_referral_wallet_rewards.sql`.
- Added migration `202611240005_international_referral_usd_equivalent.sql`: Owner-only USD/BDT rate setting with source/reference audit; BDT 50 for Bangladesh-based referrers; USD 50 converted to BDT for non-Bangladesh referrers; rate/country/base USD metadata recorded on ledger; foreign awards wait when rate is missing; rewards wait until the referrer's profile country is manually verified by Owner/Admin.
- Added the new migration to the guarded production migration preflight.
- The FX rate is Owner-entered; no automatic FX data provider is configured. Existing wallet/payout UI remains BDT and Bangladesh bKash/Nagad only; the new Owner FX rate UI and Owner/Admin country verification queue are included; non-Bangladesh payout-provider support is not implemented.

**Not live yet:** production migration has not been applied; no FX rate has been entered; no real reward funds have been confirmed; Edge Function deployment, Actions secrets and two-member/end-to-end acceptance tests remain unverified. No automatic bKash/Nagad or foreign payout is active. Do not advertise the rewards as available until all production gates and real funding/payout checks pass.


## ১০০% সরাসরি সদস্য + ১০০% Owner network reward (২০২৬-১১-২৪ অনুমোদিত)

- সাধারণ সদস্য কেবল নিজের সরাসরি আমন্ত্রণে আসা প্রত্যেক যোগ্য সদস্যের জন্য standard reward-এর ১০০% পাবেন।
- একমাত্র verified `owner` role account পুরো referral tree-র প্রতিটি eligible referral event-এর জন্য অতিরিক্ত standard reward-এর ১০০% পাবে—direct, second level, third level বা আরও গভীর স্তর নির্বিশেষে। অন্য admin account-এ global commission যাবে না।
- Owner network reward-টি সাধারণ সদস্যের direct reward-এর অতিরিক্ত; তাই প্রতি referral event-এ মোট reward liability ২০০%। বাংলাদেশি referrer-এর উদাহরণে সদস্য ৳৫০ + Owner ৳৫০ = মোট ৳১০০; বিদেশি referrer-এর উদাহরণে ১ USD=৳১৩০ হলে সদস্য ৳৬,৫০০ + Owner ৳৬,৫০০ = মোট ৳১৩,০০০।
- Referral processor প্রথমে দুই beneficiary-র Pending entitlement তৈরি করবে। পুরো দুই reward-এর সমান cleared funding না থাকলে কোনো wallet credit হবে না। পর্যাপ্ত funding থাকলে দুই credit একই transaction-এ তৈরি হবে।
- Exactly one verified Owner account না থাকলে processor reward release করবে না। একই referral-এর জন্য একই reward kind একবারই তৈরি হবে; repeat job duplicate credit করবে না।
- Admin network reward-কে network report ও Owner wallet-এ আলাদাভাবে দেখাতে হবে। এটি Owner-এর মাসিক compensation ledger থেকে পৃথক।
