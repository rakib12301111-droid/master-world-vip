# MASTER WORLD VIP — Admin-only Referral & Work-to-Earn Policy (বাংলা)

Last updated: 2026-11-25

## Owner-এর সর্বশেষ সিদ্ধান্ত: প্রথম ৬–৭ মাস Admin-only referral

এই নথি আগের সাধারণ সদস্যের direct referral reward এবং Owner network referral reward নীতিকে প্রতিস্থাপন করে। পুরোনো নথি/মাইগ্রেশনে ৳৫০ member_direct এবং ৳৫০ owner_network-এর উল্লেখ থাকলে, এই নতুন নীতির সঙ্গে সাংঘর্ষিক অংশগুলো superseded হিসেবে গণ্য হবে; production database-এ পরিবর্তন কার্যকর করতে আলাদা reviewed migration ও acceptance test লাগবে।

### ১. সাধারণ সদস্য
- Registration ও কাজের সুযোগ বিনামূল্যে থাকবে।
- সাধারণ সদস্য Work & Earn, digital service, marketplace এবং অনুমোদিত partner/sponsor task করতে পারবে।
- কাজ সম্পন্ন, যাচাই এবং client/sponsor payment settlement হলে প্রকাশিত task rate অনুযায়ী পারিশ্রমিক পাবে।
- সাধারণ সদস্য কোনো referral bonus বা referral commission পাবে না।
- সাধারণ সদস্যের UI-তে referral code, referral wallet, referral leaderboard বা referral bonus promotion দেখানো হবে না।

### ২. Admin
- অনুমোদিত Admin-রা নিজেরাও সাধারণ সদস্যের মতো eligible কাজ করতে পারবে এবং একই প্রকাশিত task-rate/quality rules অনুযায়ী কাজের পারিশ্রমিক পাবে।
- Admin-only Admin Referral Center থাকবে: campaign/source link, attributable signups, qualification status, approved bonus, pending/funded/paid history এবং audit trail।
- Admin referral bonus কেবল নির্দিষ্ট campaign/role-এর জন্য Owner কর্তৃক আগে থেকে প্রকাশিত ও অনুমোদিত শর্তে অর্জিত হবে। Bonus amount/rate এখনো নির্ধারিত নয়; কোনো rate অনুমান করে চালু করা যাবে না।
- Self-referral, fake/duplicate account, bot, forced signup, misleading promotion, spam এবং attribution manipulation নিষিদ্ধ।

### ৩. MASTER WORLD VIP link ও attribution
- Admin সাধারণ MASTER WORLD VIP website/app link শেয়ার করতে পারবে; UI-তে সেটি সাধারণ platform invite/onboarding link হিসেবে দেখানো যেতে পারে, “Referral link” নামে প্রচার করা বাধ্যতামূলক নয়।
- Link-এ campaign/admin attribution identifier থাকলে তা privacy notice-এ স্পষ্টভাবে জানাতে হবে; signup-এর সময় প্রয়োজনীয় notice/consent দিতে হবে। গোপন fingerprinting, device/IP tracking দিয়ে ব্যক্তিকে শনাক্ত করা বা সম্মতি ছাড়া গোপনে attribution করা যাবে না।
- Signup যেখান থেকেই শুরু হোক, কেবল documented, consented এবং server-verified attribution rule মেনে Admin referral হিসেবে গণনা হবে। Attribution source, timestamp, campaign, rule version এবং reviewer audit log-এ থাকবে।
- একই signup-কে একাধিক Admin-এর নামে গণনা করা যাবে না। Attribution dispute-এর জন্য Owner review থাকবে।

### ৪. Owner কমিশন
- Owner কমিশন Admin-এর eligible, verified এবং বাস্তবে settled কাজ/কোম্পানির আয় থেকে আলাদা Owner commission ledger-এ গণনা হবে।
- Owner rate, calculation basis, tax/refund/processor-fee treatment, payment timing এবং approval rule লিখিতভাবে নির্ধারণ না হওয়া পর্যন্ত commission accrual/withdrawal চালু হবে না।
- Admin-এর কাজের পুরো gross amount-কে Owner commission বলা যাবে না। কেবল প্রকাশিত agreement-এ নির্ধারিত net basis থেকে হিসাব হবে।
- Admin referral bonus, Admin work payment, Owner commission এবং Company Revenue—চারটি আলাদা ledger/line item হবে; double counting চলবে না।

### ৫. ৬–৭ মাস পর সাধারণ referral পুনর্বিবেচনা
- প্রথম ৬–৭ মাস referral privileges Admin-only থাকবে।
- সময় শেষে Owner সদস্যসংখ্যা, retention, genuine settled revenue, fraud/abuse rate, support capacity, reward-fund solvency এবং legal/provider review দেখে সিদ্ধান্ত নেবেন।
- Review পাস করলেই সাধারণ referral স্বয়ংক্রিয়ভাবে চালু হবে না; নতুন লিখিত policy, UI, migration, funding proof এবং acceptance tests ছাড়া member referral বন্ধই থাকবে।

## আয়ের জন্য Work & Earn ও নতুন feature roadmap

সব কাজের পারিশ্রমিক বাস্তব client order, sponsor funding, partner contract বা কোম্পানির settled revenue-এর বিপরীতে হবে। কাজের availability বা income guaranteed নয়।

1. **Micro-task board:** Bengali/English typing, data entry, spreadsheet cleanup, transcription, proofreading, translation।
2. **Creative services:** poster/banner, social-media post, thumbnail, CV/resume, PDF formatting, basic logo and video editing।
3. **Facebook Creator Support:** caption writing, content calendar, thumbnail/post design, subtitle/editing support; fake engagement, fake accounts, credential collection বা Meta policy violation নয়।
4. **Digital products & services shop:** templates, document formatting, design packages এবং platform-approved digital deliverables।
5. **Marketplace:** member service listings, order milestones, buyer/seller dispute flow, completion proof, refund/chargeback controls এবং disclosed platform commission।
6. **Sponsor-funded task campaigns:** sponsor-approved brief, budget cap, task instructions, evidence review, fraud checks এবং funded payout reserve।
7. **Partner offers:** written partner agreement, eligible action definition, attribution window, commission terms, reversal/refund rules and settlement reference।
8. **Admin work & referral center:** Admin task queue এবং separate Admin-only referral reporting/bonus panel।
9. **Skill ladder:** free learning modules, sample tasks, quality score, verified skill tags and higher-value task eligibility; no paid unlock or mandatory deposit।
10. **Trust & anti-fraud:** duplicate detection using proportionate signals, human review, rate limits, evidence retention limits, appeals and audit log. Never expose private device/IP data to other members.

## Financial and member-protection rules

- Signup, job application and access to ordinary tasks must not require member deposit, activation fee or mandatory purchase.
- Never advertise “সহজে নিশ্চিত বেশি টাকা”; show actual task rate, estimated effort, eligibility, deadline and payment conditions before a member accepts a task.
- Unfunded tasks must not be published as payable. Sponsor/client funds or approved company budget must be reserved before promising a payout.
- Pending is not cash and not withdrawable. Mark Paid only after actual transfer and non-secret transaction reference reconciliation.
- Customer promotional spend first enters Company Revenue Ledger; it is not automatically Admin or Owner personal income.
- Do not ask for Facebook passwords, OTPs, recovery codes, session cookies, NID scans unless a separately justified lawful verification flow exists, or access to personal accounts.
- Admin roles are server-side RBAC protected; hiding a menu is not authorization.

## Implementation status — policy only

This document records the latest product and business policy in the existing MASTER WORLD VIP repository. It does NOT yet:
- disable existing member referral UI, attribution, reward processor or old SQL reward rules;
- implement the Admin-only referral attribution/bonus workflow;
- implement new task categories, sponsor campaign funding, marketplace checkout or partner integrations;
- calculate Owner commission automatically;
- apply Supabase migrations, deploy Edge Functions, configure provider secrets, collect funds or send payouts.

Required next engineering sequence:
1. Inventory all existing referral UI, RPCs, Edge Functions, cron jobs, policies, migrations and tests.
2. Design a safe additive migration that disables member rewards and supersedes old direct-member/Owner-network credits without deleting audit history or silently confiscating already-paid/earned entitlements. Owner must decide how any previously earned but unpaid balances are handled before migration.
3. Implement Admin-only attribution with privacy notice/consent, server-side role checks, anti-fraud and audit.
4. Implement funded task budgets and Admin task payment records; no unfunded task payouts.
5. Implement separate Company Revenue, Admin Work Pay, Admin Referral Bonus and Owner Commission ledgers, with a documented non-overlapping calculation basis.
6. Add role-separated UI, RLS/RPC tests, two-member + Admin + Owner acceptance tests, Pages deployment verification and guarded production migration only after backup/restore/dry-run and explicit authorization.
7. Connect real advertisers, sponsors, clients and partners only after agreements, lawful payment collection, provider approval and server-side secret setup.

No real revenue, reward funding, task payment or referral payout is created by this policy document.


## Update 18 — 2026-11-25: Revenue funding map and expanded earning roadmap

- Clarified who pays each earning stream: (a) task customer/client pays for accepted deliverables; (b) sponsor prepays or settles its campaign budget; (c) marketplace buyer pays the order and the platform retains only its disclosed commission; (d) partner pays commission after the contracted eligible action is verified; (e) ad network/advertiser pays only after valid monetized activity and its settlement threshold. No provider payment is assumed until actually received.
- The company, not the Owner personally by default, is the payer of approved Admin referral bonuses and Owner commission. The company may pay them only from settled, legally usable company funds explicitly allocated to the appropriate reserve/ledger. Sponsor-restricted money may only be used for the sponsor-approved purpose. If funds are absent, entries remain Pending and non-withdrawable; no debt, guaranteed date, member deposit or fabricated wallet balance.
- Owner referral commission is a separate payable from Admin referral bonus and Admin work pay. Its rate, net/gross basis, tax/refund/chargeback treatment and approval rules remain unset until a written Owner-approved schedule is published. Do not calculate or release it using an invented percentage or by double-counting gross sales.
- Added earning roadmap candidates: (1) verified microtasks and client task escrow/reserve; (2) digital service storefront with order milestones; (3) reusable digital templates and document services; (4) sponsor-funded challenge/campaign tasks; (5) approved partner lead-generation and affiliate offers; (6) creator support service packages; (7) skill badges and free training-to-task progression; (8) transparent marketplace commission; (9) client repeat-order and quality tiers; (10) admin-only campaign/referral analytics. All task rates and availability must be shown before acceptance and backed by reserved funds.
- Added payment-source reconciliation requirements: payer identity/category, contract/order/campaign ID, gross receipt, tax/processor/refund adjustments, settled net amount, restricted/unrestricted designation, reserve allocation, payout reference and reviewer audit. Never treat impressions, clicks, unpaid invoices, pending partner reports or chargeback-prone receipts as spendable cash.
- **Status: policy/roadmap documentation only.** No revenue provider, sponsor, client checkout, marketplace payment, partner API, Company Revenue Ledger, Owner commission calculator or Admin-only referral workflow has been connected or made live by this update. No money has been collected or paid.


## Update 19 — 2026-11-25: Owner-earned revenue funding and Admin Auto Work

### Owner কাজ করে কোম্পানির আয় তৈরি করলে
- Owner নিজে কোনো বাস্তব client task/service সম্পন্ন করে আয় করলে, client-এর contract/invoice অনুযায়ী টাকা Owner নাকি কোম্পানির পাওনা—তা আগে নির্ধারণ করতে হবে। কোম্পানির নামে কাজ/চুক্তি হলে এবং টাকা কোম্পানির হিসাবে বাস্তবে settled হলে সেটি Company Revenue Ledger-এ যাবে।
- Owner-এর ব্যক্তিগতভাবে সম্পন্ন কাজের পারিশ্রমিক স্বয়ংক্রিয়ভাবে কোম্পানির আয় নয়। Owner চাইলে লিখিতভাবে নিজের প্রাপ্ত আয়ের নির্দিষ্ট অংশ কোম্পানির Referral Reward Fund-এ বরাদ্দ করতে পারেন; এটি ঐচ্ছিক, বাধ্যতামূলক ব্যক্তিগত deposit নয়।
- উদাহরণ: কোম্পানির নামে করা বাস্তব কাজ থেকে ৳১,০০০ net settled revenue এলে এবং অনুমোদিত allocation ৳৫০০ হলে, সর্বোচ্চ ৳৫০০ Referral Reward Fund-এ যাবে। বাকি অর্থ কোম্পানির অন্য খরচ/রিজার্ভে থাকবে। এটি কেবল প্রকৃত অর্থ পাওয়া ও settlement সম্পন্ন হওয়ার পর।
- সাধারণ সদস্যের earned work payment, customer refund reserve, sponsor-restricted funds বা অন্যের জমা/আমানত থেকে Admin referral bonus দেওয়া নিষিদ্ধ।
- Referral bonus policy-তে ২৪ ঘণ্টার account-good-standing qualification থাকতে পারে; এটি continuous online time নয়। কোনো নতুন সদস্যকে কাজ করতে বাধ্য করা যাবে না, যদি Owner আলাদাভাবে প্রকাশিত শর্তে সেটি অনুমোদন না করেন।
- Owner/Admin bonus rate, eligibility, maximum budget, payment timing ও legal/tax treatment লিখিতভাবে প্রকাশ/অনুমোদন না হওয়া পর্যন্ত নতুন cash liability/withdrawal promise চালু করা যাবে না। Unfunded amount-কে Available বা withdrawable দেখানো যাবে না।

### Admin-only Auto Work & Earn
- নতুন প্রস্তাবিত সুবিধার নাম: **Admin Auto Work & Earn**; এটি কেবল অনুমোদিত Admin role-এর জন্য। সাধারণ সদস্যের UI বা account-এ এই সুবিধা থাকবে না।
- এটি কেবল বাস্তব, অনুমোদিত ও পারিশ্রমিক-নির্ধারিত client/sponsor/partner কাজের বৈধ automation করবে—যেমন অনুমোদিত API-তে data processing, scheduled report preparation, file conversion/formatting, বা client-অনুমোদিত batch processing।
- ফোনে internet চালু থাকলেই আয় তৈরি হয় না। প্রতিটি automated job-এর জন্য task owner/client, written permission, scope, rate, acceptance criteria, deadline, budget/funded status এবং output verification থাকতে হবে।
- ভুয়া ad impression/click/view, auto-like/follow/comment, fake account/signup, traffic inflation, bot engagement, CAPTCHA/verification bypass, অন্যের account-এ অননুমোদিত কাজ, অথবা provider terms ভঙ্গ করে কোনো আয় করা যাবে না।
- Android/PWA app বন্ধ থাকলে বা ফোন sleep/battery optimization-এ গেলে background execution থেমে যেতে পারে। তাই নির্ভরযোগ্য continuous processing দরকার হলে অনুমোদিত server-side queue/worker ব্যবহার করতে হবে; ফোনের internet-কে শুধু status/monitoring/control হিসেবে ধরা যাবে। App-এ Pause/Resume, job status, estimated resource use, last run, logs, consent এবং Stop control থাকতে হবে।
- টাকা কেবল client/sponsor/partner কাজের output গ্রহণ ও বাস্তব payment settlement-এর পর earned হিসেবে রেকর্ড হবে। Job চলা, ফোন online থাকা, বা task attempt করা নিজে কোনো আয় বা withdrawable balance নয়।
- Admin Auto Work-এর আয় Admin Work Payment/Company Revenue—চুক্তি অনুযায়ী সঠিক ledger-এ যাবে; Referral Bonus ও Owner Commission-এর সঙ্গে মেশানো যাবে না।

**Implementation status:** এই আপডেট কেবল নীতি ও পরিকল্পনা। Auto Work UI, job queue/worker, provider/API integrations, billing, ledger posting, role checks, mobile background behavior, deployment ও acceptance tests এখনো implement/live হয়নি। কোনো স্বয়ংক্রিয় আয় বা payout চালু হয়নি।


## Member Auto Work package safety — Owner directive (2026-11-25)
সাধারণ সদস্যের আর্থিক সুরক্ষা সর্বোচ্চ অগ্রাধিকার। Member Auto Work বাতিল নয়, আপাতত বন্ধ; ভবিষ্যতে dedicated isolated infrastructure দিয়ে পুনরায় বিবেচনা করা যাবে। বর্তমান অবস্থায় member Auto Work execution এবং paid package checkout **DISABLED / NOT LIVE**; কোনো সদস্যের কাছ থেকে package fee/deposit নেওয়া যাবে না। Work & Earn-এর human-reviewed, funded task আলাদা নিয়মে চলতে পারে।

ভবিষ্যৎ paid package-এর আগে প্রতিটি বিক্রির সমপরিমাণ ১০০% actual liquid BDT refund reserve আলাদা রাখতে হবে; reserve server/API/operations cost, Owner profit, commission বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Compute/API খরচ আলাদা platform operating fund থেকে দিতে হবে। Reserve 100% না থাকলে, reconciliation stale/mismatch হলে, payment provider hold/dispute থাকলে বা আলাদা operating budget না থাকলে checkout ও নতুন jobs fail-closed হবে। নতুন সদস্যের package payment দিয়ে পুরোনো সদস্যকে refund করা যাবে না।

প্রস্তাবিত refund rule: নির্দিষ্ট evaluation period শেষে package-সম্পর্কিত client-accepted এবং payment-settled কাজ থেকে member-এর withdrawable net earning package price-এর কম হলে original package price 100% ফেরত; সদস্যের ইতোমধ্যে অর্জিত কাজের পারিশ্রমিক অক্ষত থাকবে। Platform/provider outage বা promised service না পেলে দ্রুত cancellation/full refund path থাকবে। Refund SLA, qualifying threshold, original payment route, fees এবং appeal process কেনার আগেই প্রকাশ করতে হবে; legal/payment-provider review ছাড়া এই guarantee বিক্রি করা যাবে না।

Owner commission কেবল সব member payable, refund liability, provider cost, tax/fee ও restricted customer funds সুরক্ষিত/মেটানোর পর প্রকৃত settled platform net revenue থেকে; member wage, deposit বা refund reserve থেকে নয়। Dedicated member worker/queue/storage/API credentials/budget, strict resource isolation, per-member hard caps, emergency stop, payment-provider server verification, audit logs, privacy controls, load/failure/security tests এবং independent reconciliation—সব launch gate পাস না করলে package sales/execution বন্ধ থাকবে। বিস্তারিত authoritative rules: [MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md](MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md).

**Implementation status:** policy/document/UI source update only. No member package catalog/checkout, actual refund reserve account, payment/refund integration, dedicated member worker or payout system is live. No member payments should be collected. GitHub Pages deployment and production database migration are separate and remain subject to their own verified gates.
