# MASTER WORLD VIP — শুরু থেকে শেষ পর্যন্ত অডিট ও কাজের ক্রম

সর্বশেষ অডিট: ২০২৬-১১-২৫  
প্রকল্প: বিদ্যমান `rakib12301111-droid/master-world-vip`  
ওয়েবসাইট: https://rakib12301111-droid.github.io/master-world-vip/

## অডিটের নিয়ম

- এই বিদ্যমান repository-তেই কাজ চলবে; নতুন project/repository শুরু হবে না।
- Git-এ code/UI/migration থাকা মানেই feature Live নয়।
- প্রতিটি ধাপের prerequisite, deployment, database migration, security test ও বাস্তব acceptance test পাস না হওয়া পর্যন্ত পরের dependent ধাপকে সম্পন্ন বলা হবে না।
- কোনো secret, password, OTP বা private key chat, source code বা browser storage-এ নেওয়া যাবে না।
- Production database migration চালানো হবে না যতক্ষণ না encrypted backup, আলাদা restore test, migration dry-run review এবং ব্যবহারকারীর স্পষ্ট অনুমোদন পাওয়া যায়।

## ১. সর্বশেষ যাচাইকৃত অবস্থা

| ক্ষেত্র | যাচাইকৃত অবস্থা | পরবর্তী বাধা |
|---|---|---|
| GitHub Pages | সর্বশেষ জানা deployment সফল | এই অডিট-আপডেটের নতুন deployment ও live verify পাস করতে হবে |
| PWA | Cache v33 ছিল | এই আপডেটে cache v34 করা হয়েছে; deploy/verify আবশ্যক |
| DB Safety Pipeline | Run `45480251887` ব্যর্থ | `SUPABASE_DB_URL` PostgreSQL URI হিসেবে parse হয়নি |
| Backup | ওই run-এ তৈরি হয়নি | URI ঠিক করে backup workflow সফল করতে হবে |
| Restore test | ওই run-এ চালু হয়নি | encrypted backup disposable/local বা আলাদা test DB-তে restore করতে হবে |
| Migration preview | ওই run-এ চালু হয়নি | backup/restore gate পাসের পরে dry-run review |
| Production DB | কোনো migration apply করা হয়নি | স্পষ্ট অনুমোদন না পাওয়া পর্যন্ত অপরিবর্তিত থাকবে |
| Auth / Member Hub / Community | UI ও backend foundation repository-তে আছে | Auth settings, migration, signup/login এবং দুই-সদস্যের RLS test |
| Work & Earn | UI ও additive SQL migration আছে | migration, দুই-সদস্যের permission/privacy test |
| Referral Wallet | reward ledger/processor/UI foundation আছে | migrations, Edge Function, cron, confirmed funding ও two-member tests |
| Owner compensation | policy, migration ও UI foundation আছে | migration, Owner/member access tests; বাস্তব settled income/transfer ছাড়া টাকা দেখানো যাবে না |
| Location Map | consent-based UI/migration foundation | phone verification, permission, opt-in/out, stale/offline ও RLS tests |
| AI / Facebook discovery | UI বা function foundation | অনুমোদিত provider/API, server-side secrets ও policy approval |
| Global Internet | provider-pending UI/checklist | authorized provider, contract, hardware/gateway, funding ও real-world tests |
| Android / Play Store | WebView/debug build foundation | signed release, device tests, Play listing ও approval |

## ২. DB Safety Pipeline-এর সুনির্দিষ্ট বাধা

সর্বশেষ run `45480251887`-এ required secret presence checks পাস করলেও URI parser এই বার্তা দিয়েছে:

`SUPABASE_DB_URL must be a PostgreSQL URI`

এর অর্থ ওই run-এ secret value PostgreSQL URI হিসেবে শুরু হয়নি বা URI-র আগে/বাইরে অতিরিক্ত লেখা ছিল। এটি এখনো database password authentication failure নয়। PostgreSQL client install, remote DB connection, backup, restore, migration preview—সবই skip হয়েছে। কোনো backup artifact তৈরি হয়নি।

GitHub Actions Secret-এ ব্যক্তিগতভাবে যাচাই করতে হবে:

- Secret name: `SUPABASE_DB_URL`
- URI scheme: `postgresql://`
- Username: `postgres.lztbbrzeuyjkuiyzrsxp`
- Host: `aws-0-ap-south-1.pooler.supabase.com`
- Port: `5432`
- Database path: `/postgres`
- Password: Supabase-এর বর্তমান database password; বিশেষ অক্ষর থাকলে URI percent-encode করতে হবে।
- পুরো URI একটানা value হবে; `SUPABASE_DB_URL=` label, markdown/code fence, quote বা অতিরিক্ত line যোগ করা যাবে না।

URI বা password কাউকে chat-এ পাঠাবেন না। Secret edit করার পর শুধু DB Safety Pipeline পুনরায় চালিয়ে sanitized log, encrypted artifact এবং restore result যাচাই করতে হবে।

## ৩. বাধ্যতামূলক কাজের ক্রম — কোনো ধাপ বাদ নয়

1. **Repository / source audit:** feature register, migrations, Edge Functions, workflows ও frontend পর্যালোচনা; duplicate/conflicting code এবং outdated status সংশোধন।
2. **Static safety checks:** JavaScript/TypeScript/SQL syntax, migration preflight, PWA cache version, live-page verification এবং security regression checks পাস।
3. **GitHub Pages deployment:** build, deploy ও live verify পাস; published HTML ও service worker version মিলিয়ে দেখা।
4. **DB connection preflight:** Session Pooler URI ও প্রয়োজনীয় secret presence/syntax যাচাই; কোনো credential print নয়।
5. **Encrypted backup:** remote Supabase থেকে logical backup, encryption এবং plaintext dump removal।
6. **Restore proof:** encrypted backup decrypt করে isolated disposable/test database-এ restore; non-empty schema/table checks পাস; artifact/reference সংরক্ষণ।
7. **Migration dry-run:** pending migration list, dependency order, target project ও Owner bootstrap review; production database অপরিবর্তিত।
8. **স্পষ্ট অনুমোদন:** backup ও restore প্রমাণ, dry-run review, Owner যাচাই এবং exact confirmation phrase ছাড়া production apply নয়।
9. **Staging / two-member tests:** signup, email OTP, login, profile, friends, private/group chat, broadcast, inbox, helpdesk, referrals, wallet, Owner roles ও RLS আলাদা test accounts দিয়ে পরীক্ষা।
10. **External integration tests:** AI provider, licensed image source, Meta-approved API, push sender, payment merchant/API, location permission, satellite/network provider—প্রতিটি নিজস্ব অনুমোদন ও server-side secrets দিয়ে পরীক্ষা।
11. **Real device acceptance:** Android browser/PWA, offline/online, permission revoke, accessibility, small-screen layout, error recovery ও privacy checks।
12. **Android release:** signed APK/AAB, release signing protection, install/update test; তারপর Play Store listing, data safety/privacy declarations ও approval।
13. **Final acceptance:** প্রতিটি feature-এর জন্য code, tests, deployment, external dependency ও live acceptance আলাদা প্রমাণসহ status update। কোনো prerequisite অসম্পূর্ণ থাকলে dependent feature pending থাকবে।

## ৪. নিরাপত্তা ও নীতিগত সীমা

- Phone number বা SIM একা দিয়ে কারও GPS location বের করা যাবে না; সদস্যের device permission ও explicit sharing consent লাগবে।
- Facebook private data scraping, password/OTP সংগ্রহ বা unauthorized account access নয়।
- Referral/Owner reward কেবল প্রকৃত, নিশ্চিত funding থাকলে payable; unfunded amount cash/withdrawable balance নয়। সদস্যের deposit বা বাধ্যতামূলক purchase নয়।
- bKash/Nagad payout বাস্তবে transfer না হওয়া পর্যন্ত Paid নয়; actual transfer reference আবশ্যক।
- Global Internet ৳০ member-price লক্ষ্য; provider capacity, hardware, gateway, license ও funding ছাড়া live internet নয়।
- AI/image search-এ provider license, attribution ও server-side secret বাধ্যতামূলক।
- GDPR certification বা Play approval দাবি করা যাবে না যতক্ষণ না সংশ্লিষ্ট review সম্পন্ন।

## ৫. এই অডিট আপডেটের পর যাচাইয়ের নিয়ম

এই নথি ও Update Center-এর লিংক প্রকাশিত হলেই backend বা production feature চালু হয়ে যায় না। নতুন GitHub Pages workflow সফল এবং live verify পাস হলে কেবল website update-কে deployed বলা হবে। DB safety pipeline আলাদা; সেটি পাস না হওয়া পর্যন্ত backup/restore/migration ধাপ pending থাকবে।

প্রতিটি পরবর্তী update-এ আগের একই feature inventory ধরে status তুলনা করতে হবে। Code foundation, automated test, deployment এবং live acceptance আলাদা করে দেখাতে হবে; প্রমাণ ছাড়া কোনো সামগ্রিক completion percentage দেওয়া যাবে না।
