# MASTER WORLD VIP — Business Worker Task Catalog

Updated: 2026-11-27
Status: **Phase A implemented — 2 business read-only handlers runtime-tested; remaining handlers are specification-only**

## Safety boundary

The database allowlist and runtime currently permit exactly three source-implemented read-only types: `system_health_check`, `project_usage_digest`, and `work_order_validate`. No other business handler is claimable. This catalog defines candidate business tasks; it does not enable them. Every task below must be implemented, threat-modelled, independently tested and explicitly allowlisted before a Worker can claim it. No task may bypass customer consent, role permissions, budget reservation, idempotency, audit or the global emergency stop.

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

`system_health_check`, `project_usage_digest`, and `work_order_validate` are source-implemented and allowlisted as read-only. The two business handlers passed disposable runtime acceptance in run `45959527467`. All other candidate tasks remain **SPECIFIED / NOT IMPLEMENTED / NOT ALLOWLISTED**. Do not enable Worker execution or project schedules because this catalog exists.


## Phase A implementation status — 27 Nov 2026

The following two catalog handlers are now implemented in source and database migrations on the planning branch:

1. `project_usage_digest` — read-only 30-day task-state counts, project currency/lifecycle, scheduler status and daily budget/spent/reserved. It does not read customer/member profiles or order details.
2. `work_order_validate` — read-only validation flags for a supplied order ID within the claimed task's project scope. It returns status, currency/scope/settlement checks and locked-allocation count; it does not return customer identity or financial amounts and does not mutate the order.

Both are registered as `read_only`, require service-role RPC, pass through the global emergency stop, active worker heartbeat, project/scheduler/budget gates, claim lease, budget reservation and audit flow. Worker source has explicit branches for these exact task types; unknown types remain fail-closed.

**Runtime acceptance:** disposable PostgreSQL workflow was triggered as run `45959311813` on commit `89c485235bee2b84e65d8e3667ad42a65beb37bc`. At the time of this documentation update it was still pending; do not call Phase A runtime acceptance passed until the run completes successfully. Worker static CI run `45959327873` passed on commit `52bfc611d2f7669a6f0534f87bbdadcb4a3b4469`.

Not implemented: reminders, file integrity/malware scan, acceptance escalation, referral reconciliation, payout preflight, payment-event reconciliation, commission preview, daily finance reconciliation. These remain specified only.

### Runtime test correction — 27 Nov 2026
- First combined Phase A runtime run `45959311813` failed closed at the work-order task claim because the preceding digest test had deliberately re-engaged the global emergency stop and the next test had not reopened it inside its disposable fixture.
- This was a test sequencing issue, not a production setting change. The work-order test now explicitly releases the kill switch only inside the disposable test transaction and re-engages it at completion.
- Corrected runtime rerun: `45959527467`, pending at documentation update. Do not claim work-order runtime acceptance until this rerun succeeds.

### Phase A corrected runtime result — 27 Nov 2026
- Corrected run `45959527467`: **SUCCESS** on disposable PostgreSQL, commit `1b2e57bfbdaad7d9b24bf9ff46ef4bf81f682379`.
- Full ordered migration chain, fresh and legacy-shape disposable DBs, kill-switch checks, synthetic order-to-member ledger tests, usage digest handler, work-order validation handler, budget reservation release and final emergency-stop restoration all passed.
- The prior run `45959311813` remains a failed attempt caused by the test fixture leaving the emergency stop engaged; the corrected fixture passed. No Production/Staging database was touched.
