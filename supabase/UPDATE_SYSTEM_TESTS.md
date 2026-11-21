# MASTER WORLD VIP — Update System verification

## What this validates
- Semantic version parsing/comparison used by the `check-updates` Edge Function.
- The Edge Function reads the app's `current_version` from the POST body (or GET query) instead of relying only on a hard-coded app version.
- The function uses the deployed Supabase `SUPABASE_URL` environment variable and reads only published release rows.
- PWA update activation remains user-initiated through the waiting Service Worker and the app's **Allow — Update Now** action.

## Migration order
Run each migration once in the target Supabase project, in this order:

1. `202611180001_master_world_vip.sql` — base tables, profiles, notifications and shared helpers.
2. `202611190001_global_community.sql` — member discovery, friend requests, direct and group chat.
3. `202611190002_privacy_rights.sql` — consent history and data request queue.
4. `20261119180000_admin_rbac_owner_control.sql` — Admin RBAC. Before running, confirm the Owner email in the final bootstrap statement is the verified Supabase Auth account.
5. `20261119190000_member_broadcast.sql` — authorized admin broadcast and per-member inbox deliveries.
6. `20261119200000_update_releases.sql` — published release metadata.

Do not run the Admin/Broadcast migrations before the base migration. Do not run the broadcast migration before Admin RBAC, because it checks `app_user_roles`.

## Read-only database smoke checks
After migrations, run:

```sql
select
  to_regclass('public.profiles') as profiles,
  to_regclass('public.friend_requests') as friend_requests,
  to_regclass('public.messages') as messages,
  to_regclass('public.group_messages') as group_messages,
  to_regclass('public.app_user_roles') as app_user_roles,
  to_regclass('public.member_broadcasts') as member_broadcasts,
  to_regclass('public.member_broadcast_deliveries') as broadcast_deliveries,
  to_regclass('public.update_releases') as update_releases;
```

Every returned value should be non-null. Check that only published releases are visible to client roles:

```sql
select version, status, published_at
from public.update_releases
order by published_at desc nulls last, created_at desc
limit 10;
```

Publish a release only after the matching PWA files have been deployed. Example (run only when intentionally publishing):

```sql
insert into public.update_releases(version, release_notes, status, published_at)
values ('3.3.0', 'MASTER WORLD VIP 3.3.0 release', 'published', now())
on conflict (version) do update
set release_notes = excluded.release_notes,
    status = 'published',
    published_at = now();
```

## Edge Function deployment
From the repository root, with Supabase CLI authenticated and linked to the intended project:

```sh
supabase functions deploy check-updates --project-ref lztbbrzeuyjkuiyzrsxp
```

The Supabase Edge runtime provides `SUPABASE_URL`. The function needs no AI-provider secret. It uses the public Supabase publishable/anon key sent by the app to read published release metadata. Never put a service-role key in the app.

## API-key validation tests

The update checker accepts `sb_publishable_...` keys and legacy JWTs only when the decoded JWT payload has `role: "anon"`. It rejects `sb_secret_...`, `service_role`, `authenticated`, malformed JWTs and arbitrary token-shaped strings. Run the automated tests with:

```sh
deno test supabase/functions/check-updates
```

## Edge Function smoke test
Use the app's public publishable key (it is not a service-role secret):

```sh
curl -X POST 'https://lztbbrzeuyjkuiyzrsxp.supabase.co/functions/v1/check-updates' \
  -H 'apikey: YOUR_SUPABASE_PUBLISHABLE_KEY' \
  -H 'Content-Type: application/json' \
  --data '{"current_version":"3.3.0"}'
```

Expected JSON includes `success: true`, `current_version: "3.3.0"`, `latest_version` (or null if no published row), and `update_available` (boolean). Also test an invalid version; it should return HTTP 400.

## PWA/device acceptance test
1. Deploy the website to GitHub Pages and confirm the deployed `www/sw.js` is the current repository version.
2. Open the app over HTTPS in Chrome on Android; install/open the PWA.
3. Publish a newer test build to Pages (bump the Service Worker cache name in `www/sw.js` whenever making a release), wait for the browser to detect an update, then tap **আপডেট পরীক্ষা করুন**.
4. Confirm the app shows a waiting worker and enables **Allow — Update Now**.
5. Tap **Allow — Update Now**. The page should reload under the new worker; verify the updated UI/version.
6. Confirm no update is falsely reported when the latest published version equals the app version.

## Status honesty
Repository tests do not prove a live Supabase migration, Edge Function deployment, Pages deployment, or physical Android device test. Keep those items marked **testing** until the target project and device checks above have been completed.
