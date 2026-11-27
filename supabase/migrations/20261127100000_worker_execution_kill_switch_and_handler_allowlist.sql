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
