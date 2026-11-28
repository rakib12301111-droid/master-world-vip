-- Disposable-only runtime assertions for worker emergency stop and handler allowlist.
-- This test never disables the kill switch and never executes business work.
\set ON_ERROR_STOP on

do $test$
declare
  v_stopped boolean;
  v_handler_count integer;
  v_claimed integer;
begin
  select emergency_stop into v_stopped
  from public.project_automation_runtime_control
  where singleton=true;
  if v_stopped is distinct from true then
    raise exception 'Worker kill switch must default to STOPPED';
  end if;

  select count(*) into v_handler_count
  from public.project_automation_task_handlers
  where task_type='system_health_check'
    and enabled=true
    and side_effect_class='read_only'
    and handler_version='1.0.0';
  if v_handler_count<>1 then
    raise exception 'Read-only system health handler allowlist missing or unsafe';
  end if;

  perform set_config('request.jwt.claim.role','service_role',true);
  select count(*) into v_claimed
  from public.worker_claim_project_automation_task('kill-switch-runtime-test');
  if v_claimed<>0 then
    raise exception 'Emergency stop allowed a task claim';
  end if;

  if has_function_privilege('anon',
    'public.worker_claim_project_automation_task(text)','EXECUTE')
    or has_function_privilege('authenticated',
    'public.worker_claim_project_automation_task(text)','EXECUTE') then
    raise exception 'Untrusted client role can execute worker claim RPC';
  end if;
  if not has_function_privilege('service_role',
    'public.worker_claim_project_automation_task(text)','EXECUTE') then
    raise exception 'Service role cannot execute worker claim RPC';
  end if;
end;
$test$;

select 'WORKER_KILL_SWITCH_RUNTIME=PASS' as result;
select 'WORKER_TASK_CLAIM_BLOCKED_WHILE_STOPPED=true' as result;
select 'ONLY_READ_ONLY_SYSTEM_HEALTH_HANDLER_ALLOWLISTED=true' as result;
