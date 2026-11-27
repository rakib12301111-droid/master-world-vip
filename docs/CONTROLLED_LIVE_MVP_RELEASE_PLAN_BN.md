# MASTER WORLD VIP — Controlled Live MVP Release Plan (বাংলা)

**তারিখ:** ২৭ নভেম্বর ২০২৬  
**উদ্দেশ্য:** শুধু প্রমাণিত, নিরাপদ ও ব্যবহারযোগ্য অংশ প্রকাশ করে Owner-কে ওয়েবসাইটে প্রবেশ, প্রাথমিক UI ব্যবহার এবং সীমিত acceptance testing-এর সুযোগ দেওয়া।  
**এটি deployment authorization নয়।**

## 1. Release strategy

একসঙ্গে পুরো platform, ৪,০০০ project engine, real payments বা payout live করা হবে না। প্রথম release হবে **Controlled Live MVP**: static website/app shell + explicitly verified public/read-only experience + clearly labelled preview areas. Login বা database-dependent feature কেবল সংশ্লিষ্ট Supabase Auth/schema/RLS/Edge Function configuration এবং live acceptance PASS হলে enabled/advertised হবে।

## 2. Existing published entry points

- Public landing page: https://rakib12301111-droid.github.io/master-world-vip/
- Member app entry: https://rakib12301111-droid.github.io/master-world-vip/www/

এই URL-গুলো repository-তে canonical entry হিসেবে লেখা আছে। এই plan তৈরির সময় live URL থেকে HTTP response/real login সফলতা independently verify করা যায়নি; তাই link থাকা মানেই live runtime acceptance নয়।

## 3. Proposed MVP release scope

### Candidate for public access after live Pages verification
- Landing page, platform purpose, feature availability/status notices.
- Static app shell/navigation and local-only setup/preferences.
- Static/offline resources only where their source freshness and safety notice are visible.
- Owner-facing progress/readiness page only if it does not expose private records or secrets.

### Keep disabled / preview-only until backend acceptance
- Registration, email OTP, login, password reset and profile CRUD.
- Member discovery, friends, private/group chat, inbox, broadcasts and push.
- Admin/Owner panels, finance ledgers, referrals, reward processing and compensation.
- Work & Earn task execution, member wallet, withdrawal, commission posting.
- AI/provider features that require secret-backed external services.
- Location tracking, device recovery, helpdesk verification and other sensitive personal-data features.

### Explicitly prohibited from MVP activation
- Production migration apply or migration-history repair.
- Worker production execution; project scheduler enablement; kill-switch disable.
- Real customer collection, bKash/Nagad/bank payout, refunds or any money movement.
- Admin 20% commission posting (proposal only).
- Any feature whose required schema, RBAC, RLS, provider approval, runtime secret or real acceptance evidence is missing.

## 4. Required release gates

1. **Source baseline:** identify actual current main HEAD, PR #20 head/base and exact files proposed for release. Do not assume planning branch is deployed.
2. **Separate release scope:** do not merge the entire Draft PR #20 merely to publish the MVP. Create a narrow release PR from current main or cherry-pick only independently reviewed safe frontend/docs changes.
3. **Static CI:** run only affected checks for changed paths; record exact commit and run IDs. Do not repeat already-passed unchanged checks.
4. **GitHub Pages:** ensure Pages source/workflow configuration is correct. Existing pages workflow deploys from main on push or manual dispatch; a planning-branch commit alone does not publish.
5. **Live Pages verification:** published root and /www/ must return success; check app HTML, manifest, service worker, static asset paths and cache version.
6. **Backend separation:** no claim that Auth/DB is ready until Staging is configured and Owner/Admin/Member acceptance passes. Do not point production UI at an unverified database or expose service-role credentials.
7. **Owner usability:** test on Android Chrome (mobile layout, install/PWA, navigation, refresh, offline shell) using an owner-controlled test account only after Auth readiness.
8. **Rollback:** record prior deployed commit and documented Pages rollback method before publishing.

## 5. Staging prerequisites for backend-dependent features

A separate Staging Supabase project and the 11 documented Staging GitHub Actions secrets are required. Secrets must be entered only in GitHub repository Actions Secrets; never send them in chat. Complete migration preview/apply in Staging, Auth Site/Redirect URL configuration, email delivery, Owner/Admin/Member RBAC and RLS tests, then worker acceptance with emergency stop still enabled. Staging success is not Production authorization.

## 6. Owner action and authorization boundary

Owner can review this plan and use the existing public/app entry URLs for a preliminary visual check. Before a release PR is merged or Pages is manually deployed, the exact release scope and current main baseline must be reviewed. This plan does not authorize production database changes, worker activation, provider integration or real money movement.

## 7. Acceptance record template

- Release PR:
- Source commit:
- Static CI run(s):
- Pages deploy run:
- Published root HTTP check:
- Published app HTTP check:
- Manifest/service worker check:
- Android Chrome test:
- Backend/Auth acceptance: NOT RUN until Staging credentials and test identities exist.
- Payments/payout/commission: DISABLED.
- Production migration/worker: NOT AUTHORIZED.

**Status at creation:** PLAN RECORDED / NOT DEPLOYED BY THIS CHANGE. No new Pages deployment, Staging acceptance, production migration, payment or payout was performed.
