# MASTER WORLD VIP — Feature Completion Register

Last reviewed: 2026-11-24

This register tracks the existing repository. A feature is **not live** merely because its UI, SQL migration, or Edge Function exists. Mark a feature live only after its migration/function is deployed and its acceptance tests pass in the target project.

## Status vocabulary

- **Repository foundation** — code, UI, migration, or workflow exists in Git.
- **Integration pending** — requires a provider, secret configured in the provider's server-side secret store, or project settings.
- **Production apply pending** — migration/function must be applied/deployed to the approved Supabase project.
- **Acceptance test pending** — must pass with separate test accounts or real devices.
- **Legal/provider approval pending** — depends on external approval or legal review.

## Update 2 progress — 2026-11-22

- Member Hub UI now edits and reloads display name, username, bio, HTTPS-only avatar URL, country, and member-search visibility.
- Public member search now displays the member-provided bio alongside the already-approved public fields returned by `search_discoverable_profiles`.
- Existing server-side RBAC, owner-only role changes, audit-log RPC, private verification/helpdesk request flow, staff review, private messages, status history and notifications were present in the repository before this UI update.
- **Not yet Live:** Supabase migrations still require guarded production apply; owner bootstrap, two-account privacy/RLS tests, staff review tests, and deployment verification remain pending.

## Update 3 progress — 2026-11-23

- Added Work & Earn job board UI: job search, categories, posting, member applications, own-post management, incoming application review and accept/reject actions.
- Added additive SQL migration `20261123100000_work_earn_job_board.sql` with authenticated-only access, RLS, one-application-per-member constraint, and owner/admin review RPCs.
- **Not live yet:** production migration, Pages deployment and two-account privacy/permission tests must pass before marking Work & Earn available. No payment processing or income guarantee is included.

## Update 4 requirements — 2026-11-23: MW VIP FREE GLOBAL INTERNET

- User requirement: provide every member and the admin with no-charge access to general internet services, including Google, YouTube, Facebook, WhatsApp, web browsing and other services that require internet—not merely selected app content.
- Required experience: a clearly labelled Global Internet Connect/Disconnect area in MASTER WORLD VIP; connection and usage status; transparent data accounting; offline Maps and previously downloaded content when no live connection exists.
- User's desired coverage includes remote locations without a cellular SIM/data plan or local Wi-Fi. This requires an actual satellite or other authorized upstream network path and compatible terminal/radio hardware; the phone app alone cannot create an internet signal where no communications link exists.
- User-facing price target: **৳0 for every member and the admin**. This is a subsidy/zero-rating goal, not a claim that network capacity is cost-free. All wholesale connectivity, satellite capacity, hardware, gateway, power, roaming, support and regulatory costs must be funded by MASTER WORLD VIP, sponsors, donors or an approved connectivity partner. Do not promise unlimited or worldwide coverage until contracted capacity and coverage are verified.
- Required provider work: obtain written commercial and technical proposals from satellite/mobile/network providers; verify Bangladesh and target-country licensing, coverage, terminal compatibility, roaming, throughput, latency, fair-use limits, service availability and wholesale pricing; obtain authorization for any direct-to-device service.
- Required architecture: provider-approved satellite terminal or direct-to-device service -> authorized gateway/backhaul -> authenticated MW VIP member access -> usage/accounting and abuse controls. Never bypass carrier billing, network access controls, SIM restrictions or provider authentication.
- Required safety/security: use encrypted transport, per-member authentication, rate limits, abuse prevention, privacy-minimizing logs, clear outage/status indicators and emergency-use disclaimers. Do not collect members' third-party Google/Facebook passwords or OTPs.
- Offline fallback: downloadable offline maps and user-selected cached content can work without a live connection, but cannot provide live search, streaming, messaging or current website data while disconnected.
- **Status: Requirements recorded only — NOT implemented, NOT connected, NOT free/live.** No satellite provider contract, hardware deployment, gateway, funded data capacity, app UI, backend service or real-device acceptance test is confirmed by this entry. Do not represent this as an available feature.
- Implementation gates: (1) select and contract an authorized provider; (2) approve sustainable funding for the ৳0 member price; (3) deploy compatible terminals/gateways and coverage; (4) implement secure app/backend integration; (5) test in Bangladesh and each claimed coverage area; (6) publish only verified service limits and mark Live only after all tests pass.


## Update 5 progress — 2026-11-23: Global Internet app-side foundation

- Added a dedicated **MW VIP FREE GLOBAL INTERNET** page and navigation entry to the existing PWA.
- Added Connect control that clearly reports provider integration is not configured; it does not fake a satellite connection. Disconnect remains disabled until a real provider session exists.
- Added a real diagnostic that checks the device's current network path to the app's own manifest endpoint and labels the result as app-host connectivity only—not satellite service.
- Added a seven-milestone Global Internet rollout checklist to the Update Manifest and connected it to both the Global Internet page and Update Center. The checklist tracks Pages deployment, provider, authorized contract/API, terminal, gateway/backhaul, funding for ৳0 member pricing, and real-device service tests.
- The previous UI foundation's GitHub Pages deployment workflow completed successfully. The new checklist changes still require their own deployment and browser verification.
- **Status: UI foundation deployed; checklist update pending deployment. Satellite provider/API/contract, terminal, gateway, funded data capacity and actual satellite internet remain NOT connected and NOT live.** The diagnostic cannot create internet access and cannot test connectivity with no network.

## Update 7 progress — 2026-11-24: Referral Wallet & Reward implementation foundation

- Added `202611240003_referral_wallet_rewards.sql`: fixed BDT 50 reward, 24-hour account-age qualification, email-confirmed/profile-complete/currently-not-banned eligibility, unique reward per referral, append-only wallet ledger, funding records, member withdrawal requests and Owner/Admin review RPCs.
- Reward processor is server-only. A service-role-only database RPC is called by `process-referral-rewards` Edge Function; a 15-minute GitHub Actions schedule invokes it with a protected cron secret. Rewards default to paused and cannot be enabled until at least ৳৫০ confirmed budget is recorded.
- Added Member Referral Wallet UI, bKash/Nagad withdrawal-request UI, Admin reward funding/pause controls, and withdrawal approval/rejection/manual-paid workflow. A withdrawal can only be marked paid with an actual transfer reference.
- Added `referral-wallet-two-member-test.sql` and a dedicated manual GitHub Actions test workflow; added the referral migration files to the guarded migration preflight.
- Fixed the referral UI's inline script being placed inside an external-script tag, and refreshed the PWA cache version to v29.
- **Current verification:** Node inline-JavaScript syntax check passed in the GitHub Actions run. The broader static safety workflow currently failed on a stale cache-version assertion (expected v25 while the app cache was v28); the assertion was updated to v29. A fresh run is required to confirm the full suite.
- **Not live:** production migration not applied/verified; Edge Function deployment and cron secrets not confirmed; reward fund not actually funded; two-member test not yet run; no automatic bKash/Nagad API payout. Until these gates pass, do not show cash as available or advertise the referral reward as live.
- Detailed rollout steps: [Referral System Acceptance Test (Bangla)](REFERRAL_SYSTEM_ACCEPTANCE_TEST_BN.md).

## Update 8 — 2026-11-24: In-app Gmail OTP verification and deployment checks

- Registration UI now includes a Gmail verification-code input, a Verify button and a Resend code action. It uses Supabase Auth `verifyOtp({ type: 'signup' })` and `resend({ type: 'signup' })`; verification codes stay with the member and must never be sent to chat or an Admin.
- Supabase Dashboard setup is documented in the app: enable Email provider, set Site URL/Redirect URLs, and configure Authentication → Email Templates → Confirm signup to display `{{ .Token }}`. Until the template is configured and a real inbox test passes, OTP delivery is not verified.
- Fixed the guarded migration preflight's migration-file loop so it checks each required migration file before dry-run.
- Added deployment verification for the in-app OTP UI and PWA cache v30. Static migration-safety workflow passed on commit `afbc12fd54a316335fe3b1f08bc63d246c6a9b2a`; latest Pages deployment for the newer commit is still in progress.
- **Still blocked/not live:** Production Supabase migration requires configured GitHub Actions secrets, a verified restorable backup and explicit authorization; no real reward funds have been added; two distinct test-member accounts and their end-to-end test are not yet available; bKash/Nagad payout remains manual until official API/merchant integration. Do not advertise rewards as live.
 
## Update 9 — 2026-11-24: Database safety execution runbook

- Added `docs/DB_SAFETY_EXECUTION_STATUS_BN.md` with the exact safety sequence, secret-to-workflow matrix, known unknowns, evidence requirements and explicit production-apply blockers.
- Updated `docs/SUPABASE_BACKUP_RESTORE_TEST_BN.md` to distinguish secrets required by backup, dry-run, secure migration and two-member tests, and to document the 7-day GitHub artifact retention plus off-platform encrypted backup requirement.
- Repository inspection confirms the encrypted backup/restore/preview workflow, secure migration workflow, migration dry-run workflow and two-member RLS/referral test workflows exist.
- **Not verified from repository access:** whether GitHub Actions secrets are present; whether Supabase has a current recoverable backup; whether the encrypted backup/restore workflow has passed on current secrets; whether production Owner identity/bootstrap is correct; whether migrations are applied; whether the two-member tests passed.
- **No production database changes were made.** No secret values were read or changed. Production migration remains blocked until real backup, separate restore test, migration preview review, Owner verification and explicit authorization are completed.
- Next operator step: configure/check the listed GitHub Actions secret names in repository Settings, then manually run `backup-restore-preview.yml` and preserve its encrypted artifact outside GitHub.

## Feature register

| Feature | Repository foundation | Remaining work before Live |
|---|---|---|
| Member Hub & Profiles | Supabase Auth starter, profile UI, username/bio/discovery fields and profile migrations | Fix IPv4 pooler connection; apply migrations; configure Auth Site/Redirect URLs and email; signup, confirmation, login, profile CRUD and two-user RLS tests |
| Global Community — Search, Friends & Chat | Member discovery, friend requests, accepted-friend-only direct chat RPC, public groups/group chat, inbox, read markers, broadcasts and realtime/polling fallback | Apply all required migrations in dependency order; verify profile privacy, direct/group membership RLS, read/unread, broadcast authorization and rate limit with two accounts |
| MW VIP FREE GLOBAL INTERNET | Requirements documented; PWA page, provider-pending Connect/Disconnect UI, app-host connectivity diagnostic, seven-step rollout checklist linked to Update Center, update-manifest entry and cache v26. Previous UI foundation Pages deployment succeeded; new checklist deployment/browser tests pending. No satellite service connected. | Obtain authorized provider contract and sustainable funding; verify regulatory approval, coverage, compatible satellite/direct-to-device hardware and gateway; implement app/backend connection and usage controls; test actual connectivity. **No free internet service is currently implemented or live.** |
| Live Number Location Map | Consent-based location migration and UI; verified phone lookup, sharing toggle, timestamp/freshness checks and map presentation foundation | Apply migration; configure browser geolocation permissions; verify phone numbers through Auth; test opt-in/opt-out, stale/offline behavior, lookup rate limit and no disclosure when sharing is off. A phone number/SIM alone must never reveal GPS |
| AI Text & Voice Assistant | AI assistant Edge Function foundation | Choose provider/model; configure provider API key only in Supabase Edge Function secrets; deploy function; implement/test voice input/output, usage limits, abuse controls and error handling |
| AI Image Search + License | AI Center UI placeholder | Select a licensed image/search provider; configure server-side credentials; return attribution, source URL, license and permitted-use metadata; test rights/attribution display |
| Facebook Public Discovery | Facebook Center UI and consent/privacy notes | Create Meta app; use only approved Graph API permissions and permitted public data; complete Meta review where required; never scrape private data or collect Facebook passwords/OTPs |
| Active User Finder | Consent-based AI/manual workflow concept | Implement explicit opt-in availability state, expiry, block/report controls and rate limits; never infer activity from phone/SIM or expose precise location without consent |
| Global Promotion & Referrals | Referral codes/attribution; Bangladesh BDT 50 and foreign USD 50-equivalent BDT policy; migration `202611240005_international_referral_usd_equivalent.sql` adds Owner-managed USD/BDT rate, source/reference audit and country/rate-based ledger calculation; Owner FX rate panel; existing funded wallet, scheduled processor and member/admin UI | Production migrations and Edge Function deploy; Owner must enter a reliable current FX rate and source/reference; profile country accuracy/verification must be established; add only real confirmed BDT reward funding (foreign award may be about ৳৬,৫০০ at ৳১৩০/USD); run two-member privacy and 24-hour end-to-end acceptance tests; bKash/Nagad payout is manual, and foreign-country payout providers are not integrated. **Not live/verified yet.** |
| Admin, Roles & Audit Logs | RBAC/owner-control and audit migrations, admin UI and server-side function foundation | Verify intended owner account before bootstrap; apply migrations; audit all privileged RPC/RLS paths; test member/admin separation, role escalation denial and audit completeness |
| Privacy, GDPR & Consent | Privacy rights/consent migration and UI foundation | Publish accurate privacy/cookie/retention policy; implement access/export/correction/deletion workflow and consent withdrawal; appoint contact/processors; obtain jurisdiction-specific legal review. Do not claim GDPR certification |
| Notifications & Support | Inbox/read markers/push subscription foundation, helpdesk schema and UI | Apply migrations; configure VAPID/Web Push sender secrets and database webhook; test Android Chrome/PWA delivery; native APK push requires separate FCM integration |
| Member Verification & Private Helpdesk | Private request, member/staff message thread, review status/events and notification migration/UI | Apply migration; test member privacy, staff queue, needs-info/reply, decisions, rate limits and audit trail with separate member and staff accounts. Never collect passwords, OTPs or login codes |
| Landing Page & Play Store | GitHub Pages/PWA foundation and app manifest | Finalize public landing page, signed Android App Bundle, developer account, store listing, privacy/data safety declarations, screenshots, policy review and Play approval |

## Safe execution order

1. **Repair database connectivity:** configure GitHub Actions secret `SUPABASE_DB_URL` with the Supabase Session Pooler connection string that uses the IPv4-compatible pooler host. Do not put the URL/password in chat or source code. The secure database workflow now validates the pooler host and uses `--db-url` for dry-run and apply.
2. **Preview only:** run the secure database workflow with `apply_migrations=false`; inspect the full pending migration list and confirm the target project. The workflow must not change the database during preview.
3. **Review the complete migration set:** the guarded push applies every pending migration in timestamp order, not only the newest feature. Verify the Owner bootstrap email, migration order and every pending change.
4. **Backup gate:** follow [the Bengali backup/restore test guide](SUPABASE_BACKUP_RESTORE_TEST_BN.md); confirm a current recoverable backup and genuinely restore it to a separate test project/local environment. Record a non-secret backup ID/reference and a separate restore-test reference.
5. **Explicit authorization:** production apply requires the exact phrase `APPLY-MASTER-WORLD-VIP-MIGRATIONS`, `backup_confirmed=true`, `restore_tested=true`, and both non-secret references. The workflow checks supplied references but cannot independently prove a human performed the restore; never set the boolean without completing the test.
6. **Apply and verify:** after a successful workflow, inspect schema/RLS and run the two-member RLS, chat, group, broadcast, location and helpdesk acceptance tests.
7. **External integrations:** configure AI, image licensing, Meta, push and Play services separately. Keep all private credentials in the provider's server-side secret store.

## Security invariants

- Browser code may contain only the Supabase project URL and publishable/anon key. Never put `service_role`, `sb_secret`, database passwords, provider keys, VAPID private keys or GitHub tokens in the website.
- Location sharing is opt-in and revocable. Phone verification is not GPS permission.
- Facebook integration uses only approved Meta APIs and public/consented data.
- Admin authorization is enforced server-side with RLS/RPC checks, not by hiding UI buttons.
- Keep message, profile, helpdesk and location data private by default.
- Do not label any feature **Live** until deployment and its real acceptance test both pass.


## Update 6 — 2026-11-24: Approved free referral reward terms

- User-approved terms recorded in [Referral Reward Policy (Bangla)](REFERRAL_REWARD_POLICY_BN.md): free signup and referral; no deposit or mandatory purchase for inviter or invitee; 24-hour account-good-standing qualification period (not 24-hour continuous online use); verified email and profile completion; ৳৫০ BDT per eligible direct referral.
- Self-referrals, duplicate/fake accounts and attribution manipulation are disallowed; qualification and reward approval must be server-side, idempotent and audited.
- Reward source must be a pre-funded, available platform marketing/reward budget. If budget is unavailable, pause issuance; never fabricate a cash balance or require members to deposit.
- **Status: Policy approved and documented only — NOT live.** The existing referral code/attribution and stats foundation exists, but qualification workflow, funded reward ledger, payout integration and acceptance tests remain pending. Production migrations must follow the existing backup/dry-run/explicit-authorization process.

## Public Member Referral Identity — 2026-11-24
- Added a system-managed public member profile route using `?member=<member-id>`.
- Added the permanent “MASTER WORLD VIP-এর মাধ্যমে যুক্ত” identity badge and stable referral code display.
- Added a public RPC that returns only explicitly discoverable profile fields and the member's referral code; it does not expose email, phone, or private account data.
- Added a direct referral join URL so visitors can open MASTER WORLD VIP and register with the referring member's code.
- New migration: `202611240002_public_member_referral_profile.sql` (depends on the base profiles and referral-code migrations, including `202611240001_member_referrals.sql`).
- Pending: apply migrations in the approved order after backup/dry-run/explicit authorization; verify anonymous public-profile access, privacy toggle behavior, referral attribution, and two-account registration. GitHub commits do not by themselves deploy or activate the feature.


## Update 10 — 2026-11-24: Admin/Owner compensation and revenue-share requirement

- Recorded the Owner/Admin compensation request as a separate business-policy item; it is distinct from the approved ৳৫০ direct-referral reward.
- Being an Admin, or a member using the site for one month, does **not** automatically create a commission entitlement unless the platform's published terms, an approved Owner agreement and the implemented billing/revenue ledger explicitly provide it.
- Proposed accounting basis for future approval: calculate any Owner share only from actually collected, settled platform revenue; exclude free usage, unpaid invoices, refunds, chargebacks, taxes and payment-provider fees; show the calculation period, source transaction, rate, adjustments and payout status in an auditable Owner ledger.
- Do not invent or activate a commission percentage, monthly fee, member charge or payout schedule. These remain **Owner decision pending** and require confirmation of the intended revenue model and rate, plus applicable legal/tax/payment-provider review.
- The ৳৫০ referral reward remains a separate, pre-funded marketing reward with its existing eligibility rules; it must not be counted as Owner commission or funded from member deposits.
- **Status: requirement documented only — no commission has been configured, accrued or paid.** No new paid subscription or fee is being introduced by this documentation update.

## Update 11 — 2026-11-24: Owner-approved ৳১,০০০ monthly minimum compensation policy

- The Owner approved a **৳১,০০০ BDT monthly minimum Admin/Owner compensation target**, separate from the one-time ৳৫০ eligible direct-referral reward.
- If calculated eligible monthly commission exceeds ৳১,০০০, record the higher amount. If it is lower, record the shortfall separately so the monthly target remains ৳১,০০০.
- If funds are unavailable, the shortfall may be shown only as an **unpaid/outstanding internal payable** under the approved policy; it is not cash, a withdrawable wallet balance, or evidence that funds exist. Do not mark it paid until an actual lawful transfer is reconciled.
- Member registration and access remain free. Do not fund Owner compensation from member deposits, hidden fees or mandatory purchases. Use only real platform revenue, sponsorship or a separately approved Owner funding allocation.
- Policy details: [Admin/Owner Monthly Compensation Policy](ADMIN_OWNER_COMPENSATION_POLICY_BN.md).
- **Status: policy approved and committed; technical implementation NOT live.** No compensation ledger/UI, monthly accrual automation, funding reserve, payout integration, Supabase migration or payment has been implemented or verified by this documentation update. These require separate code, security review, deployment and acceptance tests.

## Update 12 — 2026-11-24: Owner compensation ledger implementation foundation

- Added additive migration `202611240004_owner_monthly_compensation.sql` with private monthly compensation and payment tables, Owner-only RPCs, append-only payment records, duplicate-month/payment-reference controls and Admin audit events.
- Added the Owner-only monthly compensation panel inside the existing Admin & Security page. It displays minimum, total due, paid and outstanding amounts; monthly history; commission/source/reference entry; and recording of a real transfer after it occurs.
- Monthly accrual is idempotently generated/backfilled from November 2026 when the verified Owner opens or refreshes the panel. Added a monthly GitHub Actions schedule (00:10 UTC on day 1) using the SUPABASE_DB_URL secret to create missing month rows. **The schedule is committed but has not been verified in a live run; it requires the migration to be applied and the secret to exist.** The Owner must manually enter eligible settled commission and evidence; the platform does not yet calculate revenue share automatically.
- The payment form records an actual transfer reference only after money has been sent externally. It does not connect to or initiate bKash, Nagad or bank transfers.
- Added static safety checks in `scripts/verify-owner-compensation.py`, included the new migration in the guarded production migration preflight, and added `supabase/audits/owner-compensation-access-test.sql` plus `docs/OWNER_COMPENSATION_ACCEPTANCE_TEST_BN.md` for Owner/member security acceptance.
- **Status: code and migration foundation committed; NOT production-live or payment-enabled.** Supabase migration apply, Pages deployment, CI safety run, scheduled accrual run, Owner-role verification, separate ordinary-member access-denial test and end-to-end ledger acceptance remain pending. No money was funded, accrued in production, or paid by this commit.
- Details: [Admin/Owner Monthly Compensation Policy](ADMIN_OWNER_COMPENSATION_POLICY_BN.md).


## Update 13 — 2026-11-24: Direct member 100% + Owner network 100% referral rewards

- User-approved rule: each ordinary member receives 100% of the standard reward for their own direct eligible referral only. The single verified `owner` account receives an additional 100% standard reward for every eligible referral event across the entire network, at any depth.
- The Owner network credit is additional to the direct member credit. Combined reward liability is 200% per eligible referral event (Bangladesh example: member ৳50 + Owner ৳50 = ৳100 total; foreign example at 1 USD = ৳130: member ৳6,500 + Owner ৳6,500 = ৳13,000 total).
- Added migration `202611240006_network_admin_referral_rewards.sql`: separate `member_direct` and `owner_network` ledger kinds; pending entitlements for both beneficiaries; a service-role-only processor that releases both credits atomically only when the complete 200% amount is covered by confirmed funds; one-verified-Owner guard; duplicate prevention; member-private pending amount RPC; Admin network commission summary RPC.
- Updated Referral Wallet and Owner/Admin finance UI to show pending rewards and Owner network pending/credited totals. Updated referral policy, acceptance tests, static verification checks, guarded migration preflight, Pages release checks, and PWA cache version v33.
- **Status: code committed to the existing repository; GitHub Pages deployment and live-release check succeeded; static safety verification succeeded.** Production Supabase migration 006 has not been applied, and no new 200% funding is recorded. The backend reward processor therefore is not live yet. Existing migration, FX setup, exactly-one-Owner role check, cron deployment/secrets, two-member/deep-tree acceptance tests and real funding/payout remain required. This update does not generate money or guarantee a payout.


## Update 10 — 2026-11-24: Zero personal-cost operating policy

- User direction: keep Owner/Admin permissions and the approved 100% Owner network reward; make registration and member participation free; do not require the Owner to seed the reward fund personally and do not charge members any fee, deposit or purchase.
- Referral cash rewards remain the previously approved 100% direct-member + 100% Owner network policy. Cash release is allowed only from confirmed genuine platform income, voluntary sponsor/donor funding or another lawful third-party fund. If no such funds exist, the cash processor must remain paused and must not display unfunded amounts as available or withdrawable.
- The Admin funding UI now labels the source as Platform Income / Sponsor Fund and explicitly states that Owner personal funding is not mandatory and members must never be charged.
- Preserve existing Owner/Admin controls, audit trails, country/FX checks and fraud protections. Do not introduce paid API, merchant, subscription or infrastructure dependencies as mandatory requirements; where a free-tier limit is reached, pause or use a safe fallback rather than incur charges.
- **This commit changes policy/UI wording only.** It does not fund the reward pool, apply Supabase migrations, deploy Edge Functions, activate cash rewards, create real money, or enable automatic bKash/Nagad payouts. Production migration and acceptance gates remain unchanged.


## Update 14 — 2026-11-24: Zero-cost policy deployment verified

- Verified GitHub Actions Pages run `45436255175` for commit `1cbc26fe0c63a32a50fc6b933ab0f2adbaf95de3`: build, deploy, and the dedicated **Verify live GitHub Pages release** job all completed successfully.
- The deployed site includes the Owner-personal-funding-not-required wording and the Admin funding-source label **Platform Income / Sponsor Fund**. The existing Owner/Admin controls and 100% direct-member + 100% Owner network reward policy remain in place.
- **Resolved:** the previously pending Pages deployment for the zero-personal-cost policy update is now successful.
- **Still not live:** Supabase production migrations (including referral migration 006), referral Edge Function/cron integration, funding confirmation, two-member/deep-tree tests, and automatic bKash/Nagad payout. No production database migration was applied by this deployment.
- No personal payment, deposit or paid service was initiated by this update. Free-tier limits still apply; no guarantee of unlimited free hosting, SMS, data, payment processing or provider capacity is made.


## Update 15 — 2026-11-24: Referral payout reference integrity hardening

- Added additive migration `202611240007_referral_payout_reference_hardening.sql` to require every Paid withdrawal to retain a non-empty 4–120 character transfer reference, a reviewer and a paid timestamp.
- Added a case-insensitive unique index per payout method so the same bKash or Nagad transaction reference cannot be reused to mark multiple withdrawal requests Paid. The migration stops with a clear error if existing Paid rows are incomplete or duplicate; it does not silently rewrite historical payout records.
- Included migration 007 in the guarded Supabase migration preflight and expanded `scripts/verify-referral-rewards.py` to check the new payout protections and the shared authenticated wallet/withdrawal path for both ordinary members and the Owner.
- **Not production-live:** this is a code/migration hardening change only. It does not send money, add funds, enable cash rewards, or mark any request Paid. The migration remains pending until the documented recoverable-backup, restore-test and exact authorization gates are completed. Static CI and live Pages verification are pending for this commit.

## Update 16 — 2026-11-25: Referral migration and preflight corrections

- Fixed five malformed PL/pgSQL dollar-quote delimiters in `202611240005_international_referral_usd_equivalent.sql` and replaced two literal escaped-newline sequences with actual SQL line breaks. These defects could have prevented the international referral migration from applying.
- Extended `scripts/verify-referral-rewards.py` with regression checks for balanced SQL function delimiters and malformed escaped line breaks.
- Corrected `.github/workflows/apply-supabase-migrations.yml`: its expected-migration loop now checks that every listed migration file actually exists, and fixed a malformed shell line continuation in the migration list.
- **Code updated in the existing GitHub repository. Not yet production-live:** this commit does not apply Supabase migrations, deploy the Edge Function, configure secrets, add real reward funding, run the two-member acceptance test, or transfer money. The automated verification run and deployment evidence must be checked before calling the code update validated; production still requires the documented recoverable backup, successful restore test, dry-run review and exact authorization.


## Update 17 — 2026-11-25: Separate Company Revenue and Referral Reward accounts

- Owner direction confirmed: Company Revenue and Referral Rewards must be two separate financial systems. Company revenue sources are advertising/sponsorship, the platform's own digital services, completed marketplace commissions, and approved partner commissions.
- Added `docs/COMPANY_REVENUE_AND_REFERRAL_SEPARATION_BN.md` defining separate Company Revenue, Referral Reward Fund, and Owner/Admin Compensation ledgers; source references and reconciliation; explicit Owner-approved allocation; no mandatory personal Owner funding; no member deposits/hidden fees; and no automatic diversion of customer promotional spend to Admin.
- The existing referral reward entitlement/funding workflow remains distinct. A referral entitlement can remain Pending when confirmed reward funds are unavailable; Pending is not cash or withdrawable balance.
- **Status: separation policy documented only — Company Revenue Ledger, revenue-provider integrations, revenue dashboard, allocation bridge, production migration and acceptance tests are NOT implemented/live by this documentation change.** No advertiser, sponsor, marketplace customer or partner payment was collected. Do not claim the company currently earns income from these sources.
- Next technical stage: build the Owner-only Company Revenue Ledger and dashboard, then a separately approved, audited allocation bridge from settled company revenue into the existing Referral Reward Fund. Provider choice, legal/tax review and actual collection setup are required before income can be recorded.


## Update 18 — 2026-11-25: Revenue funding map and earning roadmap

- Updated the Admin-only referral/Work & Earn policy with a clear payer map for client tasks, sponsor campaigns, marketplace commissions, partner commissions and advertising settlements.
- Clarified that the company pays approved Admin referral bonuses and Owner commission only from actually settled, legally usable funds allocated to the relevant ledger/reserve; Owner personal funding is not mandatory. Unfunded amounts remain Pending and non-withdrawable.
- Owner commission rate and calculation basis remain unset pending a written schedule; no percentage is invented and gross revenue is not double-counted.
- Added future earning features: funded microtasks, digital service storefront, templates/document services, sponsor challenges, partner offers, creator-support packages, free skill progression, marketplace commission, repeat-client quality tiers and Admin-only referral analytics.
- **Documentation only — NOT live:** no advertiser/sponsor/client/partner integrations, payment collection, Company Revenue Ledger, commission calculator or Admin-only referral code workflow was implemented or activated by this update. No revenue or payouts were created.


## Update 19 — 2026-11-25: Owner-earned revenue funding and Admin Auto Work

- Recorded the Owner's proposed operating model: where the Owner performs genuine client work under a company contract and the payment actually settles to the company, net receipts may be allocated to the Referral Reward Fund under a separately approved budget. Owner's personal earnings are not automatically Company Revenue; any voluntary allocation must be explicit and documented.
- Reaffirmed that ordinary member work pay, customer refund reserves, sponsor-restricted funds and member deposits cannot be used for Admin referral bonuses. A 24-hour account-good-standing period is not 24 hours of continuous online use; a referred member is not required to work unless separately and transparently stated in an approved policy.
- Added the **Admin Auto Work & Earn** proposal, restricted to authorized Admin roles. It may automate only genuine, permitted, paid client/sponsor/partner tasks with written scope, budget, acceptance criteria and output verification. Internet connectivity or an attempted/running job does not itself create revenue.
- Prohibited fake ad impressions/clicks/views, artificial engagement, fake signups, CAPTCHA bypass, unauthorized account activity and provider-policy violations.
- Continuous execution on Android/PWA cannot be guaranteed while the app is closed, device sleeps or battery optimization intervenes. Reliable continuous jobs require an authorized server-side queue/worker; the phone app can monitor/control jobs. Add Pause/Resume/Stop, status, logs, consent and resource-use indicators.
- Earnings are recorded only after deliverables are accepted and client/sponsor/partner funds actually settle. Record each receipt in the correct Company Revenue or Admin Work Payment ledger; keep Admin Referral Bonus and Owner Commission separate.
- **Status: policy/roadmap only — NOT implemented or live.** No Auto Work UI, background worker, paid task API, provider integration, billing, ledger automation, mobile background guarantee, deployment or acceptance test was created by this documentation update. No money was generated or paid.


## Member Auto Work package safety — Owner directive (2026-11-25)
সাধারণ সদস্যের আর্থিক সুরক্ষা সর্বোচ্চ অগ্রাধিকার। Member Auto Work বাতিল নয়, আপাতত বন্ধ; ভবিষ্যতে dedicated isolated infrastructure দিয়ে পুনরায় বিবেচনা করা যাবে। বর্তমান অবস্থায় member Auto Work execution এবং paid package checkout **DISABLED / NOT LIVE**; কোনো সদস্যের কাছ থেকে package fee/deposit নেওয়া যাবে না। Work & Earn-এর human-reviewed, funded task আলাদা নিয়মে চলতে পারে।

ভবিষ্যৎ paid package-এর আগে প্রতিটি বিক্রির সমপরিমাণ ১০০% actual liquid BDT refund reserve আলাদা রাখতে হবে; reserve server/API/operations cost, Owner profit, commission বা অন্য সদস্যের refund-এ ব্যবহার করা যাবে না। Compute/API খরচ আলাদা platform operating fund থেকে দিতে হবে। Reserve 100% না থাকলে, reconciliation stale/mismatch হলে, payment provider hold/dispute থাকলে বা আলাদা operating budget না থাকলে checkout ও নতুন jobs fail-closed হবে। নতুন সদস্যের package payment দিয়ে পুরোনো সদস্যকে refund করা যাবে না।

প্রস্তাবিত refund rule: নির্দিষ্ট evaluation period শেষে package-সম্পর্কিত client-accepted এবং payment-settled কাজ থেকে member-এর withdrawable net earning package price-এর কম হলে original package price 100% ফেরত; সদস্যের ইতোমধ্যে অর্জিত কাজের পারিশ্রমিক অক্ষত থাকবে। Platform/provider outage বা promised service না পেলে দ্রুত cancellation/full refund path থাকবে। Refund SLA, qualifying threshold, original payment route, fees এবং appeal process কেনার আগেই প্রকাশ করতে হবে; legal/payment-provider review ছাড়া এই guarantee বিক্রি করা যাবে না।

Owner commission কেবল সব member payable, refund liability, provider cost, tax/fee ও restricted customer funds সুরক্ষিত/মেটানোর পর প্রকৃত settled platform net revenue থেকে; member wage, deposit বা refund reserve থেকে নয়। Dedicated member worker/queue/storage/API credentials/budget, strict resource isolation, per-member hard caps, emergency stop, payment-provider server verification, audit logs, privacy controls, load/failure/security tests এবং independent reconciliation—সব launch gate পাস না করলে package sales/execution বন্ধ থাকবে। বিস্তারিত authoritative rules: [MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md](MEMBER_AUTO_WORK_OWNER_COMMISSION_POLICY_BN.md).

**Implementation status:** policy/document/UI source update only. No member package catalog/checkout, actual refund reserve account, payment/refund integration, dedicated member worker or payout system is live. No member payments should be collected. GitHub Pages deployment and production database migration are separate and remain subject to their own verified gates.


## Update 8 — 2026-11-25: Owner/Admin automatic profit policy (20%)

- Owner/Admin profit rate fixed by the current decision at **20% of distributable net platform revenue** (not gross client payment, member wages, package price, refund reserve or unsettled funds). Examples: ৳500→৳100; ৳1,000→৳200; ৳5,000→৳1,000; ৳10,000→৳2,000, where the input is already distributable net revenue.
- Distributable net revenue is calculated only after settled/accepted client receipts and after member payable, applicable tax/payment fees, refunds/chargebacks, provider/compute/operations costs and all protected liabilities/reserves are fully covered.
- Future Admin Settings may allow Owner/Super Admin to change the rate with an audited, non-retroactive change; default remains 20%, and the rate must be disclosed before a job/order is accepted.
- After verified settlement, member's full earned payable and Owner's eligible profit accrual are posted in one atomic, idempotent server-side ledger transaction. Separate append-only Member Wallet and Admin Profit ledgers; provider-verified events, unique idempotency keys, reconciliation and fail-closed behavior are required. No partial posting, duplicate credit, or profit from member wages/refund reserves.
- **Status: policy/documentation only — NOT live.** No production commission engine, Admin Settings, payment gateway settlement, atomic wallet posting, or Admin payout is confirmed. Member Auto Work package sales/checkout/execution remain disabled until all prior safety and legal gates pass.


## Update 9 — 2026-11-25: Work & Earn wallet and Owner profit backend foundation

- Added migration `20261125160000_work_earn_wallet_owner_profit.sql`: separate append-only member Work & Earn wallet and Owner profit ledgers; Owner-only audited commission rate (20% default); provider-verified payment event and short-lived finance reconciliation inputs; member wallet and Owner profit read RPCs; and service-role-only atomic/idempotent settlement posting.
- The settlement RPC credits the member's full approved payable and calculates Owner profit as the configured percentage of distributable net platform fee after tax, payment-provider fee, operating cost and restricted liability. It requires provider settlement, client acceptance, current reconciliation with all gates true, exact gross split and exactly one Owner. Duplicate retries do not double-credit; collisions and unsafe states fail closed.
- Added `docs/WORK_EARN_WALLET_OWNER_PROFIT_ACCEPTANCE_TEST_BN.md` and added the migration to Supabase README order and guarded migration preflight.
- **Status: CODE COMMITTED, NOT LIVE.** No production migration apply, provider webhook/Edge Function, merchant credentials, actual refund reserve custody, independently reconciled operating funds, bank/bKash/Nagad payout connector, or end-to-end test is confirmed. Wallet/accrual entries are not completed cash transfers. Member Auto Work package checkout/execution remains disabled.

## Update 20 — 2026-11-26: VIP USD Bonus Draw and Admin USD revenue policy

- Owner requested an irregular/random USD bonus experience for ordinary members in the VIP area, without promising when or who will receive USD. Recorded it as a lawful, no-purchase-necessary promotional draw only: no member deposit, mandatory paid plan, task-unlock fee or increased odds from buying a plan. It requires a separately pre-funded liquid USD prize reserve, legal review/required permits in Bangladesh and each served jurisdiction, transparent eligibility/rules, auditable random selection, fraud controls, tax disclosure and verified payout. No funded reserve/approval means no draw.
- Owner requested Admin USD accounting across Free and Paid plan activity. Clarified that Free Plan activation itself creates no USD revenue; actual customer-paid work/services performed under Free Plan may generate eligible settled net revenue. Paid plan fees count only after real provider-verified settlement and deduction of taxes, payment/FX fees, refunds/chargebacks, delivery costs, member payable and required reserves. Admin's own plan purchase is an operating expense, not income.
- The “100% confirmed Admin USD” requirement is recorded as 100% accurate ledger posting/reconciliation of an approved Admin entitlement from actual eligible settled net revenue—not 100% of gross receipts, fabricated USD, guaranteed fixed amounts or income merely because a plan is active. No eligible settled revenue = zero accrual.
- Updated policy/marketplace/earning requirements and handover. **Documentation only / NOT LIVE:** no VIP UI, USD draw engine, funded prize reserve, RNG/audit system, Admin USD ledger, plan checkout, payment/FX integration, legal approval or payout was implemented by this update. Existing database backup/restore and migration gates remain unchanged.


## Update 21 — 2026-11-26: 4,000-project dual-currency automation target

- Recorded Owner target: 4,000 project slots under one automation control plane: 2,000 USD-denominated revenue projects and 2,000 BDT-denominated revenue projects, with separate immutable currency ledgers and settlement/reconciliation.
- Recorded Admin access model: one Free Admin entitlement plus one Paid Admin plan. Ordinary Members activate plan-linked automation only after a real provider-verified paid-plan settlement and entitlement checks. A paid plan does not guarantee tasks, work, income or profit; no fabricated balance or self-purchase revenue.
- Added docs/4000_PROJECT_AUTOMATION_AND_DUAL_CURRENCY_REVENUE_BN.md with architecture, accounting, status and acceptance gates.
- Existing repository foundations include AI assistant function, Work & Earn board/migration, referral wallet/reward foundation, verified-payment/checkout migration source and Work & Earn wallet/Owner-profit settlement migration source. These are not proof of a live 4,000-project fleet, production checkout/entitlement activation, company revenue ledger, USD/BDT payout or settled income.
- Member Auto Work paid package checkout/execution remains DISABLED / NOT LIVE until its existing 100% liquid refund reserve, separate operating budget, isolated infrastructure, verified provider integration, legal/security review and acceptance tests pass.
- **Status: requirements/specification only — NOT LIVE.** No new customer payments, project workers, income, migration apply or deployment resulted from this update.


## Update 22 — 2026-11-26: Free + Paid option clarified for every project; automation progress audit

- Owner clarified that all 4,000 project slots (2,000 USD + 2,000 BDT) must each expose two access options: Free Option and Paid Automatic Plan.
- Admin may use the Free Option across the project portfolio and may purchase the Paid Plan. Ordinary Members activate paid automation only after provider-confirmed settlement and server-side entitlement checks. The two options mean Free + Paid, not two paid tiers; pricing/limits/features remain to be specified.
- Progress audit: repository contains operational GitHub Actions workflow source for daily backup/restore preview, weekly read-only database audit and six-hour database health monitoring; these automate infrastructure checks, not customer earning projects.
- Existing product foundations include AI Assistant Edge Function, Work & Earn board/migration, referral wallet/reward foundation, verified-payment/checkout migration source, and Work & Earn wallet/Owner-profit settlement migration source.
- Missing/not verified as live: 4,000-project registry/orchestrator/worker fleet; project queues/schedulers/budget enforcement; Company Revenue Ledger; complete plan checkout→verified webhook→entitlement activation; production USD/BDT revenue and payout integrations; Admin/Member entitlement enforcement; full acceptance/load/security tests.
- **Status: foundation + specification only; NOT LIVE as a 4,000-project earning system.** No new customer payment, revenue, payout, production migration or deployment was performed.


## Update 23 — 2026-11-26: Step 1 implementation — 4,000-project registry source

- Added `supabase/migrations/20261126100000_earning_project_registry.sql`.
- Registry schema includes stable project code/number, USD/BDT group, lifecycle state, Free/Paid option flags, paid-plan configuration state, execution/revenue kill-switch defaults, payer model, budget cap and JSON configuration.
- Seeds exactly 4,000 planned slots: MW-USD-0001..2000 and MW-BDT-0001..2000. Both option flags are enabled for every catalog row; paid plans remain unconfigured.
- Safety defaults: execution_enabled=false, revenue_collection_enabled=false, budget_cap=0. No payment, worker, revenue or payout is initiated.
- Added read-only audit query at `supabase/audits/4000_project_registry_read_only.sql`, and documented migration order in Supabase README.
- **Status:** migration and audit source committed to feature branch; not applied to Supabase production. Disposable CI validation must pass before Step 1 can be marked verified. This is a project catalog registry, not 4,000 working/earning projects.


## Update 24 — 2026-11-26: Step 2 — Central 4,000-project automation engine source

- Added `20261126110000_project_automation_engine.sql`: per-project scheduler configuration, worker registry and heartbeat, idempotent task queue, lease-based worker claims, bounded retries/dead-letter handling, audit log and Admin overview RPC.
- Added hard gates: all scheduler rows are opt-in and absent by default; scheduler enqueue only considers registry projects with execution_enabled=true and a positive approved project budget; worker RPCs are service_role-only; worker currency support, fresh heartbeat, lease token, per-task budget and per-project daily budget are checked. One running task per project is enforced.
- Added a read-only audit SQL file and static verifier, and wired the verifier into the Supabase migration safety workflow.
- No worker service, external provider connector, payment collection, revenue recording or payout is deployed by this source migration. No project is enabled by default; the 4,000 registry rows still have execution disabled and zero budget.
- **Status:** source files committed to the feature branch; GitHub Actions and disposable SQL validation pending. Not applied to Production, not deployed, and not generating income.

- **CI result:** GitHub Actions migration-safety Run `45866578250` passed, including the new central automation verifier (job `140070826818`, step 8). Auto Work static safety Run `45866578261` also passed. Static checks do not prove PostgreSQL runtime correctness; disposable-database SQL validation remains pending.


## Update 25 — 2026-11-26: Customer-led projects, 10M+ customer ambition and Member financial protection

- Owner requirement: real customers must bring genuine paid work/orders/service requests to the relevant projects; fake customers, fake orders, fake tasks and artificial revenue are prohibited.
- Long-term ambition: 10,000,000+ real customers. This is a target, not an achieved customer count, forecast or guarantee. Growth and capacity claims require measured acquisition, retention, support, fraud, load and unit-economics evidence.
- Member safety requirements: no mandatory deposit/recharge/unlock fee to access work; paid plans remain optional and never guarantee work or income; customer-funded orders must have server-side verified settlement and segregated funding before a Member starts work.
- Scope, price/currency, deadlines, acceptance, cancellation, dispute/refund and Member payable must be clear before work starts. Member payable, refund liabilities and platform operating funds must be accounted separately.
- Require idempotent provider settlement, duplicate/fraud checks, audit trails, chargeback/refund workflow, incident freeze/kill switch and customer support. Never ask Members to cover customer payment shortfalls from personal funds.
- No software can guarantee zero risk in every circumstance; funded-order gates, reserves, controls and dispute handling are mandatory launch acceptance criteria.
- Updated the main architecture spec Section 10 and handover. Requirement recorded only: no customer acquisition system, customer count, funded reserve, payment integration or loss-free guarantee is thereby live.


## Update 26 — 2026-11-26: Step 3 — Free/Paid plan catalog ও customer funded-order gates (source foundation)

- Added `20261126120000_free_paid_plan_customer_order_gates.sql` with separate Admin/Member plan catalog, paid-plan subscription entitlement records and customer service order records.
- Paid catalog rows are not seeded/enabled; paid plan requires a positive configured price and billing period. Active subscription requires provider transaction/event identifiers, positive settled amount and server-settled timestamp.
- Customer service orders require a strictly positive customer price; funded/in-progress/delivered/accepted/completed states require server-verified provider settlement, segregated funds, independently verified refund reserve and operating budget, plus sufficient gross allocation to cover Member payable, refund liability and operating costs.
- Customer free browsing/quote is distinct from paid work delivery. No zero-price customer service order can be created by this schema.
- RLS restricts reads to enabled catalog / own subscriptions / own orders; all writes are service-role only. Added static verifier `scripts/verify-plan-customer-order-gates.py` and wired it into migration-safety workflow.
- **Not live:** no checkout, provider webhook, payment capture, plan activation, reserve custody, worker execution, payout, production migration apply or live deployment. Prices/features remain intentionally unconfigured; no fees should be collected on the basis of this schema alone.


## Update 27 — 2026-11-26: Member fund protection hardening

- Strengthened Step 3 migration with `customer_order_fund_allocations`: three separate order-level buckets (Member payable, refund reserve, operating cost), unique per order/bucket, currency and reconciliation reference.
- Funded/in-progress order transitions now require exactly three matching locked allocations, verified provider settlement, external fund-segregation timestamp, refund-reserve verification, operating-budget verification, active project and complete scope terms.
- Added static checks for the three protected allocations and fail-closed order transition.
- **Important limitation:** database allocation rows/timestamps are internal evidence only; they do not establish real bank custody, trust/safeguarded account, provider settlement or actual payout. Dedicated lawful custody, signed provider webhooks, daily reconciliation, dispute/chargeback operations and payout rails remain mandatory before launch. No Member funds have been collected or secured by this source change.


## Update 28 — 2026-11-26: Member Loss-Prevention Hard Security (database guard foundation)

- Added `20261126130000_member_loss_prevention_hardening.sql`: immutable customer-order financial terms, immutable funded-order scope/settlement evidence, append-only fund allocations, allow-listed forward-only order lifecycle and protected-order delete prevention.
- The guards are database triggers and also apply to service-role writes; a correction requires cancelling/replacing the order rather than silently rewriting financial allocation history.
- Extended `verify-plan-customer-order-gates.py` to assert these controls. This is static source-level validation, not a substitute for disposable PostgreSQL execution/integration tests.
- **Not live:** migration not applied to Production; no actual bank custody/safeguarded reserve, signed payment webhook, solvency monitor, refund/chargeback/payout rail or compensation fund is connected. These controls reduce tampering and unsafe state changes but cannot guarantee lifetime zero loss or prove money is held.


## Update 29 — 2026-11-26: Double-entry ledger and guarded payout/refund foundation

- Added immutable, balanced, idempotent USD/BDT journal posting and per-Member payable overdraft protection in `20261126140000_append_only_double_entry_finance_ledger.sql`.
- Added guarded Member payout/customer refund requests with pending-balance reservations, immutable terms, restricted state transitions and paid-state requirements for provider settlement evidence, reconciliation and matching ledger journal in `20261126150000_guarded_member_payout_refund_workflows.sql`.
- Added static verifiers and disposable PostgreSQL 16 runtime test workflow. The runtime test checks balanced posting, idempotent retry, cross-currency rejection, immutable journals, Member overdraw prevention and payout state completion.
- **Not live:** no provider-specific signed webhook, safeguarded bank/custodian account, funded reserve, external payout/refund rail, or daily independent bank reconciliation is connected. Ledger/request rows are not cash custody or transfers. Production migration not applied.
