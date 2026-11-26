#!/usr/bin/env python3
"""Static safety checks for Step 3 plan, customer-funded orders and Member protection."""
from pathlib import Path
import re

base = Path("supabase/migrations/20261126120000_free_paid_plan_customer_order_gates.sql").read_text(encoding="utf-8")
hardening = Path("supabase/migrations/20261126130000_member_loss_prevention_hardening.sql").read_text(encoding="utf-8")
flat = re.sub(r"\\s+", " ", base.lower())
hard = re.sub(r"\\s+", " ", hardening.lower())
checks = {
    "Free/Paid catalog separates Admin and Member audiences": all(x in flat for x in ["project_plan_catalog", "audience in ('admin','member')", "plan_kind in ('free','paid')"]),
    "paid plan requires positive price and billing period": "plan_kind='paid' and price>0 and billing_period is not null" in flat,
    "no unapproved price or paid activation is seeded": "enabled boolean not null default false" in flat and "paid_activation_enabled boolean not null default false" in flat and "insert into public.project_plan_catalog" not in flat,
    "active entitlement requires verified provider settlement": all(x in flat for x in ["provider_transaction_id is not null", "provider_event_id is not null", "provider_settled_at is not null", "status<>'active'"]),
    "activation checks exact catalog amount, currency and enabled paid plan": all(x in flat for x in ["validate_project_plan_subscription", "v_plan.plan_kind<>'paid'", "v_plan.paid_activation_enabled", "new.settled_amount is distinct from v_plan.price", "new.currency is distinct from v_plan.currency"]),
    "customer orders require positive price and allocated cost coverage": "customer_price numeric(14,2) not null check (customer_price>0)" in flat and "customer_price>=member_payable+refund_liability+operating_cost_budget" in flat,
    "customer work is blocked until provider settlement": all(x in flat for x in ["status not in ('funded','in_progress','delivered','accepted','completed')", "provider_transaction_id is not null", "provider_event_id is not null", "provider_settled_at is not null"]),
    "funds are allocated into three separate protected buckets": all(x in flat for x in ["customer_order_fund_allocations", "member_payable", "refund_reserve", "operating_cost", "unique(order_id,bucket)"]),
    "funded work requires exactly three matching locked allocations": all(x in flat for x in ["v_allocation_count<>3", "not v_allocations_match", "state='locked'", "three matching locked fund allocations are required"]),
    "fund segregation, refund reserve and operating budget are separate gates": all(x in flat for x in ["funds_segregated_at is null", "refund_reserve_verified_at is null", "operating_budget_verified_at is null"]),
    "project currency and execution enablement are enforced": all(x in flat for x in ["validate_customer_service_order", "new.currency is distinct from v_project.revenue_currency", "v_project.execution_enabled", "v_project.revenue_collection_enabled", "v_project.lifecycle_status<>'active'"]),
    "scope terms must exist before funded work": "new.scope_terms='{}'::jsonb" in flat,
    "payment events and orders are idempotent": "provider_event_id text unique" in flat and "idempotency_key text not null unique" in flat,
    "acceptance requires evidence": "status not in ('accepted','completed') or acceptance_evidence<>'{}'::jsonb" in flat,
    "RLS and service-role-only writes cover all four tables": flat.count("enable row level security") == 4 and "from public,anon,authenticated" in flat and "to service_role" in flat,
    "financial order terms cannot be edited after creation": "customer_price is distinct from old.customer_price" in hard and "member_payable is distinct from old.member_payable" in hard,
    "order lifecycle transitions are explicitly allow-listed and cannot move backwards": "invalid customer order lifecycle transition" in hard and "a funded order cannot be moved backwards or re-funded" in hard,
    "fund allocations are append-only with update/delete blocked": "before update or delete on public.customer_order_fund_allocations" in hard and "customer order fund allocations are immutable" in hard,
    "funded and financially resolved orders cannot be deleted": "before delete on public.customer_service_orders" in hard and "cannot be deleted" in hard,
    "hardening triggers are security-definer with fixed search path": hard.count("security definer") >= 3 and hard.count("set search_path = ''") >= 3,
    "no live checkout or custody provider is falsely introduced": not any(x in hard for x in ["create checkout", "net.http_post(", "stripe.checkout", "webhook handler"]),
}
for name, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + name)
if not all(checks.values()):
    raise SystemExit(1)
