-- Read-only verification for the 4,000-project registry.
-- Run only after the migration has been separately approved and applied.
select
  count(*) as total_projects,
  count(*) filter(where revenue_currency='USD') as usd_projects,
  count(*) filter(where revenue_currency='BDT') as bdt_projects,
  count(*) filter(where free_option_enabled) as free_options,
  count(*) filter(where paid_option_enabled) as paid_options,
  count(*) filter(where paid_plan_configured) as configured_paid_plans,
  count(*) filter(where execution_enabled) as execution_enabled_projects,
  count(*) filter(where revenue_collection_enabled) as revenue_enabled_projects
from public.earning_project_registry;
-- Expected: 4000, 2000, 2000, 4000, 4000, 0, 0, 0.

select project_code,project_number,revenue_currency,project_group,lifecycle_status
from public.earning_project_registry
where (project_number between 1 and 2000 and revenue_currency<>'USD')
   or (project_number between 2001 and 4000 and revenue_currency<>'BDT')
   or execution_enabled or revenue_collection_enabled
order by project_number;
-- Expected: zero rows.
