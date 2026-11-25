# MASTER WORLD VIP — Member Auto Work & Owner Commission Policy

Updated: 2026-11-25

## Owner decision
Member Auto Work is intended to be open to ordinary registered members as an optional, free-to-join earning opportunity. Members may opt in, view eligible automated task offers, accept a task, and submit/review its result. Admin retains provider, job-source, safety, queue and budget control. The Owner may earn a platform commission only from genuine, customer/partner-funded, settled revenue attributable to accepted member work.

This policy is approved as a product design; it is **not live** until backend, worker, UI, provider/customer source, settlement ledger and tests are deployed.

## Member access and free participation
- Registration, viewing offers, joining/opt-in and accepting a task must not require a deposit, subscription, purchase, referral payment or upfront fee.
- No member is charged for API usage, storage, task failure or platform operation.
- A member may decline, pause participation or leave without penalty.
- Member task pay, rate, estimated effort, eligibility, deadline, acceptance criteria and payment timing are shown before acceptance.
- No payment for merely being online, installing an app, clicking ads, watching artificial ads, fake traffic, fake engagement, or creating accounts.
- Pay only for verified deliverables accepted by the real customer/partner and backed by settled funds; no guaranteed income or guaranteed task volume.
- If a task is unpaid, it must be explicitly labelled voluntary and never disguised as an earning task.

## Five member automation categories
Member access can be offered only to task types enabled by Admin and covered by a documented client/provider contract and permitted API:
1. AI data processing / structured data cleanup.
2. Translation, document processing, proofreading and caption/transcript review.
3. PDF formatting, conversion, extraction and quality checking.
4. Image resize, compression, format conversion and permitted production.
5. Website monitoring/report verification and report preparation.

Members must not be given account credentials, client secrets, unrestricted data, Admin controls, or the Owner's private jobs/files. Access is scoped to the task's minimum required data.

## Owner platform commission and ledger
- Commission is calculated from the actual settled payment for a valid accepted member deliverable, under the displayed terms.
- Suggested formula for each settled task: settled customer receipt minus refunds/chargebacks, payment/provider fees, directly attributable API/compute/storage costs, and required tax/reserve = net distributable task proceeds.
- Member task payment and Owner platform commission are separate ledger entries. Commission rate and member payment amount must be shown before a task is accepted; rates remain configurable and are not set by this document.
- The Owner's commission is payable only when customer/partner funds have settled and the task passes acceptance; never take commission from unpaid member wages or another member's payment.
- No duplicate revenue: same receipt is recorded once, then allocated to the appropriate ledgers.
- If payment is refunded, disputed, reversed, fraudulent or not settled, the task payout/commission remains pending or is reversed according to published terms and law. Never claw back earned member pay unlawfully.
- Owner personal commission is tracked separately from company revenue and Admin work pay.

## Protect the Owner's own work and the platform
Member jobs must not harm or block Owner/Admin work:
- Separate queues and per-member quotas; never share private jobs, files, credentials or datasets.
- Owner/Admin queue priority and reserved capacity. Member jobs use only capacity explicitly allocated for members; when capacity is unavailable, members' jobs wait or are not offered.
- Initially, strict limits: one active job per member, global member concurrency cap, per-module member concurrency cap, daily quota, task-size and timeout limits. Exact caps must be set after load tests.
- One active task per module for Admin remains independent; member tasks cannot claim Admin queue slots. Global emergency pause and per-module/member pause.
- Member work is FREE-ONLY: paid API/server fallback is off. Quota exhaustion pauses/queues member tasks; never charges members or silently bills Owner.
- Admin can close offers, pause member auto-work, revoke access, quarantine output and investigate abuse; audit all administrative actions.
- Test CPU, memory, queue, database, storage, API quotas and rate limits under simulated member load before public launch. If resource pressure affects Owner/Admin tasks, automatically throttle or pause member tasks first.
- Customer SLA, contract scope, provider terms, privacy and geographic eligibility must be verified before offering the task.
- Do not use members' devices, mobile data, electricity or bandwidth as a distributed compute network unless a separate transparent opt-in, risk review and compensation model is designed; this feature is not part of the initial rollout.

## Anti-abuse and privacy
- Verified accounts, rate limits, duplicate/fraud detection, task-specific permissions and output checks.
- Keep only required data; private storage; short-lived access links; retention/deletion rules.
- Prohibit fake ad activity, click/view farming, auto-surf, fake signups/engagement, CAPTCHA bypass, unauthorized scraping, malware, account takeover, and tasks that violate provider terms.
- Provide report/dispute and appeal routes. Record accepted/rejected reason and audit history.

## Launch sequence
1. Build member-facing Auto Work offer list, opt-in, task acceptance, task progress and submission/review UI.
2. Add member-specific database roles/policies, queue, limits, ledger and separate commission allocation.
3. Use test/sandbox jobs; prove members cannot read or affect Owner/Admin jobs.
4. Load-test queue isolation, resource ceilings, emergency pause and quota exhaustion.
5. Connect only legitimate customer/provider sources with documented permissions and settlement.
6. Launch limited pilot with a small member cap; review incidents, cost and settled revenue before increasing limits.

## Current status
The existing Work & Earn page is an ordinary member job board. The Admin Auto Work status panel and control-plane migration are groundwork for Admin automation, not member automation. Member Auto Work, commission ledger, provider integrations, actual paid work sources and withdrawals are not deployed or verified. This document defines the intended policy only.
