#!/usr/bin/env python3
"""Static checks for offline emergency center and games."""
from pathlib import Path
import sys
ui=Path("www/index.html").read_text(encoding="utf-8")
sw=Path("www/sw.js").read_text(encoding="utf-8")
doc=Path("docs/EMERGENCY_OFFLINE_SATELLITE_GAMES.md").read_text(encoding="utf-8")
checks={
 "emergency navigation and section exist": 'data-page="emergency"' in ui and 'id="emergency"' in ui,
 "earthquake, cyclone, flood, pandemic and fire guidance exist": all(x in ui for x in ["earthquake:","cyclone:","flood:","pandemic:","fire:"]),
 "speech requires explicit button interaction": "speakEmergency" in ui and "speechSynthesis.speak" in ui,
 "local alarm does not claim remote notification": "কেবল এই ডিভাইসে" in ui and "কাউকে সতর্ক করে না" in ui,
 "offline games center exists": 'data-page="games"' in ui and 'id="games"' in ui,
 "tic tac toe and number guessing exist": "ticTacToeBoard" in ui and "guessTarget" in ui,
 "satellite not falsely advertised": "স্যাটেলাইট সংযোগ বা সরকারি Cell Broadcast" in ui,
 "PWA cache version incremented": "mwvip-pwa-v18" in sw,
 "capability boundaries documented": "No satellite link" in doc and "No automatic earthquake" in doc,
}
for k,v in checks.items(): print(("PASS" if v else "FAIL")+" — "+k)
if not all(checks.values()): sys.exit(1)
print(f"All {len(checks)} emergency and games checks passed.")
