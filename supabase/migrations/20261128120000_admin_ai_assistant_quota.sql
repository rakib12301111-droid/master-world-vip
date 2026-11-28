-- Admin-only AI request quotas. No API keys or prompts are stored here.
create table if not exists public.admin_ai_assistant_quota (
  user_id uuid not null references auth.users(id) on delete cascade,
  window_type text not null check (window_type in ('minute','day')),
  window_start timestamptz not null,
  request_count integer not null default 0 check (request_count >= 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, window_type, window_start)
);
alter table public.admin_ai_assistant_quota enable row level security;
revoke all on public.admin_ai_assistant_quota from anon, authenticated;

create or replace function public.consume_admin_ai_assistant_quota(
  p_minute_limit integer default 5,
  p_daily_limit integer default 30
)
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_uid uuid := auth.uid();
  v_role text;
  v_count integer;
  v_minute timestamptz := date_trunc('minute', now());
  v_day timestamptz := date_trunc('day', now() at time zone 'UTC') at time zone 'UTC';
begin
  if v_uid is null then raise exception 'Sign in required'; end if;
  if p_minute_limit < 1 or p_daily_limit < 1 then raise exception 'Invalid quota'; end if;
  select public.get_my_admin_access() into v_role;
  if v_role not in ('owner','super_admin','admin') then raise exception 'Admin access required'; end if;

  insert into public.admin_ai_assistant_quota(user_id,window_type,window_start,request_count)
  values(v_uid,'day',v_day,1)
  on conflict(user_id,window_type,window_start) do update
    set request_count = public.admin_ai_assistant_quota.request_count + 1, updated_at = now()
    where public.admin_ai_assistant_quota.request_count < p_daily_limit
  returning request_count into v_count;
  if not found then raise exception 'Daily AI request limit reached (30/day)'; end if;

  insert into public.admin_ai_assistant_quota(user_id,window_type,window_start,request_count)
  values(v_uid,'minute',v_minute,1)
  on conflict(user_id,window_type,window_start) do update
    set request_count = public.admin_ai_assistant_quota.request_count + 1, updated_at = now()
    where public.admin_ai_assistant_quota.request_count < p_minute_limit
  returning request_count into v_count;
  if not found then raise exception 'AI rate limit reached (5/minute)'; end if;
end;
$$;
revoke all on function public.consume_admin_ai_assistant_quota(integer,integer) from public, anon;
grant execute on function public.consume_admin_ai_assistant_quota(integer,integer) to authenticated;
