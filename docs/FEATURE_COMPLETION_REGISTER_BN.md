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
| Global Promotion & Referrals | Referral codes/attribution and stats; approved BDT 50/24-hour policy; migration `202611240003_referral_wallet_rewards.sql` for server qualification, funded wallet ledger, Owner funding/pause controls, member withdrawals and Admin review; scheduled processor Edge Function/workflow; member/admin UI; two-member security test | Production migrations and Edge Function deploy; configure `REFERRAL_CRON_SECRET` in Supabase and GitHub Actions plus `SUPABASE_URL`; add only real confirmed reward funding; run two-member privacy and 24-hour end-to-end acceptance tests; bKash/Nagad automatic payout still requires official merchant/API integration. **Not live/verified yet.** |
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
