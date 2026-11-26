#!/usr/bin/env python3
"""Static safety checks for Step 3 plan and customer-funded order foundations."""
from pathlib import Path
import re

sql = Path("supabase/migrations/20261126120000_free_paid_plan_customer_order_gates.sql").read_text(encoding="utf-8")
flat = re.sub(r"\s+", " ", sql.lower())
checks = {
    "Free/Paid catalog separates Admin and Member audiences": all(x in flat for x in ["project_plan_catalog", "audience in ('admin','member')", "plan_kind in ('free','paid')"]),
    "paid plan requires positive price and billing period": "plan_kind='paid' and price>0 and billing_period is not null" in flat,
    "no unapproved price or paid activation is seeded": "enabled boolean not null default false" in flat and "paid_activation_enabled boolean not null default false" in flat and "insert into public.project_plan_catalog" not in flat,
    "active entitlement requires verified provider settlement": all(x in flat for x in ["provider_transaction_id is not null", "provider_event_id is not null", "provider_settled_at is not null", "status<>'active'"]),
    "activation checks exact catalog amount, currency and enabled paid plan": all(x in flat for x in ["validate_project_plan_subscription", "v_plan.plan_kind<>'paid'", "v_plan.paid_activation_enabled", "new.settled_amount is distinct from v_plan.price", "new.currency is distinct from v_plan.currency"]),
    "customer orders require strictly positive price": "customer_price numeric(14,2) not null check (customer_price>0)" in flat,
    "work cannot start without settled and segregated customer funds": all(x in flat for x in ["status not in ('funded','in_progress','delivered','accepted','completed')", "funds_segregated_at is not null", "provider_settled_at is not null"]),
    "refund reserve and operating budget are independently verified": "refund_reserve_verified_at is not null" in flat and "operating_budget_verified_at is not null" in flat,
    "order financial allocation must be covered": "customer_price>=member_payable+refund_liability+operating_cost_budget" in flat,
    "project currency and execution enablement are enforced": all(x in flat for x in ["validate_customer_service_order", "new.currency is distinct from v_project.revenue_currency", "v_project.execution_enabled", "v_project.revenue_collection_enabled", "v_project.lifecycle_status<>'active'"]),
    "scope terms must exist before funded work": "new.scope_terms='{}'::jsonb" in flat,
    "duplicate payment events and orders are idempotent": "provider_event_id text unique" in flat and "idempotency_key text not null unique" in flat,
    "acceptance requires evidence": "status not in ('accepted','completed') or acceptance_evidence<>'{}'::jsonb" in flat,
    "RLS and service-role-only writes": flat.count("enable row level security") == 3 and "from public,anon,authenticated" in flat and "to service_role" in flat,
    "no live checkout/provider integration is introduced": not any(x in flat for x in ["create checkout", "net.http_post(", "stripe.checkout", "webhook handler"]),
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if failed:
    raise SystemExit(1)
