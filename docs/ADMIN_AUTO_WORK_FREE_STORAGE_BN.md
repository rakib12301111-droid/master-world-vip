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