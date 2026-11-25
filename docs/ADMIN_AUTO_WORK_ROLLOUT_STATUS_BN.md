# MASTER WORLD VIP — Admin Auto Work rollout

Updated: 2026-11-25

## Requested five modules
1. AI Data Processing
2. AI Translation & Document Processing
3. PDF Automation
4. Image Processing
5. Website Monitoring & Automated Reporting

## What this change adds
- Additive database migration `20261125100000_admin_auto_work_control_plane.sql`.
- Admin-only module/provider/job/audit tables.
- Admin RPCs to view status, enable/pause modules, and queue authorized jobs.
- Worker-only RPCs to claim and finish jobs. Only Supabase `service_role` can call the worker RPCs.
- Provider activation requires an approved contract reference and approver record.
- A module cannot be enabled until an active provider is attached and a positive daily budget cap is set.
- Idempotency keys prevent duplicate queue submissions.
- Job cost caps and module daily budget checks are included.

## Critical limitation / current status
This is the secure control-plane/database foundation, not a complete running automation engine. It does not yet contain the five provider-specific connectors, an always-on worker deployment, actual customer contracts, or payout integration. Therefore all five modules are seeded **disabled**, and no income is generated or promised by this commit. The phone/PWA is not the 24/7 worker.

To make it operational:
1. Complete backup and restore test; review and apply the additive migration in staging first.
2. Select a real customer/provider for each module and verify terms, Bangladesh eligibility, payout route, fees and contract.
3. Build and deploy each connector as a server-side worker using server-only secrets.
4. Test retries, idempotency, budget exhaustion, provider outage, permissions and settlement reconciliation.
5. Activate only after Owner approval. Free quota exhaustion must pause work; paid usage must remain off unless separately approved.

## Accounting rules
- A job attempt, AI response or phone online state is not revenue.
- Revenue is recorded only after client acceptance and actual settlement.
- Keep Company Revenue, Admin Work Payment, Admin Referral Bonus and Owner Commission separate.
- Ordinary-member referral rewards remain off. Never fund referral rewards from member work pay.

## Safety
No fake ad clicks/views, auto-surf, traffic exchange, fake engagement, fake signups, CAPTCHA bypass, unauthorized scraping, account takeover or provider-terms violations.


## Free-quota policy and income estimate (2026-11-25)

### No universal "one free limit"
A free allowance belongs to each provider and often varies by model, endpoint, account, region and date. It must be read from that provider's official quota/billing page or API response; do not hard-code one shared request count for all five modules.

Examples checked from official provider documentation:
- Cloudflare Workers AI: 10,000 Neurons per day on the Free allocation; excess requires a Paid plan. This is compute usage, not 10,000 guaranteed jobs. [Official pricing](https://developers.cloudflare.com/workers-ai/platform/pricing/).
- Gemini API: free access is limited to selected models and has model-specific rate limits; there is no single universal daily request quota. [Official pricing](https://ai.google.dev/gemini-api/docs/pricing).

### Safe default for MASTER WORLD VIP
- Start in **FREE-ONLY / zero-paid-spend** mode.
- Track usage separately for each provider, model and module.
- Warn at 80%; pause at 100% of the confirmed free allowance, or earlier on provider quota/rate-limit errors.
- Never fall back to a paid endpoint automatically.
- Paid usage stays disabled until the Owner explicitly approves a separate budget.
- Local PDF formatting, image resize/compression and basic website checks may not need an AI API, but hosting, storage, bandwidth and monitoring providers may still impose limits or charges.

### Income: no guaranteed amount from free quota
Free quota itself generates **৳0**. Revenue is counted only after a real customer accepts the deliverable and payment settles. Example only: if accepted customer work settles ৳500 and direct fees/costs are ৳30, net before other company overhead is ৳470. This is an illustration, not an earnings forecast. With no paying customer, settled income is ৳0 even if all free quota is used.

The dashboard must report separately: free quota consumed, jobs processed, customer-accepted jobs, invoiced amount, settled receipts, direct costs, and net settled revenue. Never convert API calls, AI outputs or queued jobs into income.


## Owner-এর deployment choice: Free first + five-module parallel (2026-11-25)

- **Server:** শুরুতে free-tier backend/queue only; future paid server requires explicit Owner approval and a separate spend cap.
- **Paid APIs:** disabled by default. No silent paid fallback when a free quota is exhausted. Provider billing mode and Owner approval must be enforced server-side before paid requests.
- **Parallelism:** five modules may run simultaneously, initially one active job per module (up to five jobs total). A second job for the same module waits in that module's queue. This matches the existing partial unique index that allows only one running job per work_type.
- **Independent controls:** each module has its own enable/pause state, queue visibility, last-run time and error/audit trail; a global emergency pause is also required.
- **Free-tier limits:** free plans are quota-limited and may sleep, throttle or suspend workloads. This is not guaranteed 24/7 hosting. Jobs remain queued or pause safely when compute/request/time quotas are exhausted.
- **File storage:** plan a private object-storage bucket for customer files, with per-file/per-client quotas, MIME/size checks, checksum, retention expiry and access audit. GitHub is for code/docs only, not customer file storage. No storage provider is connected or verified yet; free quota and retention are provider-specific, so unlimited/permanent free storage is not promised.
- **Paid protection:** a paid server/API must require a server-side Owner approval record, explicit BDT spend cap, and audit event. Quota exhaustion must pause rather than switch to paid.
- **Not live:** these are implementation requirements. No free server, queue worker, file bucket or provider connector has been deployed or verified by this documentation update.


## Owner-এর Storage ও zero-cost server নির্দেশনা (2026-11-25)

- **Storage candidate:** Cloudflare R2 Standard primary; আলাদা provider-এ encrypted backup; Owner-এর নিয়ন্ত্রিত device-এ downloadable copy। বর্তমান R2 free allowance ও সীমা দেখুন [official pricing](https://developers.cloudflare.com/r2/pricing/)। 10 GB-month, 1M Class A এবং 10M Class B হলো বর্তমান প্রকাশিত monthly allowance—lifetime guarantee নয়।
- **Backup independence:** একই R2 account-এর দ্বিতীয় bucket একা যথেষ্ট independent backup নয়। অন্য provider/অফলাইন Owner copy এবং নিয়মিত restore test প্রয়োজন।
- **Zero-cost rule:** প্রথমে free-tier only. Free quota শেষ, service sleep/suspend বা provider limit এলে কাজ pause/queue হবে; কোনো paid plan বা API-তে automatic fallback হবে না।
- **Server reality:** “শক্তিশালী, সবসময় চালু, unlimited, আজীবন free server” কোনো provider নিশ্চিত করে না। Free compute-এ request/CPU/time/storage/network সীমা, sleep/restart এবং plan পরিবর্তন হতে পারে। উদাহরণ হিসেবে Cloudflare Workers Free-এর published limits-এ 100,000 requests/day ও প্রতি invocation-এ 10 ms CPU time আছে; এটি unlimited long-running worker/server নয় ([official limits](https://developers.cloudflare.com/workers/platform/limits/))।
- **Recommended zero-cost-first design:** static website/control panel + lightweight serverless endpoints + durable queue where eligible + short, bounded jobs. ভারী/দীর্ঘ AI, video বা document processing free runtime-এ সবসময় চালানোর প্রতিশ্রুতি নয়; সীমা এলে queue/pause।
- **Owner-only spending lock:** paid server, API, storage, backup, domain add-on বা bandwidth—কোনোটিই Owner-এর named-service approval, BDT budget cap ও audit record ছাড়া চালু করা যাবে না। Budget cap না থাকলে paid feature disabled থাকবে।
- **Not deployed:** এই সিদ্ধান্ত/ডকুমেন্টেশন মাত্র। কোনো R2 bucket, backup destination, free compute server, worker বা provider connector এই commit-এ deploy/connect করা হয়নি।
