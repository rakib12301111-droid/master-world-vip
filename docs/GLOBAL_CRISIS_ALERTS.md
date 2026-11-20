# Global crisis news and alert feature

## Included in this release
- Region selection and crisis categories: armed conflict/war, disaster, public health, and security incidents.
- Current news article discovery through the GDELT public DOC API while online.
- Article title, source domain, timestamp when supplied, and original source link.
- Translation handoff through Google Translate into Bengali, English, Arabic, or Urdu.
- Last successful article list cached locally for offline reading.
- Optional in-app foreground notification after explicit browser permission.

## Safety limitations
- News reports are not official emergency warnings. The UI explicitly distinguishes them.
- GDELT coverage is media coverage, not a government alert feed; it may be delayed, incomplete, duplicated, or inaccurate.
- The page does not poll in the background, does not send web push when closed, and does not guarantee notifications while offline.
- Browser notifications require HTTPS, supported browser, and explicit user permission.
- True critical alerts require authoritative country-specific government feeds, backend verification/deduplication, translation review, Web Push/VAPID server configuration, and per-device opt-in.
- Never present an unverified report as a confirmed war, attack, or evacuation order. Users should follow local authorities.


## Push sender hardening
The send-push Edge Function allows browser requests only from the production GitHub Pages origin and returns no-store responses. This CORS rule is defense-in-depth, not authentication: the webhook secret remains mandatory and must only exist in server-side Supabase secrets. The function is not live until deployed with its required secrets.
