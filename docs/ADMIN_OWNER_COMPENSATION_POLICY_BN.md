# MASTER WORLD VIP — Admin/Owner Monthly Compensation Policy

Last updated: 2026-11-24

## Owner-approved policy

The Owner approved a monthly minimum Admin/Owner compensation target of **৳১,০০০ BDT**. It is separate from member referral rewards. Member registration and access remain free; this policy introduces no member fee, deposit, mandatory purchase or hidden deduction.

## Monthly calculation

- Monthly minimum: **৳১,০০০ BDT**.
- If eligible monthly commission from actually settled platform revenue is higher than ৳১,০০০, the higher amount is due.
- If eligible commission is below ৳১,০০০, the platform's monthly compensation target remains ৳১,০০০; the difference is the minimum top-up.
- Formula: `monthly due = max(৳১,০০০, eligible settled commission)`; `minimum top-up = max(৳১,০০০ - eligible settled commission, ৳০)`.
- Commission amounts must be supported by a recorded revenue source and a non-secret accounting reference. Free usage, unpaid invoices, refunds, chargebacks, taxes and payment-provider fees are not eligible settled net revenue.
- If funds are unavailable, the outstanding amount may be recorded as an **unpaid internal payable** under this approved policy. It is not cash, a withdrawable wallet balance, evidence that funds exist, or a guaranteed payment date.
- Payment is recorded only after a real lawful transfer, with its actual non-secret transaction reference. The ledger does not send money.
- Funding must come from real settled platform funds, sponsorship or a separately approved Owner allocation. Never use member deposits or undisclosed member charges.

## Separate referral reward

The approved direct-referral reward remains **৳৫০ BDT once per eligible direct referral**, subject to its 24-hour good-standing period, verified email and completed profile, and only when backed by a pre-funded reward budget. It is not recurring monthly commission and must not be merged with Owner compensation.

## Technical implementation

- Migration: `supabase/migrations/202611240004_owner_monthly_compensation.sql`.
- The compensation tables are private; direct client table writes are revoked. Owner-only SECURITY DEFINER RPCs enforce access and write audit events.
- The Owner dashboard is embedded in the existing Admin & Security page. Only a verified `owner` role can load it.
- Monthly entries are generated idempotently from the policy start month when the Owner opens/refreshes the dashboard; missed calendar months are backfilled. This is on-demand accrual, not a background scheduler.
- The Owner records the actual settled commission and source/reference manually. The ledger computes the minimum top-up and outstanding amount. The scheduled workflow creates missing monthly minimum entries; it does not calculate revenue commission.
- A real payment must be made outside the app first; the Owner then records the amount and actual transfer reference. No bKash/Nagad or bank transfer API is connected by this feature.

## Deployment and verification gates

This repository change does not itself apply the Supabase migration or prove production deployment. Apply only through the guarded migration workflow after the required recoverable backup, separate restore test, dry-run review and exact Owner authorization. Then verify the Owner-only RPCs and dashboard with the intended Owner account and a separate ordinary member account. Do not describe the feature as live until the migration, deployment and acceptance tests pass.

## Security and compliance

Keep the ledger restricted to the verified Owner; preserve audit history; prevent duplicate month entries and overpayment; reconcile payment references against actual transfer records. Review applicable Bangladesh legal, tax and payment-provider requirements before real payments. Never request or store passwords, OTPs, bKash/Nagad PINs, card security codes or private payment credentials.
