-- MASTER WORLD VIP — Step 3 hardening: immutable order funds and monotonic order lifecycle.
-- Additive and fail-closed. This does not custody real money or prove bank segregation.
-- Apply only after the preceding plan/customer-order migration has been reviewed and tested.

create or replace function public.guard_customer_order_financial_changes()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if new.id is distinct from old.id
    or new.project_id is distinct from old.project_id
    or new.customer_user_id is distinct from old.customer_user_id
    or new.currency is distinct from old.currency
    or new.customer_price is distinct from old.customer_price
    or new.member_payable is distinct from old.member_payable
    or new.refund_liability is distinct from old.refund_liability
    or new.operating_cost_budget is distinct from old.operating_cost_budget
    or new.idempotency_key is distinct from old.idempotency_key then
    raise exception 'Customer order identity and financial terms are immutable; create a replacement order';
  end if;

  if new.status is distinct from old.status then
    if not (
      (old.status='pending_payment' and new.status in ('funded','cancelled','refunded'))
      or (old.status='funded' and new.status in ('in_progress','cancelled','disputed','refunded'))
      or (old.status='in_progress' and new.status in ('delivered','cancelled','disputed','refunded'))
      or (old.status='delivered' and new.status in ('accepted','disputed','refunded'))
      or (old.status='accepted' and new.status in ('completed','disputed','refunded'))
      or (old.status='disputed' and new.status in ('accepted','refunded','cancelled'))
    ) then
      raise exception 'Invalid customer order lifecycle transition';
    end if;
  end if;

  if old.status in ('funded','in_progress','delivered','accepted','completed','disputed')
    and new.status in ('pending_payment','funded') then
    raise exception 'A funded order cannot be moved backwards or re-funded';
  end if;

  return new;
end;
$function$;

revoke all on function public.guard_customer_order_financial_changes() from public,anon,authenticated;
drop trigger if exists customer_order_financial_guard on public.customer_service_orders;
create trigger customer_order_financial_guard
  before update on public.customer_service_orders
  for each row execute function public.guard_customer_order_financial_changes();

-- Allocation evidence is append-only. Corrections require cancelling the order and
-- creating a new order; existing Member/refund/operating buckets cannot be rewritten.
create or replace function public.reject_customer_order_allocation_mutation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  raise exception 'Customer order fund allocations are immutable; cancel and recreate the order to correct allocation data';
end;
$function$;

revoke all on function public.reject_customer_order_allocation_mutation() from public,anon,authenticated;
drop trigger if exists customer_order_allocation_no_update on public.customer_order_fund_allocations;
create trigger customer_order_allocation_no_update
  before update or delete on public.customer_order_fund_allocations
  for each row execute function public.reject_customer_order_allocation_mutation();

-- A protected order cannot be deleted, including by service_role.
create or replace function public.reject_protected_customer_order_delete()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if old.status in ('funded','in_progress','delivered','accepted','completed','disputed','refunded') then
    raise exception 'Funded or financially resolved customer orders cannot be deleted';
  end if;
  return old;
end;
$function$;

revoke all on function public.reject_protected_customer_order_delete() from public,anon,authenticated;
drop trigger if exists customer_order_no_protected_delete on public.customer_service_orders;
create trigger customer_order_no_protected_delete
  before delete on public.customer_service_orders
  for each row execute function public.reject_protected_customer_order_delete();

comment on function public.guard_customer_order_financial_changes() is
  'Prevents post-creation financial-term edits and invalid/backwards customer order lifecycle transitions.';
comment on function public.reject_customer_order_allocation_mutation() is
  'Makes order fund allocation records append-only; database evidence is not external custody proof.';
comment on function public.reject_protected_customer_order_delete() is
  'Prevents deletion of funded or financially resolved customer order records.';
