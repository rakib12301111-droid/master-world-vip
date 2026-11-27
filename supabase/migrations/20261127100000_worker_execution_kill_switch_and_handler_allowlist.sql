-- MASTER WORLD VIP — fail-closed worker execution controls.
-- Adds an Owner/Admin emergency stop and a database-enforced task-handler allowlist.
-- Only the built-in read-only system_health_check handler is registered.
-- No customer data mutation, provider call, payment, refund or payout is implemented here.

create table if not exists public.project_automation_runtime_control (
  singleton boolean primary key default true check (singleton),
  emergency_stop boolean not null default true,
  stop_reason text not null default 'Default safe state: worker execution disabled',
  updated_by uuid references auth.users(id) on delete set null,
  updated_at timestamptz not null default now()
);

insert into public.project_automation_runtime_control(singleton,emergency_stop,stop_reason)
values(true,true,'Default safe state: worker execution disabled')
on conflict(singleton) do nothing;

create table if not exists public.project_automation_task_handlers (
  task_type text primary key check (task_type ~ '^[a-z][a-z0-9_]{1,63}$'),
  enabled boolean not null default false,
  side_effect_class text not null check (side_effect_class in ('read_only','internal_write','external_write','financial')),
  handler_version text not null check (char_length(btrim(handler_version)) between 1 and 40),
  max_runtime_seconds integer not null default 30 check (max_runtime_seconds between 1 and 300),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- This is the only handler implemented in the worker. It is read-only and has no external effects.
insert into public.project_automation_task_handlers(task_type,enabled,side_effect_class,handler_version,max_runtime_seconds)
values('system_health_check',true,'read_only','1.0.0',15)
on conflict(task_type) do update set
  enabled=excluded.enabled,
  side_effect_class=excluded.side_effect_class,
  handler_version=excluded.handler_version,
  max_runtime_seconds=excluded.max_runtime_seconds,
  updated_at=now();

alter table public.project_automation_runtime_control enable row level security;
alter table public.project_automation_task_handlers enable row level security;
revoke all on public.project_automation_runtime_control,public.project_automation_task_handlers from public,anon,authenticated;

create or replace function public.admin_set_project_automation_kill_switch(
  p_stopped boolean,
  p_reason text
) returns boolean
language plpgsql security definer set search_path=''
as $function$
begin
  if not public.is_admin_auto_work_admin() then
    raise exception 'Owner/Admin access required';
  end if;
  if p_stopped is null or char_length(btrim(coalesce(p_reason,''))) not between 8 and 300 then
    raise exception 'Explicit kill-switch state and reason required';
  end if;

  update public.project_automation_runtime_control
  set emergency_stop=p_stopped,
      stop_reason=left(btrim(p_reason),300),
      updated_by=auth.uid(),
      updated_at=now()
  where singleton=true;

  insert into public.project_automation_audit(action,actor_user_id,details)
  values(
    case when p_stopped then 'global_kill_switch_engaged' else 'global_kill_switch_released' end,
    auth.uid(),
    jsonb_build_object('reason',left(btrim(p_reason),300),'emergency_stop',p_stopped)
  );
  return true;
end;
$function$;

revoke all on function public.admin_set_project_automation_kill_switch(boolean,text) from public,anon;
grant execute on function public.admin_set_project_automation_kill_switch(boolean,text) to authenticated;

-- Replace the earlier claim routine with a database-enforced kill-switch and handler allowlist.
-- The worker may claim only the exact read-only handler implemented in its source code.
create or replace function public.worker_claim_project_automation_task(p_worker_key text)
returns setof public.project_automation_tasks
language plpgsql security definer set search_path=''
as $function$
declare
  v_worker public.project_automation_workers%rowtype;
  v_task uuid;
  v_lease uuid;
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

  select t.id into v_task
  from public.project_automation_tasks t
  join public.earning_project_registry r on r.id=t.project_id
  join public.project_automation_settings s on s.project_id=r.id and s.enabled
  join public.project_automation_task_handlers h on h.task_type=t.task_type
    and h.enabled and h.side_effect_class='read_only'
  where t.task_type='system_health_check'
    and t.status in ('queued','retry_wait')
    and t.available_at<=now()
    and t.attempts<t.max_attempts
    and t.actual_cost<t.budget_cap
    and r.execution_enabled
    and r.budget_cap>0
    and r.revenue_currency=any(v_worker.supported_currencies)
    and s.daily_budget>0
    and s.daily_budget<=r.budget_cap
    and (case when s.budget_date<current_date then 0 else s.daily_spent end)<s.daily_budget
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

  v_lease:=gen_random_uuid();
  update public.project_automation_tasks
  set status='running',
      worker_id=v_worker.id,
      attempts=attempts+1,
      lease_token=v_lease,
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
    jsonb_build_object('task_type',task_type,'attempt',attempts+1,'lease_seconds',300)
  from public.project_automation_tasks
  where id=v_task;

  return query
  select * from public.project_automation_tasks where id=v_task;
end;
$function$;

revoke all on function public.worker_claim_project_automation_task(text) from public,anon,authenticated;
grant execute on function public.worker_claim_project_automation_task(text) to service_role;

comment on table public.project_automation_runtime_control is
  'Global fail-closed worker kill switch. Emergency stop defaults true; releasing it requires Owner/Admin RPC and an audit record.';
comment on table public.project_automation_task_handlers is
  'Database allowlist of worker handlers. Only system_health_check is registered; it is read-only and cannot move funds or mutate customer data.';


-- Reserve the remaining per-task budget at claim time. This prevents parallel or
-- retrying tasks from oversubscribing the daily project budget before completion.
alter table public.project_automation_settings
  add column if not exists daily_reserved numeric(14,2) not null default 0
  check (daily_reserved>=0);
alter table public.project_automation_tasks
  add column if not exists budget_reserved numeric(14,2) not null default 0
  check (budget_reserved>=0 and budget_reserved<=budget_cap);

do $constraints$
begin
  if not exists(
    select 1 from pg_constraint
    where conrelid='public.project_automation_settings'::regclass
      and conname='project_automation_daily_budget_reserved_check'
  ) then
    alter table public.project_automation_settings
      add constraint project_automation_daily_budget_reserved_check
      check (daily_spent+daily_reserved<=daily_budget);
  end if;
end;
$constraints$;

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
  where t.task_type='system_health_check'
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
    jsonb_build_object('task_type',task_type,'attempt',attempts,'budget_reserved',budget_reserved,'lease_seconds',300)
  from public.project_automation_tasks
  where id=v_task;

  return query select * from public.project_automation_tasks where id=v_task;
end;
$function$;

create or replace function public.worker_finish_project_automation_task(
 p_task_id uuid,p_lease_token uuid,p_success boolean,p_actual_cost numeric default 0,
 p_error text default null
) returns boolean language plpgsql security definer set search_path=''
as $function$
declare
  v_task public.project_automation_tasks%rowtype;
  v_settings public.project_automation_settings%rowtype;
begin
 if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
 if p_actual_cost is null or p_actual_cost<0 or round(p_actual_cost,2)<>p_actual_cost then
   raise exception 'Invalid task cost';
 end if;

 select * into v_task from public.project_automation_tasks
 where id=p_task_id and status='running' and lease_token=p_lease_token for update;
 if not found then raise exception 'Task lease is invalid, expired or already completed'; end if;
 if now()>v_task.lease_expires_at then raise exception 'Task lease expired'; end if;
 if p_actual_cost>v_task.budget_reserved
   or v_task.actual_cost+p_actual_cost>v_task.budget_cap then
   raise exception 'Task budget reservation or cap exceeded';
 end if;

 select * into v_settings from public.project_automation_settings
 where project_id=v_task.project_id for update;
 if not found then raise exception 'Project scheduler settings missing'; end if;
 if (case when v_settings.budget_date<current_date then 0 else v_settings.daily_spent end)+p_actual_cost
   >v_settings.daily_budget then raise exception 'Project daily budget cap exceeded'; end if;

 update public.project_automation_settings set
   daily_spent=(case when budget_date<current_date then 0 else daily_spent end)+p_actual_cost,
   daily_reserved=greatest(0,(case when budget_date<current_date then 0 else daily_reserved end)-v_task.budget_reserved),
   budget_date=current_date,
   updated_at=now()
 where project_id=v_task.project_id;

 update public.project_automation_tasks set
   status=case when p_success then 'succeeded'
     when attempts>=max_attempts then 'dead_letter' else 'retry_wait' end,
   actual_cost=actual_cost+p_actual_cost,
   budget_reserved=0,
   lease_token=null,locked_at=null,lease_expires_at=null,
   available_at=case when not p_success and attempts<max_attempts
     then now()+make_interval(secs=>least(3600,(30*power(2,attempts))::integer))
     else available_at end,
   last_error=case when p_success then null else left(coalesce(p_error,'Worker task failed'),1000) end,
   finished_at=case when p_success or attempts>=max_attempts then now() else null end,
   updated_at=now()
 where id=p_task_id;

 update public.project_automation_workers set
   tasks_succeeded=tasks_succeeded+case when p_success then 1 else 0 end,
   tasks_failed=tasks_failed+case when p_success then 0 else 1 end,
   updated_at=now()
 where id=v_task.worker_id;

 insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
 values(v_task.project_id,p_task_id,v_task.worker_id,
   case when p_success then 'task_succeeded'
     when v_task.attempts>=v_task.max_attempts then 'task_dead_lettered'
     else 'task_retry_scheduled' end,
   jsonb_build_object('actual_cost',p_actual_cost,'budget_reservation_released',v_task.budget_reserved,
     'error',left(coalesce(p_error,''),300)));
 return true;
end;
$function$;

create or replace function public.scheduler_reap_expired_project_task_leases()
returns integer language plpgsql security definer set search_path=''
as $function$
declare v_count integer;
begin
 if auth.role()<>'service_role' then raise exception 'Scheduler service role required'; end if;
 with expired as (
   select t.id,t.project_id,t.worker_id,t.budget_reserved
   from public.project_automation_tasks t
   where t.status='running' and t.lease_expires_at<now()
   for update skip locked
 ), updated as (
   update public.project_automation_tasks t
   set status=case when t.attempts>=t.max_attempts then 'dead_letter' else 'retry_wait' end,
     worker_id=null,lease_token=null,locked_at=null,lease_expires_at=null,
     budget_reserved=0,
     available_at=case when t.attempts<t.max_attempts
       then now()+make_interval(secs=>least(3600,(30*power(2,t.attempts))::integer))
       else t.available_at end,
     last_error='Worker lease expired before task completion',
     finished_at=case when t.attempts>=t.max_attempts then now() else null end,
     updated_at=now()
   from expired e where t.id=e.id
   returning t.id,t.project_id,t.worker_id,t.status
 ), released as (
   update public.project_automation_settings s
   set daily_spent=case when s.budget_date<current_date then 0 else s.daily_spent end,
     daily_reserved=greatest(0,
       (case when s.budget_date<current_date then 0 else s.daily_reserved end)
       -coalesce((select sum(e.budget_reserved) from expired e where e.project_id=s.project_id),0)),
     budget_date=current_date,updated_at=now()
   where exists(select 1 from expired e where e.project_id=s.project_id)
   returning s.project_id
 ), logged as (
   insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
   select project_id,id,worker_id,
     case when status='dead_letter' then 'expired_task_dead_lettered' else 'expired_task_requeued' end,
     jsonb_build_object('reason','worker_lease_expired')
   from updated returning id
 )
 select count(*)::integer into v_count from logged;
 return coalesce(v_count,0);
end;
$function$;

revoke all on function public.worker_finish_project_automation_task(uuid,uuid,boolean,numeric,text) from public,anon,authenticated;
grant execute on function public.worker_finish_project_automation_task(uuid,uuid,boolean,numeric,text) to service_role;
revoke all on function public.scheduler_reap_expired_project_task_leases() from public,anon,authenticated;
grant execute on function public.scheduler_reap_expired_project_task_leases() to service_role;
