# MASTER WORLD VIP — Release Readiness Plan

**Last checked:** 27 November 2026  
**PR:** #20 — Draft / Open / Unmerged  
**Scope:** 4,000-project registry, central automation foundation, Free/Paid and customer-order gates, Member loss-prevention controls, USD/BDT double-entry ledger, guarded payout/refund requests, payout-method specification and proposed 20% Admin commission.

## Executive release decision

**NOT READY FOR PRODUCTION / NOT LIVE.** The source branch has passing static safety checks and a passing isolated PostgreSQL 16 runtime test for the finance-ledger and payout/refund migrations. These results do not prove that the full migration chain applies cleanly to the current Production schema, that real payment providers settle funds, or that safeguarded funds and payouts exist.

No Production migration, live money movement, public release or revenue activation is authorized by this document.

## Verified evidence

Latest PR head after release-readiness documentation updates: `2ba5af6027f2f8fecd23ae5ce837079ca6e7b44d`.

- PostgreSQL 16 disposable runtime workflow run `45874411633`: success. It runs the ledger and payout/refund migration tests against an isolated disposable database.
- Supabase migration safety run `45874411687`: success. Static verifier steps for the project registry, automation engine, plan/order gates, finance ledger and payout/refund safety all passed; the existing community readiness and other static checks also passed.
- Auto Work static safety run `45874411490`: success.
- The PR is still Draft, Open and Unmerged. Its base is `main`.
- The registry seeds 4,000 planned slots, but execution and revenue collection remain disabled and project budgets are zero.
- No worker fleet, customer checkout/webhook integration, safeguarded custody account, funded refund reserve, bKash/Nagad/bank payout adapter, or live Admin commission posting is connected by these changes.

## Release blockers and required evidence

### A. Source and database readiness

- Review the complete PR diff and resolve all review findings.
- Run the entire ordered migration chain against a clean disposable Supabase-compatible PostgreSQL environment, not only the finance migrations.
- Run schema-drift and migration-history preview against the intended Production project in preview-only mode.
- Run read-only Production schema/RLS/index audit and two-member RLS integration checks using approved ordinary test accounts.
- Verify a current recoverable backup and a successful restore rehearsal; record a non-secret backup reference.
- Confirm the Production project ref and migration inventory exactly match the intended project.
- Do not repair migration history or apply migrations without separate explicit approval.

### B. Real payment and custody readiness

- Select the actual merchant/provider accounts (for example bKash Merchant, Nagad Merchant, SSLCommerz, or another approved provider).
- Implement provider-specific sandbox checkout, signed webhook verification, idempotency, settlement lookup, refund/chargeback callbacks and replay/tamper tests.
- Obtain lawful merchant/provider onboarding, KYC and payout eligibility; configure secrets only in the approved secret store. Never ask for passwords, OTPs, PINs or API secrets in chat.
- Establish independently verifiable segregated custody for Member payable, refund/chargeback reserve and platform operating funds. USD and BDT custody and reconciliation must remain separate.
- Prove the reserve is actually funded and liquid. Database allocation rows are not custody evidence.
- Implement and test real payout/refund rails. bKash/Nagad requests require Admin approval under the recorded policy; bank self-enrollment does not bypass bank/provider permissions, ownership verification or risk controls.
- Implement daily independent provider/bank reconciliation and stop new risky work on any mismatch, stale feed or reserve shortfall.

### C. Business and operational readiness

- Define Free and Paid plan features, prices, billing periods, usage limits, cancellation and refund terms.
- Define the proposed 20% Admin commission basis, provider-fee treatment, tax, rounding, refund/chargeback reversal and Member net payable disclosure. The 20% remains proposal-only until explicitly configured and reviewed.
- Implement the actual worker service, scheduler execution, provider connectors, monitoring, alerting, kill switch, support/dispute process, rate limits and per-project cost controls.
- Complete security, privacy, fraud, load, recovery, accessibility and end-to-end acceptance tests.
- Start with a limited, controlled pilot only after all legal, financial and operational gates pass. Expand project/customer count based on measured evidence; 4,000 projects and 10 million customers are goals, not live capacity or achieved users.

## Controlled release sequence

1. Finish source review and add/repair automated tests in this PR.
2. Complete full-chain disposable database migration and security/RLS test evidence.
3. Complete provider sandbox and custody/reconciliation/payout/refund simulations.
4. Run Production read-only audits, migration dry-run and backup/restore verification.
5. Obtain the owner's separate exact authorization for Production migration apply: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`, together with backup/restore confirmations and backup reference.
6. Apply only the reviewed migrations in a controlled window; verify schema, RLS, application health and rollback/restore readiness.
7. Obtain separate approval for public deployment and separately for any live payment or payout activation.
8. Launch a limited pilot; reconcile every transaction and pause automatically on any safety invariant failure.

## Approval boundaries

Routine source edits, documentation, static checks and disposable tests may continue on this feature branch under the owner's standing engineering-update instruction.

The following are not authorized by routine update permission: Production database writes/migration-history repair, public/live deployment, live customer billing, real payout/refund/transfer, or changes to bank/payment-provider accounts and KYC. Each requires the relevant separate owner approval and any provider/legal approval. Never expose credentials or financial account secrets.

## Current conclusion

Continue improving the branch and tests. Do not describe the project as Production-ready, payment-live, income-generating, or Member-funds-secured in real custody until the evidence above exists.
