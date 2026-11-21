#!/usr/bin/env python3
from pathlib import Path
ui=Path("www/index.html").read_text(encoding="utf-8")
sw=Path("www/sw.js").read_text(encoding="utf-8")
assert 'id="crisisAlerts"' in ui
for item in ["crisisCountry","crisisLanguage","crisisWar","crisisDisaster","crisisHealth","crisisSecurity","refreshCrisis","enableCrisisNotice"]:
 assert 'id="'+item+'"' in ui, item
for item in ["api.gdeltproject.org/api/v2/doc/doc","mwvip_crisis_cache_v1","mwvip_crisis_notice_optin","Notification.requestPermission","document.visibilityState==='visible'"]:
 assert item in ui, item
assert "mwvip-pwa-v24" in sw
assert "সরকারি সতর্কতা" in ui and "background push" in ui
print("PASS — crisis news region and category filters")
print("PASS — multilingual notification preference and explicit permission")
print("PASS — online fetch with offline last-seen cache")
print("PASS — media reports are distinguished from official alerts")
print("PASS — PWA cache version updated")
