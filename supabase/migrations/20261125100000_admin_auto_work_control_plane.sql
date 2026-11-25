-- MASTER WORLD VIP — Admin-only Auto Work control plane
-- Additive schema only. This creates queue/control records; it does NOT execute paid work.
-- Apply only after backup + restore-test + Owner approval gates.

create table if not exists public.admin_auto_work_providers (
  id uuid primary key default gen_random_uuid(),
  provider_key text not null unique check (provider_key ~ '^[a-z0-9][a-z0-9_-]{1,63}$'),
  display_name text not null check (char_length(btrim(display_name)) between 2 and 120),
  status text not null default 'pending' check (status in ('pending','active','paused','revoked')),
  contract_reference text,
  approved_by uuid references auth.users(id),
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((status <> 'active') or (contract_reference is not null and approved_by is not null and approved_at is not null))
);

create table if not exists public.admin_auto_work_modules (
  work_type text primary key check (work_type in (
    'ai_data_processing','ai_translation_documents','pdf_automation',
    'image_processing','website_monitoring_reporting'
  )),
  display_name text not null,
  enabled boolean not null default false,
  provider_id uuid references public.admin_auto_work_providers(id),
  daily_budget_bdt numeric(12,2) not null default 0 check (daily_budget_bdt >= 0),
  daily_cost_bdt numeric(12,2) not null default 0 check (daily_cost_bdt >= 0),
  daily_cost_date date not null default current_date,
  last_run_at timestamptz,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now(),
  check (daily_cost_bdt <= daily_budget_bdt)
);

insert into public.admin_auto_work_modules(work_type,display_name) values
 ('ai_data_processing','AI Data Processing'),
 ('ai_translation_documents','AI Translation & Document Processing'),
 ('pdf_automation','PDF Automation'),
 ('image_processing','Image Processing'),
 ('website_monitoring_reporting','Website Monitoring & Automated Reporting')
on conflict(work_type) do nothing;

create table if not exists public.admin_auto_work_jobs (
  id uuid primary key default gen_random_uuid(),
  work_type text not null references public.admin_auto_work_modules(work_type),
  requested_by uuid not null references auth.users(id),
  contract_reference text,
  permission_reference text,
  input_reference text,
  output_reference text,
  payload jsonb not null default '{}'::jsonb,
  status text not null default 'queued' check (status in ('queued','running','succeeded','failed','cancelled')),
  attempts integer not null default 0 check (attempts between 0 and 10),
  max_attempts integer not null default 3 check (max_attempts between 1 and 10),
  idempotency_key text not null unique,
  budget_cap_bdt numeric(12,2) not null default 0 check (budget_cap_bdt >= 0),
  actual_cost_bdt numeric(12,2) not null default 0 check (actual_cost_bdt >= 0),
  revenue_settled_bdt numeric(12,2) not null default 0 check (revenue_settled_bdt >= 0),
  accepted_at timestamptz,
  settled_at timestamptz,
  last_error text,
  available_at timestamptz not null default now(),
  locked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (revenue_settled_bdt = 0 or settled_at is not null),
  check (settled_at is null or accepted_at is not null)
);

create table if not exists public.admin_auto_work_audit (
  id bigint generated always as identity primary key,
  actor_user_id uuid references auth.users(id),
  job_id uuid references public.admin_auto_work_jobs(id) on delete set null,
  work_type text,
  action text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists admin_auto_work_jobs_queue_idx
  on public.admin_auto_work_jobs(status,available_at,created_at)
  where status='queued';
create index if not exists admin_auto_work_jobs_type_created_idx
  on public.admin_auto_work_jobs(work_type,created_at desc);
create index if not exists admin_auto_work_audit_created_idx
  on public.admin_auto_work_audit(created_at desc);

alter table public.admin_auto_work_providers enable row level security;
alter table public.admin_auto_work_modules enable row level security;
alter table public.admin_auto_work_jobs enable row level security;
alter table public.admin_auto_work_audit enable row level security;

revoke all on public.admin_auto_work_providers,public.admin_auto_work_modules,
  public.admin_auto_work_jobs,public.admin_auto_work_audit from anon,authenticated;

create or replace function public.is_admin_auto_work_admin()
returns boolean
language sql stable security definer set search_path=''
as $$
 select auth.uid() is not null and exists(
   select 1 from public.app_user_roles r
   where r.user_id=auth.uid() and r.role in ('owner','super_admin','admin')
 );
$$;

create or replace function public.admin_auto_work_overview()
returns jsonb
language plpgsql stable security definer set search_path=''
as $$
declare v_modules jsonb; v_jobs jsonb;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 select coalesce(jsonb_agg(jsonb_build_object(
   'work_type',m.work_type,'display_name',m.display_name,'enabled',m.enabled,
   'provider_status',coalesce(p.status,'not_connected'),
   'daily_budget_bdt',m.daily_budget_bdt,'daily_cost_bdt',m.daily_cost_bdt,
   'last_run_at',m.last_run_at
 ) order by m.display_name),'[]'::jsonb) into v_modules
 from public.admin_auto_work_modules m
 left join public.admin_auto_work_providers p on p.id=m.provider_id;
 select coalesce(jsonb_agg(jsonb_build_object(
   'status',j.status,'count',j.n
 )),'[]'::jsonb) into v_jobs
 from (select status,count(*)::int n from public.admin_auto_work_jobs
       where created_at > now()-interval '7 days' group by status) j;
 return jsonb_build_object('modules',v_modules,'jobs_last_7_days',v_jobs,
   'execution_ready',false,
   'note','Control plane only: a reviewed provider connector and deployed worker are required before jobs execute.');
end;
$$;

create or replace function public.admin_register_auto_work_provider(
 p_provider_key text,p_display_name text,p_contract_reference text
)
returns uuid
language plpgsql security definer set search_path=''
as $
declare v_id uuid;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 if coalesce(length(btrim(p_contract_reference)),0)=0 then raise exception 'Contract reference required'; end if;
 insert into public.admin_auto_work_providers(provider_key,display_name,contract_reference,status)
 values(lower(p_provider_key),p_display_name,p_contract_reference,'pending')
 returning id into v_id;
 insert into public.admin_auto_work_audit(actor_user_id,action,details)
 values(auth.uid(),'provider_registered',jsonb_build_object('provider_id',v_id,'provider_key',lower(p_provider_key)));
 return v_id;
end;
$;

create or replace function public.owner_review_auto_work_provider(
 p_provider_id uuid,p_work_type text,p_approve boolean
)
returns boolean
language plpgsql security definer set search_path=''
as $
begin
 if not exists(select 1 from public.app_user_roles where user_id=auth.uid() and role='owner') then
   raise exception 'Only the Owner can approve an Auto Work provider';
 end if;
 if not exists(select 1 from public.admin_auto_work_providers where id=p_provider_id and status='pending' and contract_reference is not null) then
   raise exception 'Pending provider with contract reference not found';
 end if;
 if p_approve then
   update public.admin_auto_work_providers
   set status='active',approved_by=auth.uid(),approved_at=now(),updated_at=now()
   where id=p_provider_id;
   update public.admin_auto_work_modules
   set provider_id=p_provider_id,updated_by=auth.uid(),updated_at=now()
   where work_type=p_work_type;
   if not found then raise exception 'Unknown Auto Work module'; end if;
 else
   update public.admin_auto_work_providers set status='revoked',updated_at=now() where id=p_provider_id;
 end if;
 insert into public.admin_auto_work_audit(actor_user_id,work_type,action,details)
 values(auth.uid(),p_work_type,case when p_approve then 'provider_approved' else 'provider_rejected' end,
        jsonb_build_object('provider_id',p_provider_id));
 return true;
end;
$;

create or replace function public.admin_set_auto_work_module(
 p_work_type text,p_enabled boolean,p_daily_budget_bdt numeric default 0
)
returns boolean
language plpgsql security definer set search_path=''
as $$
declare v_provider uuid; v_provider_status text;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 if p_daily_budget_bdt is null or p_daily_budget_bdt < 0 then raise exception 'Invalid budget'; end if;
 select provider_id into v_provider from public.admin_auto_work_modules where work_type=p_work_type for update;
 if not found then raise exception 'Unknown Auto Work module'; end if;
 if p_enabled then
   if p_daily_budget_bdt <= 0 then raise exception 'Set a positive daily budget cap before enabling'; end if;
   select status into v_provider_status from public.admin_auto_work_providers where id=v_provider;
   if v_provider is null or v_provider_status <> 'active' then
     raise exception 'A verified active provider and approved contract are required before enabling';
   end if;
 end if;
 update public.admin_auto_work_modules
 set enabled=p_enabled,daily_budget_bdt=p_daily_budget_bdt,
     updated_by=auth.uid(),updated_at=now()
 where work_type=p_work_type;
 insert into public.admin_auto_work_audit(actor_user_id,work_type,action,details)
 values(auth.uid(),p_work_type,case when p_enabled then 'module_enable_requested' else 'module_paused' end,
        jsonb_build_object('daily_budget_bdt',p_daily_budget_bdt));
 return true;
end;
$$;

create or replace function public.admin_enqueue_auto_work_job(
 p_work_type text,p_contract_reference text,p_permission_reference text,
 p_input_reference text,p_payload jsonb,p_idempotency_key text,p_budget_cap_bdt numeric
)
returns uuid
language plpgsql security definer set search_path=''
as $$
declare v_id uuid;
begin
 if not public.is_admin_auto_work_admin() then raise exception 'Admin access required'; end if;
 if coalesce(length(btrim(p_idempotency_key)),0) not between 8 and 160 then raise exception 'Valid idempotency key required'; end if;
 if coalesce(length(btrim(p_contract_reference)),0)=0 or coalesce(length(btrim(p_permission_reference)),0)=0 then
   raise exception 'Client contract and permission reference are required';
 end if;
 if p_budget_cap_bdt is null or p_budget_cap_bdt < 0 then raise exception 'Invalid job budget'; end if;
 if not exists(select 1 from public.admin_auto_work_modules m
   join public.admin_auto_work_providers p on p.id=m.provider_id
   where m.work_type=p_work_type and m.enabled and p.status='active'
     and m.daily_budget_bdt>0 and p_budget_cap_bdt<=m.daily_budget_bdt) then
   raise exception 'Module is paused, provider is not active, or budget exceeds the module cap';
 end if;
 insert into public.admin_auto_work_jobs(
   work_type,requested_by,contract_reference,permission_reference,input_reference,
   payload,idempotency_key,budget_cap_bdt
 ) values (
   p_work_type,auth.uid(),p_contract_reference,p_permission_reference,p_input_reference,
   coalesce(p_payload,'{}'::jsonb),p_idempotency_key,p_budget_cap_bdt
 ) returning id into v_id;
 insert into public.admin_auto_work_audit(actor_user_id,job_id,work_type,action)
 values(auth.uid(),v_id,p_work_type,'job_queued');
 return v_id;
exception when unique_violation then
 select id into v_id from public.admin_auto_work_jobs where idempotency_key=p_idempotency_key;
 return v_id;
end;
$$;

-- Worker-only claim. Supabase service_role is the only granted caller.
create or replace function public.worker_claim_admin_auto_work_job()
returns setof public.admin_auto_work_jobs
language plpgsql security definer set search_path=''
as $$
declare v_job uuid;
begin
 select j.id into v_job
 from public.admin_auto_work_jobs j
 join public.admin_auto_work_modules m on m.work_type=j.work_type and m.enabled
 join public.admin_auto_work_providers p on p.id=m.provider_id and p.status='active'
 where j.status='queued' and j.available_at<=now()
   and j.attempts<j.max_attempts
   and (case when m.daily_cost_date<current_date then 0 else m.daily_cost_bdt end)<m.daily_budget_bdt
   and j.actual_cost_bdt<j.budget_cap_bdt
 order by j.created_at
 for update of j skip locked limit 1;
 if v_job is null then return; end if;
 update public.admin_auto_work_jobs
 set status='running',attempts=attempts+1,locked_at=now(),updated_at=now()
 where id=v_job;
 return query select * from public.admin_auto_work_jobs where id=v_job;
end;
$$;

create or replace function public.worker_finish_admin_auto_work_job(
 p_job_id uuid,p_success boolean,p_output_reference text default null,
 p_actual_cost_bdt numeric default 0,p_error text default null
)
returns boolean
language plpgsql security definer set search_path=''
as $$
declare v_type text; v_cap numeric;
begin
 if p_actual_cost_bdt is null or p_actual_cost_bdt<0 then raise exception 'Invalid actual cost'; end if;
 select work_type,budget_cap_bdt into v_type,v_cap
 from public.admin_auto_work_jobs where id=p_job_id and status='running' for update;
 if not found then raise exception 'Running job not found'; end if;
 if p_actual_cost_bdt + (select actual_cost_bdt from public.admin_auto_work_jobs where id=p_job_id) > v_cap then
   raise exception 'Cumulative job cost exceeds its cap';
 end if;
 update public.admin_auto_work_jobs
 set status=case when p_success then 'succeeded' else
   case when attempts<max_attempts then 'queued' else 'failed' end end,
   output_reference=case when p_success then p_output_reference else output_reference end,
   actual_cost_bdt=actual_cost_bdt+p_actual_cost_bdt,
   last_error=case when p_success then null else left(coalesce(p_error,'Worker failed'),1000) end,
   locked_at=null,available_at=case when not p_success and attempts<max_attempts then now()+interval '2 minutes' else available_at end,
   updated_at=now()
 where id=p_job_id;
 update public.admin_auto_work_modules
 set daily_cost_bdt=(case when daily_cost_date<current_date then 0 else daily_cost_bdt end)+p_actual_cost_bdt,
     daily_cost_date=current_date,updated_at=now()
 where work_type=v_type;
 insert into public.admin_auto_work_audit(job_id,work_type,action,details)
 values(p_job_id,v_type,case when p_success then 'job_processed' else 'job_attempt_failed' end,
        jsonb_build_object('actual_cost_bdt',p_actual_cost_bdt));
 return true;
end;
$$;

revoke all on function public.is_admin_auto_work_admin() from public,anon;
revoke all on function public.admin_auto_work_overview() from public,anon;
revoke all on function public.admin_register_auto_work_provider(text,text,text) from public,anon;
revoke all on function public.owner_review_auto_work_provider(uuid,text,boolean) from public,anon;
revoke all on function public.admin_set_auto_work_module(text,boolean,numeric) from public,anon;
revoke all on function public.admin_enqueue_auto_work_job(text,text,text,text,jsonb,text,numeric) from public,anon;
revoke all on function public.worker_claim_admin_auto_work_job() from public,anon,authenticated;
revoke all on function public.worker_finish_admin_auto_work_job(uuid,boolean,text,numeric,text) from public,anon,authenticated;

grant execute on function public.admin_auto_work_overview() to authenticated;
grant execute on function public.admin_register_auto_work_provider(text,text,text) to authenticated;
grant execute on function public.owner_review_auto_work_provider(uuid,text,boolean) to authenticated;
grant execute on function public.admin_set_auto_work_module(text,boolean,numeric) to authenticated;
grant execute on function public.admin_enqueue_auto_work_job(text,text,text,text,jsonb,text,numeric) to authenticated;
grant execute on function public.worker_claim_admin_auto_work_job() to service_role;
grant execute on function public.worker_finish_admin_auto_work_job(uuid,boolean,text,numeric,text) to service_role;

-- No client direct table access; no member referral changes; no payment/payout is created here.
