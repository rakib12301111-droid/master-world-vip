# MASTER WORLD VIP — Feature Completion Register

Last reviewed: 2026-11-22

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

## Feature register

| Feature | Repository foundation | Remaining work before Live |
|---|---|---|
| Member Hub & Profiles | Supabase Auth starter, profile UI, username/bio/discovery fields and profile migrations | Fix IPv4 pooler connection; apply migrations; configure Auth Site/Redirect URLs and email; signup, confirmation, login, profile CRUD and two-user RLS tests |
| Global Community — Search, Friends & Chat | Member discovery, friend requests, accepted-friend-only direct chat RPC, public groups/group chat, inbox, read markers, broadcasts and realtime/polling fallback | Apply all required migrations in dependency order; verify profile privacy, direct/group membership RLS, read/unread, broadcast authorization and rate limit with two accounts |
| Live Number Location Map | Consent-based location migration and UI; verified phone lookup, sharing toggle, timestamp/freshness checks and map presentation foundation | Apply migration; configure browser geolocation permissions; verify phone numbers through Auth; test opt-in/opt-out, stale/offline behavior, lookup rate limit and no disclosure when sharing is off. A phone number/SIM alone must never reveal GPS |
| AI Text & Voice Assistant | AI assistant Edge Function foundation | Choose provider/model; configure provider API key only in Supabase Edge Function secrets; deploy function; implement/test voice input/output, usage limits, abuse controls and error handling |
| AI Image Search + License | AI Center UI placeholder | Select a licensed image/search provider; configure server-side credentials; return attribution, source URL, license and permitted-use metadata; test rights/attribution display |
| Facebook Public Discovery | Facebook Center UI and consent/privacy notes | Create Meta app; use only approved Graph API permissions and permitted public data; complete Meta review where required; never scrape private data or collect Facebook passwords/OTPs |
| Active User Finder | Consent-based AI/manual workflow concept | Implement explicit opt-in availability state, expiry, block/report controls and rate limits; never infer activity from phone/SIM or expose precise location without consent |
| Global Promotion & Referrals | Growth UI foundation | Add referral codes, server-side attribution, anti-self-referral/fraud checks, transparent reward rules, analytics consent and payout policy; test duplicate/fraud cases |
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
