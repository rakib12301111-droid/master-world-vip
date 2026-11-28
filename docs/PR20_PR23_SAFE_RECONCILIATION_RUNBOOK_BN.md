# PR #20–#23 নিরাপদ Reconciliation ও Release Runbook (বাংলা)

**তারিখ:** ২৮ নভেম্বর ২০২৬  
**Repository:** `rakib12301111-droid/master-world-vip`  
**উদ্দেশ্য:** বিদ্যমান PR ও branch-গুলোকে dependency অনুযায়ী নিরাপদে reconcile, test, Staging-এ accept এবং পরে release করা। এটি নতুন app নয়।

## ১. যাচাইকৃত dependency map

| PR | Head branch | Base branch | Dependency / নিয়ম |
|---|---|---|---|
| #20 — 4,000-project dual-currency economy | `planning/4000-automated-project-economy` | `main` | মূল economy, order, ledger ও worker foundation |
| #23 — Admin Free / Member Paid-only | `feature/admin-free-member-paid-plan-gates` | `planning/4000-automated-project-economy` | #20-এর ওপর stacked; #20 ছাড়া main-এ নেওয়া যাবে না |
| #21 — Customer Services catalogue | `feature/customer-services-mvp` | `main` | #22-এর parent foundation; একা release নয় |
| #22 — Authenticated quote + Admin inbox | `feature/customer-quote-workflow` | `feature/customer-services-mvp` | আগে #21 branch-এর সঙ্গে integrate ও test করতে হবে |

## ২. নিরাপদ integration sequence

### Track A — Economy
1. `main`-এর সর্বশেষ commit-এর সঙ্গে `planning/4000-automated-project-economy` compare করুন।
2. Conflict হলে আলাদা integration branch-এ conflict resolve করুন; original PR branch force-push/overwrite করবেন না।
3. Migration order, production migration inventory/allowlist, rollback/dry-run verifier, worker fail-closed behavior, USD/BDT double-entry ledger, idempotency এবং customer-fund allocation invariant যাচাই করুন।
4. Full disposable PostgreSQL chain: fresh DB ও legacy-shape DB—দুইটিতেই সব migration ক্রমানুসারে apply ও runtime assertions চালান।
5. সব required CI green এবং review ছাড়া #20 merge নয়।
6. #20 integration branch-এ #23-এর changes reconcile করুন; entitlement must deny Member without verified Paid entitlement and Admin must remain Free. Every task/order/worker execution entry point-এ server-side enforcement test করুন।

### Track B — Customer Services
1. `feature/customer-services-mvp`-কে latest `main`-এর সঙ্গে reconcile করুন।
2. `feature/customer-quote-workflow`-কে updated parent branch-এর সঙ্গে reconcile করুন।
3. Authenticated customer quote submission, per-user rate limit, private RLS, server-side Admin RBAC, immutable quote terms, expiry/cancel/decline এবং append-only audit/events পরীক্ষা করুন।
4. Quote acceptance যেন funded order, payment বা payout বলে গণ্য না হয়—এটি বজায় রাখুন।
5. Combined branch-এ full disposable migration/runtime CI, Staging acceptance, Admin/Customer manual tests এবং Android Chrome check সফল হওয়ার পরই PR #21/#22-এর release merge বিবেচনা করুন।

## ৩. প্রতিটি merge-এর আগে বাধ্যতামূলক gate

- [ ] latest base SHA ও PR head SHA নথিভুক্ত
- [ ] merge conflict শূন্য; কোনো unresolved review thread নেই
- [ ] fresh + legacy disposable PostgreSQL full-chain tests PASS
- [ ] migration safety / allowlist / dry-run tests PASS
- [ ] backup encryption + isolated restore PASS
- [ ] worker static + runtime tests PASS; default kill switch STOPPED
- [ ] customer/order/ledger/entitlement runtime tests PASS
- [ ] Staging Auth-এ Owner, Admin, Member তিনটি পৃথক confirmed account দিয়ে password-grant login PASS
- [ ] Staging-only migration preview ও manual acceptance PASS
- [ ] no production project ref in Staging workflow; secrets remain in GitHub/Supabase secure settings
- [ ] human review/approval and deployment impact understood

## ৪. Live হওয়ার আগে এখনো আলাদা engineering deliverables

- বাস্তব document/PDF/image/translation task handlers; বর্তমানে audited worker-এ read-only health, usage digest ও work-order validation handlers মাত্র।
- Isolated worker hosting, scheduler, heartbeat, retries, monitoring, task budget এবং emergency kill switch।
- Customer quote → priced order → provider signed settlement webhook → independently verified segregated custody → scoped Member assignment → deliverable → customer acceptance/dispute/refund।
- Official payment/payout provider adapters, lawful onboarding/KYC, funded refund/chargeback reserve, daily external reconciliation এবং actual transfer confirmation।
- USD ও BDT পৃথক double-entry accounting, Member payable protection এবং Admin commission calculation/disclosure/reversal tests।

## ৫. Production safety boundary

- সাধারণ “চালু করুন” অনুমতি Production migration-এর নির্দিষ্ট অনুমতি নয়।
- Production migration-এর আগে সব backup/restore, full-chain validation, read-only audit, rollback plan ও staging gates PASS হতে হবে এবং Owner-কে আলাদাভাবে exact phrase দিতে হবে: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`।
- এই exact approval না পাওয়া পর্যন্ত Production migration apply করা যাবে না।
- Provider settlement, funded custody ও payout rail যাচাই না হওয়া পর্যন্ত বাস্তব টাকা সংগ্রহ, reserve, commission, refund বা payout চালু করা যাবে না।
- Synthetic test transaction, database allocation row বা CI PASS বাস্তব অর্থ লেনদেনের প্রমাণ নয়।

## ৬. বর্তমান execution record

এই runbook তৈরি করার সময় GitHub থেকে PR description ও branch names পুনরায় দেখা হয়েছে। PR #20–#23-এর branch dependency আগের handover-এর সঙ্গে সামঞ্জস্যপূর্ণ। কিন্তু এই update-এ কোনো code conflict resolve, branch ref move, PR merge, Staging migration, Production migration, Worker deploy বা payment/payout action করা হয়নি। সেগুলোর জন্য আলাদা code-level changes, fresh CI evidence এবং dashboard/provider acceptance প্রয়োজন।

**Release status: NOT READY / NOT LIVE.** এই নথি execution checklist; completion certificate নয়।
