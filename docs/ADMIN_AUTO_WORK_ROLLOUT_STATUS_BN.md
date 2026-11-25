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

## Implementation update — Admin status panel and worker-claim hardening (2026-11-25)

### Added to the existing app
- www/index.html now contains an Admin Auto Work status panel inside the existing Admin & Security Center.
- Only server-verified owner, super_admin or admin roles can see the panel.
- The panel reads admin_auto_work_overview() and displays the five module states, provider state, daily budget/use, last run and last-seven-day job counts.
- It explicitly displays NOT READY / control-plane-only when execution_ready is false. It does not pretend to start or execute jobs.
- Refresh is read-only. No module can be enabled from the browser until a real reviewed connector and worker are deployed.

### Database migration inventory
- 20261125100000_admin_auto_work_control_plane.sql creates the control-plane schema and RPCs.
- 20261125130000_admin_auto_work_claim_concurrency_fix.sql prevents multiple workers from claiming two running jobs in the same module. The intended limit remains one active job in each of five modules (maximum five total).
- The guarded production migration workflow now includes both Auto Work migrations in its expected-file preflight list.
- The Supabase README migration order now lists the Work & Earn, referral and Auto Work migrations.

### Still not deployed / not complete
- No Auto Work migration has been applied to Supabase by this code update.
- No server-side Auto Work worker or provider-specific job connector has been deployed.
- No Cloudflare R2 bucket, independent backup destination, signed upload/download flow or storage connector has been created.
- No customer contracts, provider approvals, API credentials or payout integrations have been verified.
- All five modules remain disabled by default; no income is generated or promised.

### Required next gates
1. Confirm a recoverable backup and successful restore test.
2. Review the exact pending migration list and run the guarded staging/production workflow. Production apply requires the existing exact confirmation phrase and backup gates.
3. Build/test actual provider adapters and the server-side worker in staging; ensure secrets stay server-side.
4. Connect R2 and an independent backup only after Owner-controlled account setup, quotas, access policies and restore tests.
5. Verify the Admin panel against the live database and test role isolation with separate Owner/Admin/member accounts.
6. Keep all paid APIs/server/storage disabled unless separately approved with a BDT spend cap.


## GitHub deployment and Supabase preflight observation (2026-11-25)

- The existing GitHub Pages deployment workflow was triggered by the app update; the newest run was still in progress at the time of this check. The Pages workflow now also checks that the Admin Auto Work panel and overview RPC marker are present in the published HTML.
- The Supabase backup/restore preview workflow reached its required-secret validation step and failed there. Therefore no recoverable Supabase backup, restore test or migration dry-run was confirmed in this run.
- Repository Actions secrets needed for the backup preview are SUPABASE_DB_URL (IPv4-compatible Supabase Session Pooler URI) and BACKUP_ENCRYPTION_PASSPHRASE. The guarded migration apply workflow also requires SUPABASE_ACCESS_TOKEN. Configure these only in GitHub repository Settings → Secrets and variables → Actions; never paste their values into chat or commit them.
- After the secrets are configured, rerun the backup/restore preview and confirm a successful disposable restore. Only then review pending migrations in the guarded workflow. Production apply additionally requires the exact phrase APPLY-MASTER-WORLD-VIP-MIGRATIONS, a non-secret backup reference and explicit confirmation of backup and restore test.
- No Supabase migration was applied by the commits in this update.


## Owner decision: Member Auto Work + platform commission (2026-11-25)

- Ordinary registered members will also be offered optional, free-to-join automated tasks, alongside the existing Work & Earn board. No deposit, subscription, purchase, referral payment or upfront fee is required.
- Member automation offers are limited to approved, legitimate customer/provider work in the five categories. Members opt in, see task rate/effort/eligibility/deadline/acceptance/payment terms before accepting, and may pause/leave freely. No guaranteed task volume or income.
- Owner/platform commission is planned from genuine settled customer/partner receipts for accepted member deliverables only. The displayed commission and member payout terms must be fixed before task acceptance. Direct costs, fees, refunds/chargebacks and required reserves are accounted first; no commission from unpaid member wages or unsettled money. Rate is not set yet.
- Member tasks must use a separate queue, per-member/module/global caps, quotas, isolated private files/data, and resource reservation for Owner/Admin jobs. Member workload is throttled or paused first if it threatens Owner/Admin tasks, server limits or quotas. Admin Auto Work remains separate and must never be blocked by member jobs.
- Initial member automation is FREE-ONLY; quota exhaustion queues/pauses work. No paid API/server fallback, no member charges and no silent Owner charges. No distributed use of members' phones, data or bandwidth in this initial design.
- Admin can disable all member offers, pause modules, limit access and review abuse. Audit and privacy protections are required.
- NOT LIVE: this is a new product decision/specification. Member Auto Work UI/backend/worker/commission ledger/customer sources and settlement tests have not been deployed. See docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md.


## Final Owner decision: Member Auto Work paused for workload protection (2026-11-25)

- Ordinary members will NOT execute automated jobs on the current shared infrastructure. Member Auto Work is DISABLED; no member job may enter the Admin/Owner queue or consume Owner-reserved worker slots, API quotas, private files or credentials.
- Reason: shared worker/queue/database/storage/API capacity could slow or interrupt Owner/Admin Auto Work. Protecting the Owner's work takes priority over offering member automation prematurely.
- Safe alternative: members may use the ordinary Work & Earn human-reviewed task marketplace (typing, data entry, translation, proofreading, PDF formatting, design, image editing, etc.). Show rate, eligibility, deadline, acceptance criteria and payment terms before acceptance. No deposit or upfront fee; no guaranteed income.
- Owner commission is conditional: only on a legitimate platform-mediated client order where the deliverable is accepted and the customer's payment is actually settled. The rate and payment integration are not set/live. If the platform does not receive/settle the customer's money, it must not claim commission. No settlement means ৳0 commission.
- Reconsider member automation only after dedicated isolated infrastructure/account, separate queue/storage/credentials/budget, hard quotas, reserved Owner/Admin capacity, automatic member-first pause, load/isolation/failure tests, genuine contracts, privacy/audit and emergency stop. If a safe separate free-tier setup is unavailable, keep member Auto Work disabled. No silent paid fallback or member charges.
- www/index.html and docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md now reflect this decision. This is source/documentation update, not live execution or payment integration.


## Member Auto Work package safety — Owner directive (2026-11-25)
সাধারণ সদস্যের আর্থিক সুরক্ষা সর্বোচ্চ অগ্রাধিকার। Member Auto Work বাতিল নয়, আপাতত বন্ধ; ভবিষ্যতে dedicated isolated infrastructure দিয়ে পুনরায় বিবেচনা করা যাবে। বর্তমান অবস্থায় member Auto Work execution এবং paid package checkout **DISABLED / NOT LIVE**; কোনো সদস্যের কাছ থেকে package fee/deposit নেওয়া যাবে না। Work & Earn-এর human-reviewed, funded task আলাদা নিয়মে চলতে পারে।

ভবিষ্যৎ paid package-এর আগে প্রতিটি বিক্রির সমপরিমাণ ১০০% actual liquid BDT refund reserve আলাদা রাখতে হবে; reserve server/API/operations cost, Owner profit, commission বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Compute/API খরচ আলাদা platform operating fund থেকে দিতে হবে। Reserve 100% না থাকলে, reconciliation stale/mismatch হলে, payment provider hold/dispute থাকলে বা আলাদা operating budget না থাকলে checkout ও নতুন jobs fail-closed হবে। নতুন সদস্যের package payment দিয়ে পুরোনো সদস্যকে refund করা যাবে না।

প্রস্তাবিত refund rule: নির্দিষ্ট evaluation period শেষে package-সম্পর্কিত client-accepted এবং payment-settled কাজ থেকে member-এর withdrawable net earning package price-এর কম হলে original package price 100% ফেরত; সদস্যের ইতোমধ্যে অর্জিত কাজের পারিশ্রমিক অক্ষত থাকবে। Platform/provider outage বা promised service না পেলে দ্রুত cancellation/full refund path থাকবে। Refund SLA, qualifying threshold, original payment route, fees এবং appeal process কেনার আগেই প্রকাশ করতে হবে; legal/payment-provider review ছাড়া এই guarantee বিক্রি করা যাবে না।

Owner commission কেবল সব member payable, refund liability, provider cost, tax/fee ও restricted customer funds সুরক্ষিত/মেটানোর পর প্রকৃত settled platform net revenue থেকে; member wage, deposit বা refund reserve থেকে নয়। Dedicated member worker/queue/storage/API credentials/budget, strict resource isolation, per-member hard caps, emergency stop, payment-provider server verification, audit logs, privacy controls, load/failure/security tests এবং independent reconciliation—সব launch gate পাস না করলে package sales/execution বন্ধ থাকবে। বিস্তারিত authoritative rules: [MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md](MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md).

**Implementation status:** policy/document/UI source update only. No member package catalog/checkout, actual refund reserve account, payment/refund integration, dedicated member worker or payout system is live. No member payments should be collected. GitHub Pages deployment and production database migration are separate and remain subject to their own verified gates.


## Live-panel diagnosis update — Owner access not configured (2026-11-25)

### Confirmed symptom
The Owner reports being logged into the Owner account, but the Admin Auto Work panel is not visible. The Admin & Security Center displays **Access Not configured** and this PostgREST error:

`Could not find the function public.get_my_admin_access without parameters in the schema cache`

### Root cause indicated by the evidence
- The existing app markup contains `#adminAutoWorkPanel`, initially hidden.
- The browser calls `public.get_my_admin_access()`; the panel is revealed only if the database returns `owner`, `super_admin` or `admin`.
- Therefore login to the website is not sufficient: the live Supabase database must have the RBAC function and the authenticated user must have the verified Owner role.
- Existing RBAC migration: `20261119180000_admin_rbac_owner_control.sql`. Its Owner bootstrap email must be checked against the verified Auth user in the correct Supabase project; never assume the existing configured value is correct.
- Apply dependency order only after database safety gates: RBAC/Owner bootstrap → `20261125100000_admin_auto_work_control_plane.sql` → `20261125130000_admin_auto_work_claim_concurrency_fix.sql`.

### Status
**BLOCKED / NOT LIVE.** This session diagnosed the missing live RPC/schema-cache function; it did not apply migrations or change production data. The panel source exists but has not passed live Owner-role verification. After migration, the panel remains a read-only control-plane view and execution remains NOT READY until actual server worker and provider connectors are deployed and accepted. All five modules remain disabled by default.

### Safe next steps
1. Verify correct Supabase project/ref and authenticated Owner identity.
2. Do not rerun backup workflow until Owner securely rotates/corrects the DB connection secret; previous attempts failed URI validation and PostgreSQL password authentication.
3. Complete encrypted backup + disposable restore + migration dry-run, with restored table count greater than zero.
4. Verify Owner bootstrap email against Supabase Auth; then use guarded migration workflow with required exact production authorization and non-secret backup reference.
5. Apply RBAC first, then the two Auto Work migrations in order; refresh schema cache if needed.
6. Verify Owner RPC result and role isolation; then reload app and test panel visibility.
7. Keep actual execution disabled until server worker, approved provider adapters/contracts, budget controls, storage, monitoring and settlement tests are complete. No paid fallback; Member Auto Work stays disabled.

No new PASS evidence was produced by this diagnosis. This section is a status update, not a completed-work entry.
