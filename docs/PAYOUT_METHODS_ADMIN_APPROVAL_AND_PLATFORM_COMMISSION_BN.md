# Payment Methods, Withdrawal Permissions and Admin Commission — বাংলা স্পেসিফিকেশন

তারিখ: ২৭ নভেম্বর ২০২৬  
অবস্থা: **Requirement recorded / design only — NOT LIVE**

## ১. লক্ষ্য

Member ও Admin-এর জন্য সহজ payout interface রাখা: বিকাশ, নগদ এবং ব্যাংক ট্রান্সফার। USD ও BDT আলাদা ledger/currency হিসাবেই থাকবে। কোনো payment method যোগ হওয়া মানে provider integration বা live withdrawal চালু হওয়া নয়।

## ২. Member payout method enrollment

- Member নিজের নামে/নিজের নিয়ন্ত্রণাধীন বিকাশ নম্বর, নগদ নম্বর অথবা ব্যাংক অ্যাকাউন্টের তথ্য যোগ, পরিবর্তন ও default method নির্বাচন করার অনুরোধ করতে পারবে।
- Bank form-এ account holder name, bank, branch/routing details, account number/IBAN (যেখানে প্রযোজ্য), currency এবং ownership verification status থাকবে। Sensitive account data encrypted/tokenized রাখতে হবে; logs/UI-তে পুরো account number প্রকাশ করা যাবে না।
- Mobile wallet number ও bank account ownership/identity যাচাই ছাড়া payout করা যাবে না। OTP/PIN/password কখনো MASTER WORLD VIP-তে সংগ্রহ বা সংরক্ষণ করা যাবে না।
- নতুন বা পরিবর্তিত payout destination-এ cooling-off period, notification, fraud/device checks এবং প্রয়োজনে step-up authentication থাকবে।

## ৩. Withdrawal authorization policy

### ৩.১ বিকাশ ও নগদ
- Member withdrawal request দেবে; request-এ amount, currency, fee (যদি থাকে), destination-এর masked পরিচয় এবং net payout দেখাবে।
- Admin অনুমোদন না দেওয়া পর্যন্ত request pending_admin_approval থাকবে এবং কোনো transfer call হবে না।
- Admin approve/reject করলে actor, সময়, কারণ ও request snapshot immutable audit log-এ থাকবে।
- Approval-এর পরও provider-এর বৈধ payout/disbursement channel, account eligibility, settlement এবং reconciliation checks পাস করতে হবে।
- কোনো provider-এর merchant/API/KYC/contractual permission বা আইনগত শর্ত এড়িয়ে personal-wallet transfer automation করা হবে না।

### ৩.২ ব্যাংক ট্রান্সফার
- Member নিজে ব্যাংক অ্যাকাউন্ট যোগ করতে পারবে। Verified account ownership, KYC/AML, sanctions/fraud checks, payout limits এবং bank/payment partner-এর অনুমোদিত transfer rail সক্রিয় থাকলে, পূর্বনির্ধারিত policy অনুযায়ী Admin-এর প্রতিটি withdrawal-এর আলাদা approval ছাড়াই স্বয়ংক্রিয় payout করা যেতে পারে।
- Admin approval ছাড়া মানে bank/provider permission ছাড়া নয়। ব্যাংক বা payment partner-এর প্রয়োজনীয় API, corporate account, mandate, KYC বা legal approval এড়িয়ে payout করা যাবে না।
- নতুন/পরিবর্তিত bank destination, high-risk/large withdrawal, unusual activity, failed reconciliation বা risk alert হলে automatic payout বন্ধ হয়ে manual review-তে যাবে (fail-closed)।
- Admin policy-তে per-transaction/daily limits, cooling-off period, eligible currencies, risk threshold ও emergency kill switch থাকবে। Admin policy ও system-level compliance controls কখনো bypass করা যাবে না।

## ৪. Admin commission per completed work

- প্রতিটি paid work order-এর জন্য Admin commission rate configurable হবে; কোনো default percentage অনুমান করে hard-code করা হবে না।
- Order গ্রহণ/কাজ শুরুর আগে customer price, currency, gross amount, provider fees (যদি থাকে), refund reserve, operating cost, Admin commission এবং Member net payable স্পষ্টভাবে দেখাতে হবে।
- Commission rate ও calculation basis order acceptance-এর সময় immutable snapshot হবে। মাঝপথে rate বদলে পুরোনো order-এর Member payable কমানো যাবে না।
- Commission কেবল policy অনুযায়ী কাজ accepted/completed এবং সংশ্লিষ্ট অর্থ settled/reconciled হলে earned/posted হবে; cancelled/refunded/disputed orders-এর ক্ষেত্রে আগে থেকে প্রকাশিত reversal/hold policy প্রযোজ্য হবে।
- Admin commission আলাদা company-revenue ledger account-এ যাবে; Member payable, refund/chargeback reserve এবং operating-cost bucket থেকে আলাদা থাকবে।
- USD commission USD-তে এবং BDT commission BDT-তে হিসাব হবে; FX conversion বা cross-currency netting নয়, আলাদা explicit exchange transaction ছাড়া।
- Commission rate, basis, rounding, provider fee treatment, tax treatment এবং refund reversal policy launch-এর আগে Admin কর্তৃক অনুমোদিত ও customer/Member-কে প্রকাশিত হতে হবে।

## ৫. বাধ্যতামূলক security / accounting controls

- Withdrawal request idempotency, available-balance reservation, no negative Member balance, immutable request terms, dual-control/step-up for high-risk actions, audit trail, rate limits, fraud checks এবং daily provider/bank reconciliation।
- Pending/failed payout-এ Member payable হারাবে না; transfer success কেবল provider/bank settlement reference ও reconciliation evidence পেলে।
- bKash/Nagad এবং bank payout আলাদা rail/provider adapter হিসেবে; provider credentials server-side secret store-এ, কখনো chat, client app বা repository-তে নয়।
- Real custody/safeguarded account, signed webhook বা bank statement reconciliation ছাড়া database row-কে cash custody বা transfer proof বলা যাবে না।
- Reserve shortfall, provider outage, mismatch, suspicious destination বা ledger imbalance হলে affected currency/rail-এর নতুন payout fail-closed এবং Admin alert হবে।
- Member-এর deposit/recharge দিয়ে payout unlock বা customer shortfall cover করা নিষিদ্ধ।

## ৬. বাস্তবায়নের পর্যায়

1. UI/schema/policy design ও static/runtime tests।
2. নির্বাচিত provider/bank-এর official sandbox integration ও signature verification।
3. Account ownership, KYC/legal/provider approval এবং secure credential setup।
4. Small-value controlled pilot, daily reconciliation ও independent audit।
5. Separate explicit approval ছাড়া Production migration, live money movement বা public deployment নয়।

## ৭. বর্তমান অবস্থা

এই নথি product requirement ও architecture policy হিসেবে যোগ করা হয়েছে। বর্তমানে bKash/Nagad/bank provider integration, account verification, live transfer, commission collection বা automatic withdrawal চালু নয়। কোনো company/provider permission ছাড়াই টাকা তোলার নিশ্চয়তা দেওয়া হচ্ছে না।


## ৮. Owner-এর Admin commission প্রস্তাব — ২৭ নভেম্বর ২০২৬

- প্রতি সম্পন্ন ও গ্রহণযোগ্য paid work order-এর জন্য **Admin commission ২০% (প্রস্তাবিত হার)** হিসেবে নথিভুক্ত করা হলো।
- এই ২০% এখনো production/configuration-এ সক্রিয় নয়; এটি প্রস্তাব, স্বয়ংক্রিয়ভাবে চালু হওয়া বা Member/customer-এর কাছ থেকে কাটা শুরু হওয়ার অনুমতি নয়।
- বাস্তবায়নের আগে commission-এর calculation basis (gross customer price নাকি provider fee বাদে net amount), provider fee, refund/chargeback reversal, tax এবং rounding policy নির্দিষ্ট করে order-এর আগে customer ও Member-কে দেখাতে হবে।
- অনুমোদিত হলে order acceptance-এর সময় ২০% rate ও calculation basis immutable snapshot হবে; কেবল কাজ accepted/completed এবং payment settled/reconciled হলে আলাদা company-revenue ledger-এ post হবে।
- USD order-এ ২০% USD-তে এবং BDT order-এ ২০% BDT-তে হিসাব হবে; cross-currency netting হবে না। Member-এর নিট পাওনা ও refund reserve আগে থেকেই স্পষ্ট দেখাতে হবে।
- **Status: proposal recorded only — not enabled, not collected, no live revenue.**
