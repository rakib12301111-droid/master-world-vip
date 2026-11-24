#!/usr/bin/env python3
"""Static safety checks for MASTER WORLD VIP referral rewards."""
from pathlib import Path
import re
import sys

sql = Path('supabase/migrations/202611240003_referral_wallet_rewards.sql').read_text(encoding='utf-8')
international_sql = Path('supabase/migrations/202611240005_international_referral_usd_equivalent.sql').read_text(encoding='utf-8')
network_sql = Path('supabase/migrations/202611240006_network_admin_referral_rewards.sql').read_text(encoding='utf-8')
payout_sql = Path('supabase/migrations/202611240007_referral_payout_reference_hardening.sql').read_text(encoding='utf-8')
edge = Path('supabase/functions/process-referral-rewards/index.ts').read_text(encoding='utf-8')
cron = Path('.github/workflows/process-referral-rewards.yml').read_text(encoding='utf-8')
ui = Path('www/index.html').read_text(encoding='utf-8')
config = Path('supabase/config.toml').read_text(encoding='utf-8')
migration_workflow = Path('.github/workflows/apply-supabase-migrations.yml').read_text(encoding='utf-8')
test_sql = Path('supabase/audits/referral-wallet-two-member-test.sql').read_text(encoding='utf-8')
test_workflow = Path('.github/workflows/test-referral-wallet-two-members.yml').read_text(encoding='utf-8')

checks = {
 'international migration PL/pgSQL dollar quotes are balanced': international_sql.count('$$') >= 10 and international_sql.count('$$') % 2 == 0,
 'international migration has no malformed dollar delimiters or escaped newlines': not re.search(r'\bas \$(?!\$)', international_sql) and r'\n' not in international_sql,
 'reward is fixed at BDT 50 and 24 hours': 'reward_amount numeric(12,2) not null default 50.00' in sql and 'qualification_hours integer not null default 24' in sql and "interval '24 hours'" in sql,
 'international migration is included in guarded preflight': '202611240005_international_referral_usd_equivalent.sql' in migration_workflow and 'admin_set_referral_usd_bdt_rate' in international_sql,
 'network reward migration is included in guarded preflight': '202611240006_network_admin_referral_rewards.sql' in migration_workflow,
 'payout hardening migration is included in guarded preflight': '202611240007_referral_payout_reference_hardening.sql' in migration_workflow,
 'Owner and members use their own authenticated wallet balance for withdrawal': 'where user_id=v_user' in sql and 'v_user uuid := auth.uid()' in sql and 'beneficiary_id=v_owner' in network_sql,
 'Paid withdrawals require real transfer reference, reviewer and timestamp': 'referral_paid_requires_transfer_audit' in payout_sql and 'paid_at is not null' in payout_sql and 'reviewed_by is not null' in payout_sql,
 'same-method Paid transfer references cannot be reused': 'referral_withdrawal_paid_reference_unique_idx' in payout_sql and 'lower(btrim(payment_reference))' in payout_sql,
 'payout hardening does not claim to send money automatically': 'does not initiate payments or create wallet funds' in payout_sql,
 'member gets 100% direct and Owner gets additional 100% network reward': "'member_direct'" in network_sql and "'owner_network'" in network_sql and "'combined_reward_cost_percent',200" in network_sql,
 'network Owner reward requires exactly one verified Owner': "if v_owner_count <> 1" in network_sql and "where role='owner'" in network_sql,
 'both entitlements remain pending until the full 200% funding is available': "where e.status='pending'" in network_sql and 'v_budget < v_row.combined_amount' in network_sql and "set status='credited'" in network_sql,
 'pending rewards have a member-private read RPC': 'get_my_referral_pending_rewards' in network_sql and 'beneficiary_id=v_user' in network_sql,
 'Admin network reward summary is protected': 'get_admin_referral_network_reward_summary' in network_sql and 'is_referral_finance_admin' in network_sql,
 'Bangladesh BDT 50 and foreign USD 50 equivalent are calculated in BDT': 'v_reward := 50.00' in international_sql and 'v_reward := round(50.00 * v_rate,2)' in international_sql and 'base_amount_usd' in international_sql and 'fx_rate_bdt_per_usd' in international_sql,
 'foreign awards wait for missing FX rate or country': 'v_waiting_for_rate' in international_sql and 'v_waiting_for_country' in international_sql,
 'country must be verified by Owner/Admin before referral reward': 'referral_reward_country_verified' in international_sql and 'admin_verify_referral_reward_country' in international_sql and 'referral_reward_country_verified=true' in international_sql,
 'Admin country verification queue and UI controls exist': 'get_admin_referral_country_review_queue' in international_sql and 'referralCountryReviewQueue' in ui and 'admin_verify_referral_reward_country' in ui,
 'FX source and reference are audited': 'rate_source' in international_sql and 'rate_reference' in international_sql and 'referral_usd_bdt_rate_updated' in international_sql,
 'reward processing requires verified email and complete profile': 'u.confirmed_at is not null' in sql and "char_length(btrim(coalesce(p.display_name,''))) > 0" in sql,
 'currently banned accounts are excluded': 'u.banned_until is null or u.banned_until <= now()' in sql,
 'wallet ledger prevents duplicate referral credits': 'unique(referral_id)' in sql and 'pg_advisory_xact_lock' in sql,
 'separate reward kinds prevent duplicate member and Owner credits': 'unique (referral_id,reward_kind)' in network_sql and 'referral_wallet_one_reward_per_referral' in network_sql,
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
 'member wallet displays pending reward and Owner network totals': 'refWalletPendingReward' in ui and 'get_my_referral_pending_rewards' in ui and 'refAdminNetworkPending' in ui and 'get_admin_referral_network_reward_summary' in ui,
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