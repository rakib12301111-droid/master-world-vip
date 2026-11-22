-- MASTER WORLD VIP: enable database change events for live messaging.
-- The client still has a 15-second refresh fallback if Realtime is unavailable.
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    if not exists (
      select 1 from pg_publication_tables
      where pubname='supabase_realtime' and schemaname='public' and tablename='messages'
    ) then
      alter publication supabase_realtime add table public.messages;
    end if;
    if not exists (
      select 1 from pg_publication_tables
      where pubname='supabase_realtime' and schemaname='public' and tablename='group_messages'
    ) then
      alter publication supabase_realtime add table public.group_messages;
    end if;
    if not exists (
      select 1 from pg_publication_tables
      where pubname='supabase_realtime' and schemaname='public' and tablename='notifications'
    ) then
      alter publication supabase_realtime add table public.notifications;
    end if;
  else
    raise notice 'supabase_realtime publication is unavailable; browser polling remains enabled.';
  end if;
end
$$;

comment on table public.messages is
'Private messages. Realtime publication is enabled when the Supabase publication exists; RLS remains enforced.';
comment on table public.group_messages is
'Group messages. Realtime publication is enabled when the Supabase publication exists; RLS remains enforced.';
