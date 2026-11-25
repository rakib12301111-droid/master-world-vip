# MASTER WORLD VIP — Company Revenue vs Referral Rewards (বাংলা)

Last updated: 2026-11-25

**নীতি হালনাগাদ:** সর্বশেষ Owner সিদ্ধান্তের জন্য [Admin-only Referral & Work-to-Earn Policy](ADMIN_ONLY_REFERRAL_AND_WORK_EARN_POLICY_BN.md) দেখুন। এই নথির নিচের পুরোনো member referral reward বিবরণ নতুন Admin-only নীতির সঙ্গে সাংঘর্ষিক হলে নতুন নীতিই প্রাধান্য পাবে।

## সিদ্ধান্ত: দুটি সম্পূর্ণ আলাদা হিসাব

MASTER WORLD VIP-এর কোম্পানির ব্যবসায়িক আয় এবং সদস্য/Owner-এর referral reward একই জিনিস নয়। আলাদা ledger, আলাদা balance, আলাদা report এবং আলাদা approval রাখতে হবে। একটি হিসাবের টাকা অন্য হিসাবে নিজে থেকে স্থানান্তর হবে না।

## A. Company Revenue Ledger — কোম্পানির নিজস্ব আয়

অনুমোদিত সম্ভাব্য আয়ের উৎস:

1. বিজ্ঞাপন ও স্পনসরশিপ — বিজ্ঞাপনদাতা/স্পনসর বাস্তবে যে অর্থ পরিশোধ করে এবং কোম্পানি গ্রহণ করে।
2. নিজস্ব ডিজিটাল সেবা — কোম্পানির বৈধভাবে বিক্রি করা ডিজিটাল সেবা/পণ্যের বাস্তবে নিষ্পত্তি হওয়া মূল্য।
3. Marketplace commission — সম্পন্ন ও পরিশোধিত marketplace লেনদেনে প্রকাশিত শর্ত অনুযায়ী কোম্পানির কমিশন।
4. অনুমোদিত partner commission — চুক্তি অনুযায়ী partner থেকে বাস্তবে পাওয়া কমিশন।

প্রতিটি আয়-রেকর্ডে source type, payer/partner, non-secret invoice/transaction reference, gross amount, refund/chargeback, tax/provider fee, net settled amount, settlement date, currency, status এবং যাচাইকারী রাখতে হবে। Unpaid invoice, অনুমানভিত্তিক আয়, pending ad campaign, refund/chargeback বা শুধু dashboard impression-কে cash income বলা যাবে না।

কোম্পানির আয় আগে Company Revenue Ledger-এ থাকবে। আয় বাস্তবে নিষ্পত্তি/ব্যাংক বা অনুমোদিত business account-এ পাওয়া এবং reconciliation না হওয়া পর্যন্ত সেটি spendable fund নয়।

## B. Admin-only Referral Bonus Ledger — এডমিন রেফার বোনাস

- সর্বশেষ Owner সিদ্ধান্ত অনুযায়ী প্রথম ৬–৭ মাস সাধারণ সদস্য কোনো referral bonus পাবে না; সাধারণ সদস্যের referral wallet/bonus UI বন্ধ রাখার লক্ষ্য থাকবে।
- কেবল অনুমোদিত Admin-রা Owner-অনুমোদিত ও আগে থেকে প্রকাশিত শর্তে eligible referral bonus পেতে পারে। Admin নিজের কাজের পারিশ্রমিকও আলাদা work-payment ledger-এ পাবে।
- সাধারণ MASTER WORLD VIP onboarding link campaign attribution বহন করতে পারে, তবে attribution privacy notice/consent-এ জানাতে হবে; গোপন fingerprinting বা সম্মতিহীন tracking নয়।
- Admin bonus release-এর আগে genuine signup, verified attribution, anti-fraud checks, Admin role, Owner approval এবং confirmed available funding যাচাই করতে হবে।
- Bonus amount/rate এখনো নির্ধারিত নয়; কোনো পুরোনো ৳৫০ direct-member বা ৳৫০ owner-network rule নতুন Admin-only policy-তে স্বয়ংক্রিয়ভাবে প্রযোজ্য নয়।
- Owner commission, Admin work pay, Admin referral bonus এবং Company Revenue আলাদা ledger-এ থাকবে; একই আয়ের ওপর দ্বৈত কমিশন নয়।
- ফান্ড না থাকলে bonus Pending থাকবে; Pending cash বা withdrawable balance নয়। সদস্যের deposit/activation fee/mandatory purchase দিয়ে fund করা যাবে না।

## C. Owner/Admin compensation — তৃতীয়, পৃথক হিসাব

Owner/Admin-এর মাসিক compensation বা revenue-share, যদি প্রকাশিত ও অনুমোদিত শর্তে থাকে, তা আলাদা Owner Compensation Ledger-এ থাকবে। এটি Company Revenue Ledger এবং Referral Reward Ledger—কোনোটির সঙ্গেই একীভূত হবে না। Referral-এর জন্য Owner network reward-কে monthly salary/compensation হিসেবে দেখানো যাবে না।

## D. Customer promotional money ও admin share

গ্রাহক বিজ্ঞাপন/প্রমোশন কিনলে তার পরিশোধিত অর্থ প্রথমে কোম্পানির বিজ্ঞাপন/সেবা আয় হিসেবে রেকর্ড হবে। কোনো নির্দিষ্ট শতাংশ Admin-এর ব্যক্তিগত হিসাবে যাবে—এমন নিয়ম স্বয়ংক্রিয়ভাবে তৈরি করা যাবে না। Admin share/commission থাকলে আগে লিখিত rate, eligible net-revenue basis, tax/refund/fee treatment, approval এবং payout terms নির্ধারণ করতে হবে। গ্রাহকের ad budget-কে referral bonus বলে গণ্য করা যাবে না; গ্রাহকের নির্দিষ্ট campaign spend থেকে অন্য উদ্দেশ্যে অর্থ কেটে নেওয়া যাবে না, যদি না চুক্তিতে স্পষ্টভাবে থাকে।

## E. প্রয়োজনীয় dashboard ও controls

- Owner-only Company Revenue panel: source-wise collected/settled revenue, refunds/fees, net amount, references and reconciliation.
- Owner-only Reward Fund panel: opening balance, allocations from identified sources, issued rewards, remaining balance and audit log.
- Member Referral Wallet: member's own pending/available/paid amounts and history only.
- Owner network referral report: separate from ordinary member wallet and monthly Owner compensation.
- No public or member access to company bank details, other members' balances, confidential invoices or private partner contracts.
- All ledger writes server-side, append-only/audited, idempotent, role-protected and reconciled against actual external transactions.

## F. Revenue sources are not yet live

এই নীতিমালা ও হিসাবের নকশা কোনো বিজ্ঞাপনদাতা, sponsor, customer, marketplace sale, partner contract বা বাস্তব cash receipt তৈরি করে না। Provider/merchant/ad network contracts, approved terms, tax/legal review, payment collection, server-side integration, reconciliation, UI, migrations and acceptance tests প্রয়োজন। কোনো বাস্তব আয়/ফান্ড না পাওয়া পর্যন্ত Company Revenue = ৳০ এবং Reward Fund = ৳০ ধরে চলতে হবে; কোনো কৃত্রিম cash balance তৈরি করা যাবে না।

## Current status — 2026-11-25

- Existing repository already has a referral reward/funding foundation and a separate Owner monthly compensation foundation.
- This document records the newly confirmed separation requirement. It does not implement the Company Revenue Ledger, connect ad networks/payment providers, collect customer money, allocate funds, apply Supabase migrations, or activate payouts.
- Next implementation stage: design and build a separate Company Revenue Ledger and Owner-only dashboard; then add an explicit audited allocation bridge into the existing Reward Fund. Integrate only providers selected and authorized by the Owner.


## Policy supersession — 2026-11-25

- The Admin-only referral policy in [ADMIN_ONLY_REFERRAL_AND_WORK_EARN_POLICY_BN.md](ADMIN_ONLY_REFERRAL_AND_WORK_EARN_POLICY_BN.md) supersedes the earlier ordinary-member direct referral and Owner-network referral reward rules for future implementation.
- Existing migrations/UI/Edge Functions may still contain the old rules. They are not automatically disabled by this documentation update. A reviewed additive migration and acceptance tests are required; preserve audit history and separately resolve any already-earned unpaid entitlements before changing production.
- This update does not implement Admin-only referrals, turn off the old reward processor, create work revenue, or enable payouts.
