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
SELECT
  t.relname AS table_name,
  array_agg(ic.relname ORDER BY ic.relname) AS duplicate_index_names,
  am.amname AS access_method,
  i.indisunique AS is_unique,
  i.indkey::text AS key_columns,
  i.indclass::text AS operator_classes,
  i.indcollation::text AS collations,
  i.indoption::text AS index_options,
  pg_get_expr(i.indpred, i.indrelid) AS partial_predicate,
  pg_get_expr(i.indexprs, i.indrelid) AS index_expressions
FROM pg_index i
JOIN pg_class t ON t.oid=i.indrelid
JOIN pg_namespace n ON n.oid=t.relnamespace
JOIN pg_class ic ON ic.oid=i.indexrelid
JOIN pg_am am ON am.oid=ic.relam
WHERE n.nspname='public'
GROUP BY t.relname, am.amname, i.indisunique, i.indkey, i.indclass, i.indcollation, i.indoption, i.indpred, i.indexprs, i.indrelid
HAVING count(*) > 1
ORDER BY t.relname;

\echo '=== RLS enabled status for protected tables ==='
WITH expected(table_name) AS (
  VALUES ('profiles'),('friend_requests'),('conversations'),
         ('conversation_members'),('messages'),('community_groups'),
         ('group_members'),('group_messages'),('app_user_roles'),
         ('admin_audit_logs'),('update_releases'),('user_roles'),
         ('privacy_consents'),('referrals'),('notifications'),
         ('support_tickets'),('audit_logs')
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
    'group_messages','app_user_roles','admin_audit_logs','update_releases',
    'user_roles','privacy_consents','referrals','notifications','support_tickets','audit_logs')
ORDER BY tablename,policyname;

\echo '=== Unsafe broad profile-discovery policy must be absent ==='
SELECT count(*) AS broad_discoverable_profile_policies
FROM pg_policies
WHERE schemaname='public'
  AND tablename='profiles'
  AND policyname='discoverable profiles visible to members';

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
