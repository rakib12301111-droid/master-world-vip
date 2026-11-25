# MASTER WORLD VIP — Company Revenue vs Referral Rewards (বাংলা)

Last updated: 2026-11-25

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

## B. Referral Reward Ledger — রেফারেল বোনাস

- বাংলাদেশে যোগ্য direct referral-এর standard member reward: ৳৫০।
- বর্তমান অনুমোদিত নীতি অনুযায়ী verified Owner-এর অতিরিক্ত network referral entitlement আলাদা `owner_network` ledger kind-এ থাকবে; এটি সাধারণ সদস্যের `member_direct` reward বা Owner-এর monthly compensation নয়।
- ২৪ ঘণ্টা account good-standing, verified email, completed profile, valid referral attribution, duplicate/self-referral checks এবং Admin review লাগবে।
- Admin/Owner যাচাই করে entitlement অনুমোদন করবেন। ফান্ড না থাকলে সেটি Pending entitlement হবে; cash available/withdrawable দেখানো যাবে না।
- Reward Fund-এ অর্থ আসবে কেবল কোম্পানির Company Revenue Ledger থেকে স্পষ্ট Owner-approved allocation, বাস্তব sponsor/donor contribution, অথবা অন্য নিশ্চিত ও আইনসম্মত third-party funding থেকে।
- Owner/Admin-কে নিজের পকেট থেকে fund দিতে বাধ্য করা যাবে না। সদস্যদের deposit, signup fee, hidden fee বা বাধ্যতামূলক purchase দিয়ে reward fund করা যাবে না।
- Fund থেকে reward allocation করার আগে source, amount, currency, date, unique reference এবং Owner approval audit করতে হবে। একই টাকা একাধিকবার allocate করা যাবে না।
- Reward Fund-এর balance পর্যাপ্ত হলে eligible pending entitlements নির্ধারিত server-side process-এ available wallet credit হবে; insufficient হলে pending-ই থাকবে। Pending কোনো নগদ টাকা বা নিশ্চিত payout date নয়।

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
