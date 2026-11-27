# MASTER WORLD VIP — Payment Provider Sandbox & Acceptance Plan

Updated: 2026-11-27
Status: **Official provider sandbox credentials/approval unavailable; live integration NOT RUN**

## 1. Provider selection and prerequisites

For each chosen rail (SSLCommerz checkout, bKash, Nagad, bank/partner transfer), record:
- Contracting legal entity, merchant/account identifier and approved product/transaction types.
- Official provider documentation version, sandbox base URL and credential owner.
- Sandbox access approval, test cards/accounts, webhook signing key and IP/network requirements.
- Supported currencies, transaction limits, fee schedule, settlement timing, refund/dispute support and reconciliation report format.
- Data processing, KYC/AML, tax, retention and incident contact obligations.

Do not use unofficial endpoints, personal-wallet automation, copied credentials or production keys in tests. Provider credentials stay in approved secret storage, never in source, chat or logs.

## 2. Adapter contract

Each provider adapter must implement explicit operations:
- `createPaymentIntent(order, idempotencyKey)`
- `verifyWebhook(rawBody, headers, timestamp)`
- `getPaymentStatus(providerReference)`
- `requestRefund(settledPaymentReference, amount, idempotencyKey)`
- `requestPayout(approvedPayoutRequest, idempotencyKey)` only where provider contract expressly permits it
- `getSettlementBatch(window)`

Common invariants:
- Verify signature over exact raw body, timestamp tolerance and key rotation.
- Match merchant, order, provider reference, amount and currency exactly.
- Reject duplicate/replayed events and same idempotency key with different request hash.
- A callback alone is not settlement proof: status inquiry and settlement/reconciliation evidence required before marking funded/paid.
- Pending/unknown status remains pending; timeout never triggers a blind second transfer.
- Rail/currency fail-closed on signature, balance, settlement or reconciliation mismatch.

## 3. Safe mock sandbox while official credentials are unavailable

Use only a clearly labelled TEST-ONLY fake provider adapter with synthetic IDs and deterministic fixtures. Mock mode must:
- Be impossible to enable in Production by environment guard.
- Use a separate test database/project and fake balances only.
- Never write to real Member withdrawable balances or mark real payout as paid.
- Simulate success, decline, pending, timeout, duplicate webhook, replay, invalid signature, amount/currency mismatch, refund, chargeback and reconciliation mismatch.
- Record that each event is synthetic in every test output.

A mock test is not an official provider sandbox test and cannot satisfy provider approval or go-live acceptance.

## 4. Provider acceptance matrix

| Scenario | Expected result |
|---|---|
| Valid signed payment + exact amount/currency/order | Payment intent advances only after status/settlement verification |
| Invalid signature or stale timestamp | Reject; no ledger mutation |
| Duplicate/replayed webhook | Idempotent no-op; no duplicate journal |
| Same key, different payload | Conflict and audit alert |
| Wrong merchant/order/amount/currency | Reject and quarantine for review |
| Pending or timeout | Remain pending; query provider; never blind retry payout |
| Provider says success but settlement report absent | Not reconciled; no withdrawable balance |
| Refund/chargeback | Hold/reverse by approved policy; preserve balanced ledger |
| Beneficiary mismatch / KYC incomplete | Payout blocked |
| Reconciliation mismatch / reserve shortfall | Freeze affected rail/currency and alert Admin |
| Provider outage | Circuit-breaker, bounded retry, no duplicate transfer |

## 5. Required workflow stages

1. Acquire official provider sandbox account, documentation and written access approval.
2. Configure test credentials only in GitHub Actions/Supabase Staging secrets.
3. Implement provider-specific adapter in a separate module; no live credentials or production endpoint in PR.
4. Run adapter contract tests with signed fixtures and deterministic replay cases.
5. Run isolated Staging end-to-end tests for checkout, webhook, status, settlement, refund and payout (only if provider sandbox supports payout).
6. Reconcile provider sandbox settlement export against test ledger.
7. Obtain security, finance, legal and provider sign-off.
8. Production remains separately gated by explicit approval and backup/restore evidence.

## Current blocker

No official provider sandbox credentials, merchant approvals, provider contract, webhook signing key or Staging project credentials were available during this update. Therefore no official provider API call or sandbox integration test is claimed. The mock acceptance plan is documentation only until a disposable mock adapter and test harness are implemented.
