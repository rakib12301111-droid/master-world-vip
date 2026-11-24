-- MASTER WORLD VIP referral wallet two-member security smoke test.
-- Run only after migration 202611240003 is applied, with two ordinary test members.
-- This script performs read/permission assertions only; it creates no funds or payouts.
\set ON_ERROR_STOP on
\if :{?member_a}
\else
  \echo 'Set member_a to Member A auth.users UUID'; \quit 3
\endif
\if :{?member_b}
\else
  \echo 'Set member_b to Member B auth.users UUID'; \quit 3
\endif

BEGIN;
SET LOCAL row_security = on;
SELECT set_config('mwvip.member_a', :'member_a', true);
SELECT set_config('mwvip.member_b', :'member_b', true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

DO $check_accounts$
DECLARE
  a uuid := current_setting('mwvip.member_a')::uuid;
  b uuid := current_setting('mwvip.member_b')::uuid;
BEGIN
  IF a=b THEN RAISE EXCEPTION 'Two different member accounts are required'; END IF;
  IF NOT EXISTS(SELECT 1 FROM auth.users WHERE id=a)
     OR NOT EXISTS(SELECT 1 FROM auth.users WHERE id=b) THEN
    RAISE EXCEPTION 'Both member accounts must exist';
  END IF;
  IF EXISTS(SELECT 1 FROM public.app_user_roles WHERE user_id IN (a,b) AND role IN ('owner','super_admin','admin')) THEN
    RAISE EXCEPTION 'Test identities must be ordinary members, not administrators';
  END IF;
END
$check_accounts$;

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', current_setting('mwvip.member_a'), true);
DO $member_a$
DECLARE
  b uuid := current_setting('mwvip.member_b')::uuid;
  v jsonb;
BEGIN
  v := public.get_my_referral_wallet();
  IF v ? 'available_balance' IS NOT TRUE THEN RAISE EXCEPTION 'Member A wallet response missing available_balance'; END IF;
  IF (v->'withdrawals')::text LIKE '%'||b::text||'%' THEN
    RAISE EXCEPTION 'Member A wallet exposed Member B data';
  END IF;
  IF EXISTS(SELECT 1 FROM public.referral_wallet_ledger WHERE user_id=b) THEN
    RAISE EXCEPTION 'Member A can read Member B wallet ledger';
  END IF;
  IF EXISTS(SELECT 1 FROM public.referral_withdrawal_requests WHERE user_id=b) THEN
    RAISE EXCEPTION 'Member A can read Member B withdrawal requests';
  END IF;
  IF has_table_privilege('authenticated','public.referral_wallet_ledger','INSERT') THEN
    RAISE EXCEPTION 'Members must not have direct wallet ledger INSERT permission';
  END IF;
  IF has_table_privilege('authenticated','public.referral_wallet_ledger','UPDATE') THEN
    RAISE EXCEPTION 'Members must not have direct wallet ledger UPDATE permission';
  END IF;
  BEGIN
    PERFORM public.get_admin_referral_finance_overview();
    RAISE EXCEPTION 'Member A unexpectedly accessed Admin finance';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'Member A unexpectedly accessed Admin finance' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM public.get_admin_referral_withdrawals();
    RAISE EXCEPTION 'Member A unexpectedly accessed Admin withdrawals';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'Member A unexpectedly accessed Admin withdrawals' THEN RAISE; END IF;
  END;
END
$member_a$;

SELECT set_config('request.jwt.claim.sub', current_setting('mwvip.member_b'), true);
DO $member_b$
DECLARE
  a uuid := current_setting('mwvip.member_a')::uuid;
  v jsonb;
BEGIN
  v := public.get_my_referral_wallet();
  IF v ? 'available_balance' IS NOT TRUE THEN RAISE EXCEPTION 'Member B wallet response missing available_balance'; END IF;
  IF (v->'withdrawals')::text LIKE '%'||a::text||'%' THEN
    RAISE EXCEPTION 'Member B wallet exposed Member A data';
  END IF;
  IF EXISTS(SELECT 1 FROM public.referral_wallet_ledger WHERE user_id=a) THEN
    RAISE EXCEPTION 'Member B can read Member A wallet ledger';
  END IF;
  IF EXISTS(SELECT 1 FROM public.referral_withdrawal_requests WHERE user_id=a) THEN
    RAISE EXCEPTION 'Member B can read Member A withdrawal requests';
  END IF;
END
$member_b$;

RESET ROLE;
ROLLBACK;
\echo 'PASS: member wallet privacy, no direct ledger writes, and admin-only finance RPC access.'
