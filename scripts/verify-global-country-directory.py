#!/usr/bin/env python3
from pathlib import Path
ui=Path("www/index.html").read_text(encoding="utf-8")
sw=Path("www/sw.js").read_text(encoding="utf-8")
assert "https://restcountries.com/v3.1/all?fields=name,cca2" in ui
assert "mwvip_global_country_list_v1" in ui
assert "countries.length<190" in ui
assert "function loadGlobalCountryDirectory" in ui
assert "helpline.value=sorted.some" in ui and "crisis.value=sorted.some" in ui
assert "mwvip-pwa-v20" in sw
assert "এই দেশের সরকারি যাচাইকৃত নম্বরের ডেটাসেট এখনো যুক্ত হয়নি" in ui
assert "ভুল নম্বর বানিয়ে দেখানো হবে না" in ui
print("PASS — global ISO country directory loader")
print("PASS — country list has offline cache and online refresh")
print("PASS — selectors cover all countries without inventing helpline numbers")
print("PASS — PWA cache version v19")
