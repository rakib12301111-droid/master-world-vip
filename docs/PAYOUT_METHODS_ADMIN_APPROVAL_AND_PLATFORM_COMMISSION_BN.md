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


## ৯. KYC/Merchant approval ছাড়া সহজ ব্যবহারের সীমা ও নিরাপদ বিকল্প

- কোনো live bKash/Nagad/bank transfer-এ provider, bank, আইন বা regulator-এর বাধ্যতামূলক পরিচয়/merchant/mandate/settlement শর্ত bypass করা যাবে না। ব্যক্তিগত wallet-এ অননুমোদিত bulk/automated payout-কে বিকল্প হিসেবে ব্যবহার করা যাবে না।
- ব্যবহারকারীর জন্য onboarding সহজ রাখা হবে: payout method form, masked destination, status tracking, clear rejection reason, Admin approval queue এবং এক-ট্যাপে request submission। Platform কখনো wallet PIN, OTP, bank password বা card secret চাইবে না।
- Provider account এখনো না থাকলে কেবল **mock/simulated payout sandbox** ব্যবহার করা যাবে: fake provider adapter, synthetic transaction IDs, deterministic success/failure/replay scenarios এবং test-only balances। এই simulation বাস্তব টাকা পাঠায় না এবং live payment হিসেবে দেখানো যাবে না।
- কোনো official provider sandbox credential/API access পাওয়া গেলে তার published sandbox terms মেনে integration করা যাবে; sandbox ব্যবহারেও provider registration/credentials প্রয়োজন হতে পারে।
- Production payout activation-এর আগে provider-approved rail, beneficiary ownership verification, legal/KYC checks, real safeguarded funds, reconciliation, fraud limits ও audit evidence আবশ্যক।

## ১০. ২০% commission-এর নিরাপদ হিসাবের সুপারিশ (এখনো অনুমোদন/সক্রিয় নয়)

- ২০% হারটি Owner-এর প্রস্তাব হিসেবেই থাকবে; সরাসরি customer gross amount থেকে ২০% কেটে Member payable কমানো যাবে না।
- প্রস্তাবিত calculation base: **Distributable Platform Margin** = customer-এর settled gross amount − provider/payment fees − প্রযোজ্য tax/withholding − সম্পূর্ণ Member payable − নির্ধারিত refund/chargeback liability funding − অনুমোদিত direct operating cost।
- Distributable Platform Margin শূন্য বা ঋণাত্মক হলে Admin commission শূন্য; Member payable বা refund reserve থেকে commission নেওয়া যাবে না। Positive margin হলে Admin commission = margin × 20%; অবশিষ্ট margin platform-এর retained net margin।
- উদাহরণ (শুধু ব্যাখ্যা, বাস্তব মূল্য নয়): customer settled 1,000; provider fee 20; tax 30; Member payable 600; refund reserve allocation 100; direct operating cost 50; distributable margin 200; Admin commission 40 (20% of 200)।
- এই base Owner-এর চূড়ান্ত ব্যবসায়িক/আইনি অনুমোদন, tax review ও Member/customer disclosure ছাড়া কার্যকর হবে না। Order acceptance-এ basis ও rate snapshot হবে; settled/reconciled accepted work-এর পরেই commission post হবে; refund/chargeback হলে পূর্বপ্রকাশিত reversal policy লাগবে।


## ১১. Owner নির্দেশ অনুযায়ী Live-readiness implementation gates (২৭ নভেম্বর ২০২৬)

এই section implementation scope নির্ধারণ করে; কোনো provider account/permission বা Production approval তৈরি করে না।

### bKash / Nagad / Bank adapters
- তিনটি rail আলাদা adapter interface-এ রাখতে হবে; common payment intent/order/ledger layer-এর সঙ্গে provider-specific authentication, request signing, webhook signature/timestamp verification, idempotency key, duplicate/replay rejection, status inquiry, refund/payout এবং reconciliation mapping থাকবে।
- bKash/Nagad: withdrawal request → Admin approval → provider-approved payout API → provider settlement confirmation → daily reconciliation; Admin approval-এর আগে কোনো transfer request নয়।
- Bank: official bank/partner API/mandate + beneficiary ownership verification + KYC/AML/fraud checks + limits; risk alert বা mismatch-এ manual review/fail-closed।
- Sandbox access না থাকলে synthetic mock provider ব্যবহার; clearly TEST-ONLY label, fake transaction IDs এবং deterministic success/failure/replay simulation। কোনো simulated success Member wallet-এ real withdrawable funds তৈরি করবে না।
- Secrets শুধু GitHub Actions/Supabase secret store-এ; কখনো browser, repository, logs বা chat-এ নয়।

### Order-to-payout finance acceptance matrix
- Customer checkout/webhook: valid signature, correct amount/currency/order, unique provider reference, idempotent retry; bad signature, wrong amount/currency, duplicate/replay reject।
- Order funding: provider settlement ও reconciliation ছাড়া funded নয়; USD/BDT cross-posting বা currency netting reject।
- Work acceptance: client acceptance evidence ছাড়া Member payable release নয়; cancelled/disputed/refunded order-এ payout hold/reversal policy।
- Commission: ২০% proposed only; final basis, fee/tax/reserve/rounding/reversal এবং disclosures অনুমোদিত না হওয়া পর্যন্ত actual commission 0/disabled। Proposed distributable-margin formula ব্যবহার করতে হলে Owner final approval লাগবে; Member payable/refund reserve থেকে কখনো commission নয়।
- Payout: verified beneficiary, available payable, Admin approval where required, provider settlement reference, reconciliation; timeout/retry duplicate transfer তৈরি করবে না। Pending/failed payout payable হারাবে না।
- Reconciliation: provider settlement report/bank statement বনাম payment intent, ledger journal, refund, payout; mismatch হলে affected rail/currency freeze + alert + audited resolution।
- Required runtime cases: balanced double-entry, exact idempotency, collision rejection, overdraw/negative balance prevention, immutability, reserve isolation, refund/chargeback, provider outage, duplicate webhook, forged signature, payout timeout/retry, Admin RBAC এবং Owner/Admin/Member separation।

### Go-live decision
- Provider legal/merchant approval, KYC/AML/tax review, official sandbox and production credentials, safeguarded funds/custody, signed webhook, settlement/reconciliation, Staging acceptance, recoverable backup/restore এবং security sign-off—সব বাধ্যতামূলক।
- ২০% Admin commission এখনো proposal only; customer/Member-কে order acceptance-এর আগে disclosed approved calculation না দেখানো পর্যন্ত deduct/post করা যাবে না।
- APPLY-MASTER-WORLD-VIP-MIGRATIONS কেবল Production database migration apply-এর আলাদা exact approval। এটি provider money transfer, payout activation বা public deployment অনুমোদন করে না।
- Current status: architecture/policy documented; existing ledger/runtime foundations only. Official provider integration, staging acceptance, live collection/payout, commission activation এবং Production migration NOT LIVE / PENDING।


## ২৭ নভেম্বর ২০২৬ — CI, Staging ও Production-এর বর্তমান Gate Status

- **Latest correction CI/runtime: PENDING** — সর্বশেষ পরিবর্তনের পর CI এবং disposable PostgreSQL full-chain finance runtime-এর সফল Run ID/logs এখনো যাচাই করা হয়নি।
- **Staging Database: PENDING** — isolated Staging project/secrets ও Owner/Admin/Member test identities প্রস্তুত/যাচাই না হওয়ায় Staging migration, RLS/RBAC এবং end-to-end acceptance pass বলা যাচ্ছে না।
- **Production Migration: NOT RUN / BLOCKED** — Production Database-এ কোনো migration apply হয়নি। APPLY-MASTER-WORLD-VIP-MIGRATIONS কেবল Production migration apply-এর exact approval gate। বর্তমান বার্তায় token-এর অর্থ জানতে চাওয়া হয়েছে, তাই token-টি apply approval হিসেবে গণ্য নয়।
- Migration approval থাকলেও real bKash/Nagad/Bank transfer, payout activation, ২০% commission deduction বা public deployment অনুমোদিত হয় না; এগুলোর পৃথক provider/legal/finance ও release gates আছে।
- Live release-এর আগে CI/runtime, Staging acceptance, official provider sandbox, complete Order-to-Payout finance tests, recoverable backup/restore এবং security review-এর evidence বাধ্যতামূলক।
- **Status: CI PENDING; STAGING PENDING; PRODUCTION MIGRATION NOT RUN; LIVE DEPLOYMENT NOT LIVE.**


## ২৭ নভেম্বর ২০২৬ — Safe Validation Workflow Update

- Finance Runtime workflow-এ payout/refund static safety validation যুক্ত হয়েছে; database runtime test disposable PostgreSQL-এ সীমাবদ্ধ।
- Full migration-chain validation workflow-এ PR trigger যোগ হয়েছে; fresh ও legacy-shape test database-এ migration পরীক্ষা করবে, Production-এ নয়।
- Staging validation workflow-এ guarded PR trigger যুক্ত হয়েছে; Staging project ref Production ref-এর সঙ্গে মিলে গেলে workflow fail-closed হবে। Staging secrets ও isolated role accounts ছাড়া Staging acceptance সম্ভব নয়।
- Synthetic encrypted backup/restore-এর জন্য `verify-disposable-backup-restore.yml` যোগ হয়েছে; fake fixture data আলাদা disposable PostgreSQL database-এ restore ও count-check হবে।
- **Execution status:** latest branch head-এর জন্য নতুন CI, Finance Runtime, synthetic Backup/Restore বা Staging run/check এখনো পাওয়া যায়নি। অতএব সবগুলো PENDING; আগের commit-এর successful runtime run বর্তমান commit-এর pass নয়। Production migration ও Live Deployment চালানো হয়নি।


## ১২. Owner-এর সর্বশেষ বাধ্যতামূলক কমিশন নীতি — পূর্বের ২০% একক-হার প্রস্তাব superseded (২৭ নভেম্বর ২০২৬)

এই section-এর নীতি আগের Section 8 ও Section 10-এ থাকা একক ২০% প্রস্তাবকে প্রতিস্থাপন করে:

- যোগ্য high-volume, USD-settled automated work: Admin commission rate **৩৫%**।
- সাধারণ BDT-settled কাজ: Admin commission rate **২০%**।
- USD ও BDT আলাদা ledger/currency-তে থাকবে; কোনো cross-currency netting নয়। USD আয় না থাকলে USD balance 0 দেখাতে হবে। FX conversion হলে rate, timestamp, fee ও exchange journal আলাদা সংরক্ষণ করতে হবে।
- নিরাপদ calculation base হলো positive Distributable Platform Margin: settled customer gross − provider/payment fees − applicable tax/withholding − full Member payable − refund/chargeback reserve funding − approved direct operating costs।
- Eligible USD work-এ Admin commission = positive distributable margin × 35%; ordinary BDT work-এ = positive distributable margin × 20%。 Margin শূন্য/ঋণাত্মক হলে commission 0।
- Member payable, refund/chargeback reserve, tax বা provider fee থেকে commission নেওয়া যাবে না। Gross order value Admin profit নয়।
- Eligibility, rate, calculation basis, fees/tax, rounding, refund reversal এবং Member net payable order acceptance-এর আগে Customer/Member-কে দেখিয়ে immutable snapshot করতে হবে। Commission কেবল accepted/completed work এবং settled/reconciled funds-এর পর আলাদা Admin/company ledger-এ post হবে।
- এই policy নথিভুক্ত; production commission এখনো disabled। Provider sandbox/webhook, Staging finance acceptance, legal/tax review এবং পৃথক release approval ছাড়া live deduction/posting হবে না।
