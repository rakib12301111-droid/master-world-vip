# MASTER WORLD VIP — Free File Storage & Parallel Auto Work Plan

Updated: 2026-11-25

## Approved operating choice
- Start with free-tier services only.
- Consider paid server/API only later, after explicit Owner approval and a separate spend limit.
- Run five modules in parallel, initially one active job per module (maximum five simultaneous jobs). Further jobs remain queued per module.
- Never auto-fallback from free quota to paid usage.

## Five modules
1. AI Data Processing
2. AI Translation & Document Processing
3. PDF Automation
4. Image Processing
5. Website Monitoring & Automated Reporting

## Backend and queue
- Use a server-side durable queue; browser/PWA is a control panel, not the worker.
- Use five independent worker lanes, one lane per module. Each lane records queued/running/succeeded/failed/cancelled status, attempt count, timestamps and sanitized error details.
- Each lane can be paused independently. Global emergency pause stops new claims across all lanes.
- Enforce idempotency, bounded retries, timeouts, rate limits, per-job cost caps and per-module daily quotas.
- Free-tier exhaustion, sleeping instances, throttling or provider outage must pause/queue work safely. Do not claim continuous 24/7 uptime on a free plan.

## Private file storage
- Store customer uploads and generated deliverables in private object storage, not in GitHub or a public web directory.
- Keep only metadata and object references in the database: client/owner, module, MIME type, byte size, checksum, upload time, retention expiry and access audit.
- Validate file type, size and quota before upload. Enforce per-client and global quota limits in the server, not only in the UI.
- Use least-privilege authorization and short-lived signed download links. Do not expose service-role credentials or permanent public object URLs.
- Apply retention/deletion rules and test backup/restore. Avoid storing passwords, OTPs, identity documents or unnecessary sensitive data.
- On quota exhaustion: stop new uploads/jobs, notify Admin, and wait for cleanup or an Owner-approved plan change. Never upgrade to paid storage automatically.

## Free means quota-limited
Free depends on the selected provider's current plan, region, account eligibility, storage size, bandwidth/egress, retention and inactivity rules. No provider has been selected/connected in this repository, so a specific free quota cannot yet be guaranteed. Unlimited or permanent free storage is not promised.

## Paid-use lock
Any paid server, paid API or paid storage requires:
1. Owner identity/role verified server-side;
2. explicit approval for the named provider/service;
3. a BDT budget cap and billing period;
4. an audit record;
5. automatic pause at the cap.
No silent paid fallback is allowed.

## Rollout checklist
- [ ] Select an eligible free-tier backend, queue and private object-storage provider.
- [ ] Verify current Bangladesh availability, free quotas, sleep/timeout limits, data region, retention and egress charges.
- [ ] Deploy staging only and test all five lanes in parallel.
- [ ] Verify per-module pause/resume, global emergency stop, error logs and idempotency.
- [ ] Verify private storage authorization, quotas, deletion and restore.
- [ ] Verify free-quota exhaustion pauses work and never triggers paid fallback.
- [ ] Obtain Owner approval before any production deployment or paid use.

## Status
Plan/specification only. No server, queue worker, storage bucket, provider connector or customer file storage has been deployed or verified by this document.

## Owner-এর Storage সিদ্ধান্ত: R2 + আলাদা ব্যাকআপ + নিজের কপি (2026-11-25)

### প্রস্তাবিত বিন্যাস
1. **Primary storage candidate: Cloudflare R2 Standard** — MASTER WORLD VIP-এর private customer files ও generated deliverables রাখার প্রথম পছন্দ। 2026-11-25-এ দেখা Cloudflare-এর প্রকাশিত free allowance: প্রতি মাসে 10 GB-month storage, 1 million Class A operations, 10 million Class B operations; R2 egress fee নেই। এটি সীমিত মাসিক free allowance, আজীবন বিনামূল্যের প্রতিশ্রুতি নয়। [Official R2 pricing](https://developers.cloudflare.com/r2/pricing/)।
2. **আলাদা backup:** সম্ভব হলে R2-এর বাইরে অন্য provider-এ encrypted backup; তবে দ্বিতীয় provider-এর free tier, retention ও restore শর্ত আলাদাভাবে যাচাই করতে হবে। একই provider/account-এ শুধু আরেকটি bucket করলে provider/account-level failure-এর বিরুদ্ধে পূর্ণ স্বাধীন backup হয় না।
3. **Owner-এর হাতে কপি:** গুরুত্বপূর্ণ ফাইল নিয়মিত encrypted archive হিসেবে Owner-এর নিয়ন্ত্রিত ফোন/কম্পিউটার বা নিজস্ব external drive-এ export/download করা যাবে। কপি সম্পূর্ণ হয়েছে কি না checksum দিয়ে যাচাই করতে হবে।
4. **Restore drill:** নির্দিষ্ট বিরতিতে backup থেকে কিছু ফাইল restore করে পরীক্ষা করতে হবে; শুধু backup তৈরি হলেই নিরাপদ ধরে নেওয়া যাবে না।

### খরচ-নিয়ন্ত্রণ
- R2-তে Standard storage-ই ব্যবহার করতে হবে যদি free allowance লক্ষ্য হয়; Infrequent Access-এর free allowance নেই।
- 80% quota-তে সতর্কবার্তা; 100% বা billing/limit error হলে নতুন upload/job pause।
- Paid storage, paid backup বা অতিরিক্ত operation-এ স্বয়ংক্রিয় upgrade/fallback নিষিদ্ধ।
- কোনো paid charge হতে পারে এমন সেটিং চালুর আগে Owner-এর আলাদা লিখিত অনুমোদন ও BDT spend cap আবশ্যক।
- Cloudflare-এর quota, pricing, eligibility ও terms পরিবর্তন হতে পারে; production সংযোগের দিন official page ও account dashboard আবার যাচাই করতে হবে।

### বাস্তব সীমা
- Cloudflare R2 এখনো এই repository-তে connected/deployed নয়; bucket, credentials, access policy বা backup job তৈরি হয়নি।
- Free quota-র বাইরে গেলে storage-কে বিনামূল্যে বাড়ানো যাবে—এমন নিশ্চয়তা নেই।
- আজীবন/চিরস্থায়ী free storage বা কোনো provider-এর অপরিবর্তিত free plan নিশ্চিত করা যায় না।
