# MASTER WORLD VIP — Project Continuity & Handover (Bangla)

সর্বশেষ আপডেট: 2026-11-25 (Asia/Dhaka)
Repository: https://github.com/rakib12301111-droid/master-world-vip
Live site: https://rakib12301111-droid.github.io/master-world-vip/
বর্তমান main HEAD: `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`

## এই নথির উদ্দেশ্য — একই কাজ অকারণে দ্বিতীয়বার নয়
এই নথিই MASTER WORLD VIP-এর কাজ কোথায় শেষ, কোথা থেকে শুরু হবে তার একক handover/source of truth। প্রতিটি নতুন সেশনে:
1. প্রথমে এই ফাইল এবং সর্বশেষ main commit পড়তে হবে।
2. শুধু চলমান/ব্যর্থ GitHub Actions run-এর বর্তমান অবস্থা ও সংশ্লিষ্ট failure log দেখবে।
3. ইতিমধ্যে PASS হওয়া একই commit-এর static check পুনরায় চালাবে না, যদি না সংশ্লিষ্ট code/configuration বদলায়, check invalid/expired হয়, বা অন্য check-এর জন্য প্রয়োজন হয়।
4. ব্যর্থ check-এর কারণ ঠিক করে নতুন commit-এ কেবল প্রাসঙ্গিক workflow পুনরায় চালাবে; আগের PASS-গুলোর evidence ধরে রাখবে।
5. প্রতিটি অর্থপূর্ণ কাজের পরে এই ফাইল update করতে হবে। কোনো কাজ বাস্তবে না হলে PASS/LIVE লেখা যাবে না।

## সর্বশেষ যাচাইকৃত অবস্থা

### Commit ও workflow evidence
- সর্বশেষ main commit: `ade8cf030a92d95214be2b6fc2087bb4cb5418cd`
  https://github.com/rakib12301111-droid/master-world-vip/commit/ade8cf030a92d95214be2b6fc2087bb4cb5418cd

- Migration/static safety run `45603357136`: **FAIL**  
  https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357136
  - Community readiness: PASS
  - Owner-only live service health: PASS (9/9)
  - Work & Earn finance static checks: PASS (22/22)
  - একমাত্র দৃশ্যমান failure: `scripts/verify-global-communication.py` — “PWA cache version is refreshed” assertion। Log-এ অন্য checks PASS।
  - অতএব পুরো workflow PASS নয়; শুধু উল্লিখিত failure ঠিক করতে হবে। 22 finance checks, community readiness এবং 9 health checks একই code-এ পরিবর্তন না হলে অকারণে পুনরায় চালানোর প্রয়োজন নেই।

- GitHub Pages run `45603357353`: **FAIL (post-deploy verification)**  
  https://github.com/rakib12301111-droid/master-world-vip/actions/runs/45603357353
  - Build: SUCCESS
  - Deploy: SUCCESS
  - “Verify live GitHub Pages release”: FAIL
  - Verification script live HTML-এ ধারাবাহিক marker খুঁজেছে; log অনুযায়ী প্রথম ব্যর্থ command ছিল `grep -q "GLOBAL AI-POWERED WORKSPACE"`। অর্থাৎ deployment job সফল হলেও published content check পাস করেনি। এই run-এ PWA cache v37, finance/member wallet markers, audit document ইত্যাদি পরের assertions পর্যন্ত পৌঁছায়নি।
  - পরবর্তী কাজ: live `www/index.html` এবং repository `www/index.html` তুলনা করে কেন প্রত্যাশিত marker অনুপস্থিত তা নির্ণয়; একই সঙ্গে live `www/sw.js` ও repository service worker-এর cache version তুলনা। তারপর প্রয়োজন হলে deployment path/base path বা verification marker সংশোধন করে deploy + live verification পুনরায় চালানো।

### আগের static finance checks — এগুলো ইতিমধ্যে PASS
Run `45603357136`-এর finance-specific check:
- আলাদা append-only Member Work Wallet ও Owner Profit Ledger
- duplicate/idempotency protections
- provider-verified settlement এবং client acceptance gate
- reconciliation, full refund reserve এবং operating budget gates
- Owner-only, audited commission rate; default 20%
- একই transaction-এ member full payable + Owner commission posting
- acceptance timestamp অনুযায়ী commission rate; retroactive change নয়
- distributable net platform fee থেকে Owner profit
- role-scoped reads, service-role-only inputs/posting
- payout live নয় — এই সীমাবদ্ধতা UI/docs-এ সঠিকভাবে বলা
**Evidence:** workflow run `45603357136`, job log; `All 22 Work & Earn finance static checks passed.`

## পরবর্তী কাজ — এখান থেকেই শুরু
**Step 1 — GitHub Pages verification failure ঠিক করা**
- আগে live site-এর HTML/JS/manifest/service-worker এবং repo-র একই ফাইলের পার্থক্য বের করতে হবে।
- প্রথম failed marker `GLOBAL AI-POWERED WORKSPACE`; কেন live HTML-এ নেই সেটি নির্ণয়।
- deploy output directory/base path এবং live release SHA যাচাই।
- সঠিক fix করে commit; তারপর Pages deploy এবং live verification।
- সফল deployment ও live verification না হওয়া পর্যন্ত site update “fully verified” নয়।

**Step 2 — Migration Safety failure ঠিক করা**
- `www/sw.js`-এর প্রকৃত cache version এবং `scripts/verify-global-communication.py`-এর প্রত্যাশিত version মিলিয়ে দেখা।
- cache version পরিবর্তন দরকার হলে app/service worker version যথাযথভাবে bump; শুধু test pass করানোর জন্য ভুল marker বসানো যাবে না।
- প্রাসঙ্গিক static workflow চালিয়ে পুরো migration safety workflow PASS নিশ্চিত করা।
- আগের finance 22/22, community readiness ও 9/9 health PASS-কে evidence হিসেবে রাখা; সংশ্লিষ্ট code না বদলালে পুনরায় অকারণে চালানো নয়।

**Step 3 — দুই workflow PASS হওয়ার পর**
- Production Supabase apply এখনো আলাদা এবং BLOCKED। কোনো migration production-এ প্রয়োগ করা হয়নি।
- আগে secret presence (কোনো secret value দেখা/শেয়ার নয়), বর্তমান recoverable backup, আলাদা restore test, migration preview ও Owner/project verification।
- তারপরই নির্ধারিত guarded workflow ও exact authorization phrase ব্যবহার করা যাবে: `APPLY-MASTER-WORLD-VIP-MIGRATIONS`। এই phrase ছাড়া production apply নয়।
- apply শেষে schema/RLS ও প্রয়োজনীয় two-account acceptance tests।
- Live payment/payout integration এবং actual reserve/reconciliation ব্যবস্থা আলাদা কাজ; শুধু migration বা Pages deployment এগুলো চালু করে না।

## আর্থিক ও নিরাপত্তা সিদ্ধান্ত — পরিবর্তন না করা পর্যন্ত বহাল
- Member Work Wallet এবং Owner Profit Ledger আলাদা।
- Owner commission = distributable **net platform revenue-এর 20%**; gross client payment বা member wages নয়।
- Member-এর earned compensation সম্পূর্ণ সুরক্ষিত; package refund বা Owner commission-এর জন্য কাটা/offset/clawback নয়।
- কেবল client money বাস্তবে provider-এ settled এবং server-side verified হলে ledger credit।
- duplicate settlement আটকাতে idempotency এবং transaction-level atomic posting।
- Owner ledger accrual মানেই Owner-এর ব্যাংক/bKash/Nagad-এ টাকা transfer নয়।
- Member wallet balance মানেই withdrawable cash বা payout completed নয়।
- প্রকৃত refund reserve custody, operating budget, reconciliation এবং legal/provider approvals ছাড়া paid Auto Work package বিক্রি/চালু নয়। Member Auto Work বর্তমানে PAUSED/DISABLED।
- কোনো সদস্যের কাছ থেকে এখন package deposit/payment সংগ্রহ নয়।
- ordinary member referral bonus এখন OFF; পূর্বে নির্ধারিত funding/eligibility policy বহাল।
- কোনো password, OTP, API key, service-role key, DB password, session cookie বা signed URL chat-এ চাইবে/রাখবে না। Secret শুধু provider/GitHub secret store-এ।

## লাইভ পেমেন্ট ও উত্তোলনের জন্য এখনও অনিষ্পন্ন
1. অনুমোদিত payment gateway/merchant account এবং server-to-server signed webhook verification।
2. production Supabase migration apply এবং বাস্তব RLS/transaction tests।
3. প্রকৃত refund reserve custody ও স্বাধীন reconciliation evidence।
4. member/Owner ledger থেকে আলাদা অনুমোদিত payout provider integration (bKash/Nagad/bank), KYC, limits, approval, idempotency, transfer reference ও reconciliation।
5. failure, retry, refund, reversal, fraud, load, backup/restore end-to-end tests।
6. প্রয়োজনীয় ব্যবসায়িক/আইনি/নিয়ন্ত্রক অনুমোদন।
এগুলো সম্পন্ন ও যাচাই না হওয়া পর্যন্ত LIVE PAYMENT / LIVE WITHDRAWAL চালু বা প্রচার করা যাবে না।

## কাজের অগ্রগতি লেখার নিয়ম
প্রতিটি নতুন entry-তে লিখবে: তারিখ, commit SHA, file/migration, কী পরিবর্তন, কোন workflow/run ID-তে কী PASS/FAIL, live/production state, blockers, এবং পরবর্তী একটিমাত্র next action। “Code exists”, “deployed”, “production applied”, “acceptance-tested”, “live” — এগুলো আলাদা status।
