# MASTER WORLD VIP — Anti-Theft & Phone Recovery (Android + iOS)

Updated: 2026-11-25

## Product goal

Offer every signed-in member a recovery center for their own registered Android phone or iPhone. Both platforms use the same MASTER WORLD VIP account and member dashboard. The current website panel is guidance and official-service shortcuts only; it is not a phone tracker.

## Critical technical truth

- An IP address is not a GPS coordinate. IP geolocation may identify an approximate network/ISP region, may be shared by many devices, and may change. Never convert an IP into a claimed street address or live phone location.
- A web page cannot reliably obtain the device's public IP without a server-side request, and a server-observed IP is only connection metadata.
- A powered-on phone is not automatically trackable by MASTER WORLD VIP. GPS updates require an installed app, device location services, network connectivity, platform permissions, and a running/eligible background location mechanism.
- If a phone is offline, powered off, has location disabled, app removed, permissions revoked, or platform restrictions suspend updates, only a previously recorded last-known location may exist. Label its timestamp and never present it as live.
- Android background location requires explicit platform permissions and is restricted by Google Play policy. Use a visible foreground location service when appropriate and request background access only when core functionality justifies it.
- iOS suspends most background apps. Location updates require Core Location background configuration and user authorization; the operating system may defer updates. Do not promise continuous tracking.

## Platform strategy

### Android native app
- Native Android app (Kotlin/Android SDK), authenticated to the same Supabase account.
- Device enrollment using an app-generated random installation identifier; do not expose IMEI as a public lookup key.
- Clear location-sharing status, permission status, persistent notification for an active foreground location service, battery-aware update schedule, and immediate stop control.
- Use Android location APIs only with disclosed permissions and Google Play policy review.
- Offer a deep link to Google Find Hub for Google-managed device recovery.

### iOS native app
- Native iOS app (Swift/SwiftUI), same account identity and backend contract.
- Core Location with explicit When In Use / Always authorization explanation, background location capability only when approved and essential, visible privacy explanation, and a stop-sharing control.
- Do not attempt to bypass iOS suspension, permission prompts, Find My, Activation Lock, or Apple's device security.
- Offer a deep link to Apple Find My / iCloud Find Devices.

## Shared backend contract (to implement; not live yet)

- Owner-only device registry: `owner_user_id`, random `device_id`, platform, model label, app version, enrolled_at, last_seen_at, sharing_enabled, revoked_at.
- Lost-device report: owner, enrolled device, report status, created_at, resolved_at, owner notes. Only the owner and authorized support staff may access it.
- Location samples: device owner, latitude, longitude, accuracy, captured_at, source, and freshness. Access only through owner-scoped authenticated RPCs. Never allow lookup by phone number or IP to reveal another person's location.
- Connection event log: server-observed IP address only for security/diagnostic use, timestamp, device/session reference, coarse geolocation only if derived from a trusted provider. Minimize retention, restrict access, and never expose raw IP in public member search.
- RLS on every table; no anon access; audit all access; rate-limit reports and device operations; revoke a device/session when the owner reports it stolen.
- Store no passwords, OTPs, recovery codes, or service-role keys in client code or chat. Keep any sensitive device identifiers private and encrypted where appropriate.

## Lost-device workflow

1. Member signs in on another trusted device and opens Anti-Theft Recovery.
2. Selects their own enrolled device and marks it lost/stolen.
3. Backend records the report and shows last successful heartbeat/location with exact timestamp and freshness label.
4. If device reconnects and the native app is still permitted to send updates, it may send a new location sample. IP is displayed only as network metadata, not as location.
5. Member opens Google Find Hub or Apple Find My for platform-native locate/secure/erase actions.
6. Member contacts their carrier to suspend the SIM and reports theft to police. Never encourage confrontation.

## Current repository implementation

- The existing Live Number Location Map remains a separate consent-based member-to-member sharing feature. It is not the anti-theft device registry.
- A new Anti-Theft Recovery guidance panel is inserted in the existing location area, with official Android and iPhone recovery links and clear limitations.
- No native Android/iOS project, device registry migration, server-side IP event collector, remote lock/erase API, or live anti-theft tracking is implemented by this update.
- Keep stage status `planned` until native apps, backend, privacy review, and physical-device acceptance tests pass.

## Acceptance tests before calling it live

- Android and iPhone enroll only under the authenticated owner's account.
- A second account cannot read another member's device list, IP logs, lost reports, or location.
- IP changes, VPN, carrier NAT, Wi-Fi changes, offline and powered-off states never generate a false GPS location.
- Background location works only under granted platform permissions and remains visible to the user.
- Revoking permission, disabling sharing, signing out, uninstalling, or revoking a device stops future collection.
- Stale last-known data is clearly timestamped and never labelled LIVE.
- Test account recovery, lost-report audit trail, retention/deletion, rate limits, and real devices on supported Android/iOS versions.
