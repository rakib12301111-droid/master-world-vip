# MASTER WORLD VIP — Referral Reward Policy (বাংলা)

সিদ্ধান্তের অবস্থা: **ব্যবহারকারীর অনুমোদিত নীতিমালা; production-এ এখনো চালু নয়।**
অনুমোদিত: ২০২৬-১১-২৪

## অনুমোদিত নিয়ম

- আমন্ত্রণকারী সদস্যের referral খরচ: **৳০**; নতুন সদস্যের registration-ও **ফ্রি**।
- কোনো deposit, VIP package, paid activation বা বাধ্যতামূলক কেনাকাটা লাগবে না।
- **বাংলাদেশে থাকা যোগ্য আমন্ত্রণকারী সদস্য:** প্রতি সফল সরাসরি referral-এ **৳৫০ BDT**।
- **বাংলাদেশের বাইরে থাকা যোগ্য আমন্ত্রণকারী সদস্য:** প্রতি সফল সরাসরি referral-এ **US$৫০-এর সমপরিমাণ BDT**। উদাহরণ: নির্ধারিত হিসাবের সময় ১ USD = ৳১৩০ হলে পুরস্কার হবে ৳৬,৫০০। ৳১৩০ কেবল উদাহরণ; এটি স্থায়ী বা স্বয়ংক্রিয় বাজারদর নয়।
- বিদেশি পুরস্কারের BDT মূল্য হিসাবের সময় ব্যবহৃত USD/BDT রেটের ভিত্তিতে নির্ধারিত হবে এবং সেই রেট, উৎস ও reference ledger-এ সংরক্ষিত থাকবে। পুরস্কার ক্রেডিট হওয়ার পর সেই ক্রেডিটের রেট বদলাবে না।
- এই সংস্করণে wallet ও withdrawal amount BDT-তে থাকবে; বিদেশি সদস্যের US$৫০ মূল্য BDT-তে রূপান্তর করে দেখানো হবে। অন্য দেশের payout currency/provider যোগ করা আলাদা কাজ।
- দেশের ভিত্তি হবে আমন্ত্রণকারী সদস্যের profile country। Country ফাঁকা থাকলে reward আটকে থাকবে; country যাচাই না করে অনুমান করা যাবে না।
- নতুন অ্যাকাউন্ট রেজিস্ট্রেশনের পর কমপক্ষে **২৪ ঘণ্টা** ভালো অবস্থায় থাকতে হবে; ২৪ ঘণ্টা অনলাইনে থাকা বাধ্যতামূলক নয়।
- নতুন সদস্যের email verification এবং profile completion থাকতে হবে।
- Referral code/link দিয়ে signup-এর সময় attribution server-side সংরক্ষিত হবে।
- Self-referral, duplicate/fake account, automated signup বা attribution manipulation নিষিদ্ধ; একই নতুন সদস্যের জন্য একবারের বেশি reward নয়।
- Referral qualification, credit ও payout state server-side, idempotent এবং audit-logged হতে হবে।

## বিনিময় হার, funding ও payout

- USD/BDT হার Owner-নিয়ন্ত্রিত server-side setting-এ source ও reference/date-সহ বসাতে হবে। বর্তমান migration-এ স্বয়ংক্রিয় live FX provider নেই; ভুল/পুরোনো হার যেন live rate বলে দেখানো না হয়।
- বাংলাদেশি reward-এর জন্য ৳৫০ এবং বিদেশি reward-এর জন্য গণনা করা সম্পূর্ণ BDT amount—দুটিই বাস্তবে নিশ্চিত ও pre-funded platform reward budget থেকে আসতে হবে।
- Budget অপর্যাপ্ত হলে reward issuance pause/অপেক্ষমাণ থাকবে; সদস্যের কাছ থেকে deposit বা fee নেওয়া যাবে না। Unfunded reward-কে cash/withdrawable balance বলা যাবে না।
- Ledger-এ referral ID, member ID, BDT amount, country, USD base amount, applied FX rate, status, timestamps ও payout reference রাখতে হবে।
- বর্তমান withdrawal workflow বাংলাদেশি bKash/Nagad নম্বর ও manual Admin reconciliation-এর জন্য। এটি বিদেশি local-wallet payout বা automatic transfer নয়।
- PIN, OTP, wallet password বা অপ্রয়োজনীয় পরিচয়পত্র কখনো চাওয়া যাবে না।

## Implementation ও acceptance checklist

1. Server-side 24-hour qualification, verified email, complete profile, good-standing, self-referral ও duplicate checks.
2. Bangladesh BDT 50 এবং foreign USD 50-equivalent BDT হিসাব; applied FX rate ledger-এ lock করা।
3. Owner-only FX rate update with source/reference audit; rate না থাকলে foreign reward hold।
4. Country missing হলে reward hold; country নিজে থেকে অনুমান নয়।
5. Append-only funded wallet ledger, budget checks ও idempotent processor।
6. দুইটি পৃথক account দিয়ে referral, privacy, fraud, missing-country, missing-FX-rate, insufficient-budget ও duplicate-job tests।
7. Actual payout reconciliation ছাড়া paid status নয়।

## Implementation status — 2026-11-24

- Existing BDT 50 referral wallet foundation remains in migration `202611240003_referral_wallet_rewards.sql`.
- Added migration `202611240005_international_referral_usd_equivalent.sql`: Owner-only USD/BDT rate setting with source/reference audit; BDT 50 for Bangladesh-based referrers; USD 50 converted to BDT for non-Bangladesh referrers; rate/country/base USD metadata recorded on ledger; foreign awards wait when rate is missing; rewards wait when referrer's profile country is missing.
- Added the new migration to the guarded production migration preflight.
- The FX rate is Owner-entered; no automatic FX data provider is configured. Existing wallet/payout UI remains BDT and Bangladesh bKash/Nagad only; the new Owner FX rate UI and non-Bangladesh payout-provider support are not yet implemented.

**Not live yet:** production migration has not been applied; no FX rate has been entered; no real reward funds have been confirmed; Edge Function deployment, Actions secrets and two-member/end-to-end acceptance tests remain unverified. No automatic bKash/Nagad or foreign payout is active. Do not advertise the rewards as available until all production gates and real funding/payout checks pass.
