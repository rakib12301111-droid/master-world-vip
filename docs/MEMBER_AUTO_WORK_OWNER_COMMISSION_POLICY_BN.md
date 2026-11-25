# MASTER WORLD VIP — Member Auto Work Pause & Owner Commission Policy

Updated: 2026-11-25

## Final current decision
**Member Auto Work execution is DISABLED for ordinary members.** This is a deliberate safety decision, not a technical failure. A shared or insufficiently isolated worker could consume CPU/RAM, queue slots, database connections, storage, bandwidth or API quota and slow or interrupt the Owner/Admin's own Auto Work. The platform must protect Owner/Admin workloads first.

Ordinary members can still use the existing Work & Earn marketplace for human-reviewed tasks (typing, data entry, translation, proofreading, PDF formatting, design, image editing and similar legitimate work). They do not receive worker execution access, Admin queue access, Owner capacity, provider credentials or background execution on their phones.

## What would be required to reconsider member automation
Do not enable it merely by increasing a shared concurrency setting. Reconsider only after all conditions are met:
1. Dedicated separate infrastructure/account/worker pool for member jobs, with separate database queue, storage namespace, API credentials and budgets from Owner/Admin.
2. Hard CPU, memory, concurrency, request, storage, bandwidth, runtime and per-member quotas enforced server-side.
3. Owner/Admin reserved capacity and priority cannot be consumed by member jobs; resource-pressure circuit breaker pauses member jobs first.
4. Independent load, failure, abuse, isolation and recovery tests prove member jobs cannot slow, read, modify or block Owner/Admin work.
5. Genuine client/provider contract and permitted data/API scope for each task type.
6. Free-tier quota and billing behavior verified. No paid fallback, no silent charges; if separate infrastructure is not available free within safe limits, keep the feature disabled. Any future paid use needs a specific budget cap recorded in secure project settings.
7. Admin emergency stop, audit trail, abuse review, privacy and dispute process.

Until all gates pass, do not display member automated tasks as available, do not enqueue member automation and do not run member code on Owner/Admin workers.

## Member Work & Earn (available direction)
- Registration and access to ordinary task listings are free; no deposit, subscription, purchase, referral fee or upfront payment.
- Offer human-reviewed tasks such as Bengali/English typing, data entry, translation, proofreading, PDF formatting, design and image editing.
- Show task description, eligibility, effort estimate, rate, deadline, acceptance criteria and payment terms before a member accepts.
- Payment only for verified deliverables accepted by a real customer/employer and backed by actual settled funds. No guaranteed task volume or income.
- No payment for simply being online, installing an app, clicking ads, fake traffic/engagement or creating accounts.
- No use of members' phones, battery, mobile data or bandwidth as distributed compute.
- Protect member privacy and client files; provide reporting, dispute and appeal routes.

## Owner commission — only on real platform-mediated revenue
- The Owner may receive a platform commission only where MASTER WORLD VIP has a legitimate customer order/contract, the member's deliverable is accepted, and the customer's payment has actually settled.
- Commission rate, member payout, fees, cost allocation and timing must be disclosed before task acceptance and recorded separately.
- The commission is not deducted from unpaid member wages and is never calculated from pending, estimated, disputed or unsettled money.
- Reconcile refunds, chargebacks, payment fees, provider costs and required reserves. A receipt is recorded once only.
- If the current Work & Earn listing is merely a peer-to-peer job board and the platform does not receive/settle the customer payment, the platform must not claim commission or promise payout through its own ledger.
- Commission rate and payment integration are not currently set or live. No customer/settled revenue means commission is ৳0.

## Admin Auto Work remains separate
The five Admin modules remain Owner/Admin-only. Member task listings and human review must not use Admin execution queues, worker slots, credentials, private files or reserved compute. Keep Admin's existing maximum of one running job per module (five total) as a separate control-plane design.

## Current implementation status
The Work & Earn page now states that Member Auto Work is paused/disabled and describes the safe human-task alternative and conditional commission rule. This is a website/source update only. It does not activate member tasks, create customer revenue, calculate commissions, or enable withdrawals. The existing Admin Auto Work database migration is not deployed, no worker/provider integrations are live, and no payout integration is verified.


## ভবিষ্যৎ বিকল্প: Member Auto Work Protected Packages (এখনো চালু নয়)
সদস্যদের নিজ খরচে প্যাকেজ কিনে আলাদা Member Auto Work infrastructure ব্যবহার করার বিকল্প ভবিষ্যতে রাখা হবে। বর্তমান সিদ্ধান্তে এটি **পরিকল্পিত/বন্ধ**, কোনো প্যাকেজ বিক্রি, পেমেন্ট গ্রহণ বা Auto Work execution এখন চালু নয়।

### প্যাকেজ বিক্রির আগে বাধ্যতামূলক সুরক্ষা
1. **সম্পূর্ণ আলাদা অবকাঠামো:** Member-এর server/worker pool, queue, database/storage namespace, API credentials, provider account এবং খরচের budget Admin/Owner Auto Work থেকে পৃথক হবে। Member load কখনো Admin-এর reserved capacity ব্যবহার করবে না।
2. **আগাম শর্ত প্রকাশ:** প্যাকেজ কেনার আগে মূল্য, মেয়াদ, অন্তর্ভুক্ত job/credits, allowed work, provider cost, quota, সম্ভাব্য আয় অনিশ্চিত—এই সতর্কতা, কাজের acceptance rule, settlement window, refund trigger, refund method/time এবং অভিযোগের পদ্ধতি বাংলায় দেখাতে হবে। কোনো আয় বা নির্দিষ্ট লাভের গ্যারান্টি নয়।
3. **100% আলাদা refund reserve:** যদি কোনো প্যাকেজে “যোগ্য কাজের আয় না হলে প্যাকেজ মূল্য ফেরত” প্রতিশ্রুতি দেওয়া হয়, তবে প্রতিটি বিক্রির সমপরিমাণ 100% refund reserve আলাদা, liquid ও reconciliation-যোগ্য হিসাবে আগে থেকেই সংরক্ষিত থাকতে হবে। এই reserve compute/API খরচ, Owner profit, commission, referral বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Reserve ঘাটতি, payment-provider hold বা reserve যাচাই ব্যর্থ হলে নতুন package sale স্বয়ংক্রিয়ভাবে বন্ধ হবে।
4. **Package funds ও operating funds আলাদা:** সদস্যের package payment-কে সঙ্গে সঙ্গে Owner-এর আয় বা profit হিসেবে গণ্য করা যাবে না। Provider/compute cost কেবল প্রকাশিত অনুমোদিত budget থেকে দেওয়া হবে; refund reserve অক্ষত থাকবে। Package price-এর কোন অংশ service fee, compute credit, tax/fee বা refundable—সব আগে প্রকাশ করতে হবে।
5. **আয় গণনার কঠোর নিয়ম:** কাজ complete হলেই আয় নয়। Client deliverable গ্রহণ এবং payment বাস্তবে settle হওয়ার পরই gross receipt গণনা হবে। Fees, tax, refunds, chargebacks, provider cost ও member payable বাদ দিয়ে net settled result হিসাব হবে। Pending/estimated/disputed অর্থ আয় নয়।
6. **Refund trigger:** প্যাকেজে নির্দিষ্ট evaluation period ও qualifying-net-earning threshold আগে প্রকাশ করতে হবে। সময় শেষে শর্ত পূরণ না হলে, অথবা সিস্টেম/প্ল্যাটফর্মের কারণে কাজ চালানো অসম্ভব হলে, প্রকাশিত refund policy অনুযায়ী original payment method-এ refund দিতে হবে। আংশিক আয় হলে refund formula আগে স্পষ্ট করতে হবে; অস্পষ্ট/পরিবর্তনশীল শর্ত ব্যবহার করা যাবে না।
7. **No hidden deductions:** Member-এর কাজের পারিশ্রমিক, refund reserve বা customer-এর restricted funds থেকে Owner commission নেওয়া যাবে না। Owner profit কেবল বাস্তবে settle হওয়া platform revenue থেকে, সব member liability, refund, provider cost, fee/tax ও reserve পূরণের পরে আলাদা ledger-এ হিসাব হবে।
8. **স্বয়ংক্রিয় সুরক্ষা:** প্রতি সদস্য ও প্যাকেজে hard spend cap, job/runtime/concurrency/rate limit, idempotency, audit log, abuse detection, pause/cancel এবং emergency stop থাকবে। budget/quota 80% হলে সতর্কতা; 100% বা provider error হলে সংশ্লিষ্ট member job pause। কোনো paid fallback বা অতিরিক্ত charge নয়।
9. **বিরোধ ও প্রমাণ:** প্রতিটি job-এর input/output reference, permission/contract, timestamps, client acceptance, settlement reference, cost, member payable ও refund status audit করা হবে। Member-কে status ও appeal/helpdesk দেখাতে হবে।
10. **আইন ও পেমেন্ট যাচাই:** বাংলাদেশে প্রযোজ্য consumer protection, e-commerce, tax, payment-provider/escrow ও refund requirements যাচাই এবং প্রয়োজনীয় provider support ছাড়া package sale চালু করা যাবে না।

### প্রস্তাবিত হিসাবের ক্রম
Customer payment settled → payment fees/tax/refund exposure reconcile → member payable reserve/pay → provider/compute costs settle → refund liabilities fully covered → তারপরই অবশিষ্ট প্রকৃত platform net revenue থেকে Owner commission/profit। Package payment নিজে profit নয়।

### Launch gate
Member package sale ও execution চালু করা যাবে কেবল: dedicated infrastructure deployed and isolated; separate cost cap and billing alerts tested; 100% refund reserve independently verified; refund/payment workflow tested; load/failure/security tests passed; terms and legal/payment review complete; Owner dashboard/audit/stop controls verified. এর কোনোটি অসম্পূর্ণ হলে package purchase button disabled থাকবে এবং সদস্যের কাছ থেকে টাকা নেওয়া হবে না.


# MASTER WORLD VIP — সদস্য Auto Work প্যাকেজ ও ১০০% সুরক্ষা নীতি
Updated: 2026-11-25

## ১. Owner-এর বাধ্যতামূলক অঙ্গীকার
সাধারণ সদস্যকে বিন্দুমাত্র আর্থিক ক্ষতির ঝুঁকিতে ফেলে Owner বা প্ল্যাটফর্ম লাভ করতে পারবে না। সদস্যের সুরক্ষা, সম্মান, গোপনীয়তা ও Admin/Owner Auto Work-এর স্থিতিশীলতা—সবই বাধ্যতামূলক। কোনো নিরাপত্তা শর্ত পূরণ না হলে প্যাকেজ বিক্রি ও Member Auto Work বন্ধ থাকবে। সদস্য Auto Work বাতিল নয়; আপাতত স্থগিত, ভবিষ্যতে সব launch gate পাস করলে চালুর সুযোগ থাকবে।

## ২. বর্তমান অবস্থা
- Member Auto Work execution: **DISABLED / NOT LIVE**.
- Member paid package sales/checkout: **DISABLED / NOT LIVE**.
- Member package purchase button, deposit collection বা paid automation queue চালু করা যাবে না।
- সাধারণ Work & Earn-এর মানব-সম্পাদিত, funded কাজ আলাদা নিয়মে চলতে পারে; কোনো registration fee/deposit বাধ্যতামূলক নয়।
- Admin Auto Work-এর queue, server, credentials, budget, storage বা capacity সদস্যের কাজ ব্যবহার করতে পারবে না।

## ৩. ভবিষ্যৎ Member Protected Package-এর মূল কাঠামো
ভবিষ্যতে সদস্য নিজের ইচ্ছায় প্যাকেজ কিনে dedicated Member Auto Work ব্যবহার করতে পারবেন। প্যাকেজ ঐচ্ছিক; কিনতে বাধ্য করা, paid unlock-কে সাধারণ সদস্যপদের শর্ত করা বা বিনা সম্মতিতে auto-renew করা যাবে না। কেনার আগে বাংলা ভাষায় মূল্য, মেয়াদ, কাজের ধরন, অন্তর্ভুক্ত credits/jobs, usage limit, provider dependency, expected turnaround, refund trigger, refund time/method, privacy এবং dispute route দেখাতে হবে। কোনো নির্দিষ্ট আয়/লাভের নিশ্চয়তা দেওয়া যাবে না; তবে প্যাকেজের অর্থ ফেরতের প্রতিশ্রুতি নির্দিষ্ট ও বাধ্যতামূলক হবে।

## ৪. ১০০% Refund Reserve — প্রতি বিক্রিতে বাধ্যতামূলক
- প্রতিটি package payment-এর **১০০% সমপরিমাণ BDT** আলাদা, liquid, reconciled refund reserve-এ সংরক্ষণ করতে হবে। Reserve-টি ঐ সদস্যের প্যাকেজ দায়ের বিপরীতে থাকবে; এটি platform revenue, Owner profit বা spendable cash নয়।
- এই reserve থেকে server/API/storage cost, salary, marketing, referral, commission, অন্য সদস্যের refund বা অন্য কোনো খরচ দেওয়া নিষিদ্ধ।
- Member Auto Work-এর compute/API/provider/operations cost দিতে হবে সম্পূর্ণ আলাদা platform-funded operating budget থেকে। package payment-কে operating capital ধরে খরচ করা যাবে না।
- নতুন বিক্রি অনুমোদনের আগে server-side control-এ payment settlement reference, reserve funding reference, reserve amount এবং reconciliation timestamp যাচাই করতে হবে। শুধু screenshot/manual claim যথেষ্ট নয়।
- Reserve coverage 100%-এর নিচে, reserve account/provider hold-এ, mismatch/dispute থাকলে বা reserve reconciliation stale হলে checkout fail-closed হবে: নতুন package purchase, renewal ও job start বন্ধ।
- Reserve আলাদা ব্যাংক/অনুমোদিত payment-provider arrangement-এ রাখা হবে; কেবল একই database-এ “reserved” লেখা থাকলেই প্রকৃত অর্থ আলাদা সংরক্ষিত হয়েছে বলে গণ্য হবে না। বাংলাদেশে প্রযোজ্য আইন ও provider অনুমোদন ছাড়া escrow/trust account বলে প্রচার করা যাবে না।
- কোনো refund-এর টাকা অন্য নতুন সদস্যের payment থেকে দেওয়া যাবে না (no cross-subsidy).

## ৫. সদস্যের ক্ষতি-না-হওয়ার refund promise
প্রতিটি প্যাকেজে আগে থেকেই একটি নির্দিষ্ট evaluation period ও qualifying earning threshold দেখাতে হবে। প্রস্তাবিত default protection:
- Evaluation period শেষে সদস্যের ঐ প্যাকেজের অধীনে সম্পন্ন, client-accepted এবং payment-settled কাজ থেকে সদস্যের নামে বাস্তবে withdrawable/paid **net eligible earning যদি package price-এর কম হয়**, সদস্য পূর্ণ original package price ফেরত পাবেন।
- সদস্য ইতিমধ্যে যে কাজের পারিশ্রমিক অর্জন করেছেন তা তারই থাকবে; refund দেওয়ার জন্য তা কেটে নেওয়া, clawback বা offset করা যাবে না।
- Refund হবে original payment method-এ; provider fee/transaction fee/FX loss প্ল্যাটফর্ম বহন করবে, যদি আইনত সম্ভব হয়। Member-এর কাছে নতুন fee দাবি করা যাবে না।
- Refund-এর নির্দিষ্ট সর্বোচ্চ processing time ও ব্যর্থ হলে escalation route checkout-এর আগেই দেখাতে হবে। সময়সীমা না থাকলে package sale চালু করা যাবে না।
- Platform/server/provider fault, job execution না হওয়া, দীর্ঘ outage, permission/contract failure বা promised service না পাওয়া গেলে evaluation period শেষ হওয়ার অপেক্ষা ছাড়াই full refund/cancel path দিতে হবে।
- Fraud/abuse exception কেবল প্রমাণ-সমর্থিত, narrow, disclosed এবং human-reviewed হতে পারে; একতরফা সিদ্ধান্তে genuine member earnings বা refund আটকে রাখা যাবে না। Member appeal/helpdesk বাধ্যতামূলক।
- এই refund promise দেওয়ার জন্য 100% reserve ছাড়াও operating costs বহনের আলাদা অর্থ থাকতে হবে। reserve থাকলেও operating budget না থাকলে বিক্রি/নতুন job বন্ধ থাকবে।
- আইনগত/payment provider review যদি এই refund guarantee-কে অনুমোদন না করে, প্যাকেজ বিক্রি চালু করা যাবে না; প্রতিশ্রুতি দুর্বল করে গোপনে বিক্রি নয়।

## ৬. Revenue, member earning ও Owner profit-এর হিসাব
ক্রমটি হবে:
1. Customer/client-এর বাস্তব payment settle এবং কাজ গ্রহণ নিশ্চিত।
2. সংশ্লিষ্ট customer obligation, fees/tax/refund/chargeback exposure reconcile।
3. Member-এর প্রকাশিত কাজের পারিশ্রমিক আলাদা payable হিসেবে সংরক্ষণ ও সময়মতো প্রদান।
4. Provider/compute/operations cost আলাদা operating fund থেকে হিসাব।
5. সব package refund liability 100% reserve-এ অক্ষত ও reconciled রাখা।
6. এরপরই প্রকৃত, আইনত ব্যবহারযোগ্য platform net revenue থাকলে, আগে প্রকাশিত rate/terms অনুযায়ী Owner commission/profit আলাদা ledger-এ accrue হতে পারে।
- Member package payment নিজে profit বা আয় নয়; তা refund-liability/contract liability হিসেবে গণ্য হবে যতক্ষণ না আইনত earned হওয়া নির্ধারিত হয়।
- Pending, estimated, disputed, invoiced-but-unpaid, free quota usage বা AI job completion revenue নয়।
- Owner commission কখনো member wage, member wallet, refund reserve, customer restricted fund বা unsettled payment থেকে কাটা যাবে না।
- Commission rate, tax, fee, refund/chargeback treatment ও timing আগে প্রকাশিত না থাকলে commission accrual = ৳০।

## ৭. আলাদা অবকাঠামো ও প্রযুক্তিগত বিচ্ছিন্নতা
- Member Auto Work-এর dedicated server/account/worker pool, queue, database schema/role boundary, storage namespace, API credentials, quota ও budget থাকবে।
- Owner/Admin-এর reserved CPU/RAM, database connections, queue slots, API quotas, storage, bandwidth ও credentials member workload থেকে hard isolation পাবে।
- Member-এর load কখনো Admin job slow/block/stop করতে পারবে না; resource pressure হলে member jobs আগে pause হবে।
- Per-member/per-package hard spend, runtime, concurrency, request, storage, bandwidth ও file-size limits; idempotency, retries, rate limiting, malware/file validation, encryption, least privilege ও audit trail থাকবে।
- 80% quota/budget-এ warning; 100% বা provider quota/error-এ pause; কোনো silent paid fallback বা অতিরিক্ত charge নয়।
- Admin/Owner emergency stop এবং member-নিজের pause/cancel controls থাকবে।
- Member-এর phone/battery/mobile data/bandwidth-কে distributed compute হিসেবে ব্যবহার করা যাবে না।
- Provider/client permission, contract, data scope ও retention rules ছাড়া কোনো job চলবে না।

## ৮. Package purchase ও job state machine
State transitions: draft → published (only after launch gates) → checkout_pending → payment_settled → reserve_verified → eligible_to_start → running → client_accepted → client_payment_settled → member_earning_paid.
Refund path: refund_requested → eligibility_review → refund_approved → provider_refund_submitted → refund_settled. প্রতিটি transition timestamp, actor, evidence/reference ও reason-সহ audit হবে। কোনো payment বা refund state browser redirect, screenshot বা member-entered transaction ID দিয়ে paid/settled করা যাবে না; provider server-to-server verification বাধ্যতামূলক। Duplicate webhook/idempotency key duplicate ledger/refund ঠেকাবে।

## ৯. Transparency, privacy ও member control
- Checkout-এর আগে total price, currency, tax/fee, renewal (default off), term, package credits, limits, refund criteria, refund route, data usage, file retention, provider name/region এবং support SLA দেখাতে হবে।
- Member dashboard-এ package status, remaining credits, jobs, usage/cost cap, client acceptance, settled earnings, paid status, refund eligibility/status ও complaint reference দেখাতে হবে।
- Member files private/encrypted, role-scoped, retention-limited; অনুমতি ছাড়া model training, public URL, unrelated processing বা data resale নয়।
- Password, OTP, Facebook login code, bank PIN, full card data chat/worker log-এ নেওয়া যাবে না।

## ১০. Launch checklist — একটিও অসম্পূর্ণ হলে বিক্রি বন্ধ
1. Dedicated Member infrastructure/account deployed; Admin/Owner isolation test pass.
2. Separate operating budget and per-member hard caps funded.
3. Every package sale has 100% actual liquid refund reserve; reconciliation automation and reserve audit pass.
4. Payment provider officially supports Bangladesh merchant onboarding, collection, refund, dispute and settlement for this business model; legal/compliance review complete.
5. Full payment/refund/partial earning/zero earning/chargeback/outage/duplicate webhook tests pass using test mode and then controlled pilot.
6. Member earnings and customer receipts are provider-verified; separate ledgers and double-entry reconciliation pass.
7. Terms, privacy notice, package comparison, refund SLA, complaints and appeal workflow published in Bengali.
8. Owner dashboard has reserve coverage, operating budget, outstanding liabilities, settled revenue, member payables, refund queue, provider health and emergency stop.
9. Security review, penetration/abuse tests, load tests, backup/restore and disaster recovery pass.
10. Small opt-in pilot completes; every member receives promised payment/refund; independent reconciliation signed off.
11. Only after Owner sign-off may packages be published. If any gate regresses, new sales and jobs automatically pause; existing member liabilities and refunds remain payable.

## ১১. Test cases (release-blocking)
- reserve = 100%: purchase may proceed only if all other gates pass.
- reserve = 99.99%, stale, locked, unmatched or missing: purchase denied.
- client pays nothing / work not accepted / member net earning below package price by evaluation deadline: full package price refund, member earnings retained.
- member earns at least package price: refund condition not triggered; member earning remains payable under task terms.
- platform outage/provider suspension: stop jobs and refund according to outage clause.
- chargeback after member payment: no arbitrary clawback from member; use disclosed reserve/chargeback process and fraud review.
- duplicate payment webhook/refund retry: no duplicate purchase, earning or refund.
- member job flood: Admin reserved capacity unchanged; member queue pauses first.
- admin tries to read member private files or member tries to access Admin queue: denied and audited.
- emergency stop: no new charge/job; member balance and refund claim remain visible.
- no real settled customer payment: no earning/Owner commission; no fake balance.

## ১২. বর্তমান বাস্তবায়ন সীমা
এই নীতিমালা ও UI copy সংরক্ষণ করা মানে payment, escrow/reserve account, refund, dedicated server, worker, customer contracts বা payout integration live হওয়া নয়। বর্তমানে Member Auto Work এবং package checkout disabled. কোনো সদস্যের কাছ থেকে টাকা নেওয়া যাবে না। Database schema/migration, provider account/merchant approval, reserve custody, backend enforcement, deployment, independent financial reconciliation ও end-to-end acceptance tests সম্পন্ন না হওয়া পর্যন্ত এটি পরিকল্পনা মাত্র।


## ১৩. চূড়ান্ত Owner/Admin Profit Rule — ২০% (2026-11-25)

- **Default Owner/Admin Profit Rate = 20% of Distributable Net Platform Revenue.** এই হার ব্যবহারকারীর নির্দেশে নির্ধারিত। Admin Settings-এ কেবল অনুমোদিত Owner/Super Admin হার পরিবর্তন করতে পারবেন; প্রতিটি পরিবর্তনে পুরোনো/নতুন হার, actor, সময়, কারণ এবং কার্যকর হওয়ার সময় audit হবে। পরিবর্তন কখনো retroactive হবে না; কাজ/অর্ডার গ্রহণের আগে প্রযোজ্য হার প্রকাশ করতে হবে।
- ২০% কখনো customer-এর gross payment, member-এর earned wage, member wallet balance, package purchase price, refund reserve, tax, payment-provider hold, unsettled/disputed receipt বা অন্যের restricted funds-এর ওপর গণনা হবে না।
- **Distributable Net Platform Revenue** কেবল বাস্তবে settled ও আইনত platform-এর প্রাপ্য আয় থেকে হিসাব হবে; সংশ্লিষ্ট tax/fees, refunds/chargebacks, client obligations, member payable, provider/compute/operations cost এবং সম্পূর্ণ refund-reserve coverage ও অন্যান্য due liabilities বাদ/নিশ্চিত করার পর যে নিট platform revenue অবশিষ্ট থাকে সেটিই ভিত্তি। একই খরচ/দায় দ্বিগুণ বাদ দেওয়া যাবে না; প্রতিটি হিসাবের source ledger reference থাকবে।
- Formula: owner_profit = round_half_up(distributable_net_platform_revenue × 20 / 100) in BDT minor units. Negative/zero base হলে profit = ৳0. Rounding policy server-side এককভাবে প্রয়োগ হবে।
- উদাহরণ (এগুলো **বণ্টনযোগ্য নিট আয়**, gross customer payment নয়): ৳500 → ৳100; ৳1,000 → ৳200; ৳5,000 → ৳1,000; ৳10,000 → ৳2,000.
- Customer payment settle এবং client acceptance যাচাইয়ের পর একই atomic, idempotent ledger transaction-এ member-এর সম্পূর্ণ earned payable/member wallet credit এবং Owner-এর 20% profit accrual লেখা হবে—কিন্তু কেবল তখনই, যখন উভয় payable ও সব reserve/operating/liability gate পূরণ হয়েছে। Member-এর মজুরি আগে পূর্ণভাবে সুরক্ষিত থাকবে; Owner profit কখনো member wage থেকে কাটা হবে না। Bank/MFS withdrawal আলাদা payout-provider settlement; wallet ledger credit-কে cash withdrawal completed বলে দেখানো যাবে না।
- Payment/refund webhooks provider signature/server-to-server verification-সহ গ্রহণ করতে হবে। Unique source transaction + event id + ledger idempotency key/unique constraint duplicate credit ঠেকাবে; retries একই ফল দেবে। Atomic transaction ব্যর্থ হলে কোনো পক্ষের ledger-এই আংশিক credit থাকবে না। Reconciliation mismatch, reserve shortfall, unresolved chargeback, insufficient operating funds বা unsettled payment থাকলে Owner profit accrual/transfer fail-closed হবে; member-এর ইতিমধ্যে অর্জিত payable অক্ষত থাকবে।
- Admin Profit Ledger ও Member Wallet Ledger আলাদা append-only ledgers হবে; adjustment কেবল অনুমোদিত reversal/compensating entry দিয়ে, মূল entry মুছে নয়। Admin dashboard-এ gross settled receipt, deductions/liabilities, distributable net base, active rate, calculated profit, transfer status ও source references দেখা যাবে।
- **Implementation status:** এই সিদ্ধান্ত/হিসাবনীতি নথিভুক্ত; ২০% commission engine, Admin Settings, atomic wallet posting, provider settlement/refund integration বা actual Admin payout এখনো live নয়। এগুলো schema, server-side enforcement, provider/legal approval, test এবং guarded deployment ছাড়া কার্যকর বলে দাবি করা যাবে না। বর্তমান Member Auto Work package checkout/execution disabled থাকবে।


## ১৪. Backend foundation added (2026-11-25)

Repository migration `20261125160000_work_earn_wallet_owner_profit.sql` now defines separate Member Work Wallet and Owner Work Profit ledgers, Owner-only audited rate settings (default 20%), server-only verified-payment and financial-reconciliation inputs, and a service-role-only atomic/idempotent settlement RPC. It calculates Owner profit only from the distributable net platform fee after tax, provider fees, operating costs and restricted liabilities, and posts the member's full payable plus Owner profit in one transaction. Duplicate event/key collisions, unverified/unaccepted payments, stale/failed reconciliation gates, mismatched amounts, and zero/multiple Owner roles fail closed.

**Status remains NOT LIVE:** this is a committed database schema/RPC foundation only. The migration has not been applied to production; no provider webhook/Edge Function, merchant account, actual reserve custody, reconciliation service, payout connector, or end-to-end test has been deployed. Do not show wallet credits as cash withdrawn. Keep paid Member Auto Work packages disabled. Acceptance checklist: `docs/WORK_EARN_WALLET_OWNER_PROFIT_ACCEPTANCE_TEST_BN.md`.


## ১৫. Owner-এর নতুন Global Marketplace ও progressive commission সিদ্ধান্ত (2026-11-26)

এই অংশটি Section ১৩-এর আগের fixed 20% rule-কে **পরিবর্তন/সুপersede** করে। এটি Owner-এর নতুন product requirement ও policy proposal; production code বা live commission setting নয়।

### A. Global Customer Order Portal
- MASTER WORLD VIP-এ দেশি ও আন্তর্জাতিক customer portal থাকবে: customer account, identity/risk checks, service catalogue, quote/price disclosure, task brief, file upload, deadline, terms acceptance, order tracking, secure payment, delivery review, accept/revision/dispute এবং invoice/receipt।
- গ্রাহক কেবল বৈধ, অনুমোদিত ও আইনসম্মত কাজ জমা দিতে পারবেন। নিষিদ্ধ/ঝুঁকিপূর্ণ কাজ, fake engagement, fake traffic, CAPTCHA bypass, credential theft, unauthorized scraping, malware, impersonation বা platform/provider terms লঙ্ঘনকারী কাজ block/review হবে।
- Customer payment status কেবল payment provider-এর server-to-server verified webhook/API ও reconciliation দিয়ে settled হবে; browser redirect, screenshot বা manual transaction ID যথেষ্ট নয়।
- Customer files private encrypted storage-এ, tenant-scoped authorization, malware/type/size validation, short-lived signed access, retention/deletion ও audit trail-সহ থাকবে।

### B. 10 million+ global customer ambition and lifetime-work objective
- Owner-এর লক্ষ্য: বিশ্বব্যাপী ১ কোটি (10,000,000) বা তার বেশি গ্রাহক অর্জন এবং দীর্ঘমেয়াদে নিয়মিত/সারাজীবন কাজের সুযোগ গড়ে তোলা। এটি growth target; বর্তমান customer count বা guaranteed future demand নয়।
- 2,000+ genuine project/service categories/modules এবং প্রয়োজনে verified client/brand programmes-এর catalogue গড়ে তোলা হবে। প্রতিটি module বাস্তব deliverable, customer demand, permission/contract, price/cost model, quality criteria, eligibility, risk review ও provider capacity দ্বারা সমর্থিত হতে হবে। শুধু নামের তালিকা বা কৃত্রিম project-কে real/active বলা যাবে না।
- “Unlimited customer work/orders” হবে customer-এর পুনরাবৃত্ত অর্ডার জমা দেওয়ার product ambition; এটি unlimited compute, unlimited storage, guaranteed instant execution, unlimited free usage বা guaranteed member income বোঝায় না। Queue, fair-use, concurrency, budget, provider quota, legal scope ও SLA অনুযায়ী গ্রহণ/প্রক্রিয়াকরণ হবে; capacity না থাকলে transparent queue/ETA বা order intake pause।
- কোনো গ্রাহক, অর্ডার, project, revenue বা lifetime availability সংখ্যা বানিয়ে dashboard-এ দেখানো যাবে না। Actual verified metrics-ই প্রকাশ করতে হবে।

### C. Smart Member Assignment
- Paid/verified eligible order-ই member assignment queue-তে যাবে। Skill, language, country eligibility, verified profile, availability, workload fairness, quality history, deadline, rate ও conflict-of-interest বিবেচনায় matching হবে।
- Member কাজ accept করার আগে scope, exact payable amount/currency, estimated effort, deadline, acceptance criteria, revision policy, client payment/settlement status, platform fee/commission, dispute path ও expected payout timing দেখতে পাবেন।
- Member-এর কাজের rate task অনুযায়ী নির্ধারিত হবে; একক fixed percentage বা অযৌক্তিক low rate নয়। কাজ গ্রহণের পর প্রকাশিত member payable কমানো যাবে না। Customer scope পরিবর্তন হলে নতুন quote ও member consent আবশ্যক।
- No real funded order = no task allocation and no earning claim. Queue/AI/API execution alone is not earning.

### D. 24/7 server-side Auto Work
- Automation server-side durable queue/worker দিয়ে চলবে; member phone/browser/PWA-কে always-on compute হিসেবে ব্যবহার করা যাবে না।
- Idempotent claims, lease/heartbeat/reclaim, bounded retries/backoff, timeout/cancellation, per-module and per-customer concurrency, fair scheduling, cost caps, provider quota tracking, monitoring, sanitized logs, disaster recovery ও global emergency stop আবশ্যক।
- Admin/Owner workload ও member workload আলাদা infrastructure/queue/credentials/storage/budgets-এ isolate হবে। Member workload Owner/Admin reserved capacity ব্যবহার করতে পারবে না।
- 24/7 architecture লক্ষ্য; provider free-tier, outages, maintenance ও quota-র কারণে uninterrupted lifetime uptime guarantee নয়। Quota/capacity শেষ হলে pause/queue; explicit approval + spend cap ছাড়া paid fallback নয়।
- 2,000+ modules ও 2,000 simultaneous jobs কেবল staged load test, real demand, database/worker/provider capacity, budget approval ও failure/recovery acceptance pass হলে ধাপে ধাপে চালু হবে; একসঙ্গে 2,000 job চালানো এখনই enabled নয়।

### E. Strong Security and anti-fraud
- Server-side RBAC/MFA for privileged roles, least privilege, RLS/tenant isolation, secure session lifecycle, CSRF/XSS/SQLi protections, rate limiting, bot/abuse detection, risk scoring, audit trail, encryption in transit/at rest, secret rotation, dependency scanning, backups and tested restore।
- Order/payment/job/settlement/payout transitions হবে server-authoritative state machine; unique idempotency keys, signed provider webhooks, reconciliation ও duplicate/fraud detection থাকবে।
- Customer/member identity, sanctions/eligibility where legally required, suspicious activity review, chargeback/dispute evidence, appeal, privacy/retention/deletion এবং incident response process লাগবে।
- Admin cannot read private customer/member files without explicit authorized support/audit purpose; members cannot access other clients' or members' records. No password/OTP/payment PIN collection in chat or logs.

### F. Member no-loss / wage protection
- কোনো সদস্যকে deposit, joining fee, mandatory paid plan বা task unlock fee দিতে হবে না। Paid plan member-এর কাজ পাওয়ার শর্ত হবে না।
- Job গ্রহণের আগে expected costs, member payable ও platform margin হিসাব হবে। Direct costs, payment fees, tax, refunds/chargebacks, required reserves ও provider cost বাদ দিয়ে sustainable margin না থাকলে order reject/requote/pause; member wage বা member wallet থেকে platform loss পূরণ নয়।
- Member payable accepted scope-এর জন্য protected liability; platform commission, refund বা chargeback-এর নামে earned wage clawback/offset নয়, কেবল প্রমাণিত fraud এবং আইনসম্মত human-reviewed process ব্যতীত।
- Customer payment settle ও deliverable acceptance verify হওয়ার পরই member earning payable/withdrawable হবে; cash payout provider reconciliation আলাদা করে দেখাতে হবে।
- “৳100 খরচে ৳1,000 বা তার বেশি আয়” একটি aspirational business target/উদাহরণ, কোনো বাস্তবসম্মত বা নিশ্চিত return নয়। প্রতিটি কাজের unit economics প্রমাণ ছাড়া এমন claim, guarantee বা marketing নিষিদ্ধ। প্রকৃত গ্রাহক মূল্য, কাজের সময়/দক্ষতা, খরচ ও বাজারদর অনুযায়ী আয় নির্ধারিত হবে।

### G. Progressive Owner/Admin commission — requested 20% / 35% tiers
- Owner-এর নতুন নির্দেশ: কম আয়ের/ছোট কাজের ক্ষেত্রে Admin commission 20%; বেশি আয়ের/বড় কাজের ক্ষেত্রে 35%।
- 20% বনাম 35% নির্ধারণের **BDT threshold এখনও Owner-এর কাছ থেকে নির্দিষ্ট হয়নি**। তাই threshold অনুমান করে code-এ hard-code করা যাবে না। Admin Settings-এ tier threshold configurable হতে পারে, কিন্তু production activation-এর আগে Owner approval, প্রকাশিত terms ও audit আবশ্যক।
- উভয় হার কেবল **Distributable Net Platform Revenue**-এর ওপর প্রয়োগ হবে; customer gross payment, member payable, tax, payment fees, refund/chargeback reserve, provider/compute/operating costs, restricted/unsettled funds-এর ওপর নয়।
- Formula: distributable net base > 0 হলে applicable_rate = approved 20% বা 35%; admin commission = round_half_up(net base × applicable_rate). Net base শূন্য/ঋণাত্মক, payment unsettled, reconciliation stale/mismatch, reserve shortfall বা member payable unfunded হলে commission = ৳0 / fail-closed।
- Member-এর প্রকাশিত payable আগে সম্পূর্ণ সুরক্ষিত থাকবে। Admin rate কখনো member wage কমিয়ে, member wallet থেকে কেটে, customer restricted funds ব্যবহার করে বা unpaid liability বাদ দিয়ে বাড়ানো যাবে না।
- Rate/threshold changes prospective only; কাজ/অর্ডার গ্রহণের আগে customer/member-কে applicable rate/fee disclosure; audit actor, old/new rate, threshold, reason, timestamp, effective_at। Retroactive change নিষিদ্ধ।
- পূর্বের Section ১৩-এর fixed 20% policy এই progressive rule দ্বারা superseded; তবে 35% rate/threshold বাস্তবে অনুমোদিত, funded ও tested না হওয়া পর্যন্ত production default 20% policy থেকে নিজে নিজে পরিবর্তিত হবে না।

### H. Admin-only Free Plan and Paid Plan choices
- Owner/Admin dashboard-এ দুইটি internal option থাকবে: (1) Free Admin Plan, default; (2) Paid Admin Plan, optional purchase/upgrade।
- Free plan-এ provider-defined quota, execution/time/storage/concurrency limits স্পষ্ট থাকবে; unlimited resources বা lifetime uptime দাবি নয়।
- Paid plan কেবল Admin-এর explicit selection, provider price/terms display, secure payment, budget cap, approval and audit-এর পর চালু হবে। Auto-renew default off; cancellation and receipt history থাকবে।
- Admin paid plan-এর খরচ Member wallet, member wages, customer restricted money বা refund reserve থেকে নেওয়া যাবে না। Free plan quota শেষ হলে pause/queue; silent paid upgrade নয়।
- এই দুই plan option Admin-only; সাধারণ সদস্যের জন্য বাধ্যতামূলক নয় এবং সদস্যকে paid plan কিনতে বাধ্য করে কাজ দেওয়া যাবে না।

### I. Release stages and proof gates
1. Customer Portal + secure order/payment state machine in staging.
2. At least one legitimate customer/provider contract and one real paid pilot order.
3. One human-reviewed member task category with disclosed rate, acceptance, settlement and successful payout.
4. Server-side worker for one approved module; isolated queue, budget, private storage and recovery tests.
5. Add categories only when each has real demand/provider/legal permission and unit economics.
6. Scale 20 → 100 → 500 → 2,000+ categories; concurrency scale separately by load-test evidence and approved budget.
7. Security/privacy/legal review, fraud/dispute/refund acceptance, backup/restore, monitoring and controlled canary.
8. Only features passing deployment + production config + real end-to-end acceptance may be marked LIVE.

### J. Status and non-guarantees
এই document update কোনো Customer Portal, payment gateway, worker, provider contract, 10-million customer base, 2,000 live projects, unlimited work, 24/7 service, commission engine, Admin plan purchase বা payout চালু করে না। এগুলো requirements/targets. Production DB safety prerequisite (including secure DB URL correction, encrypted backup/restore/dry-run and explicit migration authorization) অপরিবর্তিত থাকবে। Until evidence passes, relevant features remain PARTIAL / BLOCKED / NOT LIVE.
