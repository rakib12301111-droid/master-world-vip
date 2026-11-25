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
