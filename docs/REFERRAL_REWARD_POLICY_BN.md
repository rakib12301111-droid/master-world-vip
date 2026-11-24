# MASTER WORLD VIP — Referral Reward Policy (বাংলা)

সিদ্ধান্তের অবস্থা: **ব্যবহারকারীর অনুমোদিত নীতিমালা; production-এ এখনো চালু নয়।**
অনুমোদিত: ২০২৬-১১-২৪

## অনুমোদিত নিয়ম

- Referral করতে আমন্ত্রণকারী সদস্যের খরচ: **৳০**।
- নতুন সদস্যের registration: **ফ্রি**।
- কোনো deposit, VIP package, paid activation বা বাধ্যতামূলক কেনাকাটা লাগবে না।
- প্রতিটি সফল ও যাচাইকৃত সরাসরি referral-এর প্রস্তাবিত reward: **৳৫০ (BDT)**।
- নতুন অ্যাকাউন্ট রেজিস্ট্রেশনের পর কমপক্ষে **২৪ ঘণ্টা** ভালো অবস্থায় থাকতে হবে। এর অর্থ ২৪ ঘণ্টা অনলাইনে থাকা নয়; ধারাবাহিকভাবে অ্যাপ ব্যবহার বাধ্যতামূলক নয়।
- নতুন সদস্যের ইমেইল verification এবং প্রয়োজনীয় profile completion থাকতে হবে।
- Referral code/link দিয়ে signup-এর সময় attribution server-side সংরক্ষিত হবে।
- নিজের referral code ব্যবহার, duplicate/fake account, automated signup, attribution manipulation বা অন্য কোনো প্রতারণা গ্রহণযোগ্য নয়।
- একই নতুন সদস্যের জন্য একবারের বেশি referral reward দেওয়া যাবে না।
- Referral status: Registered → Pending qualification → Qualified → Reward approved/paid; fraud বা policy breach হলে Cancelled, কারণসহ audit record রাখতে হবে।
- সদস্য নিজের referral count/status দেখতে পারবেন; অন্য সদস্যের ব্যক্তিগত তথ্য দেখতে পারবেন না।
- Admin report ও reward approval কেবল অনুমোদিত Owner/Admin server-side permission দিয়ে করতে পারবেন।

## Reward funding ও payout

- ৳৫০ reward অবশ্যই MASTER WORLD VIP-এর আগে থেকে বরাদ্দকৃত এবং বাস্তবে উপলব্ধ marketing/reward budget থেকে দিতে হবে।
- কোনো unfunded reward-কে available cash balance বা নিশ্চিত payout হিসেবে দেখানো যাবে না।
- Budget অপর্যাপ্ত হলে নতুন reward issuance pause করতে হবে এবং dashboard-এ স্পষ্টভাবে pending/funding status দেখাতে হবে; সদস্যের কাছ থেকে deposit বা fee নেওয়া যাবে না।
- Reward ledger-এ referral ID, member ID, amount, currency, status, approval actor, timestamps এবং payout reference সংরক্ষণ করতে হবে।
- bKash/Nagad/bank payout কেবল official provider integration ও reconciliation সম্পন্ন হলে automated বলা যাবে। তার আগে manual/pending integration হিসেবে দেখাতে হবে।
- PIN, OTP, wallet password বা অপ্রয়োজনীয় পরিচয়পত্র কখনো চাওয়া যাবে না।

## Implementation ও acceptance checklist

1. Server-side policy configuration: 24-hour qualification window, BDT 50 fixed reward, free signup/no purchase/deposit.
2. Verified email, account standing, profile completion, self-referral and duplicate checks.
3. Trusted server workflow for qualification; browser/client must never mark a referral as qualified or paid.
4. Append-only reward ledger and idempotent processing to prevent double credit.
5. Owner/Admin budget allocation, pause/resume and approval controls with audit log.
6. Member dashboard: link/code, registered/pending/qualified/rewarded counts, reward status and withdrawal history.
7. Tests with two separate accounts: valid referral, invalid code, self-referral, duplicate attribution, less-than-24-hours, exactly-after-24-hours, unverified email, suspended account, insufficient budget, duplicate job execution, member privacy and non-admin access denial.
8. Verify actual payout reconciliation before marking any reward as paid.

## Implementation status — 2026-11-24

Repository code now includes:
- Additive SQL migration 202611240003_referral_wallet_rewards.sql for the 24-hour server qualification, funded BDT 50 reward ledger, one-credit-per-referral constraint, member wallet reads, withdrawal requests, Owner-only funding and reward enable/disable, Admin review and audit records.
- Server-only process-referral-rewards Edge Function and a 15-minute scheduled GitHub Actions workflow.
- Member Wallet and bKash/Nagad withdrawal-request UI; Owner/Admin reward-budget and withdrawal-review UI.
- Two-member wallet privacy/permission SQL test and dedicated GitHub Actions workflow.
- Deployment and acceptance instructions in REFERRAL_SYSTEM_ACCEPTANCE_TEST_BN.md.

**Not live yet:** the production migration has not been confirmed applied; Edge Function deployment and REFERRAL_CRON_SECRET / SUPABASE_URL Actions secrets are not verified; no real reward fund has been deposited/recorded; no two-member test has passed against the target Supabase project. The withdrawal flow currently supports requests and manual Admin payout reconciliation only. It is **not automatic bKash/Nagad cashout**; official merchant/API access, provider credentials, webhook verification and reconciliation remain necessary.

Do not advertise the ৳৫০ reward as available until the migration, secure processor, funded budget, two-member acceptance tests and real payout process are verified.
