#!/usr/bin/env python3
import json
from pathlib import Path
ui=Path("www/index.html").read_text(encoding="utf-8")
data=json.loads(Path("www/data/helplines-BD.json").read_text(encoding="utf-8"))
sw=Path("www/sw.js").read_text(encoding="utf-8")
assert 'data-page="emergency"' in ui and 'id="helplineCountry"' in ui
assert 'refreshHelplines' in ui and 'mwvip_helplines_BD_v1' in ui
assert data["country"]=="BD" and len(data["records"])>=10
ids={r["id"]:r for r in data["records"]}
for key in ["bd-national-emergency","bd-fire-102","bd-fire-16163","bd-disaster","bd-health","bd-power","bd-desco","bd-desco-turag"]:
 r=ids[key]; assert r["number"] and r["source_url"].startswith("https://") and r["verified_on"]
assert ids["bd-national-emergency"]["number"]=="999"
assert ids["bd-desco"]["number"]=="16120"
assert ids["bd-desco-turag"]["number"]=="01324-435978"
assert "mwvip-pwa-v34" in sw
print("All official helpline directory checks passed.")
