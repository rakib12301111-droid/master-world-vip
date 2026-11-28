-- MASTER WORLD VIP — Phase A read-only business handler.
-- Adds a project usage digest only. No customer data, order mutation, external calls or money movement.
-- Safe by default: global kill switch and per-project/schedule/budget gates remain authoritative.

insert into public.project_automation_task_handlers
  (task_type,enabled,side_effect_class,handler_version,max_runtime_seconds)
values
  ('project_usage_digest',true,'read_only','1.0.0',20)
on conflict(task_type) do update set
  enabled=excluded.enabled,
  side_effect_class=excluded.side_effect_class,
  handler_version=excluded.handler_version,
  max_runtime_seconds=excluded.max_runtime_seconds,
  updated_at=now();

create or replace function public.worker_read_project_usage_digest(p_project_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path=''
as $function$
declare
  v_result jsonb;
begin
  if auth.role()<>'service_role' then
    raise exception 'Worker service role required';
  end if;
  if p_project_id is null then
    raise exception 'Project id required';
  end if;

  select jsonb_build_object(
    'project_code',r.project_code,
    'project_number',r.project_number,
    'currency',r.revenue_currency,
    'lifecycle_status',r.lifecycle_status,
    'execution_enabled',r.execution_enabled,
    'scheduler_enabled',coalesce(s.enabled,false),
    'daily_budget',coalesce(s.daily_budget,0),
    'daily_spent',case
      when s.budget_date<current_date then 0
      else coalesce(s.daily_spent,0) end,
    'daily_reserved',case
      when s.budget_date<current_date then 0
      else coalesce(s.daily_reserved,0) end,
    'tasks',jsonb_build_object(
      'queued',coalesce(t.queued,0),
      'running',coalesce(t.running,0),
      'succeeded',coalesce(t.succeeded,0),
      'retry_wait',coalesce(t.retry_wait,0),
      'dead_letter',coalesce(t.dead_letter,0),
      'failed',coalesce(t.failed,0),
      'cancelled',coalesce(t.cancelled,0)
    ),
    'generated_at',now()
  )
  into v_result
  from public.earning_project_registry r
  left join public.project_automation_settings s on s.project_id=r.id
  left join lateral (
    select
      count(*) filter(where status='queued')::integer as queued,
      count(*) filter(where status='running')::integer as running,
      count(*) filter(where status='succeeded')::integer as succeeded,
      count(*) filter(where status='retry_wait')::integer as retry_wait,
      count(*) filter(where status='dead_letter')::integer as dead_letter,
      count(*) filter(where status='failed')::integer as failed,
      count(*) filter(where status='cancelled')::integer as cancelled
    from public.project_automation_tasks
    where project_id=r.id
      and created_at>=now()-interval '30 days'
  ) t on true
  where r.id=p_project_id;

  if v_result is null then
    raise exception 'Project not found';
  end if;
  return v_result;
end;
$function$;

revoke all on function public.worker_read_project_usage_digest(uuid) from public,anon,authenticated;
grant execute on function public.worker_read_project_usage_digest(uuid) to service_role;

-- Permit only the two source-implemented read-only handlers.
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
  ) then
    return;
  end if;

  select * into v_worker
  from public.project_automation_workers
  where worker_key=p_worker_key
    and status='active'
    and last_heartbeat_at>now()-interval '2 minutes'
  for update;
  if not found then
    raise exception 'Active worker heartbeat required';
  end if;

  select t.id,(t.budget_cap-t.actual_cost)
  into v_task,v_budget_reservation
  from public.project_automation_tasks t
  join public.earning_project_registry r on r.id=t.project_id
  join public.project_automation_settings s on s.project_id=r.id and s.enabled
  join public.project_automation_task_handlers h on h.task_type=t.task_type
    and h.enabled and h.side_effect_class='read_only'
  where t.task_type in ('system_health_check','project_usage_digest')
    and t.status in ('queued','retry_wait')
    and t.available_at<=now()
    and t.attempts<t.max_attempts
    and t.actual_cost<t.budget_cap
    and r.execution_enabled
    and r.budget_cap>0
    and r.revenue_currency=any(v_worker.supported_currencies)
    and s.daily_budget>0
    and s.daily_budget<=r.budget_cap
    and (case when s.budget_date<current_date then 0
      else s.daily_spent+s.daily_reserved end)+(t.budget_cap-t.actual_cost)<=s.daily_budget
    and not exists(
      select 1 from public.project_automation_tasks running
      where running.project_id=t.project_id and running.status='running'
    )
  order by t.available_at,t.created_at
  for update of t,s skip locked
  limit 1;

  if v_task is null then
    return;
  end if;

  update public.project_automation_settings
  set daily_spent=case when budget_date<current_date then 0 else daily_spent end,
      daily_reserved=(case when budget_date<current_date then 0 else daily_reserved end)+v_budget_reservation,
      budget_date=current_date,
      updated_at=now()
  where project_id=(select project_id from public.project_automation_tasks where id=v_task);

  v_lease:=gen_random_uuid();
  update public.project_automation_tasks
  set status='running',
      worker_id=v_worker.id,
      attempts=attempts+1,
      lease_token=v_lease,
      budget_reserved=v_budget_reservation,
      locked_at=now(),
      lease_expires_at=now()+interval '5 minutes',
      started_at=coalesce(started_at,now()),
      updated_at=now()
  where id=v_task;

  update public.project_automation_workers
  set tasks_claimed=tasks_claimed+1,updated_at=now()
  where id=v_worker.id;

  insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
  select project_id,id,v_worker.id,'task_claimed',
    jsonb_build_object('task_type',task_type,'attempt',attempts,
      'budget_reserved',budget_reserved,'lease_seconds',300)
  from public.project_automation_tasks
  where id=v_task;

  return query select * from public.project_automation_tasks where id=v_task;
end;
$function$;

revoke all on function public.worker_claim_project_automation_task(text) from public,anon,authenticated;
grant execute on function public.worker_claim_project_automation_task(text) to service_role;

comment on function public.worker_read_project_usage_digest(uuid) is
  'Service-role-only read-only 30-day project usage summary. Excludes customer/member data and never mutates records.';
