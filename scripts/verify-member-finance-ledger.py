#!/usr/bin/env python3
"""Static checks for the append-only USD/BDT double-entry ledger."""
from pathlib import Path
import re
sql=Path("supabase/migrations/20261126140000_append_only_double_entry_finance_ledger.sql").read_text(encoding="utf-8").lower()
flat=re.sub(r"\s+"," ",sql)
checks={
 "USD and BDT are separate ledger currencies": "currency in ('usd','bdt')" in flat and "cross currency" not in flat,
 "account chart separates system and per-member payable accounts": all(x in flat for x in ["finance_accounts","member_payable","owner_user_id","is_system"]),
 "journal headers have unique idempotency keys": "idempotency_key text not null unique" in flat,
 "journal lines enforce one-sided positive debit or credit": "check ((debit>0 and credit=0) or (credit>0 and debit=0))" in flat,
 "posting rejects unbalanced journals": "v_debits<>v_credits" in flat,
 "posting enforces one currency and known accounts": "v_account.currency<>p_currency" in flat,
 "Member payout cannot exceed own accrued payable": "member payout exceeds that member own settled payable balance" in flat,
 "posting is trusted service-role only": "trusted finance service role required" in flat and "to service_role" in flat,
 "idempotent retries return original journal": "v_existing.request_lines=p_lines" in flat and "'duplicate',true" in flat,
 "idempotency collisions with changed payload fail": "idempotency key collision with different journal payload" in flat,
 "journal headers, lines and accounts are append-only": flat.count("before update or delete on public.finance_")>=3,
 "ledger integrity audit checks every journal": "finance_journal_integrity_check" in flat and "unbalanced_journals" in flat,
 "RLS blocks browser writes": flat.count("enable row level security")>=3 and "from public,anon,authenticated" in flat,
 "no live bank or payment custody is claimed": "not proof of external custody" in flat,
}
for name,ok in checks.items(): print(("PASS" if ok else "FAIL")+" - "+name)
if not all(checks.values()): raise SystemExit(1)
