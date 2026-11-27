-- MASTER WORLD VIP — Central 4,000-project orchestration engine (foundation only)
-- Additive control plane. It does not launch external work, collect revenue or enable projects.
-- Requires 20261126100000_earning_project_registry.sql and Admin Auto Work RBAC helpers.

create table if not exists public.project_automation_settings (
  project_id uuid primary key references public.earning_project_registry(id) on delete restrict,
  enabled boolean not null default false,
  task_type text not null default 'project_cycle'
    check (task_type ~ '^[a-z][a-z0-9_]{1,63}$'),
  schedule_interval_minutes integer not null default 1440
    check (schedule_interval_minutes between 5 and 10080),
  next_run_at timestamptz,
  daily_budget numeric(14,2) not null default 0 check (daily_budget >= 0),
  daily_spent numeric(14,2) not null default 0 check (daily_spent >= 0),
  budget_date date not null default current_date,
  max_attempts integer not null default 3 check (max_attempts between 1 and 10),
  max_concurrent_tasks integer not null default 1 check (max_concurrent_tasks between 1 and 10),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (daily_spent <= daily_budget),
  check (not enabled or (daily_budget > 0 and next_run_at is not null))
);

create table if not exists public.project_automation_workers (
  id uuid primary key default gen_random_uuid(),
  worker_key text not null unique check (worker_key ~ '^[a-zA-Z0-9][a-zA-Z0-9._:-]{2,95}$'),
  display_name text not null check (char_length(btrim(display_name)) between 2 and 100),
  status text not null default 'offline' check (status in ('offline','active','paused','revoked')),
  supported_currencies text[] not null default array['USD','BDT']::text[]
    check (supported_currencies <@ array['USD','BDT']::text[] and cardinality(supported_currencies)>0),
  last_heartbeat_at timestamptz,
  tasks_claimed bigint not null default 0,
  tasks_succeeded bigint not null default 0,
  tasks_failed bigint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.project_automation_tasks (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.earning_project_registry(id) on delete restrict,
  worker_id uuid references public.project_automation_workers(id),
  task_type text not null check (task_type ~ '^[a-z][a-z0-9_]{1,63}$'),
  status text not null default 'queued'
    check (status in ('queued','running','succeeded','retry_wait','failed','dead_letter','cancelled')),
  payload jsonb not null default '{}'::jsonb check (jsonb_typeof(payload)='object'),
  idempotency_key text not null unique check (char_length(idempotency_key) between 8 and 200),
  attempts integer not null default 0 check (attempts between 0 and 10),
  max_attempts integer not null default 3 check (max_attempts between 1 and 10),
  budget_cap numeric(14,2) not null default 0 check (budget_cap >= 0),
  actual_cost numeric(14,2) not null default 0 check (actual_cost >= 0),
  lease_token uuid,
  locked_at timestamptz,
  lease_expires_at timestamptz,
  available_at timestamptz not null default now(),
  last_error text,
  started_at timestamptz,
  finished_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (actual_cost <= budget_cap),
  check ((status='running') = (lease_token is not null and lease_expires_at is not null))
);

create table if not exists public.project_automation_audit (
  id bigint generated always as identity primary key,
  project_id uuid references public.earning_project_registry(id) on delete set null,
  task_id uuid references public.project_automation_tasks(id) on delete set null,
  worker_id uuid references public.project_automation_workers(id) on delete set null,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  details jsonb not null default '{}'::jsonb check (jsonb_typeof(details)='object'),
  created_at timestamptz not null default now()
);

create index if not exists project_automation_schedule_due_idx
  on public.project_automation_settings(next_run_at) where enabled;
create index if not exists project_automation_queue_idx
  on public.project_automation_tasks(status,available_at,created_at)
  where status in ('queued','retry_wait');
create index if not exists project_automation_project_status_idx
  on public.project_automation_tasks(project_id,status,created_at desc);
create index if not exists project_automation_worker_heartbeat_idx
  on public.project_automation_workers(status,last_heartbeat_at);
create index if not exists project_automation_audit_created_idx
  on public.project_automation_audit(created_at desc);

-- At most one active task per project unless a later reviewed design explicitly changes this.
create unique index if not exists project_automation_one_running_per_project_idx
  on public.project_automation_tasks(project_id) where status='running';

alter table public.project_automation_settings enable row level security;
alter table public.project_automation_workers enable row level security;
alter table public.project_automation_tasks enable row level security;
alter table public.project_automation_audit enable row level security;
revoke all on public.project_automation_settings,public.project_automation_workers,
  public.project_automation_tasks,public.project_automation_audit from anon,authenticated;

create or replace function public.admin_project_automation_overview()
returns jsonb language plpgsql stable security definer set search_path=''
as $$
declare v_projects jsonb; v_tasks jsonb; v_workers jsonb;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 select coalesce(jsonb_agg(jsonb_build_object(
   'project_code',r.project_code,'currency',r.revenue_currency,
   'lifecycle_status',r.lifecycle_status,'execution_enabled',r.execution_enabled,
   'scheduler_enabled',coalesce(s.enabled,false),'next_run_at',s.next_run_at,
   'daily_budget',coalesce(s.daily_budget,0),'daily_spent',
     case when s.budget_date<current_date then 0 else coalesce(s.daily_spent,0) end
 ) order by r.project_number),'[]'::jsonb) into v_projects
 from public.earning_project_registry r
 left join public.project_automation_settings s on s.project_id=r.id;
 select coalesce(jsonb_agg(jsonb_build_object('status',x.status,'count',x.n)),'[]'::jsonb)
 into v_tasks from (select status,count(*)::int n from public.project_automation_tasks
   where created_at>now()-interval '7 days' group by status) x;
 select coalesce(jsonb_agg(jsonb_build_object('status',w.status,'count',w.n)),'[]'::jsonb)
 into v_workers from (select status,count(*)::int n from public.project_automation_workers group by status) w;
 return jsonb_build_object('projects',v_projects,'tasks_last_7_days',v_tasks,
   'workers',v_workers,'execution_ready',false,
   'note','Control plane only. Project execution remains blocked until each registry project is separately enabled and a reviewed worker is deployed.');
end $$;

create or replace function public.admin_configure_project_schedule(
 p_project_code text,p_enabled boolean,p_interval_minutes integer,
 p_daily_budget numeric,p_task_type text default 'project_cycle'
) returns boolean language plpgsql security definer set search_path=''
as $$
declare v_project public.earning_project_registry%rowtype;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 select * into v_project from public.earning_project_registry
 where project_code=p_project_code for update;
 if not found then raise exception 'Project code not found'; end if;
 if p_interval_minutes not between 5 and 10080 or p_daily_budget is null or p_daily_budget<0
   then raise exception 'Invalid schedule interval or budget'; end if;
 if p_task_type !~ '^[a-z][a-z0-9_]{1,63}$' then raise exception 'Invalid task type'; end if;
 if p_enabled and (not v_project.execution_enabled or v_project.budget_cap<=0
   or p_daily_budget<=0 or p_daily_budget>v_project.budget_cap) then
   raise exception 'Project execution must be separately enabled with a positive approved project budget first';
 end if;
 insert into public.project_automation_settings(
   project_id,enabled,task_type,schedule_interval_minutes,next_run_at,daily_budget,
   daily_spent,budget_date,max_attempts,updated_by,updated_at
 ) values (v_project.id,p_enabled,p_task_type,p_interval_minutes,
   case when p_enabled then now() else null end,p_daily_budget,0,current_date,3,auth.uid(),now())
 on conflict(project_id) do update set enabled=excluded.enabled,task_type=excluded.task_type,
   schedule_interval_minutes=excluded.schedule_interval_minutes,
   next_run_at=excluded.next_run_at,daily_budget=excluded.daily_budget,
   updated_by=excluded.updated_by,updated_at=now();
 insert into public.project_automation_audit(project_id,actor_user_id,action,details)
 values(v_project.id,auth.uid(),case when p_enabled then 'schedule_configured' else 'schedule_paused' end,
   jsonb_build_object('interval_minutes',p_interval_minutes,'daily_budget',p_daily_budget));
 return true;
end $$;

-- Scheduler entry point. It creates idempotent queue records only for explicitly enabled projects.
create or replace function public.scheduler_enqueue_due_project_tasks()
returns integer language plpgsql security definer set search_path=''
as $$
declare v_count integer;
begin
 with due as (
   select s.project_id,r.project_code,s.task_type,s.daily_budget,s.max_attempts,
          s.schedule_interval_minutes
   from public.project_automation_settings s
   join public.earning_project_registry r on r.id=s.project_id
   where s.enabled and s.next_run_at<=now()
     and r.execution_enabled and r.budget_cap>0
     and s.daily_budget>0 and s.daily_budget<=r.budget_cap
     and (case when s.budget_date<current_date then 0 else s.daily_spent end)<s.daily_budget
   order by s.next_run_at for update of s skip locked limit 250
 ), inserted as (
   insert into public.project_automation_tasks(
     project_id,task_type,payload,idempotency_key,max_attempts,budget_cap,available_at
   )
   select project_id,task_type,'{}'::jsonb,
     project_code||':'||to_char(date_trunc('minute',now()),'YYYYMMDDHH24MI'),
     max_attempts,daily_budget,now()
   from due on conflict(idempotency_key) do nothing returning project_id
 ), advanced as (
   update public.project_automation_settings s
   set next_run_at=now()+make_interval(mins=>d.schedule_interval_minutes),
       updated_at=now()
   from due d where s.project_id=d.project_id returning s.project_id
 )
 select count(*)::integer into v_count from inserted;
 return coalesce(v_count,0);
end $$;

create or replace function public.worker_register_project_automation(
 p_worker_key text,p_display_name text,p_currencies text[] default array['USD','BDT']::text[]
) returns uuid language plpgsql security definer set search_path=''
as $$
declare v_id uuid;
begin
 if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
 if p_worker_key !~ '^[a-zA-Z0-9][a-zA-Z0-9._:-]{2,95}$'
   or coalesce(array_length(p_currencies,1),0)=0
   or not (p_currencies <@ array['USD','BDT']::text[]) then raise exception 'Invalid worker registration'; end if;
 insert into public.project_automation_workers(worker_key,display_name,status,supported_currencies,last_heartbeat_at)
 values(p_worker_key,p_display_name,'active',p_currencies,now())
 on conflict(worker_key) do update set display_name=excluded.display_name,status='active',
   supported_currencies=excluded.supported_currencies,last_heartbeat_at=now(),updated_at=now()
 returning id into v_id;
 return v_id;
end $$;

create or replace function public.worker_heartbeat_project_automation(p_worker_key text)
returns boolean language plpgsql security definer set search_path=''
as $$
begin
 if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
 update public.project_automation_workers set last_heartbeat_at=now(),updated_at=now()
 where worker_key=p_worker_key and status='active';
 return found;
end $$;

create or replace function public.worker_claim_project_automation_task(p_worker_key text)
returns setof public.project_automation_tasks language plpgsql security definer set search_path=''
as $$
declare v_worker public.project_automation_workers%rowtype; v_task uuid; v_lease uuid;
begin
 if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
 select * into v_worker from public.project_automation_workers
 where worker_key=p_worker_key and status='active'
   and last_heartbeat_at>now()-interval '2 minutes' for update;
 if not found then raise exception 'Active worker heartbeat required'; end if;
 select t.id into v_task from public.project_automation_tasks t
 join public.earning_project_registry r on r.id=t.project_id
 join public.project_automation_settings s on s.project_id=r.id and s.enabled
 where t.status in ('queued','retry_wait') and t.available_at<=now()
   and t.attempts<t.max_attempts and t.actual_cost<t.budget_cap
   and r.execution_enabled and r.budget_cap>0
   and r.revenue_currency=any(v_worker.supported_currencies)
   and s.daily_budget>0 and s.daily_budget<=r.budget_cap
   and (case when s.budget_date<current_date then 0 else s.daily_spent end)<s.daily_budget
   and not exists(select 1 from public.project_automation_tasks running
     where running.project_id=t.project_id and running.status='running')
 order by t.available_at,t.created_at
 for update of t,s skip locked limit 1;
 if v_task is null then return; end if;
 v_lease:=gen_random_uuid();
 update public.project_automation_tasks set status='running',worker_id=v_worker.id,
   attempts=attempts+1,lease_token=v_lease,locked_at=now(),
   lease_expires_at=now()+interval '5 minutes',
   started_at=coalesce(started_at,now()),updated_at=now() where id=v_task;
 update public.project_automation_workers set tasks_claimed=tasks_claimed+1,updated_at=now()
 where id=v_worker.id;
 return query select * from public.project_automation_tasks where id=v_task;
end $$;

create or replace function public.worker_finish_project_automation_task(
 p_task_id uuid,p_lease_token uuid,p_success boolean,p_actual_cost numeric default 0,
 p_error text default null
) returns boolean language plpgsql security definer set search_path=''
as $$
declare v_task public.project_automation_tasks%rowtype; v_settings public.project_automation_settings%rowtype;
begin
 if auth.role()<>'service_role' then raise exception 'Worker service role required'; end if;
 if p_actual_cost is null or p_actual_cost<0 then raise exception 'Invalid task cost'; end if;
 select * into v_task from public.project_automation_tasks
 where id=p_task_id and status='running' and lease_token=p_lease_token for update;
 if not found then raise exception 'Task lease is invalid, expired or already completed'; end if;
 if now()>v_task.lease_expires_at then raise exception 'Task lease expired'; end if;
 if v_task.actual_cost+p_actual_cost>v_task.budget_cap then raise exception 'Task budget cap exceeded'; end if;
 select * into v_settings from public.project_automation_settings
 where project_id=v_task.project_id for update;
 if not found then raise exception 'Project scheduler settings missing'; end if;
 if (case when v_settings.budget_date<current_date then 0 else v_settings.daily_spent end)+p_actual_cost
   >v_settings.daily_budget then raise exception 'Project daily budget cap exceeded'; end if;
 update public.project_automation_settings set
   daily_spent=(case when budget_date<current_date then 0 else daily_spent end)+p_actual_cost,
   budget_date=current_date,updated_at=now() where project_id=v_task.project_id;
 update public.project_automation_tasks set
   status=case when p_success then 'succeeded'
     when attempts>=max_attempts then 'dead_letter' else 'retry_wait' end,
   actual_cost=actual_cost+p_actual_cost,lease_token=null,locked_at=null,lease_expires_at=null,
   available_at=case when not p_success and attempts<max_attempts
     then now()+make_interval(secs=>least(3600,(30*power(2,attempts))::integer))
     else available_at end,
   last_error=case when p_success then null else left(coalesce(p_error,'Worker task failed'),1000) end,
   finished_at=case when p_success or attempts>=max_attempts then now() else null end,
   updated_at=now() where id=p_task_id;
 update public.project_automation_workers set
   tasks_succeeded=tasks_succeeded+case when p_success then 1 else 0 end,
   tasks_failed=tasks_failed+case when p_success then 0 else 1 end,updated_at=now()
 where id=v_task.worker_id;
 insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
 values(v_task.project_id,p_task_id,v_task.worker_id,
   case when p_success then 'task_succeeded' when v_task.attempts>=v_task.max_attempts then 'task_dead_lettered' else 'task_retry_scheduled' end,
   jsonb_build_object('actual_cost',p_actual_cost,'error',left(coalesce(p_error,''),300)));
 return true;
end $$;


-- Recover abandoned worker leases so a crashed worker cannot strand a project forever.
create or replace function public.scheduler_reap_expired_project_task_leases()
returns integer language plpgsql security definer set search_path=''
as $$
declare v_count integer;
begin
 if auth.role()<>'service_role' then raise exception 'Scheduler service role required'; end if;
 with expired as (
   update public.project_automation_tasks
   set status=case when attempts>=max_attempts then 'dead_letter' else 'retry_wait' end,
     worker_id=null,lease_token=null,locked_at=null,lease_expires_at=null,
     available_at=case when attempts<max_attempts
       then now()+make_interval(secs=>least(3600,(30*power(2,attempts))::integer))
       else available_at end,
     last_error='Worker lease expired before task completion',
     finished_at=case when attempts>=max_attempts then now() else null end,
     updated_at=now()
   where status='running' and lease_expires_at<now()
   returning id,project_id,worker_id,status
 ), logged as (
   insert into public.project_automation_audit(project_id,task_id,worker_id,action,details)
   select project_id,id,worker_id,
     case when status='dead_letter' then 'expired_task_dead_lettered' else 'expired_task_requeued' end,
     jsonb_build_object('reason','worker_lease_expired')
   from expired returning id
 )
 select count(*)::integer into v_count from logged;
 return coalesce(v_count,0);
end $$;

revoke all on function public.admin_project_automation_overview() from public,anon;
revoke all on function public.admin_configure_project_schedule(text,boolean,integer,numeric,text) from public,anon;
revoke all on function public.scheduler_enqueue_due_project_tasks() from public,anon,authenticated;
revoke all on function public.scheduler_reap_expired_project_task_leases() from public,anon,authenticated;
revoke all on function public.worker_register_project_automation(text,text,text[]) from public,anon,authenticated;
revoke all on function public.worker_heartbeat_project_automation(text) from public,anon,authenticated;
revoke all on function public.worker_claim_project_automation_task(text) from public,anon,authenticated;
revoke all on function public.worker_finish_project_automation_task(uuid,uuid,boolean,numeric,text) from public,anon,authenticated;
grant execute on function public.admin_project_automation_overview() to authenticated;
grant execute on function public.admin_configure_project_schedule(text,boolean,integer,numeric,text) to authenticated;
grant execute on function public.scheduler_enqueue_due_project_tasks() to service_role;
grant execute on function public.scheduler_reap_expired_project_task_leases() to service_role;
grant execute on function public.worker_register_project_automation(text,text,text[]) to service_role;
grant execute on function public.worker_heartbeat_project_automation(text) to service_role;
grant execute on function public.worker_claim_project_automation_task(text) to service_role;
grant execute on function public.worker_finish_project_automation_task(uuid,uuid,boolean,numeric,text) to service_role;

comment on table public.project_automation_settings is
 'Per-project scheduler configuration. Disabled by default; enabling requires separately approved project execution and budget.';
comment on table public.project_automation_tasks is
 'Idempotent task queue with worker leases, bounded retries and per-task budget caps; no external connector is included.';
