# MASTER WORLD VIP — Worker Task Execution ও Revenue Acceptance

সর্বশেষ আপডেট: ২৭ নভেম্বর ২০২৬

এই নথি Worker-এর নিরাপদ Task Execution Framework, Budget Reservation, Retry/Dead-letter, Audit, Emergency Stop এবং synthetic Revenue-to-Member Settlement পরীক্ষার সীমা নির্ধারণ করে। এটি Production activation বা real payment-এর অনুমতি নয়।

## ১. Worker Execution Architecture

### বর্তমানে বাস্তবায়িত
- Worker service-role authentication, registration ও heartbeat।
- Database-side worker_claim_project_automation_task(); active worker heartbeat, project execution flag, enabled schedule, supported currency, task status, retry count, lease এবং budget gate যাচাই করে।
- Task idempotency: project_automation_tasks.idempotency_key unique; duplicate key নতুন task তৈরি করতে পারে না।
- Lease token ও expiry: finish operation-এ exact lease token আবশ্যক; stale/duplicate completion প্রত্যাখ্যাত।
- Per-task budget reservation: claim-এর সময় remaining task budget budget_reserved হিসেবে reserve হয়; finish বা expired-lease recovery-তে reservation release হয় এবং actual cost daily spend-এ যোগ হয়।
- Daily project budget: daily_spent + daily_reserved <= daily_budget database constraint ও claim/finish transaction দিয়ে enforce হয়।
- Retry: failed task bounded exponential backoff-এ retry_wait হয়; max attempts পূর্ণ হলে dead_letter।
- Lease reaper: crashed/expired worker-এর lease clear করে reservation release এবং retry/dead-letter করে।
- Audit: task claim, success, retry, dead-letter, lease recovery এবং global kill-switch change আলাদা audit action হিসেবে রেকর্ড হয়।
- Global emergency stop: project_automation_runtime_control.emergency_stop default true; Owner/Admin RPC admin_set_project_automation_kill_switch(boolean,text) দিয়ে reason-সহ audited change করা যায়। Stop চালু থাকলে নতুন task claim হয় না। In-flight task finish/audit করতে পারে।
- Worker function secret MWVIP_WORKER_ENABLED=true না হলে execution disabled থাকে।

### বর্তমানে allow-listed handler
- `system_health_check` — read-only health check.
- `project_usage_digest` — read-only project usage/budget/task-state digest.
- `work_order_validate` — read-only order validation within the claimed task's project scope.

এই তিনটি ছাড়া অন্য কোনো task type claim হবে না। দুইটি business handler-এর disposable runtime acceptance run `45959527467`-এ সফল। ভবিষ্যৎ handler যোগ করতে হলে source implementation, database allowlist, authorization, input/output schema, idempotency, budget, timeout, audit এবং test আলাদাভাবে review করতে হবে।

## ২. Execution Gate

Task execute হওয়ার জন্য সব শর্ত একসঙ্গে সত্য হতে হবে:
1. Worker function MWVIP_WORKER_ENABLED=true।
2. Valid service-role authorization ও worker key।
3. Global emergency stop false।
4. Active worker ও সাম্প্রতিক heartbeat।
5. Project execution_enabled=true এবং approved positive project budget।
6. Project schedule enabled, daily budget positive এবং available।
7. Task type database allowlist-এ enabled ও read_only।
8. Task queued/retry_wait, available, attempts বাকি এবং budget cap বাকি।
9. Project-এর জন্য অন্য running task নেই (বর্তমান unique index limit: এক সময়ে একটি)।

Default state-এ global emergency stop true; project registry ও schedules default disabled। তাই code deploy হলেই task execution শুরু হয় না।

## ৩. Disposable Runtime Acceptance

Workflow validate-migrations-disposable.yml সম্পূর্ণ migration chain fresh ও audited legacy-shape disposable PostgreSQL-এ apply করে এবং এরপর:
- Emergency stop default true কি না যাচাই;
- stop অবস্থায় claim শূন্য কি না যাচাই;
- anon/authenticated worker claim করতে পারে না কি না যাচাই;
- synthetic task claim ও lease completion;
- duplicate idempotency key-এ একটিমাত্র task;
- claim-time budget reservation ও completion-time release;
- failed attempt retry এবং max attempts-এ dead-letter;
- daily spend এবং audit events যাচাই;
- synthetic customer order lifecycle, provider settlement evidence, তিনটি locked allocation, double-entry journal, duplicate journal retry এবং Member payout ledger reconciliation যাচাই।

সব fixture synthetic। Provider transaction/event/reconciliation reference fake। কোনো external provider API, bank, bKash, Nagad, Production database বা real money ব্যবহার হয় না।

## ৪. Revenue → Member Settlement Model

Synthetic acceptance path:
1. Customer order তৈরি হয় pending_payment অবস্থায়।
2. Verified-payment evidence, fund segregation, refund reserve, operating budget ও তিনটি matching locked allocation ছাড়া funded হওয়া যায় না।
3. Work lifecycle: funded → in_progress → delivered → accepted → completed।
4. Double-entry journal-এ customer settlement, Member payable এবং refund reserve আলাদা currency/account-এ পোস্ট হয়।
5. Duplicate journal retry একই idempotency key/payload-এ duplicate হিসেবে ফেরে; নতুন journal তৈরি হয় না।
6. Member payout request available payable balance reserve করে।
7. Synthetic payout journal balanced হওয়ার পর fake provider settlement/reconciliation fields দিয়ে request paid হয়।
8. Member payable balance ও ledger integrity পুনরায় যাচাই হয়।

এই test internal accounting/workflow correctness যাচাই করে; external payment collection, fund custody, real settlement বা bank payout প্রমাণ করে না।

## ৫. এখনো অসম্পূর্ণ / বাহ্যিক নির্ভরতা

- আলাদা Staging Supabase project ও ১১টি Staging secret; Owner/Admin/Member পৃথক Auth test identities।
- Staging migration/Auth/RBAC end-to-end acceptance।
- Read-only health check ছাড়া বাস্তব business task handler; নির্দিষ্ট task catalog, input/output contract, permissions, cost model, customer data scope এবং acceptance evidence।
- Official bKash/Nagad/bank/SSLCommerz sandbox/API access, merchant/provider approval, signed webhook verification, beneficiary verification, legal/KYC/AML/tax review এবং settlement reconciliation।
- Customer-facing checkout এবং real paid order-এর external provider integration।
- Admin commission ২০% এখনো proposal only; calculation basis, disclosure ও legal/tax approval ছাড়া সক্রিয় নয়।
- Production migration, Worker production deployment, live collection, refund বা payout সবই আলাদা approval gate-এর অধীন।

## ৬. নিরাপত্তা সিদ্ধান্ত

- এই migration Production-এ apply করা হয়নি।
- Staging workflow manual-only; কোনো Staging secret বা project credential এই নথিতে নেই।
- Emergency stop default true; Worker execution secret default enabled নয়।
- কোনো real funds, wallet PIN/OTP, bank password বা provider secret ব্যবহার করা হয়নি।
- Production migration ও Live Deployment-এর জন্য পৃথক explicit approval বাধ্যতামূলক।


## Phase A Read-only Business Handlers — 27 November 2026

Added on the planning branch:
- Migration `20261127120000_project_usage_digest_read_only_handler.sql`: `project_usage_digest` allowlist registration, service-role-only `worker_read_project_usage_digest(uuid)`, and claim routine allowing only source-implemented read-only handler types.
- Migration `20261127130000_work_order_validate_read_only_handler.sql`: `work_order_validate` registration, service-role-only `worker_validate_work_order(uuid,uuid)`, strict task-project/order-project match, and updated exact handler allowlist.
- Worker TypeScript explicitly dispatches `project_usage_digest` and `work_order_validate`; malformed order IDs fail closed. Both results declare no external or financial effects.
- Disposable runtime SQL now exercises both handlers against synthetic fixtures, verifies budget reservation release and re-engages global emergency stop.

The new business handlers expose no customer identity, make no order or ledger mutation, and call no payment provider. Their database functions are service-role-only. Project execution, schedule and budget still must be separately enabled; the global kill switch remains default STOPPED. No Production or Staging deployment occurred.

Verification:
- Worker Static CI run `45959327873`: success, commit `52bfc611d2f7669a6f0534f87bbdadcb4a3b4469`.
- Disposable full-chain migration/runtime run `45959311813`: pending at the time recorded; its result must be checked before claiming runtime acceptance.

### Runtime test correction — 27 November 2026
- Combined Phase A run `45959311813` failed at the work-order claim because the preceding digest test correctly restored the global emergency stop; the following test fixture did not reopen it before claiming.
- Corrected only the disposable test fixture: it now releases the stop for that isolated work-order test and sets it back to TRUE at the end. No Staging/Production control was changed.
- Corrected runtime rerun `45959527467` was pending when this note was added. Work-order validation runtime pass is not claimed until that run completes successfully.

### Corrected Phase A runtime acceptance — 27 November 2026
- Corrected run `45959527467`: **SUCCESS**. It applied the complete ordered migration chain to fresh and legacy-shape disposable PostgreSQL databases and passed the full synthetic runtime step.
- The same run passed both Phase A handlers: `project_usage_digest` and `work_order_validate`, including project-scope/data-minimization checks, task completion, budget reservation release and emergency-stop restoration.
- The earlier run `45959311813` failed because the test fixture attempted to claim while the emergency stop was correctly TRUE; the fixture was corrected to reopen only inside the disposable test and close again afterward.
- Worker Static CI `45959327873`: **SUCCESS**. No Staging or Production action occurred.
