# Global communication, offline and country news roadmap

## Current deliverable in this update

- Country selector opens Google News top stories for the selected country and language.
- Offline message drafts can be saved locally on this device and reopened. A draft is not delivered to another member.
- PWA shell assets may be available from cache after a prior online visit.
- Voice notes can be recorded and played locally after the user grants microphone permission. They are not uploaded or sent to another member.
- Satellite connectivity is explicitly shown as not active and not available through an ordinary app alone.

## Network reality and architecture

Private messages, group chat, broadcast, live news feeds, authentication, and push delivery require some communication path to a server or peer. With no internet, mobile data, Wi-Fi, or supported satellite/radio network, a phone cannot deliver a message to a person in another country. Offline drafts only preserve text locally.

A future store-and-forward design may queue encrypted messages on-device and transmit them when connectivity returns. It requires:
- a device-protected encryption key and recovery design;
- message expiry, retry, deduplication and delivery receipts;
- explicit user control over cellular/satellite data use;
- server-side queue and rate limits;
- end-to-end encryption design and key verification;
- no promise of delivery while the device has no network path.

## Satellite connection prerequisites

The application cannot create satellite connectivity in software. A production integration requires a named provider, supported phone/modem hardware, coverage in the target countries, an approved API/SDK, commercial/operational agreement, and local regulatory compliance. Until these exist, the app must not show "satellite connected" or claim messages are being delivered by satellite.

## Country news

The current feature opens Google News country/language pages. A first-party in-app headline feed requires a licensed news provider or approved API, source attribution, country/language mapping, caching, rate limits, and content-policy handling. External news links require connectivity.

## Production service prerequisites

The prior backend tasks remain separate:
- configure GitHub production Environment deployment secrets and deploy Edge Functions;
- configure Supabase server-only runtime secrets;
- confirm recoverable backup and run a database dry-run before applying migrations;
- verify Owner role;
- perform two-account private chat, inbox/read status, group, broadcast, push, and Android PWA acceptance tests.

Do not put service-role keys, GitHub tokens, VAPID private keys, or webhook secrets in frontend source, localStorage, or chat. Do not claim live server delivery until verified.
