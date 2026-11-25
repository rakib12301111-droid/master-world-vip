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
