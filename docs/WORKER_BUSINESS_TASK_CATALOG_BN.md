# MASTER WORLD VIP — Business Worker Task Catalog

Updated: 2026-11-27
Status: **Specification baseline — handlers NOT enabled**

## Safety boundary

The database allowlist and runtime currently permit only `system_health_check` (read-only). This catalog defines candidate business tasks; it does not enable them. Every task below must be implemented, threat-modelled, independently tested and explicitly allowlisted before a Worker can claim it. No task may bypass customer consent, role permissions, budget reservation, idempotency, audit or the global emergency stop.

## Common task envelope

Every task must carry:
- `task_id`, `task_type`, `schema_version`, `project_id`, `idempotency_key`.
- `requested_by` and a server-verified authorization context (never trust a role supplied in payload).
- `input` validated against a versioned JSON schema; reject unknown fields and oversized payloads.
- `deadline_at`, `timeout_seconds`, `max_attempts`, `budget_cap`, `currency`.
- `data_scope` identifying the exact tenant/customer records the handler may access.
- Output schema, structured error code, audit correlation ID and actual cost.
- No credentials, OTP, wallet PIN, bank password, card secret or raw provider secret in payload/logs.

Common execution rules:
1. Resolve tenant and actor authorization server-side; enforce tenant isolation and least privilege.
2. Validate payload and current record state before side effects.
3. Use idempotency key + immutable input hash for every external or database side effect. Same key/different hash is a hard conflict.
4. Reserve the maximum approved task budget at claim; record actual cost and release unused reservation at finish.
5. Apply bounded timeout/retry with exponential backoff and jitter; do not retry non-idempotent external operations without status inquiry.
6. Write start/result/failure, actor, task version, cost, redacted input/output hash and correlation ID to audit.
7. Stop claiming on global/project/rail kill switch, budget exhaustion, authorization failure or integrity mismatch.
8. A task cannot mark payment settled, order funded, payout paid or commission earned without verified provider settlement and reconciliation evidence.

## Candidate business tasks

| Task type | Purpose / input | Permitted effect | Required evidence / acceptance | Initial risk |
|---|---|---|---|---|
| `work_order_validate` | Validate a submitted work order ID, deliverable requirements and required fields | Read-only validation; return checklist | Tenant/RBAC tests, missing/invalid field cases, no state mutation | Low |
| `work_order_reminder_schedule` | Order ID, due date, recipient preference | Create an idempotent in-app reminder only | Consent/preference check, dedupe, timezone and cancellation tests | Medium |
| `work_delivery_integrity_check` | Order ID and submitted artifact metadata | Read-only malware/format/size/hash policy checks; no content publication | File type/size/hash tests, tenant isolation, quarantine path | Medium |
| `work_acceptance_timeout_escalate` | Order ID, acceptance deadline, policy version | Create an Admin review/escalation record; never auto-accept or release funds | Boundary/timezone tests, dispute hold, no automatic payable release | High |
| `referral_attribution_reconcile` | Referral event IDs and attribution window | Reconcile attribution candidate; no wallet credit | Duplicate/self-referral/fraud tests, immutable source event, manual approval | High |
| `member_payout_preflight` | Payout request ID | Read-only eligibility check; never submit transfer | Beneficiary verification status, balance/hold/limit checks, RBAC, no provider call | High |
| `payment_event_reconcile` | Provider event reference and payment intent ID | Compare signed event evidence with ledger; no funding by itself | Signature/timestamp/replay/amount/currency tests; mismatch freezes rail | Critical |
| `commission_preview_calculate` | Completed order snapshot and approved policy version | Calculate preview only; no journal posting or deduction | Deterministic decimal arithmetic, immutable snapshot, zero/negative margin tests | High |
| `daily_finance_reconciliation` | Provider settlement batch reference and ledger window | Produce discrepancy report; no automatic balance repair | Completeness, duplicate/missing rows, currency separation, audit report | Critical |
| `project_usage_digest` | Project usage window | Read-only usage and budget summary | Tenant isolation, aggregation correctness, no PII leakage | Low |

## Rollout order

**Phase A — safe read-only:** `work_order_validate`, `project_usage_digest`, `member_payout_preflight` (read-only only).

**Phase B — controlled internal records:** `work_order_reminder_schedule`, `work_delivery_integrity_check`, `work_acceptance_timeout_escalate` (Admin review only).

**Phase C — finance-adjacent, still no money movement:** `referral_attribution_reconcile`, `commission_preview_calculate`, `payment_event_reconcile`, `daily_finance_reconciliation`. These require signed evidence, security review and dedicated disposable/Staging runtime tests.

No payment collection, refund, payout submission, bank transfer, bKash/Nagad transfer, commission posting or automatic order acceptance is in this initial catalog.

## Definition of Done for each handler

- Versioned input/output schema and documented data scope.
- Server-side authorization and tenant isolation tests.
- Idempotency, same-key/different-payload conflict, duplicate delivery and crash/retry tests.
- Timeout, budget reservation, actual-cost accounting and dead-letter tests.
- Kill-switch and fail-closed tests.
- Audit event assertions with secret/PII redaction.
- Disposable database runtime test and isolated Staging acceptance.
- Security review and explicit allowlist entry.
- Handover records exact commit and successful workflow run.

## Current decision

Only `system_health_check` is enabled. All candidate tasks above remain **SPECIFIED / NOT IMPLEMENTED / NOT ALLOWLISTED**. Do not flip Worker execution or project schedules on because this catalog exists.
