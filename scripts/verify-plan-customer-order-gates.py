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
    "customer orders require strictly positive price and full allocation coverage": "customer_price numeric(14,2) not null check (customer_price>0)" in flat and "customer_price>=member_payable+refund_liability+operating_cost_budget" in flat,
    "all customer work is blocked until provider settlement": all(x in flat for x in ["status not in ('funded','in_progress','delivered','accepted','completed')", "provider_transaction_id is not null", "provider_event_id is not null", "provider_settled_at is not null"]),
    "funds are allocated into three separate protected buckets": all(x in flat for x in ["customer_order_fund_allocations", "member_payable", "refund_reserve", "operating_cost", "unique(order_id,bucket)"]),
    "funded work requires exactly three matching locked allocations": all(x in flat for x in ["v_allocation_count<>3", "not v_allocations_match", "state='locked'", "three matching locked fund allocations are required"]),
    "fund segregation, refund reserve and operating budget are separate gates": all(x in flat for x in ["funds_segregated_at is null", "refund_reserve_verified_at is null", "operating_budget_verified_at is null"]),
    "project currency and execution enablement are enforced": all(x in flat for x in ["validate_customer_service_order", "new.currency is distinct from v_project.revenue_currency", "v_project.execution_enabled", "v_project.revenue_collection_enabled", "v_project.lifecycle_status<>'active'"]),
    "scope terms must exist before funded work": "new.scope_terms='{}'::jsonb" in flat,
    "duplicate payment events and orders are idempotent": "provider_event_id text unique" in flat and "idempotency_key text not null unique" in flat,
    "acceptance requires evidence": "status not in ('accepted','completed') or acceptance_evidence<>'{}'::jsonb" in flat,
    "RLS and service-role-only writes cover all four tables": flat.count("enable row level security") == 4 and "from public,anon,authenticated" in flat and "to service_role" in flat,
    "no live checkout/provider integration is introduced": not any(x in flat for x in ["create checkout", "net.http_post(", "stripe.checkout", "webhook handler"]),
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if failed:
    raise SystemExit(1)
