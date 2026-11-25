# MASTER WORLD VIP — Global Customer Marketplace & Lifetime Work System
**Version:** 1.0  
**Date:** 2026-11-26  
**Status:** OWNER-REQUESTED PRODUCT REQUIREMENTS / NOT LIVE  
**Repository:** `rakib12301111-droid/master-world-vip`

## 1. Vision
Build MASTER WORLD VIP as a global marketplace where customers in Bangladesh and other countries submit legitimate paid work, pay through verified payment providers, receive accepted deliverables, and create ongoing opportunities for ordinary members.

The Owner's ambition is to reach 10,000,000+ customers, maintain a catalogue of 2,000+ real project/service categories and verified brand/client programmes, and support repeat/unlimited order submissions over the long term. These are growth and product goals—not current metrics, guaranteed customer demand, guaranteed lifetime work, or guaranteed income.

## 2. Customer Order Portal
Required customer journey:
1. Customer registration, verification and account security.
2. Browse searchable, country/language-aware service catalogue.
3. Submit a job brief, scope, files, budget, currency, deadline and acceptance criteria.
4. Receive a transparent quote including taxes/fees and expected delivery window.
5. Accept terms and pay through an approved payment provider.
6. Track order status, assigned work, questions, delivery and revisions.
7. Review/accept deliverable, open a dispute if needed, and receive invoice/receipt and final files.

Only server-to-server verified payment settlement can mark an order paid. Redirect pages, screenshots and user-entered transaction references are not proof. Files must be private, encrypted, tenant-isolated, validated, retention-controlled and audited.

## 3. Real projects, categories and brands
- Build 2,000+ categories/modules progressively; every active category must have a clear lawful deliverable, real customer demand or verified client/provider contract, price and cost model, quality/acceptance criteria, skill requirements, permission and operational owner.
- A brand/client programme may be listed as active only with authorization/contract or verifiable public programme terms. Do not imply brand endorsement or invent active projects.
- Customers may submit repeat orders without an arbitrary lifetime count promise, but intake and execution remain subject to fair-use rules, queue capacity, provider quotas, security, budgets, legal scope and disclosed service levels.
- Do not display fabricated customers, orders, brands, project activity, income or availability.

## 4. Smart Member Assignment
Route only eligible, funded orders to ordinary members. Matching inputs: skills, language, location eligibility, verification, availability, workload fairness, quality, deadline, conflict checks and member-selected preferences.

Before acceptance, show the full scope, exact member payable, currency, effort estimate, deadline, acceptance/revision criteria, payment status, commission/fees, dispute route and payout timing. Do not lower an accepted payable retroactively. Scope changes require a new quote and member consent. No real funded customer order means no work assignment and no earning claim.

## 5. 24/7 Server-side Auto Work
Use durable server-side queues and workers, not member phones or browsers as always-on compute. Required controls: idempotent job claims, leases/heartbeats/recovery, bounded retries/backoff, timeouts, cancellation, fair scheduling, per-customer/per-module concurrency, cost caps, provider quota tracking, monitoring, sanitized logs, backup/restore and global emergency stop.

Admin/Owner work and member work must use separate infrastructure, queues, credentials, storage namespaces and budgets. Member jobs cannot consume Owner/Admin reserved capacity. Quota exhaustion or provider outage must pause/queue safely; no silent paid fallback. 24/7 operation is an engineering target, not a guarantee of uninterrupted lifetime uptime.

2,000+ modules and 2,000 simultaneous jobs are separate scaling dimensions. Concurrent execution must grow only after real order demand, load/failure/isolation tests, infrastructure capacity, provider permission and an explicit spend cap. Do not turn on 2,000 concurrency by changing a single setting.

## 6. Security and anti-fraud
Enforce server-side RBAC, MFA for privileged roles, least privilege, tenant-isolated RLS, secure sessions, input/output validation, rate limiting, abuse detection, encryption, secret rotation, dependency review, backup/restore and incident response.

Order, payment, job, acceptance, refund, settlement and payout are server-authoritative state machines with signed provider webhooks, unique idempotency keys, audit evidence and reconciliation. Include customer/member verification as legally required, dispute/appeal workflows, chargeback review, privacy controls and retention/deletion. No credential theft, fake traffic/engagement, CAPTCHA bypass, unauthorized scraping or provider-terms violations.

## 7. No-loss member protection
- No joining fee, deposit, mandatory purchase, paid task unlock or requirement to buy a plan.
- Calculate unit economics before accepting a job. If member payable, direct costs, provider/payment fees, tax, refund/chargeback exposure and required reserves cannot be funded with a sustainable margin, reject, re-quote or pause the job.
- Protect the full disclosed member payable after accepted work. Never fund platform loss, admin commission, refunds or chargebacks by taking earned wages or member wallet balances.
- Earnings become payable only after deliverable acceptance and actual customer payment settlement. A wallet entry is not a completed cash withdrawal.
- The example “৳100 cost → ৳1,000+ income” is an aspiration, not a forecast or guarantee. Never advertise or promise this return without proven per-task economics and actual settled customer revenue.

## 8. Progressive Admin commission: 20% / 35%
Owner requests 20% for lower-value/smaller work and 35% for higher-value work. The BDT threshold separating the two tiers has not yet been specified; do not invent or hard-code it. Make it configurable only after explicit Owner approval, public disclosure and audited prospective activation.

Both rates apply solely to Distributable Net Platform Revenue after member payable, taxes, payment/provider fees, direct/compute/operating costs, refunds/chargebacks and required reserves/restricted liabilities are fully accounted for. Never calculate commission on gross customer payments, member wages, unsettled/disputed funds or refund reserves. If net base is zero/negative or reconciliation/reserve/member-pay gates fail, commission is zero and fails closed.

The prior fixed 20% policy is superseded as the requested future tier design, but the existing production behavior must not change until the approved threshold, implementation, legal review and end-to-end tests are complete. Rate changes are prospective only and must be disclosed before order acceptance and audited.

## 9. Admin Free Plan and Paid Plan
Admin dashboard must offer:
- **Free Admin Plan** (default), with clearly displayed provider-defined quotas and limits.
- **Paid Admin Plan** (optional), enabled only after Admin's explicit selection, displayed price/terms, secure payment, approved budget cap and audit record.

No silent paid upgrade or paid fallback. Paid plan costs cannot be taken from member wages, member wallet, customer restricted funds or refund reserve. These are Admin-only options; members must not be required to purchase a plan to access legitimate work.

## 10. Scale-up roadmap
1. Secure customer portal and verified payment flow in staging.
2. One real client/provider contract and one paid pilot order.
3. One human-reviewed member task category with disclosed pay, acceptance and successful payout.
4. One isolated server worker and approved provider module.
5. Add categories only with real demand, contract/permission, unit economics and quality controls.
6. Grow catalogue in stages (20 → 100 → 500 → 2,000+); scale concurrency separately using measured load tests.
7. Complete legal/privacy/security, refund/dispute, disaster-recovery and controlled production-canary gates.

## 11. Current blockers and release rule
This document is a product requirements baseline only. It does not deploy or activate the portal, real customer acquisition, 10-million customer base, 2,000 live projects, unlimited work, workers, providers, payments, commission tiers, Admin plan checkout or member payouts.

Existing database safety gate remains mandatory: secure correction of the GitHub `SUPABASE_DB_URL` secret, encrypted backup, decrypt, disposable restore with nonzero table count, migration dry-run and explicit authorization before production migration. No secret or password belongs in chat or documentation.

Mark a feature LIVE only after code, required deployment, production configuration, security review, provider/client permission and real end-to-end acceptance all pass. Until then use PARTIAL / BLOCKED / NOT LIVE.


## ১২. High-value USD projects and BDT member payouts (Owner priority, 2026-11-26)

### High-value catalogue priority
- Owner-এর নতুন অগ্রাধিকার: 2,000+ catalogue-এর মধ্যে বাস্তব চাহিদা ও লাভজনকতা যাচাই করে একটি গুরুত্বপূর্ণ **High-Value USD Projects** শ্রেণি গড়ে তুলতে হবে। উদাহরণ customer order price: **US$30, US$50, US$100, US$150 এবং তার বেশি**। এগুলো লক্ষ্য price bands/উদাহরণ—বর্তমান live order, নিশ্চিত কাজ, member earning বা Admin profit নয়।
- প্রতিটি USD-priced project-এর জন্য বাস্তব customer/client, লিখিত scope ও deliverable, market-supported quote, lawful permission/contract, verified payment, acceptance criteria, effort estimate, provider capacity, refund/dispute terms এবং positive unit economics আবশ্যক। কোনো কাজের প্রকৃত বাজারদর/পরিশ্রমের সঙ্গে price না মিললে শুধু বড় dollar label দেওয়া যাবে না।
- Catalogue-এ আলাদা priority/ranking থাকবে: verified funded high-value orders আগে eligible matching পেতে পারে; তবে skill/quality/eligibility, fairness, deadline, member workload এবং আগে-প্রকাশিত pay terms অগ্রাহ্য করা যাবে না। উচ্চ মূল্য মানেই অযোগ্য সদস্যকে কাজ দেওয়া বা কাজের মান কমানো নয়।

### USD-to-BDT quote and payout
- Customer USD-তে pay করতে পারবেন যেখানে অনুমোদিত payment provider/country support আছে। Bangladesh member-এর জন্য task accept করার আগেই **নির্দিষ্ট BDT payable** দেখাতে হবে; USD equivalent, conversion-rate source, rate timestamp, provider/FX fee, tax/withholding, payout fee ও rate-lock expiry আলাদা দেখাতে হবে।
- FX calculation হবে server-side trusted provider/bank rate snapshot দিয়ে, order quote তৈরি/lock হওয়ার সময়। Member task accept করার পর প্রকাশিত BDT payable FX fluctuation-এর কারণে কমানো যাবে না। Platform currency risk নিতে না পারলে assignment-এর আগে quote পুনর্নির্ধারণ করে member-এর নতুন consent নিতে হবে; ইতিমধ্যে accepted payable retroactively কমানো যাবে না।
- Customer-এর USD gross payment থেকে আগে tax, gateway/FX fees, refunds/chargebacks, verified delivery obligation, full member payable, direct provider/compute/operating cost এবং required reserve হিসাব হবে। কেবল এরপর অবশিষ্ট **Distributable Net Platform Revenue**-এ অনুমোদিত Admin 20%/35% tier প্রযোজ্য হবে। Admin commission কখনো US$30/50/100/150 gross customer price-এর সরাসরি 20%/35% নয়।
- Customer, member ও Admin-এর জন্য আলাদা transparent breakdown/ledger ও settlement references রাখতে হবে। Customer যেন scope অনুযায়ী ন্যায্য deliverable পান; member যেন accepted BDT wage পান; Admin যেন কেবল বাস্তবে অর্জিত, settled এবং distributable net platform revenue থেকে আয় পান।

### High-value safety and launch gates
- High-value orders-এর জন্য enhanced client verification, fraud/chargeback screening, milestone/escrow or provider-supported payment protection where available, human review, evidence-based acceptance, dispute/appeal and payout reconciliation আবশ্যক।
- Unfunded, suspicious, illegal, unrealistic-margin বা unverifiable $30–$150+ order queue-তে paid work হিসেবে যাবে না; pause/reject/requote হবে। Fake client, fake brand programme, fabricated dollar balance, guaranteed daily income বা artificial order volume নিষিদ্ধ।
- $30/$50/$100/$150+ bands catalogue priority ও pricing target মাত্র। প্রকৃত আয় order volume, customer acquisition, delivery cost, quality, market demand, currency/fees এবং verified settlement-এর ওপর নির্ভরশীল; কোনো নির্দিষ্ট আয়/ROI guarantee নয়।
- **Status:** এই high-value USD project policy নথিভুক্ত requirement; USD checkout, FX lock, BDT payout, real high-value clients/orders, priority scheduler বা settlement এখনও এই documentation update দ্বারা live/verified হয়নি। Database backup/restore safety blocker ও production migration approval gate অপরিবর্তিত।

## ১৩. VIP USD Bonus Draw and Admin USD revenue rules (Owner priority, 2026-11-26)

- VIP/Member Rewards area-তে eligible ordinary members-এর জন্য অনিয়মিত, auditable random **USD promotional bonus draw**-এর requirement থাকবে। কে কখন USD পাবেন তা আগে থেকে বলা বা guarantee করা যাবে না; কোনো সদস্যের নির্দিষ্ট USD income, frequency বা winner status নিশ্চিত নয়।
- এটি pay-to-enter lottery নয়: member deposit, joining fee, paid-plan purchase বা task unlock-এর বিনিময়ে entry/chance বিক্রি করা যাবে না; plan purchase chance বাড়াবে না। Free/basic work access অক্ষুণ্ণ থাকবে।
- Draw-এর আগে separately funded liquid USD prize pool, clear published rules/eligibility, lawful jurisdictional approval, tax disclosure, secure auditable random selection, fraud screening, immutable audit log, appeal/correction route এবং verified USD payout method আবশ্যক। Funding/approval/odds disclosure requirements পূরণ না হলে draw paused/disabled থাকবে। Member wages, deposits, customer restricted funds বা refund reserve prize funding নয়।
- Admin-এর USD revenue ledger-এ Free ও Paid Plan activity-র সঙ্গে যুক্ত প্রকৃত settled platform revenue আলাদা source reference-সহ reconcile হবে। Free Plan নিজে free হওয়ায় শুধু plan active থাকলে USD আয় হয় না; Free Plan-এ করা বাস্তব customer-paid service-এর eligible net revenue থেকেই approved Admin entitlement হিসাব হবে।
- Paid Plan-এর customer/member payment কেবল বাস্তবে settled হলে এবং tax, provider/FX fees, refunds/chargebacks, delivery/direct costs, member payable ও protected reserves বাদ দেওয়ার পর eligible net revenue তৈরি করতে পারে। Member-এর paid plan বাধ্যতামূলক নয়। Admin নিজে Paid Admin Plan কিনলে সেটি operating expense—Admin income নয়।
- User-এর “Admin 100% নিশ্চিত USD” নির্দেশকে accounting rule হিসেবে সীমাবদ্ধ করা হলো: **প্রকৃত eligible settled net revenue-এর অনুমোদিত Admin entitlement 100% ledger-এ সঠিকভাবে record/reconcile করতে হবে**। Plan existence, Free Plan activation বা Admin-এর নিজের purchase থেকে guaranteed USD/profit বা fixed dollar credit তৈরি করা যাবে না। Eligible settled revenue শূন্য হলে Admin USD accrual শূন্য।
- এটি high-value USD project pricing (Section 12), BDT member payable, progressive commission ও no-loss member protection-এর অতিরিক্ত পৃথক reward/revenue stream; একটির অর্থ অন্যটির সঙ্গে মিশিয়ে double-count করা যাবে না।
- **Status: DOCUMENTED ONLY / NOT LIVE.** VIP UI, promotional draw, funded prize pool, random selection engine, USD ledger, plan checkout, payment settlement, legal approvals and payout are not implemented/verified by this policy update. Existing DB backup/restore and migration authorization blockers remain unchanged.
