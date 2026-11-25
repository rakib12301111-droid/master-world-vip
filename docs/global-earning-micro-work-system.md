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

## VIP USD bonus draw and plan-linked Admin revenue — Owner request (2026-11-26)

### Ordinary member USD bonus
- MASTER WORLD VIP-এর VIP/Member Rewards area-তে একটি **USD Bonus Draw** requirement থাকবে: eligible সাধারণ সদস্যরা কোনো পূর্বনির্ধারিত আয় বা নির্দিষ্ট তারিখের প্রতিশ্রুতি ছাড়া অনিয়মিত/random selection-এ USD promotional bonus পেতে পারেন। কে কখন পাবেন তা আগে থেকে নিশ্চিত করে বলা হবে না; কোনো সদস্যের USD পাওয়া guaranteed নয়।
- এটি funded promotional prize draw হবে, member deposit, joining fee, task-unlock fee বা paid-plan purchase-এর বিনিময়ে lottery ticket নয়। Basic membership/work access free থাকবে; কোনো plan কিনলে chance বাড়বে না।
- Draw চালুর আগে পৃথক, liquid, fully funded USD prize pool, published eligibility/rules, jurisdictional legal review, tax/withholding disclosure, fraud controls, independent auditable random selection, immutable draw log, winner notification, appeal/correction process এবং verified USD payout provider আবশ্যক।
- Prize pool না থাকলে draw pause হবে; ভবিষ্যৎ member payment, wages, customer restricted funds, refund reserve বা অন্য সদস্যের deposit দিয়ে পুরস্কার দেওয়া যাবে না। No fabricated USD wallet balance, guaranteed winner, daily payout or income claim.
- Applicable law যদি lottery/contest registration, permit, free-entry route, odds disclosure বা other restrictions চায়, legal approval না পাওয়া পর্যন্ত draw চালু হবে না. The feature must be structured as a lawful no-purchase-necessary promotional reward, not gambling or pay-to-enter.

### Admin USD revenue across Free/Paid plan activity
- Owner চান Admin-এর USD revenue ledger-এ Free Plan ও Paid Plan—দুই ধরনের plan activity থেকে প্রাপ্য প্রকৃত platform revenue সঠিকভাবে ধরা হোক। **Eligible, settled USD net revenue-এর 100% approved Admin entitlement হিসেবে ledger-এ post/reconcile হবে**, তবে entitlement-এর rate/amount কেবল approved financial schedule ও actual source transaction অনুযায়ী নির্ধারিত হবে; gross plan price বা কৃত্রিম fixed USD credit নয়।
- Free Plan নিজে কোনো payment নেয় না; তাই শুধু Free Plan active থাকায় USD আয় সৃষ্টি হয় না। Free Plan ব্যবহার করে বাস্তব customer-paid service/order সম্পন্ন ও payment settle হলে, tax/fees/refunds/chargebacks/direct costs/member payable/reserves বাদ দিয়ে অবশিষ্ট eligible net platform revenue থেকে approved Admin share হিসাব হবে।
- Paid plan-এর মূল্য বাস্তবে customer/member থেকে আইনসম্মতভাবে আদায় ও settle হলে, refund window/liabilities, tax, gateway/FX charges, delivery/provider costs ও member liabilities বাদ দিয়ে প্রকৃত net revenue হিসাব হবে। সাধারণ সদস্যের জন্য paid plan কখনো বাধ্যতামূলক নয় এবং plan কেনা কাজ/আয়/bonus draw-এর শর্ত নয়।
- যদি Admin নিজেই Paid Admin Plan কেনেন, সেটি Admin-এর operating expense; নিজের payment-কে নিজের income বলা যাবে না। Plan payment, Admin operating cost, Company Revenue ও Admin Profit আলাদা ledger-এ থাকবে।
- “Admin 100% নিশ্চিত USD পাবে” কথাটি কেবল **যে প্রকৃত eligible settled net revenue ইতিমধ্যে অর্জিত হয়েছে, তার অনুমোদিত Admin entitlement 100% সঠিকভাবে ledger-এ নথিভুক্ত/settle করা হবে**—এই accounting guarantee-তে সীমাবদ্ধ। Free plan বা plan purchase মাত্রেই guaranteed USD income, নির্দিষ্ট ডলার অঙ্ক বা profit guarantee নয়। কোনো settled eligible revenue না থাকলে Admin USD accrual = 0.
- Member Auto Work package checkout/execution বর্তমানে DISABLED থাকবে যতক্ষণ না 100% liquid refund reserve, separate operating fund, isolated infrastructure, provider/legal/security gates এবং acceptance tests পাস করে। এই USD reward/plan requirement ওই gate bypass করবে না.

**Implementation status:** Owner-requested product/policy documentation only. VIP screen, draw engine, USD prize reserve, RNG/audit system, USD ledger, plan checkout, payment provider, FX conversion or payout is NOT VERIFIED / NOT LIVE. No money has been created or paid by this document update.
