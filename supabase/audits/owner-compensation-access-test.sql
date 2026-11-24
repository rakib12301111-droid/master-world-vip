-- MASTER WORLD VIP Owner compensation access and ledger smoke test.
-- Run only after migration 202611240004 is applied.
-- Read/permission assertions only; transaction is rolled back and no payment is created.
\set ON_ERROR_STOP on
\if :{?owner_id}
\else
  \echo 'Set owner_id to the verified Owner auth.users UUID'; \quit 3
\endif
\if :{?member_id}
\else
  \echo 'Set member_id to an ordinary member auth.users UUID'; \quit 3
\endif

BEGIN;
SET LOCAL row_security = on;
SELECT set_config('mwvip.owner_id', :'owner_id', true);
SELECT set_config('mwvip.member_id', :'member_id', true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

DO $check_accounts$
DECLARE
  o uuid := current_setting('mwvip.owner_id')::uuid;
  m uuid := current_setting('mwvip.member_id')::uuid;
BEGIN
  IF o=m THEN RAISE EXCEPTION 'Owner and member must be different accounts'; END IF;
  IF NOT EXISTS(SELECT 1 FROM auth.users WHERE id=o)
     OR NOT EXISTS(SELECT 1 FROM auth.users WHERE id=m) THEN
    RAISE EXCEPTION 'Both accounts must exist';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM public.app_user_roles WHERE user_id=o AND role='owner') THEN
    RAISE EXCEPTION 'Owner test account must have verified owner role';
  END IF;
  IF EXISTS(SELECT 1 FROM public.app_user_roles WHERE user_id=m AND role IN ('owner','super_admin','admin')) THEN
    RAISE EXCEPTION 'Member test account must not be an administrator';
  END IF;
END
$check_accounts$;

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', current_setting('mwvip.owner_id'), true);
DO $owner_access$
DECLARE v jsonb;
BEGIN
  v := public.get_my_owner_compensation();
  IF (v->>'minimum_monthly')::numeric <> 1000.00 THEN
    RAISE EXCEPTION 'Owner monthly minimum must be BDT 1000';
  END IF;
  IF jsonb_typeof(v->'months') <> 'array' THEN
    RAISE EXCEPTION 'Owner monthly history is missing';
  END IF;
  IF has_table_privilege('authenticated','public.owner_compensation_months','SELECT')
     OR has_table_privilege('authenticated','public.owner_compensation_months','INSERT')
     OR has_table_privilege('authenticated','public.owner_compensation_payments','SELECT')
     OR has_table_privilege('authenticated','public.owner_compensation_payments','INSERT') THEN
    RAISE EXCEPTION 'Client role unexpectedly has direct table access';
  END IF;
END
$owner_access$;

SELECT set_config('request.jwt.claim.sub', current_setting('mwvip.member_id'), true);
DO $member_denial$
BEGIN
  BEGIN
    PERFORM public.get_my_owner_compensation();
    RAISE EXCEPTION 'Ordinary member unexpectedly accessed Owner compensation';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'Ordinary member unexpectedly accessed Owner compensation' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM public.owner_set_monthly_compensation_commission(
      date_trunc('month',current_date)::date,0,null,null
    );
    RAISE EXCEPTION 'Ordinary member unexpectedly changed Owner commission';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'Ordinary member unexpectedly changed Owner commission' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM public.owner_record_compensation_payment(
      date_trunc('month',current_date)::date,1,'TEST-REFERENCE'
    );
    RAISE EXCEPTION 'Ordinary member unexpectedly recorded Owner payment';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'Ordinary member unexpectedly recorded Owner payment' THEN RAISE; END IF;
  END;
END
$member_denial$;

RESET ROLE;
ROLLBACK;
\echo 'PASS: verified Owner access, BDT 1000 minimum, private ledger and ordinary-member denial.'
