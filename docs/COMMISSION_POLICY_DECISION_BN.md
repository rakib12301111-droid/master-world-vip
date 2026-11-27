# MASTER WORLD VIP — Admin Commission Policy (Decision Draft)

Updated: 2026-11-27
Status: **20% rate recorded as Owner proposal; calculation policy recommended, NOT approved or active**

## 1. Proposed rate and base

- Proposed Admin rate: **20% of Distributable Platform Margin**, not 20% of customer gross price.
- Formula:
  `Distributable Platform Margin = settled customer gross - provider/payment fees - applicable taxes/withholding - full Member payable - funded refund/chargeback reserve allocation - approved direct order costs`.
- `Admin commission = max(0, Distributable Platform Margin) × 20%`.
- If margin is zero or negative, commission is zero. Member payable and refund/chargeback reserve are never a source for commission.
- Remaining positive margin after commission remains platform-retained margin.
- BDT orders calculate in BDT; USD orders calculate in USD. No implicit FX conversion or cross-currency netting.

## 2. Illustrative example (not live amounts)

| Item | BDT example |
|---|---:|
| Settled customer gross | 1,000.00 |
| Provider fee | -20.00 |
| Tax/withholding | -30.00 |
| Full Member payable | -600.00 |
| Refund/chargeback reserve allocation | -100.00 |
| Approved direct order cost | -50.00 |
| Distributable Platform Margin | 200.00 |
| Proposed Admin commission (20%) | 40.00 |
| Platform retained margin | 160.00 |

## 3. Posting and disclosure

1. Before order acceptance, show gross amount, currency, provider fee estimate/actual treatment, tax treatment, Member payable, reserve, direct costs, calculation basis, proposed rate and expected commission.
2. At acceptance, snapshot policy version, rate, basis, amounts, currency and rounding mode immutably. Later policy changes apply only to new orders.
3. Commission is only eligible after work is accepted/completed, customer funds are provider-settled and reconciled, and refund/chargeback holds are satisfied.
4. Calculation preview and actual ledger posting are separate operations. Preview task must be read-only.
5. Posting must use a unique order + policy-version idempotency key and balanced double-entry journal to a separate company commission revenue account.
6. Refund, chargeback, dispute, provider reversal or later reserve shortfall triggers a documented hold/reversal workflow; never silently debit Member payable.
7. Admin cannot approve their own high-risk commission override. Owner/second authorized approver and immutable audit are required for exceptions.

## 4. Arithmetic and rounding

- Use exact decimal/numeric arithmetic; never binary floating point for money.
- Preserve currency minor units; round commission to the currency's supported minor unit using a single documented half-up rule, unless local accounting rules require a different approved rule.
- Store unrounded calculation inputs, rounded output, policy version and rounding method for audit.
- Recompute is permitted only before order acceptance; after snapshot, changes require a versioned adjustment journal and approval.

## 5. Required approvals before activation

- Owner's explicit final approval of this exact calculation basis and rate.
- Legal/accounting/tax review for applicable jurisdictions and withholding treatment.
- Provider fee schedule and refund/chargeback reserve methodology.
- Customer and Member terms/disclosure reviewed and published before order acceptance.
- Finance ledger account mapping, refund/reversal tests, reconciliation and independent review.
- Separate Production migration/release approval where applicable.

## 6. Non-goals and prohibitions

- This policy does not authorize a commission deduction from gross price or Member payable.
- It does not authorize live payment collection, custody, payout or provider API use.
- It does not activate the 20% rate in code/configuration.
- No commission is earned merely because a Worker task ran or an order was created.
- No negative margin, pending payment, disputed, cancelled, refunded or unreconciled order can earn commission.

## Current status

**PROPOSED ONLY.** The 20% rate and distributable-margin formula are a decision draft for Owner approval. No production setting, live commission ledger posting or real revenue is enabled.
