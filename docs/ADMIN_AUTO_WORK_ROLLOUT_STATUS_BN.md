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
