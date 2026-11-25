# MASTER WORLD VIP — Owner-এর Zero-Cost Server Policy

Updated: 2026-11-25

## Owner-এর চূড়ান্ত লক্ষ্য
কোনো টাকা খরচ না করে যতটা সম্ভব শক্তিশালী ও নির্ভরযোগ্য অবকাঠামো ব্যবহার করা। তবে unlimited, always-on, lifetime-free server বা storage বাস্তবে কোনো provider নিশ্চিত করে না। Free plan-এর quota, CPU/runtime, request, bandwidth, sleep, retention, region ও terms পরিবর্তিত হতে পারে।

## বাধ্যতামূলক নিয়ম
1. শুরুতে FREE-ONLY / zero-paid-spend।
2. Free quota শেষ, provider sleep/suspend, rate-limit বা error হলে job queue/pause হবে।
3. Paid server/API/storage/backup-এ automatic fallback বা silent upgrade সম্পূর্ণ নিষিদ্ধ।
4. Owner-এর named-provider approval, BDT spend cap ও audit record ছাড়া কোনো paid usage চালু হবে না।
5. Spending cap শূন্য/অনুমোদন অনুপস্থিত থাকলে paid feature disabled থাকবে।
6. Customer data private থাকবে; secrets কেবল server-side secret manager-এ, GitHub বা chat-এ নয়।
7. Heavy/long-running workloads free plan-এ 24/7 চলবে—এমন দাবি করা যাবে না।

## প্রস্তাবিত architecture: free-first
- Static frontend/control panel.
- Lightweight serverless API/control endpoints.
- Queue-backed short jobs; bounded retries, timeout, idempotency, per-module limits.
- পাঁচটি module lane: AI Data Processing; AI Translation & Document Processing; PDF Automation; Image Processing; Website Monitoring & Automated Reporting.
- প্রথমে প্রতি module-এ সর্বোচ্চ একটি active job (সর্বোচ্চ পাঁচটি একসঙ্গে); অতিরিক্ত job queue-তে।
- Free compute/storage quota exhaustion-এ automatic pause, Admin alert ও Owner dashboard status।
- Heavy/long jobs কেবল উপযুক্ত runtime ও approved budget থাকলে; না হলে queued/disabled।

## Provider limit example — not a deployment promise
Cloudflare Workers Free-এর প্রকাশিত সীমার উদাহরণ: 100,000 requests/day এবং প্রতি invocation-এ 10 ms CPU time। এই সীমা ও অন্যান্য শর্ত পরিবর্তনশীল; এটি long-running always-on server নয়। Production-এর আগে [Cloudflare Workers limits](https://developers.cloudflare.com/workers/platform/limits/) পুনরায় যাচাই করতে হবে।

## Storage policy
- Primary candidate: Cloudflare R2 Standard; বর্তমান free allowance [official R2 pricing](https://developers.cloudflare.com/r2/pricing/) অনুযায়ী যাচাই করতে হবে।
- আলাদা provider-এ encrypted backup এবং Owner-এর offline/downloadable copy।
- Backup restore test ও checksum verification বাধ্যতামূলক।
- R2 free quota অতিক্রম করলে upload pause; paid storage-এ auto-upgrade নয়।
- Lifetime-free বা permanent retention guarantee নেই।

## Rollout gates
- [ ] Provider account eligibility ও Bangladesh availability যাচাই।
- [ ] বর্তমান free quotas, billing behavior, sleep/timeout, data location, retention ও export/restore পরীক্ষা।
- [ ] Staging deployment ও quota exhaustion test।
- [ ] Billing protection/spend cap যাচাই; paid fallback disabled প্রমাণ।
- [ ] Owner approval ছাড়া production activation নয়।

## Status
এটি policy/design document মাত্র। কোনো নতুন server, worker, R2 bucket, backup provider বা storage connector deploy/connect করা হয়নি।
