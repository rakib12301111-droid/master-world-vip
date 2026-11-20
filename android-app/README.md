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
