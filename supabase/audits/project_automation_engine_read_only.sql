-- Read-only audit for the central project automation engine.
-- Run only after its migration has been separately approved and applied.
select
  (select count(*) from public.earning_project_registry) as registered_projects,
  (select count(*) from public.project_automation_settings where enabled) as enabled_schedulers,
  (select count(*) from public.project_automation_workers where status='active') as active_workers,
  (select count(*) from public.project_automation_tasks where status='queued') as queued_tasks,
  (select count(*) from public.project_automation_tasks where status='running') as running_tasks,
  (select count(*) from public.project_automation_tasks where status='dead_letter') as dead_letter_tasks;
-- Initial expected state after migration: 4000 registered projects and zero scheduler,
-- worker, queue or running-task activity. This migration seeds no worker and no tasks.
select r.project_code,r.execution_enabled,r.budget_cap,
       coalesce(s.enabled,false) as scheduler_enabled,
       coalesce(s.daily_budget,0) as scheduler_daily_budget
from public.earning_project_registry r
left join public.project_automation_settings s on s.project_id=r.id
where r.execution_enabled or coalesce(s.enabled,false) or coalesce(s.daily_budget,0)>0
order by r.project_number;
-- Expected immediately after migration: zero rows.
