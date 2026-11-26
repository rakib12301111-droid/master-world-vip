# MASTER WORLD VIP — Dual-Currency Wallet, Work Earnings & Commission Policy

**Date:** 2026-11-26 (Bangladesh time)  
**Status:** OWNER-APPROVED PRODUCT REQUIREMENT / DOCUMENTATION ONLY / NOT LIVE  
**Repository:** `rakib12301111-droid/master-world-vip`  
**Purpose:** Authoritative clarification of the two work/currency streams, 20%/35% Admin allocation, USD display/conversion, member USD promotional draw, and customer-funded zero-personal-cost operating model.

## 1. Two separate work and earning streams

MASTER WORLD VIP must maintain two visibly separate earning/work categories. Never merge them into one unexplained balance or use one category to conceal the other.

1. **USD / Automatic-System stream:** high-volume/high-value work obtained through the USD customer/project system. This stream uses the 35% Admin/Owner allocation rule in Section 2, only on its defined eligible net base. The member's actual work payable remains separately protected and must be shown before accepting the task.
2. **BDT / Ordinary Work stream:** ordinary work priced and accounted for in Bangladeshi taka. This stream uses the 20% Admin/Owner allocation rule in Section 2, only on its defined eligible net base. The member's BDT work payable is shown separately.

The 35% and 20% rates are **not one flat commission** and must not be described as “35% Admin commission on everything.” They are distinct rates assigned to the USD Automatic-System stream and the ordinary BDT work stream respectively. Do not apply both rates to the same receipt, stack them, or switch a task between streams after acceptance.

## 2. Admin/Owner allocation rates and calculation base

| Work/accounting stream | Admin/Owner allocation |
|---|---:|
| USD Automatic-System stream (high-volume/high-value USD work) | 35% |
| Ordinary BDT Work stream | 20% |

- These rates apply only to the relevant stream's **Distributable Net Platform Revenue**, not gross customer payment.
- Before calculating the eligible net base, reconcile taxes/withholding, payment and FX fees, refunds/chargebacks, direct customer-delivery/provider/compute/operating costs, the full disclosed member payable, and required protected reserves/restricted liabilities.
- Member wages, member wallet funds, member deposits, USD prize reserves, refund reserves, unsettled/disputed customer receipts and customer-restricted funds are never the source of Admin/Owner allocation.
- If the relevant net base is zero/negative, or member-pay, refund-reserve, payment-settlement or reconciliation gates fail, the allocation for that transaction is zero and fails closed.
- The applicable stream and rate must be disclosed before the member accepts the task/customer order. No retroactive rate change or deduction from an accepted member payable.
- This currency-stream rule clarifies/supersedes any generic wording that could be read as selecting 20% or 35% only by an unspecified BDT order-value threshold. Do not invent a threshold.

## 3. Two balances: USD and BDT

Member Wallet must show two distinct current balances:

- **USD Balance:** show the real available USD amount when USD is received; if no USD is available, display exactly **US$0.00** (or the equivalent zero-format for the interface). Never hide a non-zero USD amount and never fabricate a USD balance.
- **BDT Balance:** show the actual available Bangladeshi-taka amount independently.

Do not silently combine the two balances. Each wallet entry must identify its source stream (USD Automatic-System or ordinary BDT Work), source order/reward, gross amount, member payable, fees/deductions where lawful and disclosed, status, and settlement reference.

## 4. USD-to-BDT automatic conversion and credit

- Eligible member USD amounts are converted automatically into BDT using an approved, trusted payment-provider/bank FX quote captured server-side.
- Record the original USD amount, currency pair, FX rate, rate source, quote timestamp/expiry, conversion fee, exact BDT credited, conversion transaction ID and destination member account.
- After a successful conversion, credit the exact converted BDT amount to the member's BDT account and show both the source USD amount and resulting BDT amount in the transaction history.
- Prevent duplicate conversion/credit with server-side idempotency and reconciliation. Failed, expired, reversed or unverified conversions must not create spendable BDT.
- Preserve the original USD receipt/award in the immutable history even after conversion. The live USD available balance must reflect what remains unconverted; if the full amount is converted, the available USD balance becomes US$0.00 while the historical USD amount and BDT credit remain visible.
- The USD work/reward category and ordinary BDT work category remain separately labelled after conversion. Currency conversion does not turn a USD promotional prize into work wages or merge its source category with ordinary BDT task pay.

## 5. USD member lottery / promotional bonus — separate from wages

- The USD lottery/draw is a separate member promotional-reward stream, not ordinary task wages, salary, guaranteed earnings or compensation for merely being online.
- Who receives a bonus and when is unpredictable; no member is promised a particular win, amount, frequency or income.
- It must be no-purchase-necessary: no deposit, joining fee, paid plan, paid task unlock or payment to obtain a chance; buying a plan cannot improve odds.
- Before any draw, the entire announced prize liability must be separately pre-funded in liquid USD. Publish clear eligibility/rules and required odds disclosures; complete legal review and obtain any required Bangladesh/served-country approvals; use secure auditable random selection, immutable logs, anti-fraud controls, tax disclosures, appeal/correction and verified payout/conversion provider.
- Prize funds cannot come from member wages/deposits, customer-restricted funds, refund reserves, unsettled receipts or later entrants. If funding, legal approval or payment provider is absent, the draw remains disabled.
- If applicable law treats the mechanic as prohibited lottery/gambling or imposes unmet requirements, do not launch; redesign or cancel it.
- On a win, record the original USD prize and, after verified conversion, the BDT credit as two linked ledger events. Do not count the same award twice as both USD spendable balance and new BDT earnings.

## 6. Real customer demand and brand/client acquisition

- Prioritize reputable, established local and international companies, brands, agencies, e-commerce businesses and technology/service providers that have recurring legitimate work.
- Seek written recurring/monthly/long-term customer contracts and a pipeline of repeat orders, not customers with no real work to offer.
- A brand/customer may be shown as an active client or endorsement only after authorization, a signed contract or verifiable public programme terms. Never invent a brand relationship, endorsement, customer, order, work volume or funding.
- The long-term objective is a broad, continuously replenished catalogue (including the requested 2,000+ work categories) and repeat/unlimited order submission capability. This is a growth target, not a claim that unlimited real orders already exist or that every member always has work.
- Only genuine, lawful, scoped, funded orders with acceptance criteria, provider/client permission, positive unit economics and a verified payment path may be assigned as paid work. If the customer has no actual work or no confirmed funding, do not count that customer as a source of member work.

## 7. Admin zero personal out-of-pocket cost

- Admin/Owner personal out-of-pocket spending target is **৳0 / US$0**. The operating model must be funded by actual customer contracts, customer prepayments/settled receipts or other lawful, separately documented platform revenue.
- Before accepting an order, reserve sufficient customer-funded money for member payable, delivery/provider costs, taxes/fees, refund/chargeback exposure and other disclosed obligations.
- Never use member deposits, member wages, member prize reserves, customer-restricted funds or refund reserves to pay platform operating costs.
- No silent paid hosting/API/storage fallback, auto-upgrade, credit/debt or personal-card charge. Free-tier quota exhaustion pauses/queues affected work and alerts Admin; paid use is disabled unless a separately approved customer-funded budget and explicit spend cap already exist.
- If customer funding or safe operating capacity is insufficient, pause/reject/requote the order. Do not promise work availability or member payouts that are not funded.
- “Admin personal cost zero” is an operating constraint, not a claim that hosting, APIs, payment processing, legal compliance or service delivery have no cost. Those costs must be covered from eligible platform/customer funds before an order is accepted.

## 8. Separate append-only ledgers and reconciliation

Maintain separate, auditable ledgers for:
1. USD Automatic-System customer receipts and project costs.
2. Ordinary BDT Work customer receipts and project costs.
3. Member BDT work pay.
4. Member USD promotional prize liability and draw results.
5. USD available balance and USD-to-BDT conversions.
6. BDT available balance and credited conversion amounts.
7. Admin/Owner 35% USD-stream entitlement.
8. Admin/Owner 20% BDT-stream entitlement.
9. Company operating expenses, customer restricted funds and refund/chargeback reserves.

Each entry must include source transaction/order, currency, gross and net values, applicable rate, FX snapshot if relevant, member payable, idempotency key, timestamp, status, actor/approval, provider settlement reference and reconciliation evidence. No double-counting, cross-subsidy or silent reclassification.

## 9. Required implementation and acceptance tests

- Show separate USD and BDT balances; test zero USD display when no USD is available.
- Test USD receipt, partial conversion, full conversion, exact BDT credit, expired/failed FX quote, reversal, duplicate webhook and idempotency.
- Test separate USD Automatic-System 35% and ordinary BDT Work 20% allocations, including gross-vs-net calculation, zero/negative net, refund/chargeback, member wage protection and reserve failures.
- Test that an USD promotional draw prize is never labelled as ordinary wages and that the USD source and linked BDT conversion are both visible without double-counting.
- Test no-purchase draw, funded prize pool, random-selection audit and legal/provider launch gates before enabling any draw.
- Test Admin personal spending remains zero, paid fallback is blocked, and customer-funded operating budget is required before order intake.
- Test no client/work claim without verified customer demand, contract/authorization and funding.

## 10. Current status — documented only, not live

This policy update records requirements only. It does not create customers/contracts, guarantee unlimited real work, fund prize pools, activate a lottery, create wallet balances, perform FX conversion, change production commission calculations, deploy workers, connect payment providers or enable withdrawals. Existing database backup/restore, migration authorization, security, provider/legal review and production acceptance gates remain mandatory. Mark each capability LIVE only after implementation, deployment, configuration and real end-to-end tests pass.
