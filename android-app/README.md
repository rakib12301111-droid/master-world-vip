# MASTER WORLD VIP Android wrapper

This Android app opens the deployed MASTER WORLD VIP web app in an Android WebView.

- Application ID: `com.masterworldvip.app`
- Website: `https://rakib12301111-droid.github.io/master-world-vip/`
- Minimum Android: 6.0 (API 23)
- Build output: `app/build/outputs/apk/debug/app-debug.apk`

## Build

The repository workflow `.github/workflows/android-apk.yml` builds an installable debug APK on GitHub Actions. It runs on pushes affecting this folder or can be started manually from the Actions tab.

The generated APK is a debug build signed with the runner's debug key. It is suitable for direct installation/testing, not Play Store upload. A production release requires a separately managed signing key and a release build.

The app is a WebView shell around the existing website. Backend services and website features remain subject to their own deployment/configuration status.

Build requested through the repository update on 2026-11-20.


## Current device-test checklist (2026-11-20)

- [ ] Install the latest debug APK on a physical Android phone and launch the hosted app.
- [ ] Sign in to the same Supabase project used by the PWA.
- [ ] Test two-account direct messaging, group messaging, inbox/unread/read behavior and broadcast permissions.
- [ ] Confirm navigation, keyboard, back button, network loss/reconnect and app resume.
- [ ] Web Push in this WebView is not certified: Service Worker Push is not reliably supported by Android WebView. Use Chrome-installed PWA for Web Push tests. Native APK push needs Firebase Cloud Messaging (FCM) integration and a server-side sender.
- [ ] Record Android version, device model, APK version and screenshots/logs for any failure.

A successful GitHub APK build verifies compilation and artifact creation only. It does not prove installation or live backend messaging/push on a physical phone.
