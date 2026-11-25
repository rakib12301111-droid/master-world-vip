# Work & Earn Wallet / Owner Profit — Acceptance Tests

**Scope:** migration 20261125160000_work_earn_wallet_owner_profit.sql. These tests are a release checklist; they are not evidence of a live provider, real reserve custody, or a production database apply.

## Required setup
- Apply all prerequisite migrations, including Work & Earn, Admin RBAC and audit log migrations, in the documented order after a recoverable backup and successful restore test.
- Use two test member accounts and exactly one verified Owner account.
- Use a staging payment-provider merchant account and a test webhook that validates the provider signature/server-to-server status before inserting a payment event.
- Insert a short-lived reconciliation snapshot only after independently reconciling the test ledger, refund reserve and separate operating budget. Never use fabricated values in production.
- Keep production package checkout and Member Auto Work disabled.

## Core cases
1. **Default rate:** confirm work_earn_commission_settings.owner_profit_rate = 20.00.
2. **Member isolation:** Member A can read only Member A's member_work_wallet_ledger; Member B cannot read A's rows. Neither member can insert, update or delete wallet entries.
3. **Owner isolation:** only the verified Owner can read owner_work_profit_ledger or call owner_set_work_earn_profit_rate; members and ordinary admins cannot change the rate.
4. **Rate change audit:** Owner changes rate to 15.00 with a reason. Confirm an audit row records old/new rates, actor, reason and effective time. Existing settlement rows retain the rate captured at posting; new accepted work uses the current disclosed rate.
5. **Valid atomic settlement:** provider event is settled, provider verification timestamp and client acceptance timestamp are present, and gross receipt exactly equals member payable plus disclosed platform fee. Use a current reconciliation snapshot with all three gates true. Confirm one member credit and one Owner profit entry appear atomically.
6. **20% math:** platform fee BDT 500, tax 0, provider fee 0, operating cost 0 and restricted liability 0 gives distributable net BDT 500 and Owner profit BDT 100. Repeat with net bases BDT 1,000 / 5,000 / 10,000 and confirm BDT 200 / 1,000 / 2,000.
7. **Deductions:** for platform fee BDT 1,000 with tax BDT 50, provider fee BDT 20, operating cost BDT 30 and restricted liability BDT 100, distributable net is BDT 800 and Owner profit at 20% is BDT 160. Member payable remains unchanged.
8. **Duplicate webhook/retry:** call the posting RPC twice with the same event and idempotency key. The second call returns the original settlement with duplicate=true; no second member credit or Owner profit entry appears.
9. **Collision protection:** reuse an event with a different idempotency key, or reuse a key with another event. Confirm a hard error and no ledger mutation.
10. **Atomic rollback:** force an insert/audit failure in staging. Confirm settlement, member credit and Owner profit all roll back together.
11. **Fail-closed gates:** test pending/unverified payment, missing client acceptance, expired reconciliation snapshot, stale snapshot, unreconciled ledger, reserve coverage false, operating budget false, disputed/reversed payment, wrong currency, gross mismatch, negative amount and more than two decimal places. Every case must fail without crediting either ledger.
12. **No fake cash:** wallet credit and Owner profit accrual must display as ledger/accrued, not as completed bKash/Nagad/bank transfer. A payout can be marked paid only after a separate real provider transfer and reference reconciliation.
13. **Single Owner:** zero or more than one Owner role must block settlement posting.
14. **Audit/reconciliation:** source event ID, provider transaction ID, reconciliation snapshot, settlement ID, member credit, applied rate and Owner profit must reconcile one-to-one.

## Go-live gates
- A reviewed payment provider/merchant contract and server-side signature validation are deployed.
- Real provider settlement webhooks, chargeback/refund/reversal handling and idempotent retries pass staging tests.
- Reconciliation snapshots are produced by a trusted service from independently verified bank/provider records; the booleans are not manually asserted by a browser.
- Actual refund reserve custody and separate operating funds are independently verified; legal/payment-provider approval is complete.
- A separate secure payout integration and real small-value bKash/Nagad/bank payout test are complete.
- RLS, role isolation, concurrency, load, backup/restore and disaster recovery tests pass.
- Only then may Owner authorize a production migration through the guarded workflow and enable real task settlement. Documentation or SQL commit alone does not enable payment.
