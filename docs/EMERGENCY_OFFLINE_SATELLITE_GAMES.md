# Emergency Offline, Satellite, Games and Production Completion Plan

## Implemented in this branch
- Offline emergency reference cards for earthquake, cyclone/surge, flood, pandemic, fire and network outage.
- Optional browser Text-to-Speech when the user taps Speak. Availability of Bengali offline voice depends on the OS/browser's installed voice package.
- A local alarm while the app page is open. It does not detect disasters or contact responders.
- Offline Tic-Tac-Toe and number guessing games.
- Existing PWA cache version incremented so the next deployment refreshes the app shell.

## Not implemented / not claimed
- No automatic earthquake, cyclone, flood or pandemic detection.
- No government Cell Broadcast / Wireless Emergency Alerts integration.
- No background alarm guarantee after the browser/app is closed or phone is powered off.
- No satellite link. Requires compatible device/modem, provider service/API, coverage, contract, approvals and country-specific regulatory compliance.
- No online multiplayer game backend, tournaments, matchmaking, moderation or anti-cheat yet.
- No database migration applied, backup verified, Owner role confirmed, live chat/broadcast/push delivery test completed, or APK release completed.

## Safety
Emergency instructions are general preparedness guidance, not a substitute for local emergency services or official alerts. The app must not represent cached guidance as a live warning. Keep device emergency features and official government alerts enabled.

## Production completion sequence
1. Configure deployment secrets in GitHub Environment and server runtime secrets in Supabase without exposing them in browser source.
2. Verify backups and recovery path; run database dry-run and review plan.
3. Apply reviewed migrations only after backup/dry-run success and explicit authorization for data/schema changes.
4. Confirm Owner role server-side.
5. Test private messages/inbox/read receipts with two test accounts.
6. Test group join, group messages, authorized broadcast delivery.
7. Configure push provider/VAPID and test on physical Android with notification permission.
8. Build signed APK using secure signing secrets; never commit keystore/password.
9. For satellite, choose provider and hardware and complete provider/legal integration.
10. For online games, implement realtime game rooms, identity/anti-cheat/rate limits and moderation.

## Games
Offline games are local and need no account or network. Online games remain planned until a server-side game service is implemented and tested.
