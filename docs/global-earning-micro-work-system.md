# MASTER WORLD VIP — Global Earning & Micro-Work System

Status: **Specification added; application UI, database, payment integrations, and live payouts are not yet implemented or verified.**
Last updated: 2026-11-21

## Product goal
Give members access to genuine, beginner-friendly paid work while allowing the platform owner to earn a clearly disclosed, sustainable service fee. Members must not need to deposit money, buy a membership, recruit others, or pay to unlock work.

## Member work marketplace
Every task must show: task title, exact instructions, required skill, estimated time, number of slots, reward, currency, deadline, proof required, approval criteria, sponsor/employer, and dispute route.

Initial task categories:
1. Bengali/English typing and document formatting.
2. Short translation and proofreading.
3. Audio transcription and caption/subtitle correction.
4. Simple graphic design and social-media post formatting.
5. Product/catalog data entry and spreadsheet cleanup.
6. Website/app usability testing with honest feedback.
7. Legitimate public information collection and directory verification (no private data harvesting).
8. Local business promotion with advertiser permission and clear sponsored labels.
9. Original content creation for verified clients.
10. Skill-based freelance projects and service requests.
11. Ethical affiliate campaigns with clear commission terms and no misleading claims.
12. Paid surveys only from reputable research providers, with eligibility, privacy and reward terms visible.
13. Knowledge contests or challenges with published rules, judging and prize funding.
14. Learning tasks and practice projects; clearly labelled unpaid unless a real sponsor funds a reward.

Never list fake engagement, fake reviews, spam, account creation for third parties, credential sharing, mass messaging, unauthorized scraping, or tasks that violate platform terms.

## Work and payment lifecycle
- Employer/admin creates a task and funds or confirms a real budget before publishing.
- Member accepts a task; task slots and deadline are reserved.
- Member submits work/proof through the app.
- Reviewer checks against published criteria and either approves, rejects with a reason, or requests correction.
- Approved rewards become payable balance; pending submissions are never shown as withdrawable.
- Member requests withdrawal; admin checks fraud and payment details; payout is marked paid only after actual transfer confirmation.
- Every change has actor, timestamp, reason, reference and immutable audit history.
- Provide dispute/appeal and correction flow.

## Earnings wallet
Separate balances: pending, approved/available, withdrawn, reversed/refunded. Show transaction history, task ID, gross reward, disclosed platform fee, net member amount, payout status and receipt/reference. Never fabricate balances or demo earnings as real money.

## Owner/platform revenue
Permitted transparent revenue sources:
- A disclosed marketplace service fee on completed, funded work.
- Employer posting/featured listing fees, clearly priced before purchase.
- Optional premium productivity tools that do not gate access to basic earning opportunities.
- AI-assisted services with displayed price, user consent, receipt and refund policy.
- Clearly labelled advertising and affiliate commissions.
- Business/creator service fees and enterprise plans.

Owner dashboard must separate gross employer funding, member liabilities, platform fees, payment charges, refunds, operating costs and net profit. Member funds are not platform profit. Do not count pending/unfunded orders as revenue.

## Referrals and rewards
- Optional single-level referral rewards only from a disclosed marketing budget or completed eligible activity.
- No payment for merely recruiting members, no multi-level/downline commission, no forced purchase, and no guaranteed income claims.
- Show eligibility, cap, expiry, fraud checks and source of funding.

## Bangladesh payout readiness
Design provider-neutral payout records for BDT and later supported currencies. bKash, Nagad and bank transfer must be labelled **manual/pending integration** until official merchant/API access, webhook verification and reconciliation are implemented. Do not claim automatic cashout. Verify payment references against the merchant account before approval; never ask members for PIN, OTP or wallet password.

## Safety, fairness and compliance
- Free access to browse and apply for eligible tasks; no deposit or paid activation.
- No guaranteed daily income or misleading earnings screenshots.
- Clear minimum withdrawal, fees, processing times and eligibility before a member starts.
- Age, country, tax and legal restrictions handled where applicable.
- Collect minimum data; never request Facebook passwords, OTPs, login codes, bank PINs or unnecessary identity-document images.
- Secure role-based access, server-side validation, rate limits, anti-bot/duplicate checks, fraud review and audit logs.
- Publish task rules and moderation standards. Do not reject genuine work arbitrarily.
- Complaints, disputes, refunds and account appeals must be available.
- Sponsored content and affiliate links must be disclosed.

## Admin controls
- Create/edit/pause/archive tasks and categories.
- Manage employers, task budgets, slots and deadlines.
- Review submissions and appeals with reason codes.
- Approve/reject withdrawals and record payment references.
- Configure platform fees and payout thresholds transparently.
- Review suspicious activity without silently confiscating member balances.
- View immutable audit trail and export accounting reports.
- Emergency pause for suspected fraud or payment-provider outage.

## Release phases
1. **Design:** task categories, user journeys, fee model, terms and fraud rules.
2. **Backend:** schema, row-level security, server-side task/earning ledger, admin roles, audit logs.
3. **Member UI:** task discovery, apply, submit proof, wallet and withdrawal request.
4. **Admin UI:** task funding/review, disputes, payout reconciliation and profit reports.
5. **Pilot:** small number of genuinely funded tasks, manual payout reconciliation and security testing.
6. **Scale:** official payment-provider integrations, employer onboarding, localization and country-specific compliance.

## Truthful status
This document records the approved product direction only. It does not mean that tasks, wallets, payouts, payment APIs, or owner profit accounting are live. Each release phase must be implemented, tested and verified before its status is changed.


## Member Auto Work package safety — Owner directive (2026-11-25)
সাধারণ সদস্যের আর্থিক সুরক্ষা সর্বোচ্চ অগ্রাধিকার। Member Auto Work বাতিল নয়, আপাতত বন্ধ; ভবিষ্যতে dedicated isolated infrastructure দিয়ে পুনরায় বিবেচনা করা যাবে। বর্তমান অবস্থায় member Auto Work execution এবং paid package checkout **DISABLED / NOT LIVE**; কোনো সদস্যের কাছ থেকে package fee/deposit নেওয়া যাবে না। Work & Earn-এর human-reviewed, funded task আলাদা নিয়মে চলতে পারে।

ভবিষ্যৎ paid package-এর আগে প্রতিটি বিক্রির সমপরিমাণ ১০০% actual liquid BDT refund reserve আলাদা রাখতে হবে; reserve server/API/operations cost, Owner profit, commission বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Compute/API খরচ আলাদা platform operating fund থেকে দিতে হবে। Reserve 100% না থাকলে, reconciliation stale/mismatch হলে, payment provider hold/dispute থাকলে বা আলাদা operating budget না থাকলে checkout ও নতুন jobs fail-closed হবে। নতুন সদস্যের package payment দিয়ে পুরোনো সদস্যকে refund করা যাবে না।

প্রস্তাবিত refund rule: নির্দিষ্ট evaluation period শেষে package-সম্পর্কিত client-accepted এবং payment-settled কাজ থেকে member-এর withdrawable net earning package price-এর কম হলে original package price 100% ফেরত; সদস্যের ইতোমধ্যে অর্জিত কাজের পারিশ্রমিক অক্ষত থাকবে। Platform/provider outage বা promised service না পেলে দ্রুত cancellation/full refund path থাকবে। Refund SLA, qualifying threshold, original payment route, fees এবং appeal process কেনার আগেই প্রকাশ করতে হবে; legal/payment-provider review ছাড়া এই guarantee বিক্রি করা যাবে না।

Owner commission কেবল সব member payable, refund liability, provider cost, tax/fee ও restricted customer funds সুরক্ষিত/মেটানোর পর প্রকৃত settled platform net revenue থেকে; member wage, deposit বা refund reserve থেকে নয়। Dedicated member worker/queue/storage/API credentials/budget, strict resource isolation, per-member hard caps, emergency stop, payment-provider server verification, audit logs, privacy controls, load/failure/security tests এবং independent reconciliation—সব launch gate পাস না করলে package sales/execution বন্ধ থাকবে। বিস্তারিত authoritative rules: [MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md](MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md).

**Implementation status:** policy/document/UI source update only. No member package catalog/checkout, actual refund reserve account, payment/refund integration, dedicated member worker or payout system is live. No member payments should be collected. GitHub Pages deployment and production database migration are separate and remain subject to their own verified gates.
