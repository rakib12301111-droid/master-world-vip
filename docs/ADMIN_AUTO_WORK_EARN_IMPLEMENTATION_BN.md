# MASTER WORLD VIP — Admin Auto Work & Earn: বাস্তবায়ন নকশা

Last updated: 2026-11-25

## বর্তমান সিদ্ধান্ত
- Admin Auto Work & Earn কেবল server-verified Admin role-এর জন্য।
- সাধারণ সদস্যের Referral feature/bonus আপাতত বন্ধ থাকবে। ভবিষ্যতে দৈনিক/মাসিক net settled revenue, operating cost, reserve ও fraud review দেখে Owner নতুন নীতি অনুমোদন না করা পর্যন্ত চালু হবে না।
- Auto Work কোনো guaranteed daily income নয়। ফোনে internet থাকা শুধু connectivity; আয় নয়।
- কাজের output client/sponsor/partner গ্রহণ এবং সংশ্লিষ্ট অর্থ বাস্তবে settle হওয়ার পরই আয় ledger-এ যাবে।

## বৈধ automation category (সম্ভাব্য, provider/client অনুমোদন সাপেক্ষে)
1. **Client API data processing:** CSV/Excel cleanup, deduplication, validation, format conversion, scheduled imports/exports.
2. **Document & media production:** batch PDF generation, image resizing/compression, subtitle/transcript processing, document formatting—শুধু লাইসেন্স/অনুমতি থাকা ফাইল।
3. **Scheduled reporting:** client analytics export, inventory/operations report, website uptime and error report.
4. **E-commerce operations:** seller-authorized catalog sync, stock/price update, order-status sync, invoice generation.
5. **Partner/affiliate operations:** approved partner API থেকে eligible lead/conversion report; commission কেবল partner-এর validated settlement-এর পর।
6. **Website/app maintenance:** authorized backups, link checks, accessibility/SEO technical scans, broken-link reports, permitted monitoring.
7. **Cloud batch jobs:** customer-provided data processing, image/document conversion, scheduled backups and authorized compute jobs.
8. **Content workflow assistance:** client-approved captions/subtitles/translations/drafts; human/client acceptance required before billable completion.

## নিষিদ্ধ/গ্রহণযোগ্য নয়
- Auto ad click/view/impression, auto-surf, paid-to-click, traffic exchange বা bot traffic.
- Fake signup, auto-like/follow/comment, fake engagement, review manipulation.
- CAPTCHA bypass, account takeover, scraping behind login or breaching API/website terms.
- নিজের ফোন/নিজের অ্যাকাউন্টে কৃত্রিম কাজ চালিয়ে নিজের জন্য আয় দেখানো।
- CPU/GPU mining বা bandwidth resale default-এ enable নয়; explicit legal/provider permission, transparent costs and security review ছাড়া নয়।

## বাস্তব architecture
- **Admin UI:** Start/Pause/Resume/Stop, connected provider status, job queue, daily gross/net settled revenue, costs, pending settlement, failures, audit log.
- **Server-side scheduler/worker:** durable queue, retries, idempotency keys, rate limits, timeouts, per-provider quotas. Phone browser/PWA শুধু monitoring/control; 24/7 execution ফোনে নির্ভর করবে না।
- **Connector adapters:** প্রতিটি client/provider-এর documented API, OAuth/consent, contract, rate limits and server-side secret configuration. কোনো provider credential browser bundle বা chat-এ রাখা যাবে না।
- **Job definition:** client/contract ID, task scope, permission, unit rate, budget cap, acceptance criteria, output reference, settlement status.
- **Accounting:** actual collected receipt -> Company Revenue (if contract is with company) or Admin Work Payment (if payable directly to Admin) according to contract. Referral Bonus and Owner Commission remain separate. No double counting.
- **Admin authorization:** server-side role/RLS/RPC validation; UI hiding alone is insufficient.
- **Safety:** pause on provider error, budget cap, abnormal usage, expired permission, or payment dispute.

## Android / phone behavior
- Android background work is scheduled and OS-controlled; app sleep, Doze, battery optimization, manufacturer limits or no network can delay/stop work. WorkManager can persist scheduled work across restarts, but is not a promise of uninterrupted 24/7 processing.
- For reliable continuous work, use a server worker. Phone internet can be optional monitoring/control, not the revenue engine.

## Daily income report
Show separate values: jobs completed, client accepted, gross invoiced, cash settled, fees/tax/refunds, net settled, compute/API costs, reserve allocation, Admin payable, Company net. Estimated, pending, disputed and settled must never be mixed.

## Integration gates before production
1. Owner selects actual paid client/provider sources and obtains contracts/permission.
2. Each provider's API documentation, commercial terms, geographic eligibility (including Bangladesh), payout method, fees and minimum settlement are verified.
3. Build and test one connector in staging with test data; never use live ad clicks or fake traffic.
4. Implement server queue, role checks, audit, budget limits, idempotent accounting and pause/stop controls.
5. Configure provider secrets only in server-side secret storage.
6. Test failure, duplicate webhook, refund, chargeback, provider suspension and payout reconciliation.
7. Enable only after real client/provider acceptance and legal/tax review.

## Status
This document is a design specification only. It does not connect a client/provider, execute jobs, create income, or enable withdrawals. No provider contract or API credential has been supplied/verified. Do not claim the feature is live until code, deployment, provider acceptance and end-to-end settlement tests pass.


## Owner-এর নতুন deployment সিদ্ধান্ত (2026-11-25)

### Server ও execution
- প্রথম পর্যায়: **FREE-TIER ONLY** backend/queue/storage; paid server এবং paid API-তে কোনো automatic fallback থাকবে না।
- ভবিষ্যৎ পর্যায়: Owner-এর স্পষ্ট অনুমোদন, নির্দিষ্ট budget cap এবং provider-এর billing terms যাচাই ছাড়া paid server/API চালু হবে না।
- পাঁচটি module একই সময়ে কাজ করতে পারবে। প্রাথমিক concurrency হবে **প্রতি module-এ সর্বোচ্চ ১টি running job**, অর্থাৎ পাঁচটি module সক্রিয় থাকলে সর্বোচ্চ পাঁচটি job parallel। প্রতিটি module-এর নিজস্ব queue, status, retry ও error log থাকবে।
- Free-tier CPU/RAM, request, execution time, storage, bandwidth বা provider quota কম হলে queue-তে job অপেক্ষা করবে; worker capacity না থাকলে job গ্রহণ/চালানো হবে না। কোনো free service 24/7 uptime বা unlimited capacity নিশ্চিত করে না।
- একটি module pause/stop করলে অন্য module চলতে পারবে; global emergency stop সব worker pause করবে।

### Free file storage policy
- User/customer files private object storage-এ থাকবে; public URL বা public bucket default-এ নিষিদ্ধ।
- Database-এ file metadata/reference, owner/client, module, MIME type, size, checksum, created time, retention expiry ও access audit রাখা হবে; file content আলাদা storage-এ থাকবে।
- File upload-এর আগে file-size, allowed type, per-user/per-client quota এবং remaining provider quota পরীক্ষা করতে হবে। Quota পূর্ণ হলে upload/job pause এবং Admin alert হবে; paid storage-এ স্বয়ংক্রিয়ভাবে migrate হবে না।
- GitHub repository কেবল source code ও documentation রাখবে; customer uploads বা ব্যক্তিগত ফাইল GitHub Pages/repository-তে রাখা হবে না।
- Free storage plan-এর quota, egress, retention, backup ও inactivity policy provider অনুযায়ী বদলাতে পারে। তাই unlimited/permanent free storage guarantee করা যাবে না; Owner provider নির্বাচন ও quota review না করা পর্যন্ত storage integration **পরিকল্পিত, live নয়**।
- Sensitive data হলে encryption, least-privilege access, signed short-lived download links, retention/deletion policy এবং backup/restore test আবশ্যক।

### Acceptance tests
1. পাঁচটি আলাদা module-এর একটি করে job একই সময়ে চলতে পারে।
2. একই module-এ দ্বিতীয় job queue-তে থাকবে যতক্ষণ প্রথমটি শেষ/ব্যর্থ/বাতিল না হয়।
3. প্রতিটি module independently enable/pause/resume/stop করা যায়।
4. Worker restart, retry, duplicate enqueue, quota exhaustion ও provider outage পরীক্ষা হবে।
5. Free quota শেষ হলে job pause হবে; paid endpoint/server-এ fallback হবে না।
6. Paid provider/server চালাতে Owner approval record + explicit spend cap আবশ্যক।
7. Private file access cross-user/cross-client denied; expired file retention policy অনুযায়ী delete হবে।

## Implementation status update (2026-11-25)

- The existing Admin & Security page now includes an Admin Auto Work overview panel. It calls the server-side admin_auto_work_overview() RPC and shows module/provider state, daily budget usage, last run and recent queue counts only to server-verified Admin roles.
- The panel is read-only and reports NOT READY until the database RPC, provider connector and worker are actually available. It does not enqueue or execute jobs.
- Added 20261125130000_admin_auto_work_claim_concurrency_fix.sql as an additive migration so concurrent workers cannot claim a second running job in a module. Maximum intended parallelism is five total: one job per each of five modules.
- The guarded migration workflow and Supabase migration README now include both Auto Work migrations.
- NOT LIVE: the database migrations are not applied, no Auto Work worker or provider adapters are deployed, and no R2 bucket/backup connector is connected. The modules remain disabled. The UI change alone does not create work, income or storage.


## নতুন সিদ্ধান্ত: সাধারণ সদস্যদের Auto Work + Owner Commission

- Admin Auto Work ছাড়াও সাধারণ সদস্যদের জন্য আলাদা opt-in Auto Work opportunity থাকবে। Registration, join, task view/accept—সব ফ্রি; deposit, subscription, purchase, referral fee বা upfront charge নয়।
- Member offer কেবল বৈধ client/provider contract ও permission-যুক্ত পাঁচ category-এর task থেকে। Member আগে rate, effort, deadline, eligibility, acceptance/payment terms দেখে accept করবে; কাজের পর client acceptance ও settled payment হলে payout.
- Owner/platform commission শুধু member-এর accepted deliverable-এর real settled customer/partner receipt থেকে, আগে প্রকাশিত rate অনুযায়ী। Rate এখনও নির্ধারিত নয়। Member payout, platform commission, fees/costs/refunds/reserve আলাদা ledger; unpaid wages বা unsettled funds থেকে commission নয়।
- Member task queue Admin queue থেকে আলাদা; per-member/per-module/global limits, quota, isolated data/file access, Owner/Admin reserved capacity, emergency pause. Resource pressure হলে member jobs আগে throttle/pause হবে; Owner/Admin work যেন member jobs দ্বারা blocked না হয়.
- Free-only mode; quota exhaustion queue/pause. Paid API/server fallback OFF; member-কে charge নয়, Owner-কে silent bill নয়. Members' phone, mobile data, bandwidth বা electricity distributed compute হিসেবে ব্যবহার হবে না.
- Fraud review, permission, audit, dispute/report/appeal, privacy, task output checks mandatory. নিষিদ্ধ fake clicks/views/traffic, auto-surf, fake engagement/signup, CAPTCHA bypass, unauthorized scraping.
- Member Auto Work এখনও live নয়; UI, database/queue/ledger, worker, customer source, settlement/payout ও isolation tests বাস্তবায়ন এবং deploy করতে হবে.


## Final Owner decision: Member Auto Work paused for workload protection (2026-11-25)

- Ordinary members will NOT execute automated jobs on the current shared infrastructure. Member Auto Work is DISABLED; no member job may enter the Admin/Owner queue or consume Owner-reserved worker slots, API quotas, private files or credentials.
- Reason: shared worker/queue/database/storage/API capacity could slow or interrupt Owner/Admin Auto Work. Protecting the Owner's work takes priority over offering member automation prematurely.
- Safe alternative: members may use the ordinary Work & Earn human-reviewed task marketplace (typing, data entry, translation, proofreading, PDF formatting, design, image editing, etc.). Show rate, eligibility, deadline, acceptance criteria and payment terms before acceptance. No deposit or upfront fee; no guaranteed income.
- Owner commission is conditional: only on a legitimate platform-mediated client order where the deliverable is accepted and the customer's payment is actually settled. The rate and payment integration are not set/live. If the platform does not receive/settle the customer's money, it must not claim commission. No settlement means ৳0 commission.
- Reconsider member automation only after dedicated isolated infrastructure/account, separate queue/storage/credentials/budget, hard quotas, reserved Owner/Admin capacity, automatic member-first pause, load/isolation/failure tests, genuine contracts, privacy/audit and emergency stop. If a safe separate free-tier setup is unavailable, keep member Auto Work disabled. No silent paid fallback or member charges.
- www/index.html and docs/MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md now reflect this decision. This is source/documentation update, not live execution or payment integration.
