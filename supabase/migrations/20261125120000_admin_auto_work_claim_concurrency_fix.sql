-- MASTER WORLD VIP — prevent two workers claiming the same module concurrently.
-- Additive hardening: preserves the one-running-job-per-module design (maximum five jobs total).

create or replace function public.worker_claim_admin_auto_work_job()
returns setof public.admin_auto_work_jobs
language plpgsql security definer set search_path=''
as $$
declare v_job uuid;
begin
 select j.id into v_job
 from public.admin_auto_work_jobs j
 join public.admin_auto_work_modules m
   on m.work_type=j.work_type and m.enabled
 join public.admin_auto_work_providers p
   on p.id=m.provider_id and p.status='active'
 where j.status='queued'
   and j.available_at<=now()
   and j.attempts<j.max_attempts
   and (case when m.daily_cost_date<current_date then 0 else m.daily_cost_bdt end)<m.daily_budget_bdt
   and (j.budget_cap_bdt-j.actual_cost_bdt) <=
       (m.daily_budget_bdt-(case when m.daily_cost_date<current_date then 0 else m.daily_cost_bdt end))
   and j.actual_cost_bdt<j.budget_cap_bdt
   -- Critical: do not claim a second job while this module already has a running job.
   and not exists (
     select 1 from public.admin_auto_work_jobs running
     where running.work_type=j.work_type and running.status='running'
   )
 order by j.created_at
 for update of j skip locked
 limit 1;

 if v_job is null then return; end if;

 update public.admin_auto_work_jobs
 set status='running',attempts=attempts+1,locked_at=now(),updated_at=now()
 where id=v_job;

 return query select * from public.admin_auto_work_jobs where id=v_job;
end;
$$;

revoke all on function public.worker_claim_admin_auto_work_job() from public,anon,authenticated;
grant execute on function public.worker_claim_admin_auto_work_job() to service_role;
