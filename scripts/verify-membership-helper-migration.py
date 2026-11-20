#!/usr/bin/env python3
"""Static safety checks for the membership-helper hardening migration."""
from pathlib import Path
import re
import sys

path = Path("supabase/migrations/20261120150000_membership_helper_hardening.sql")
sql = path.read_text(encoding="utf-8")
normalized = re.sub(r"--[^\n]*", "", sql).lower()

checks = {
    "conversation helper is caller-scoped": bool(re.search(
        r"create\s+or\s+replace\s+function\s+public\.is_conversation_member\s*\(\s*target_conversation\s+uuid\s*\)", normalized
    )) and "and cm.user_id = auth.uid()" in normalized,
    "group helper is caller-scoped": bool(re.search(
        r"create\s+or\s+replace\s+function\s+public\.is_group_member\s*\(\s*target_group\s+uuid\s*\)", normalized
    )) and "and gm.user_id = auth.uid()" in normalized,
    "helpers use empty search_path": normalized.count("set search_path = ''") >= 2,
    "public and anon execution revoked": (
        "revoke all on function public.is_conversation_member(uuid) from public, anon" in normalized
        and "revoke all on function public.is_group_member(uuid) from public, anon" in normalized
    ),
    "only authenticated execution granted": (
        "grant execute on function public.is_conversation_member(uuid) to authenticated" in normalized
        and "grant execute on function public.is_group_member(uuid) to authenticated" in normalized
    ),
    "direct-message and group policies rebound": all(x in normalized for x in (
        'create policy "conversation members read"',
        'create policy "conversation participants read conversations"',
        'create policy "conversation members read messages"',
        'create policy "group members read roster"',
        'create policy "group members read posts"',
        'create policy "group members send posts"',
    )),
    "legacy two-argument helpers removed": all(x in normalized for x in (
        "drop function if exists public.is_conversation_member(uuid, uuid)",
        "drop function if exists public.is_group_member(uuid, uuid)",
    )),
    "no caller-supplied target_user helper parameter": not re.search(
        r"function\s+public\.is_(?:conversation|group)_member\s*\([^)]*target_user", normalized
    ),
}

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(("PASS" if passed else "FAIL") + " — " + name)
if failed:
    print(f"\n{len(failed)} safety check(s) failed.", file=sys.stderr)
    sys.exit(1)
print(f"\nAll {len(checks)} static migration safety checks passed.")
