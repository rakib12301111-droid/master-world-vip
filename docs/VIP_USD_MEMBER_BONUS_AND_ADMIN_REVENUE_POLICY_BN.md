# MASTER WORLD VIP — VIP USD Member Bonus & Admin Revenue Policy

**Date:** 2026-11-26  
**Status:** OWNER-REQUESTED POLICY / DOCUMENTATION ONLY / NOT LIVE  
**Scope:** VIP area, ordinary member USD promotional bonus, Free/Paid plan revenue accounting.

## 1. Ordinary member USD bonus — random, not guaranteed
- VIP/Member Rewards area may provide eligible ordinary members with an irregular, random USD promotional bonus. No one may promise in advance who will receive USD or when; no fixed frequency, amount, daily income or winning status is guaranteed.
- This must be a lawful **no-purchase-necessary** promotional draw, not a pay-to-enter lottery. No deposit, joining fee, mandatory paid plan or task-unlock fee; buying a plan cannot improve odds. Basic member work access remains free.
- Before any draw: separately pre-fund 100% of the announced prize liability in liquid USD; publish eligibility, rules, selection period/process and required odds disclosures; complete Bangladesh and each served jurisdiction's legal review and obtain any required permit/registration; use secure auditable random selection, independent/immutable logs, anti-fraud/duplicate controls, tax/withholding disclosures, appeal/correction process and a verified USD payout provider.
- No funded reserve or legal approval means the draw stays disabled. Prize funds must never come from member wages/deposits, customer-restricted funds, refund reserves, unsettled receipts or later entrants. No fabricated winners or USD balances.
- If the legal review classifies the proposed mechanic as prohibited lottery/gambling or requires conditions not met, do not launch it; redesign or cancel.

## 2. Admin USD revenue from Free/Paid plan activity
- Admin USD reporting must separately identify eligible revenue generated through Free Plan and Paid Plan activity. Free Plan itself is free and creates no revenue merely by being active. Real customer-paid services/orders completed under Free Plan can generate eligible settled net platform revenue.
- A Paid Plan fee is revenue only when a real, lawful, disclosed purchase has been paid and provider-verified as settled. Deduct applicable taxes, payment/FX fees, refunds/chargebacks, delivery/provider/compute/operating costs, member payable and protected reserves before calculating distributable net revenue.
- Member Paid Plan is never mandatory to access legitimate work or enter the promotional draw. No plan purchase guarantees work, earnings or USD bonus.
- If Admin personally purchases a Paid Admin Plan, that payment is an operating expense, not Admin income. Circular/self-payment cannot be booked as revenue.
- Interpret “100% confirmed Admin USD” only as: **100% of the approved Admin entitlement from actual eligible settled net revenue must be accurately posted and reconciled to the Admin USD ledger**. It does not mean 100% of gross plan receipts, a fixed USD amount, or guaranteed income from Free Plan activation/plan existence. If eligible settled revenue is zero, Admin USD accrual is zero.
- Admin entitlement percentage/schedule, FX/settlement method and accounting/tax treatment require written approval and implementation tests; do not invent or hard-code an amount/rate. The existing 20%/35% Admin commission tier applies only to its approved distributable net platform revenue base. Avoid double counting between Admin revenue, member bonus pool and project commission.

## 3. Separate ledgers and member protections
Maintain separate append-only records for Company Revenue (USD receipts), Admin USD Entitlement/Profit, Member USD Promotional Prize liability, Member BDT Work Pay, Refund Reserve and Operating Expenses. Record source transaction, currency, FX snapshot, idempotency key, timestamp, actor, approval and reconciliation evidence.
Member prize cannot replace earned work wages or be netted against member payable. Admin revenue cannot use member wages/deposits or prize reserve. Existing Member Auto Work checkout/execution remains disabled until the 100% liquid refund reserve, separate operating fund, isolated infrastructure, provider/legal/security and acceptance gates all pass.

## 4. Release gates and truthful status
No VIP UI, random draw engine, USD reserve custody, random-selection/audit service, Admin USD ledger, plan checkout, payment/FX integration, legal approval or USD payout is verified live by this document. Build and test in staging first; require legal/accounting review, funded reserves, provider settlement reconciliation, security/privacy review and controlled acceptance before production. Do not advertise guaranteed member or Admin income.


## 5. Currency-stream commission and automatic USD-to-BDT wallet rule (Owner clarification, 2026-11-26)

The 20%/35% rates are separate by work/currency stream, not a flat 35% commission:
- USD Automatic-System / high-volume-high-value USD work stream: 35% Admin/Owner allocation.
- Ordinary Bangladeshi-taka Work stream: 20% Admin/Owner allocation.

Both rates apply only to the relevant Distributable Net Platform Revenue after member payable, taxes, payment/FX fees, direct delivery/provider/compute/operating costs, refunds/chargebacks and protected reserves are fully covered. Never apply either rate to gross receipts, member wages, member deposits, prize reserves, customer-restricted funds or unsettled receipts. Do not invent a BDT threshold or apply both rates to one transaction. The stream and rate must be disclosed before acceptance.

Member wallet must show separate USD and BDT balances. Show actual available USD when present; otherwise show US$0.00. Verified USD amounts are automatically converted at a trusted server-side FX quote and credited to the BDT account. Preserve the original USD amount, FX rate/source/time, fees and exact BDT credit in linked ledger history. After full conversion, available USD becomes zero while the original USD source and BDT credit remain visible. Keep USD promotional draw prizes separate from ordinary task wages; conversion does not change the prize's source category.

Admin/Owner personal out-of-pocket cost target is zero. Customer-funded contracts/settled receipts must cover disclosed member payable, provider/delivery costs, fees, tax and reserves before work is accepted. No member funds, wages or prize reserves may fund operations; no silent paid fallback. If funding/capacity is insufficient, pause/reject/requote.

See the authoritative detailed rules and acceptance tests in `docs/DUAL_CURRENCY_MEMBER_WALLET_AND_COMMISSION_POLICY_BN.md`.

**Status:** DOCUMENTED ONLY / NOT LIVE. No production wallet, FX conversion, commission calculation, customer contract, prize draw or payout is activated by this documentation update.
