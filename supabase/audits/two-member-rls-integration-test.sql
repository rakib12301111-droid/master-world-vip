-- MASTER WORLD VIP two-member RLS integration test.
-- Run only against production after a verified backup, with two existing test accounts.
-- Uses transactional fixtures and rolls them back. Never use owner/admin UUIDs as members.
\set ON_ERROR_STOP on
\if :{?member_a}
\else
  \echo 'Set psql variable member_a to existing Member A auth.users UUID'; \quit 3
\endif
\if :{?member_b}
\else
  \echo 'Set psql variable member_b to existing Member B auth.users UUID'; \quit 3
\endif

BEGIN;
SET LOCAL row_security = on;
SELECT set_config('mwvip.test_member_a', :'member_a', true);
SELECT set_config('mwvip.test_member_b', :'member_b', true);

DO $mwvip_check$
DECLARE
  a uuid := current_setting('mwvip.test_member_a')::uuid;
  b uuid := current_setting('mwvip.test_member_b')::uuid;
BEGIN
  IF a = b THEN RAISE EXCEPTION 'RLS test requires two different member accounts'; END IF;
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id=a)
     OR NOT EXISTS (SELECT 1 FROM auth.users WHERE id=b) THEN
    RAISE EXCEPTION 'Both test accounts must exist in auth.users';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.app_user_roles
    WHERE user_id IN (a,b) AND role IN ('owner','super_admin','admin','moderator')
  ) OR EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id IN (a,b) AND role IN ('admin','moderator')
  ) THEN
    RAISE EXCEPTION 'Use ordinary member accounts only; elevated admin/moderator roles are not valid RLS fixtures';
  END IF;
END $mwvip_check$;

-- Ensure both test identities have the ordinary member role and a profile row.
-- Any newly inserted rows are temporary and are removed by the final ROLLBACK.
INSERT INTO public.user_roles(user_id,role)
SELECT v.user_id,'member'
FROM (VALUES (:'member_a'::uuid), (:'member_b'::uuid)) AS v(user_id)
WHERE NOT EXISTS (
  SELECT 1 FROM public.user_roles r
  WHERE r.user_id=v.user_id AND r.role='member'
);

-- Older Auth accounts may predate the profile-creation trigger; create only
-- a minimal missing test profile so the own-profile assertion is deterministic.
INSERT INTO public.profiles(id,display_name)
SELECT :'member_a'::uuid,'MWVIP RLS test member'
WHERE NOT EXISTS (
  SELECT 1 FROM public.profiles p WHERE p.id=:'member_a'::uuid
);

-- Fixture IDs are transaction-local constants; rollback removes every inserted row.
CREATE TEMP TABLE mwvip_rls_fixture AS
SELECT
  :'member_a'::uuid AS member_a,
  :'member_b'::uuid AS member_b,
  gen_random_uuid() AS conversation_id,
  gen_random_uuid() AS private_group_id,
  gen_random_uuid() AS broadcast_id,
  gen_random_uuid() AS support_ticket_id,
  gen_random_uuid() AS notification_id,
  gen_random_uuid() AS verification_request_id;
GRANT SELECT ON mwvip_rls_fixture TO authenticated;

INSERT INTO public.conversations(id,kind,created_by)
SELECT conversation_id,'direct',member_a FROM mwvip_rls_fixture;
-- Member B is deliberately NOT a participant: this tests cross-member denial.
INSERT INTO public.conversation_members(conversation_id,user_id)
SELECT conversation_id,member_a FROM mwvip_rls_fixture;
INSERT INTO public.messages(conversation_id,sender_id,body)
SELECT conversation_id,member_a,'MWVIP RLS integration fixture' FROM mwvip_rls_fixture;

INSERT INTO public.community_groups(id,name,description,is_private,owner_id)
SELECT private_group_id,'MWVIP RLS TEST','Temporary RLS fixture',true,member_a FROM mwvip_rls_fixture;
INSERT INTO public.group_members(group_id,user_id,role)
SELECT private_group_id,member_a,'owner' FROM mwvip_rls_fixture;
INSERT INTO public.group_messages(group_id,sender_id,body)
SELECT private_group_id,member_a,'MWVIP private group fixture' FROM mwvip_rls_fixture;

INSERT INTO public.support_tickets(id,user_id,subject,message)
SELECT support_ticket_id,member_a,'MWVIP RLS fixture','Temporary test ticket' FROM mwvip_rls_fixture;
INSERT INTO public.notifications(id,user_id,title,body,category)
SELECT notification_id,member_a,'MWVIP RLS fixture','Temporary test notification','test' FROM mwvip_rls_fixture;
INSERT INTO public.member_verification_requests(id,user_id,request_note)
SELECT verification_request_id,member_a,'Temporary private verification request fixture' FROM mwvip_rls_fixture;
INSERT INTO public.verification_request_messages(request_id,sender_id,body)
SELECT verification_request_id,member_a,'Temporary private helpdesk message' FROM mwvip_rls_fixture;
INSERT INTO public.verification_request_events(request_id,actor_id,event_type,new_status)
SELECT verification_request_id,member_a,'submitted','pending' FROM mwvip_rls_fixture;

-- Member B: cannot see A's direct conversation, message, private group, group roster/posts,
-- support ticket, notification, admin role table or audit log.
SELECT set_config('request.jwt.claim.sub',(SELECT member_b::text FROM mwvip_rls_fixture),true);
SET LOCAL ROLE authenticated;
DO $$
DECLARE f record;
BEGIN
  SELECT * INTO f FROM mwvip_rls_fixture;
  IF EXISTS (SELECT 1 FROM public.profiles WHERE id=f.member_a) THEN RAISE EXCEPTION 'FAIL: B can read A full/private profile row'; END IF;
  IF EXISTS (SELECT 1 FROM public.user_roles WHERE user_id=f.member_a) THEN RAISE EXCEPTION 'FAIL: B can read A role assignment'; END IF;
  IF EXISTS (SELECT 1 FROM public.conversations WHERE id=f.conversation_id) THEN RAISE EXCEPTION 'FAIL: B can read A private conversation'; END IF;
  IF EXISTS (SELECT 1 FROM public.messages WHERE conversation_id=f.conversation_id) THEN RAISE EXCEPTION 'FAIL: B can read A private messages'; END IF;
  IF EXISTS (SELECT 1 FROM public.community_groups WHERE id=f.private_group_id) THEN RAISE EXCEPTION 'FAIL: B can read A private group'; END IF;
  IF EXISTS (SELECT 1 FROM public.group_members WHERE group_id=f.private_group_id) THEN RAISE EXCEPTION 'FAIL: B can read A private group roster'; END IF;
  IF EXISTS (SELECT 1 FROM public.group_messages WHERE group_id=f.private_group_id) THEN RAISE EXCEPTION 'FAIL: B can read A private group posts'; END IF;
  IF EXISTS (SELECT 1 FROM public.support_tickets WHERE id=f.support_ticket_id) THEN RAISE EXCEPTION 'FAIL: B can read A support ticket'; END IF;
  IF EXISTS (SELECT 1 FROM public.notifications WHERE id=f.notification_id) THEN RAISE EXCEPTION 'FAIL: B can read A notification'; END IF;
  IF EXISTS (SELECT 1 FROM public.member_verification_requests WHERE id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: B can read A verification request'; END IF;
  IF EXISTS (SELECT 1 FROM public.verification_request_messages WHERE request_id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: B can read A helpdesk messages'; END IF;
  IF EXISTS (SELECT 1 FROM public.verification_request_events WHERE request_id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: B can read A verification audit history'; END IF;
  IF has_table_privilege('authenticated','public.app_user_roles','SELECT') THEN RAISE EXCEPTION 'FAIL: authenticated role has direct SELECT on admin roles'; END IF;
  IF has_table_privilege('authenticated','public.admin_audit_logs','SELECT') THEN RAISE EXCEPTION 'FAIL: authenticated role has direct SELECT on admin audit logs'; END IF;
END $$;
RESET ROLE;

-- Member A can read own fixtures; B cannot read A's notification or support ticket.
SELECT set_config('request.jwt.claim.sub',(SELECT member_a::text FROM mwvip_rls_fixture),true);
SET LOCAL ROLE authenticated;
DO $$
DECLARE f record;
BEGIN
  SELECT * INTO f FROM mwvip_rls_fixture;
  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id=f.member_a) THEN RAISE EXCEPTION 'FAIL: A cannot read own profile'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id=f.member_a) THEN RAISE EXCEPTION 'FAIL: A cannot read own role assignment'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.conversations WHERE id=f.conversation_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own conversation'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.messages WHERE conversation_id=f.conversation_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own message'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.community_groups WHERE id=f.private_group_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own private group'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.group_members WHERE group_id=f.private_group_id AND user_id=f.member_a) THEN RAISE EXCEPTION 'FAIL: A cannot read own group roster entry'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.group_messages WHERE group_id=f.private_group_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own private group post'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.support_tickets WHERE id=f.support_ticket_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own support ticket'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.notifications WHERE id=f.notification_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own notification'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.member_verification_requests WHERE id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own verification request'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.verification_request_messages WHERE request_id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own helpdesk messages'; END IF;
  IF NOT EXISTS (SELECT 1 FROM public.verification_request_events WHERE request_id=f.verification_request_id) THEN RAISE EXCEPTION 'FAIL: A cannot read own verification audit history'; END IF;
END $$;
RESET ROLE;

ROLLBACK;
\echo 'PASS: two-member RLS fixtures passed and all test rows were rolled back.'
