-- Read-only production audit for MASTER WORLD VIP.
-- No CREATE, ALTER, INSERT, UPDATE, DELETE, or policy changes are performed.

\echo '=== Required lookup indexes ==='
WITH expected(index_name, table_name) AS (
  VALUES
    ('update_releases_published_idx','update_releases'),
    ('messages_conversation_created_idx','messages'),
    ('group_messages_group_created_idx','group_messages'),
    ('friend_requests_addressee_status_idx','friend_requests'),
    ('profiles_username_lower_uidx','profiles')
)
SELECT e.index_name, e.table_name,
       CASE WHEN i.indexname IS NULL THEN 'MISSING' ELSE 'PRESENT' END AS status,
       i.indexdef
FROM expected e
LEFT JOIN pg_indexes i
  ON i.schemaname='public' AND i.indexname=e.index_name
ORDER BY e.table_name,e.index_name;

\echo '=== Exact duplicate index definitions ==='
SELECT schemaname, tablename, array_agg(indexname ORDER BY indexname) AS index_names,
       indexdef
FROM pg_indexes
WHERE schemaname='public'
GROUP BY schemaname,tablename,indexdef
HAVING count(*) > 1
ORDER BY tablename;

\echo '=== RLS enabled status for protected tables ==='
WITH expected(table_name) AS (
  VALUES ('profiles'),('friend_requests'),('conversations'),
         ('conversation_members'),('messages'),('community_groups'),
         ('group_members'),('group_messages'),('app_user_roles'),
         ('admin_audit_logs'),('update_releases')
)
SELECT e.table_name,
       CASE WHEN c.oid IS NULL THEN 'MISSING TABLE'
            WHEN c.relrowsecurity THEN 'RLS ENABLED'
            ELSE 'RLS DISABLED' END AS rls_status,
       COALESCE(c.relforcerowsecurity,false) AS force_rls
FROM expected e
LEFT JOIN pg_class c ON c.relname=e.table_name
LEFT JOIN pg_namespace n ON n.oid=c.relnamespace AND n.nspname='public'
WHERE c.oid IS NULL OR n.oid IS NOT NULL
ORDER BY e.table_name;

\echo '=== Policies on protected tables ==='
SELECT schemaname, tablename, policyname, permissive, roles,
       cmd, qual, with_check
FROM pg_policies
WHERE schemaname='public'
  AND tablename IN ('profiles','friend_requests','conversations',
    'conversation_members','messages','community_groups','group_members',
    'group_messages','app_user_roles','admin_audit_logs','update_releases')
ORDER BY tablename,policyname;

\echo '=== Authenticated role must not directly read admin tables ==='
SELECT
  has_table_privilege('authenticated','public.app_user_roles','SELECT') AS member_can_read_roles,
  has_table_privilege('authenticated','public.admin_audit_logs','SELECT') AS member_can_read_admin_audit;

\echo '=== Query plan: published releases ==='
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT version,release_notes
FROM public.update_releases
WHERE status='published'
ORDER BY published_at DESC NULLS LAST,created_at DESC
LIMIT 20;

\echo '=== Query plan: recent conversation messages ==='
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT id,conversation_id,sender_id,created_at
FROM public.messages
WHERE conversation_id='00000000-0000-0000-0000-000000000000'::uuid
ORDER BY created_at DESC
LIMIT 50;

\echo '=== Query plan: recent group messages ==='
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT id,group_id,sender_id,created_at
FROM public.group_messages
WHERE group_id='00000000-0000-0000-0000-000000000000'::uuid
ORDER BY created_at DESC
LIMIT 50;

\echo '=== Audit completed: read-only; inspect results above ==='
