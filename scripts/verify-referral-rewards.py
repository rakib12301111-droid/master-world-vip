#!/usr/bin/env python3
"""Static safety checks for MASTER WORLD VIP referral rewards."""
from pathlib import Path
import sys

sql = Path('supabase/migrations/202611240003_referral_wallet_rewards.sql').read_text(encoding='utf-8')
international_sql = Path('supabase/migrations/202611240005_international_referral_usd_equivalent.sql').read_text(encoding='utf-8')
edge = Path('supabase/functions/process-referral-rewards/index.ts').read_text(encoding='utf-8')
cron = Path('.github/workflows/process-referral-rewards.yml').read_text(encoding='utf-8')
ui = Path('www/index.html').read_text(encoding='utf-8')
config = Path('supabase/config.toml').read_text(encoding='utf-8')
migration_workflow = Path('.github/workflows/apply-supabase-migrations.yml').read_text(encoding='utf-8')
test_sql = Path('supabase/audits/referral-wallet-two-member-test.sql').read_text(encoding='utf-8')
test_workflow = Path('.github/workflows/test-referral-wallet-two-members.yml').read_text(encoding='utf-8')

checks = {
 'reward is fixed at BDT 50 and 24 hours': 'reward_amount numeric(12,2) not null default 50.00' in sql and 'qualification_hours integer not null default 24' in sql and "interval '24 hours'" in sql,
 'international migration is included in guarded preflight': '202611240005_international_referral_usd_equivalent.sql' in migration_workflow and 'admin_set_referral_usd_bdt_rate' in international_sql,
 'Bangladesh BDT 50 and foreign USD 50 equivalent are calculated in BDT': 'v_reward := 50.00' in international_sql and 'v_reward := round(50.00 * v_rate,2)' in international_sql and 'base_amount_usd' in international_sql and 'fx_rate_bdt_per_usd' in international_sql,
 'foreign awards wait for missing FX rate or country': 'v_waiting_for_rate' in international_sql and 'v_waiting_for_country' in international_sql,
 'FX source and reference are audited': 'rate_source' in international_sql and 'rate_reference' in international_sql and 'referral_usd_bdt_rate_updated' in international_sql,
 'reward processing requires verified email and complete profile': 'u.confirmed_at is not null' in sql and "char_length(btrim(coalesce(p.display_name,''))) > 0" in sql,
 'currently banned accounts are excluded': 'u.banned_until is null or u.banned_until <= now()' in sql,
 'wallet ledger prevents duplicate referral credits': 'unique(referral_id)' in sql and 'pg_advisory_xact_lock' in sql,
 'members cannot directly mutate wallet ledger': 'revoke insert, update, delete on public.referral_wallet_ledger from anon, authenticated' in sql,
 'withdrawals reserve balance and require Bangladesh wallet number': "status in ('pending','approved')" in sql and "'^01[3-9][0-9]{8}$'" in sql,
 'only verified Owner can add funds and enable rewards': "role='owner'" in sql and 'admin_add_referral_funds' in sql and 'admin_set_referral_rewards_enabled' in sql,
 'rewards default paused and require confirmed funds': 'rewards_enabled boolean not null default false' in sql and 'At least BDT 50.00 of confirmed reward budget' in sql,
 'mark-paid requires actual payment reference': 'Actual bKash/Nagad transfer reference is required' in sql and "status='paid'" in sql,
 'scheduled processor is service-role-only': 'grant execute on function public.process_eligible_referrals() to service_role' in sql and 'revoke all on function public.process_eligible_referrals() from public, anon, authenticated' in sql,
 'Edge Function validates protected cron secret': 'REFERRAL_CRON_SECRET' in edge and 'x-cron-secret' in edge and 'SUPABASE_SERVICE_ROLE_KEY' in edge,
 'cron runs every 15 minutes using secrets': '*/15 * * * *' in cron and 'REFERRAL_CRON_SECRET' in cron and 'SUPABASE_URL' in cron,
 'Supabase function does not require public JWT': '[functions.process-referral-rewards]' in config and 'verify_jwt = false' in config,
 'member wallet and admin budget UI exist': 'memberReferralWallet' in ui and 'refWalletAvailable' in ui and 'refFundAmount' in ui and 'adminReferralWithdrawals' in ui,
 'referral inline JS is no longer inside an external script tag': '<script src="./vip-security-center.js" defer></script>' in ui and 'async function loadReferralDashboard()' in ui,
 'guarded migration workflow includes all referral migrations': all(x in migration_workflow for x in ['202611240001_member_referrals.sql','202611240002_public_member_referral_profile.sql','202611240003_referral_wallet_rewards.sql']),
 'two-member test checks cross-wallet privacy and privilege separation': 'member_a' in test_sql and 'member_b' in test_sql and 'get_my_referral_wallet' in test_sql and 'get_admin_referral_finance_overview' in test_sql,
 'two-member test workflow requires separate member UUIDs': 'RLS_TEST_MEMBER_A_UUID' in test_workflow and 'RLS_TEST_MEMBER_B_UUID' in test_workflow and 'test "$MEMBER_A" != "$MEMBER_B"' in test_workflow,
}
for name, ok in checks.items():
    print(('PASS' if ok else 'FAIL') + ' — ' + name)
failed = [name for name, ok in checks.items() if not ok]
if failed:
    sys.exit(1)
print(f'All {len(checks)} referral reward safety checks passed.')