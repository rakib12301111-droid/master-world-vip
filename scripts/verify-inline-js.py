#!/usr/bin/env python3
"""Check every inline JavaScript block in the published app with Node.js."""
from pathlib import Path
import re
import subprocess
import sys
import tempfile

html = Path("www/index.html").read_text(encoding="utf-8")
blocks = re.findall(
    r"<script\b(?![^>]*\bsrc\s*=)[^>]*>(.*?)</script\s*>",
    html,
    flags=re.IGNORECASE | re.DOTALL,
)
if not blocks:
    print("FAIL — no inline JavaScript blocks found", file=sys.stderr)
    sys.exit(1)

with tempfile.TemporaryDirectory(prefix="mwvip-js-check-") as tmp:
    for index, source in enumerate(blocks, start=1):
        path = Path(tmp) / f"inline-{index}.js"
        path.write_text(source, encoding="utf-8")
        result = subprocess.run(["node", "--check", str(path)], check=False)
        if result.returncode:
            print(f"FAIL — inline JavaScript block {index}", file=sys.stderr)
            sys.exit(result.returncode)
        print(f"PASS — inline JavaScript block {index}")

print(f"All {len(blocks)} inline JavaScript block(s) passed syntax validation.")
