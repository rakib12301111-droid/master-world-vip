# MASTER WORLD VIP — Anti-Theft & Phone Recovery (Android + iOS)

Updated: 2026-11-25

## User workflow

1. Before loss, the member signs into the same MASTER WORLD VIP account on the phone and enrolls that installation in the native Android/iOS app.
2. Enrollment uses a random installation UUID, platform, device label and app version. Do not use IMEI as a public identifier.
3. The member explicitly grants OS location permission and enables visible location sharing. Explain battery use, background restrictions, data retention and how to stop sharing.
4. If the phone is lost, the owner signs in from another trusted device, selects their own enrolled device and creates a lost-device report.
5. The recovery center shows the last successful heartbeat and GPS sample with timestamp, accuracy and a freshness label. If the phone reconnects and OS permissions/background execution allow it, the native app may send a fresh sample.
6. The owner can also open Google Find Hub or Apple Find My for platform-native recovery/secure actions.

## Important technical limits

- Signing into MASTER WORLD VIP with Gmail does not reveal the lost phone's current IP or GPS.
- IP is network/security metadata, not a GPS coordinate. Mobile carrier NAT, VPN, Wi-Fi changes and dynamic IP mean it cannot identify an exact address. Never present IP geolocation as a street-level or live location.
- A server can observe an IP only when the device makes a request. The browser cannot remotely query a disconnected phone.
- Live GPS requires a native app previously installed/enrolled on the lost phone, OS location services, explicit permissions, network connectivity and platform-compliant background behavior.
- If the device is powered off/offline, location is disabled, permissions revoked, app removed or OS suspends background activity, no new location may arrive. Show only a timestamped last-known location.
- Do not promise remote lock/erase from MASTER WORLD VIP. Use official platform services.

## Backend foundation in this repository

Migration: `supabase/migrations/20261125120000_anti_theft_device_recovery.sql`

- `member_recovery_devices`: owner-scoped device registry for Android/iOS.
- `member_lost_device_reports`: owner-scoped lost/recovered reports.
- `member_recovery_location_samples`: owner-only GPS sample read access; samples must be sent by the future native app/backend.
- `member_recovery_connection_events`: raw IP security telemetry, inaccessible to anon/authenticated clients and intended for server-side service-role use only, with 30-day retention metadata.
- RLS is enabled. Device rows and reports are scoped to `auth.uid()`. Location samples have owner-only SELECT; authenticated clients cannot directly insert location samples. A trusted backend/native ingestion endpoint must validate device ownership and permission before inserting.

## Still not implemented / must not be claimed live

- Native Android Kotlin and iOS Swift apps, device enrollment UX and authenticated device binding.
- Secure server endpoint/Edge Function for native app heartbeats and GPS ingestion, including ownership validation, replay/rate limiting and audit.
- Authenticated owner-only lost-report UI/API wired to the migration.
- Server-side IP event collector, retention purge job and trusted coarse-IP provider (if ever needed).
- Live map, push alerts and native background location behavior.
- Remote lock/erase integration.
- Supabase migration application, backup/restore safety gate, RLS tests, two-account isolation tests and real Android/iPhone acceptance tests.

## Required safety and acceptance tests

- A member can enroll/read/revoke only their own devices.
- A second account cannot read another member's devices, reports or location samples.
- Anonymous users cannot access any recovery data.
- No location can be looked up by phone number, IP or another member's account.
- Native ingestion verifies authenticated owner + registered device + active sharing + OS permission state before accepting GPS.
- IP changes, VPN, carrier NAT, Wi-Fi changes and offline/powered-off states never create fake GPS coordinates.
- Stale samples are timestamped and never labelled LIVE.
- Revoking permission/sharing/device enrollment stops future collection.
- Verify retention purge, account deletion cascade, audit, rate limits and actual supported Android/iOS devices.
