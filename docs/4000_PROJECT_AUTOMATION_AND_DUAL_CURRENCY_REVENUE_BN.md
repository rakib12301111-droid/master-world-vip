# MASTER WORLD VIP — ৪,০০০ প্রজেক্টের কেন্দ্রীয় অটোমেশন ও আয়-ব্যবস্থা

**Status: OWNER REQUIREMENT / ARCHITECTURE SPECIFICATION — NOT IMPLEMENTED OR LIVE**  
**Recorded:** ২৬ নভেম্বর ২০২৬

## ১. মূল লক্ষ্য
MASTER WORLD VIP-এ মোট **৪,০০০টি project slot** থাকবে। সবগুলো একটি কেন্দ্রীয় Automation Control Plane-এর অধীনে পরিচালিত হবে; প্রতিটি প্রজেক্টের নিজস্ব ID, কাজের ধরন, currency, payer/source, execution policy, budget cap, status, audit trail ও acceptance criteria থাকবে।

- **MW-USD-0001 থেকে MW-USD-2000:** সর্বোচ্চ ২,০০০টি USD-earning project slot। ডলার কেবল বাস্তব আন্তর্জাতিক customer, advertiser, sponsor, marketplace buyer বা অনুমোদিত partner-এর settled payment থেকে আসবে।
- **MW-BDT-2001 থেকে MW-BDT-4000:** সর্বোচ্চ ২,০০০টি BDT-earning project slot। টাকা কেবল বাস্তব বাংলাদেশি customer, advertiser, sponsor, marketplace buyer বা অনুমোদিত partner-এর settled payment থেকে আসবে।
- দুই গ্রুপ একই automation platform ব্যবহার করবে; তবে currency ledger, payment provider, tax/fee, payout route ও reconciliation আলাদা থাকবে।
- ৪,০০০ হলো portfolio target/capacity goal; বর্তমানে ৪,০০০টি চালু বা আয়কারী project আছে—এমন দাবি নয়। প্রতিটি slot-এ যাচাইকৃত business model ও funded demand না থাকলে সেটি Planned/Unfunded থাকবে।

## ২. Admin ও Member plan policy

### Admin
- Admin-এর জন্য একটি Free Admin entitlement থাকবে—এতে নির্ধারিত basic control, monitoring ও project oversight সুবিধা থাকবে।
- একটি Paid Admin plan থাকবে—এতে অনুমোদিত অতিরিক্ত automation/management capability থাকবে।
- Admin-এর নিজের plan purchase বা নিজের account-এ internal credit কোনো company income নয়। Admin paid plan-এর মূল্য সত্যিকারের provider settlement হলে তবেই customer revenue হিসেবে গণ্য হবে; Owner-এর নিজের purchase হলে সেটি operating expense হিসেবে হিসাব হবে।

### সাধারণ Member
- সাধারণ Member paid plan কিনে, payment provider-এর server-side verified settlement এবং entitlement checks পাস করার পর plan-সংশ্লিষ্ট automation সুবিধা চালু করতে পারবেন।
- Plan কেনা মানেই কাজ, task, নির্দিষ্ট আয়, দৈনিক ডলার/টাকা, bonus বা profit নিশ্চিত নয়।
- Member-কে শুধু কাজ/আয় পাওয়ার প্রতিশ্রুতি দিয়ে plan কিনতে বাধ্য করা যাবে না। প্রযোজ্য আইন, consumer disclosure, refund terms ও provider rules যাচাই করতে হবে।
- Member Auto Work paid package checkout/execution বর্তমান policy অনুযায়ী **DISABLED / NOT LIVE** থাকবে যতক্ষণ না ১০০% liquid refund reserve, আলাদা operating budget, isolated worker infrastructure, verified payment/refund integration, legal/security review ও acceptance tests পাস করে। এই নথি ওই safety gate বাতিল করে না।

## ৩. অর্থপ্রবাহ ও হিসাব
1. Plan/order তৈরি → server-side payment session → provider signature/webhook verification → settled status যাচাই।
2. একই event idempotency key দিয়ে একবারই process হবে; client-side success screen বা redirect একা payment proof নয়।
3. Verified settlement-এর পরেই plan entitlement সক্রিয় হবে; expiry, refund, chargeback, dispute বা provider hold হলে policy অনুযায়ী suspend/revoke হবে।
4. USD receipt USD ledger-এ এবং BDT receipt BDT ledger-এ immutable source reference-সহ থাকবে। USD→BDT conversion আলাদা, বাস্তব executable FX quote ও provider settlement-এর পরেই post হবে; একই receipt দুই currency-তে দ্বিগুণ revenue হিসেবে গণনা হবে না।
5. Gross receipt, tax, gateway/FX fee, refund/chargeback, delivery/API/compute cost, member payable, restricted reserve, net platform revenue ও Admin entitlement আলাদা entry হবে।
6. Member wage/customer restricted funds/refund reserve কখনো Admin profit বা operating cost হিসেবে ব্যবহার করা যাবে না।
7. Payout কেবল বাস্তব transfer confirmation ও provider reference-এর পরে Paid হবে। bKash/Nagad/Bank/USD payout API integration না থাকলে status Manual/Pending-ই থাকবে।

## ৪. কেন্দ্রীয় Automation Control Plane
প্রতিটি project-এর জন্য অন্তত:
- Unique project ID এবং USD/BDT currency classification;
- project owner/worker role, permitted task type ও source-of-funds;
- budget ceiling, API/compute quota, rate limit ও kill switch;
- queue/job state: planned → funded → queued → running → review/accepted → settled → completed;
- retry/idempotency, failure isolation, timeout ও dead-letter handling;
- customer acceptance / sponsor proof / marketplace settlement evidence;
- privacy, access control, audit log, observability ও incident alert;
- unit economics: gross receipts, direct cost, refunds, member payable, net contribution;
- status: Planned, Building, Test, Blocked, Live (evidence required), Paused, Retired.

কোনো project internet access, timer, scheduled workflow বা successful code execution-এর কারণে নিজে থেকে revenue তৈরি করে না। প্রতিটি earning project-এর identifiable payer, enforceable scope/offer, customer demand, successful delivery, acceptance এবং collected settlement থাকতে হবে।

## ৫. প্রাথমিক আয়-উৎসের project families
এগুলো ৪,০০০ slot-এর সম্ভাব্য category; সবগুলো এখন live নয়:
- Premium subscription ও AI Services;
- Marketplace sales ও completed-order commission;
- Digital services / document / design / productivity delivery;
- Advertising ও sponsorship;
- approved affiliate / partner commission;
- funded client microtasks ও employer projects;
- Bangladesh-local service orders এবং international USD orders.

কোনো category-কে বাস্তব আয়কারী বলা যাবে না যতক্ষণ provider/customer onboarding, delivery workflow, settlement, reconciliation ও acceptance test প্রমাণিত না হয়।

## ৬. বর্তমান codebase-এ যাচাইকৃত অবস্থান (২৬ নভেম্বর ২০২৬)

**যা repository foundation হিসেবে আছে:**
- Member Hub, Admin/RBAC/audit, AI assistant Edge Function foundation;
- Work & Earn job-board UI ও migration source;
- referral wallet/reward schema ও UI foundation;
- Work & Earn member wallet এবং Owner profit settlement RPC-এর migration source;
- verified-payment state এবং SSLCommerz checkout-সংক্রান্ত migration source;
- backup/restore, migration preview, read-only audit এবং disposable migration validation workflows.

**যা এখনো production-live/সম্পূর্ণ বলে যাচাই করা হয়নি:**
- Company Revenue Ledger/dashboard ও revenue allocation bridge;
- complete Premium/AI paid-plan catalog, checkout, verified webhook-to-entitlement activation;
- ৪,০০০ project registry, project scheduler/queue fleet ও worker orchestration;
- USD/BDT পৃথক production earning ledgers ও actual payout integrations;
- Admin Free/Paid entitlement enforcement এবং সাধারণ Member paid-plan purchase/activation;
- production migration apply, payment provider merchant/webhook configuration, legal/provider approvals এবং end-to-end customer acceptance tests.

Work & Earn wallet/Owner profit backend migration source থাকলেও production migration, payment webhook/Edge Function, merchant credentials, funded refund reserve/operating reconciliation, payout connector এবং end-to-end tests যাচাই হয়নি। তাই balance/ledger foundation-কে cash income বা automatic payout বলা যাবে না।

## ৭. বাস্তবায়নের নিরাপদ ধাপ
1. **Registry & architecture:** ৪,০০০ slot-এর ID/category registry, project intake rules, USD/BDT separation, shared control plane design.
2. **Revenue core:** company revenue ledger, immutable double-entry accounting, source attribution, refund/chargeback, reconciliation ও Admin entitlement calculation.
3. **Plan commerce:** Admin Free/Paid এবং Member paid plan catalog, terms, pricing, provider checkout, signed webhook, idempotent entitlement lifecycle; non-production sandbox tests first.
4. **Project automation:** queue/worker isolation, quotas, per-project budgets, scheduler, observability, kill switch, delivery acceptance.
5. **Currency & payout:** supported USD/BDT provider onboarding, real FX settlement, tax/compliance, bank/mobile-wallet payout acceptance.
6. **Scale validation:** staged load tests, cost forecasts, disaster recovery, privacy/security review; ১০ মিলিয়ন member capacity কেবল measured evidence থাকলে দাবি করা যাবে.
7. **Release:** feature-by-feature rollout; Production database migration, real billing/payment execution ও live deployment-এর জন্য আলাদা explicit approval/safety gate বাধ্যতামূলক।

## ৮. Acceptance criteria
কোনো project বা plan Live হবে না যতক্ষণ না:
- payer/source ও lawful revenue model documented;
- price, currency, fees, refund/renewal/expiry terms প্রকাশিত;
- provider server-side settlement verified;
- correct USD/BDT ledger entry exactly once;
- entitlement/worker permissions tested for Member vs Admin;
- delivery/acceptance, failure, retry, refund/chargeback paths tested;
- costs, liabilities, reserve and net contribution reconciled;
- security, privacy, load and operational tests passed;
- production deployment and monitoring evidence recorded.

**সত্যতা-নীতি:** ৪,০০০ project, ২,০০০ USD + ২,০০০ BDT split এবং Admin/Member plan rules হলো Owner-এর লক্ষ্য ও specification। এই document commit কোনো project চালু করে না, customer/payment আনে না, dollar/BDT তৈরি করে না এবং income guarantee দেয় না।


## ৯. ৪,০০০ প্রজেক্টের Free Option ও Paid Automatic Plan — Owner clarification

- প্রতিটি ৪,০০০ project slot-এ দুটি access option থাকবে: **Free Option** এবং **Paid Automatic Plan**। অর্থাৎ ২,০০০ USD project ও ২,০০০ BDT project—সব ৪,০০০টিরই Free entry/option এবং paid automation plan থাকবে।
- **Admin:** সব ৪,০০০ project-এর Free Option ব্যবহার করতে পারবেন; প্রয়োজন হলে নির্ধারিত Paid Automatic Plan কিনে paid entitlement নিতে পারবেন।
- **সাধারণ Member:** Free Option/paid earning automation-এ Admin-এর মতো free paid-plan entitlement পাবেন না; paid plan-এর মূল্য বাস্তবে provider-এর মাধ্যমে settle ও server-side verify হওয়ার পরেই সংশ্লিষ্ট project-এর paid automation entitlement চালু হবে।
- Paid plan-এর সুনির্দিষ্ট মূল্য, মেয়াদ, feature limits, কোন project-এ কী সুবিধা এবং refund/renewal terms পরে লিখিতভাবে নির্ধারণ ও প্রকাশ করতে হবে। কোনো paid plan কাজ, customer demand, নির্দিষ্ট আয় বা profit নিশ্চিত করে না।
- এই ব্যাখ্যা **দুটি access option (Free + Paid)** বোঝায়; এখানে Basic/Premium নামে দুটি আলাদা paid tier অনুমান করা হয়নি।


## ১০. বাস্তব গ্রাহক, গ্রাহকের কাজের অর্ডার ও Member সুরক্ষা — Owner-এর বাধ্যতামূলক শর্ত

### ১০.১ গ্রাহক-চালিত কাজের মডেল
- ৪,০০০ project-এর প্রতিটি প্রাসঙ্গিক service/marketplace-এ বাস্তব গ্রাহক কাজ, অর্ডার, service request বা paid subscription নিয়ে আসবেন। প্রজেক্ট/সিস্টেম নিজেরা ভুয়া customer, ভুয়া order, ভুয়া task, কৃত্রিম engagement বা কৃত্রিম revenue তৈরি করবে না।
- Customer acquisition, public service catalog, project-specific landing page, search/discovery, quote/order intake, customer support, checkout, delivery, acceptance, refund/dispute এবং repeat-customer workflow আলাদা করে তৈরি ও পরিমাপ করতে হবে।
- ১ কোটি (১০,০০০,০০০) বা তার বেশি বাস্তব গ্রাহক হলো দীর্ঘমেয়াদি scale target—বর্তমান customer count বা নিশ্চিত ফল নয়। পর্যায়ক্রমিক acquisition, conversion, retention, support capacity, infrastructure load, fraud rate ও unit economics-এর প্রমাণ ছাড়া এই সংখ্যা achieved/capacity বলে প্রচার করা যাবে না।
- USD ও BDT customer journey, displayed price, payment provider, ledger, refund, FX ও payout আলাদা থাকবে; project control plane shared হলেও currency boundaries অতিক্রম করে অর্থ মেশানো যাবে না।

### ১০.২ সাধারণ Member-এর আর্থিক সুরক্ষা
- সাধারণ Member-কে কাজ পাওয়ার জন্য deposit, recharge, paid membership, unlock fee বা ব্যক্তিগত অর্থ ঝুঁকিতে দিতে বাধ্য করা যাবে না। Paid plan ঐচ্ছিক; paid plan কেনা কাজ/আয় পাওয়ার শর্ত বা নিশ্চয়তা নয়।
- Customer-funded কাজের ক্ষেত্রে কাজ assign/worker শুরু করার আগে customer payment বাস্তবে provider-এ settled এবং সংশ্লিষ্ট order-এর জন্য যথেষ্ট অর্থ funded/segregated আছে তা server-side verify করতে হবে। কেবল screenshot, client-side success বা pending payment গ্রহণযোগ্য নয়।
- কাজের scope, মূল্য, currency, deadline, acceptance criteria, revision, cancellation, dispute, refund এবং Member payable কাজ শুরুর আগেই স্পষ্ট করতে হবে।
- Member-এর কাজের পারিশ্রমিক, customer refund liability ও platform operating funds আলাদা ledger/accounting bucket-এ রাখতে হবে। Member payable-কে platform revenue বা operating cash হিসেবে ব্যবহার করা যাবে না।
- Milestone/acceptance evidence, idempotent payment posting, fraud checks, duplicate-order protection, chargeback/dispute workflow, audit trail এবং incident freeze/kill switch থাকতে হবে।
- গ্রাহক payment settle না করলে, কাজ বাতিল/বিতর্কিত হলে বা fraud signal দেখা দিলে নতুন কাজ শুরু বন্ধ থাকবে; policy ও আইন অনুযায়ী refund/dispute নিষ্পত্তি হবে। Member-কে নিজের টাকা দিয়ে customer shortfall পূরণ করতে বলা যাবে না।
- কোনো সিস্টেমই শূন্য ঝুঁকি বা প্রত্যেক পরিস্থিতিতে ক্ষতি-শূন্য ফলের নিশ্চয়তা দিতে পারে না। তাই Member-এর অগ্রিম অর্থ ঝুঁকি নিষিদ্ধ করা, funded-order gate, reserve, clear terms, দ্রুত dispute handling ও নিয়মিত audit বাধ্যতামূলক acceptance criteria হবে।

### ১০.৩ Launch gates
- Public launch-এর আগে বাস্তব customer onboarding ও order-to-settlement-to-delivery-to-member-payment end-to-end sandbox tests, refund/chargeback tests, fraud/abuse review, security/privacy review, capacity/load tests, customer support staffing ও legal/provider compliance সম্পন্ন করতে হবে।
- ১০,০০০,০০০+ customer scale-এর আগে staged load test, regional capacity, queue isolation, per-project quotas, rate limiting, autoscaling, disaster recovery, observability, support operations ও cost-per-customer validation পাস করতে হবে।
- এই শর্তগুলো architecture/acceptance requirements; এগুলো বাস্তব গ্রাহক, settled order, funded reserve, Member protection guarantee বা production deployment ইতিমধ্যে আছে—এমন দাবি নয়।
