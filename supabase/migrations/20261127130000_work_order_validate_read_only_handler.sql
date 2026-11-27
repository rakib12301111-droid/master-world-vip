-- MASTER WORLD VIP — Phase A read-only work-order validation handler.
-- Returns validation flags only; no customer identifiers, financial amounts or record mutation.

insert into public.project_automation_task_handlers
  (task_type,enabled,side_effect_class,handler_version,max_runtime_seconds)
values
  ('work_order_validate',true,'read_only','1.0.0',20)
on conflict(task_type) do update set
  enabled=excluded.enabled,
  side_effect_class=excluded.side_effect_class,
  handler_version=excluded.handler_version,
  max_runtime_seconds=excluded.max_runtime_seconds,
  updated_at=now();

create or replace function public.worker_validate_work_order(
  p_project_id uuid,
  p_order_id uuid
) returns jsonb
language plpgsql
stable
security definer
set search_path=''
as $function$
declare
  v_order record;
  v_locked_allocations integer;
  v_scope_ok boolean;
  v_settlement_ok boolean;
  v_currency_ok boolean;
begin
  if auth.role()<>'service_role' then
    raise exception 'Worker service role required';
  end if;
  if p_project_id is null or p_order_id is null then
    raise exception 'Project id and order id required';
  end if;

  select o.status,o.currency,o.scope_terms,o.provider_transaction_id,
         o.provider_event_id,o.provider_settled_at,
         r.revenue_currency
  into v_order
  from public.customer_service_orders o
  join public.earning_project_registry r on r.id=o.project_id
  where o.id=p_order_id and o.project_id=p_project_id;

  if not found then
    raise exception 'Work order not found in task project scope';
  end if;

  select count(*)::integer into v_locked_allocations
  from public.customer_order_fund_allocations a
  where a.order_id=p_order_id
    and a.currency=v_order.currency
    and a.state='locked';

  v_scope_ok := v_order.scope_terms<>'{}'::jsonb;
  v_settlement_ok := v_order.provider_transaction_id is not null
    and v_order.provider_event_id is not null
    and v_order.provider_settled_at is not null;
  v_currency_ok := v_order.currency=v_order.revenue_currency;

  return jsonb_build_object(
    'order_id',p_order_id,
    'project_id',p_project_id,
    'status',v_order.status,
    'currency_match',v_currency_ok,
    'scope_terms_present',v_scope_ok,
    'settlement_evidence_present',v_settlement_ok,
    'locked_allocation_count',v_locked_allocations,
    'validation_passed',(
      v_currency_ok and v_scope_ok
      and (v_order.status='pending_payment' or v_settlement_ok)
      and (v_order.status='pending_payment' or v_locked_allocations=3)
    ),
    'read_only',true
  );
end;
$function$;

revoke all on function public.worker_validate_work_order(uuid,uuid) from public,anon,authenticated;
grant execute on function public.worker_validate_work_order(uuid,uuid) to service_role;

-- Extend claimable set only to handlers present in source and explicitly allowlisted as read-only.
create or replace function public.worker_claim_project_automation_task(p_worker_key text)
returns setof public.project_automation_tasks
language plpgsql security definer set search_path=''
as $function$
declare
  v_worker public.project_automation_workers%rowtype;
  v_task uuid;
  v_lease uuid;
  v_budget_reservation numeric(14,2);
begin
  if auth.role()<>'service_role' then
    raise exception 'Worker service role required';
  end if;
  if not exists(
    select 1 from public.project_automation_runtime_control
    where singleton=true and emergency_stop=false
  ) then return; end if;

  select * into v_worker
  from public.project_automation_workers
  where worker_key=p_worker_key and status='active'
    and last_heartbeat_at>now()-interval '2 minutes'
  for update;
  if not found then raise exception 'Active worker heartbeat required'; end if;

  select t.id,(t.budget_cap-t.actual_cost)
  into v_task,v_budget_reservation
  from public.project_automation_tasks t
  join public.earning_project_registry r on r.id=t.project_id
  join public.project_automation_settings s on s.project_id=r.id and s.enabled
  join public.project_automation_task_handlers h on h.task_type=t.task_type
    and h.enabled and h.side_effect_class='read_only'
  where t.task_type in ('system_health_check','project_usage_digest','work_order_validate')
    and t.status in ('queued','retry_wait')
    and t.available_at<=now()
    and t.attempts<t.max_attempts
    and t.actual_cost<t.budget_cap
    and r.execution_enabled and r.budget_cap>0
    and r.revenue_currency=any(v_worker.supported_currencies)
    and s.daily_budget>0 and s.daily_budget<=r.budget_cap
    and (case when s.budget_date<current_date then 0
      else s.daily_spent+s.daily_reserved end)+(t.budget_cap-t.actual_cost)<=s.daily_budget
    and not exists(
      select 1 from public.project_automation_tasks running
      where running.project_id=t.project_id and running.status='running'
    )
  order by t.available_at,t.created_at
  for update of t,s skip locked limit 1;

  if v_task is null then return; end if;

  update public.project_automation_settings
  set daily_spent=case when budget_date<current_date then 0 else daily_spent end,
      daily_reserved=(case when budget_date<current_date then 0 else daily_reserved end)+v_budget_reservation,
      budget_date=current_date,updated_at=now()
  where project_id=(select project_id from public.project_automation_tasks where id=v_task);

  v_lease:=gen_random_uuid();
  update public.project_automation_tasks
  set status='running',worker_id=v_worker.id,attempts=attempts+1,
      lease_token=v_lease,budget_reserved=v_budget_reservation,
      locked_at=now(),lease_expires_at=now()+interval '5 minutes',
      started_at=coalesce(started_at,now()),updated_at=now()
  where id=v_task;

  update public.project_automation_workers
  set tasks_claimed=tasks_claimed+1,updated_at=now()
  where id=v_worker.id;

  insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
  select project_id,id,v_worker.id,'task_claimed',
    jsonb_build_object('task_type',task_type,'attempt',attempts,
      'budget_reserved',budget_reserved,'lease_seconds',300)
  from public.project_automation_tasks where id=v_task;

  return query select * from public.project_automation_tasks where id=v_task;
end;
$function$;

revoke all on function public.worker_claim_project_automation_task(text) from public,anon,authenticated;
grant execute on function public.worker_claim_project_automation_task(text) to service_role;

comment on function public.worker_validate_work_order(uuid,uuid) is
  'Service-role-only read-only work order validation. Returns flags only and enforces task project scope.';
