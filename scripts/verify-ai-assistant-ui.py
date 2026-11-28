#!/usr/bin/env python3
"""Static checks for the authenticated MASTER WORLD VIP AI Center UI."""
from pathlib import Path

html = Path("www/index.html").read_text(encoding="utf-8")
staging = Path(".github/workflows/validate-staging-supabase.yml").read_text(encoding="utf-8")
checks = {
    "AI prompt is bounded to 12,000 characters": 'id="mwAiPrompt"' in html and 'maxlength="12000"' in html,
    "AI UI offers Bengali and English": 'id="mwAiLanguage"' in html and 'value="bn"' in html and 'value="en"' in html,
    "AI request uses the authenticated Supabase Edge Function": "client.functions.invoke('ai-assistant'" in html,
    "AI UI refuses requests without an authenticated user": "if(!client||!currentUser)" in html,
    "AI output is rendered as text, not HTML": "reply.textContent=data.reply" in html,
    "AI UI does not contain provider or service-role credentials": not any(x in html for x in ("AI_PROVIDER_API_KEY", "SUPABASE_SERVICE_ROLE_KEY")),
    "AI request button is disabled while processing": "button.disabled=true;status.textContent='নিরাপদ AI backend-এ অনুরোধ পাঠানো হচ্ছে…" in html,
    "Staging acceptance workflow deploys the AI assistant Edge Function": "supabase functions deploy ai-assistant --project-ref \"$PROJECT_REF\"" in staging,
    "AI function deployment is pinned to Staging and excludes Production": "PROJECT_REF: awatzrapqrteybgspqlq" in staging and "test \"$PROJECT_REF\" != \"lztbbrzeuyjkuiyzrsxp\"" in staging,
    "Staging deployment documents the server-side provider secret gate": "AI_PROVIDER_API_KEY must be configured as a Staging Edge Function secret" in staging,
    "Voice and licensed image search are not falsely marked live": "Speech input/output এখনো সংযুক্ত নয়" in html and "Licensed image provider integration বাকি" in html,
}
for label, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " - " + label)
if not all(checks.values()):
    raise SystemExit(1)
