#!/usr/bin/env python3
"""Static checks for offline, voice and country news UI claims."""
from pathlib import Path
import sys
ui=Path("www/index.html").read_text(encoding="utf-8")
sw=Path("www/sw.js").read_text(encoding="utf-8")
manifest=Path("www/manifest.webmanifest").read_text(encoding="utf-8")
doc=Path("docs/GLOBAL_COMMUNICATION_OFFLINE_NEWS_ROADMAP.md").read_text(encoding="utf-8")
checks={
 "global news navigation and country selector exist": 'data-page="global"' in ui and 'id="newsCountry"' in ui,
 "country news opens country-specific Google News URL": 'news.google.com/topstories' in ui and "ceid=" in ui,
 "offline drafts are local and explicitly not sent": 'mwvip_offline_draft_v1' in ui and 'এখনো পাঠানো হয়নি' in ui,
 "offline and online status is displayed": "addEventListener('online'" in ui and "addEventListener('offline'" in ui,
 "voice recording requires explicit microphone request": "getUserMedia({audio:true})" in ui,
 "voice UI does not claim server delivery": 'অন্য সদস্যকে পাঠানো হয়নি' in ui,
 "satellite is not falsely advertised as connected": 'স্যাটেলাইট সংযোগ এখনো সক্রিয় নয়' in ui,
 "PWA cache version is refreshed": "mwvip-pwa-v23" in sw,
 "PWA manifest remains configured": '"display": "standalone"' in manifest,
 "technical limitations and provider requirements are documented": "Satellite connection prerequisites" in doc and "cannot deliver a message" in doc,
}
for name,ok in checks.items(): print(("PASS" if ok else "FAIL")+" — "+name)
failed=[k for k,v in checks.items() if not v]
if failed: sys.exit(1)
print(f"All {len(checks)} global communication checks passed.")
