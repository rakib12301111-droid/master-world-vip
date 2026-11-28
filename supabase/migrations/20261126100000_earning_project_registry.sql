-- MASTER WORLD VIP — 4,000-project registry foundation
-- Additive registry only. All projects start planned and non-executable.
-- Catalog records do not launch work, charge users, collect revenue or connect providers.

create table if not exists public.earning_project_registry (
  id uuid primary key default gen_random_uuid(),
  project_code text not null unique check (project_code ~ '^MW-(USD|BDT)-[0-9]{4}$'),
  project_number integer not null unique check (project_number between 1 and 4000),
  display_name text not null check (char_length(btrim(display_name)) between 3 and 120),
  revenue_currency text not null check (revenue_currency in ('USD','BDT')),
  project_group text not null check (project_group in ('international_usd','bangladesh_bdt')),
  lifecycle_status text not null default 'planned'
    check (lifecycle_status in ('planned','designing','ready_for_review','active','paused','retired')),
  free_option_enabled boolean not null default true,
  paid_option_enabled boolean not null default true,
  paid_plan_configured boolean not null default false,
  execution_enabled boolean not null default false,
  revenue_collection_enabled boolean not null default false,
  project_category text not null default 'general',
  payer_model text not null default 'not_configured'
    check (payer_model in ('not_configured','customer','advertiser','sponsor','marketplace_buyer','partner')),
  budget_cap numeric(14,2) not null default 0 check (budget_cap >= 0),
  configuration jsonb not null default '{}'::jsonb check (jsonb_typeof(configuration) = 'object'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint earning_project_currency_group_check check (
    (project_number between 1 and 2000 and revenue_currency='USD'
      and project_group='international_usd' and project_code like 'MW-USD-%')
    or
    (project_number between 2001 and 4000 and revenue_currency='BDT'
      and project_group='bangladesh_bdt' and project_code like 'MW-BDT-%')
  ),
  constraint earning_project_not_live_by_default check (
    (execution_enabled=false and revenue_collection_enabled=false)
    or lifecycle_status='active'
  )
);

create index if not exists earning_project_registry_group_status_idx
  on public.earning_project_registry(project_group,lifecycle_status,project_number);
create index if not exists earning_project_registry_currency_idx
  on public.earning_project_registry(revenue_currency,project_number);

alter table public.earning_project_registry enable row level security;
revoke all on public.earning_project_registry from anon,authenticated;
grant select on public.earning_project_registry to authenticated;

drop policy if exists "owner admins read earning project registry" on public.earning_project_registry;
create policy "owner admins read earning project registry"
  on public.earning_project_registry for select to authenticated
  using (public.is_admin_auto_work_admin());

-- Stable catalog identifiers: 2,000 international USD slots and 2,000 Bangladesh BDT slots.
insert into public.earning_project_registry (
  project_code,project_number,display_name,revenue_currency,project_group,
  lifecycle_status,free_option_enabled,paid_option_enabled,
  paid_plan_configured,execution_enabled,revenue_collection_enabled
)
select
  case when n<=2000 then 'MW-USD-'||lpad(n::text,4,'0')
       else 'MW-BDT-'||lpad((n-2000)::text,4,'0') end,
  n,
  case when n<=2000 then 'International USD Project '||lpad(n::text,4,'0')
       else 'Bangladesh BDT Project '||lpad((n-2000)::text,4,'0') end,
  case when n<=2000 then 'USD' else 'BDT' end,
  case when n<=2000 then 'international_usd' else 'bangladesh_bdt' end,
  'planned',true,true,false,false,false
from generate_series(1,4000) as n
on conflict (project_code) do nothing;

do $$
declare v_total integer; v_usd integer; v_bdt integer; v_enabled integer;
begin
  select count(*)::integer,
         count(*) filter(where revenue_currency='USD')::integer,
         count(*) filter(where revenue_currency='BDT')::integer,
         count(*) filter(where execution_enabled or revenue_collection_enabled)::integer
    into v_total,v_usd,v_bdt,v_enabled
  from public.earning_project_registry;
  if v_total<>4000 or v_usd<>2000 or v_bdt<>2000 or v_enabled<>0 then
    raise exception 'Registry invariant failed: total %, USD %, BDT %, enabled %',
      v_total,v_usd,v_bdt,v_enabled;
  end if;
end $$;

comment on table public.earning_project_registry is
  'Catalog of 4,000 planned project slots. Registry presence does not mean operational or revenue-live.';
