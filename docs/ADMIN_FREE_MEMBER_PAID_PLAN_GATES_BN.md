# MASTER WORLD VIP — Admin Free ও Member Paid-only Plan

## নির্ধারিত নিয়ম
- Owner/Super Admin/Admin role পাবে Admin Free entitlement।
- সাধারণ Member Free Plan দিয়ে কাজ করতে পারবে না; একই Project-এর active, মেয়াদ-সঠিক, provider-verified Paid Plan লাগবে।
- Member Paid Plan সক্রিয় হবে কেবল সঠিক catalog price/currency-এর server-verified settlement, unique provider transaction/event এবং start time থাকলে।
- Admin account-কে Member Paid subscription দিয়ে entitlement দেওয়া যাবে না।
- Admin audience কেবল Free; Member audience কেবল Paid। Admin Free Plan-এর মূল্য শূন্য এবং billing period নেই।
- কোনো plan price, feature, মেয়াদ বা checkout provider এই পরিবর্তনে seed/configure করা হয়নি।

## Code change
Migration: supabase/migrations/20261127150000_admin_free_member_paid_plan_gates.sql
- Plan audience guard trigger.
- Active subscription validation hardening.
- my_project_plan_access(project_id) entitlement resolver.
- Result: admin_free, member_paid, অথবা no_access.

## সীমা
এই resolver একটি entitlement helper; প্রতিটি worker/task/order execution entry point-এ server-side enforcement যুক্ত ও পরীক্ষা না করা পর্যন্ত পুরো platform-এর কাজ বন্ধ/চালু হয়েছে বলা যাবে না। Checkout, bKash/Nagad/Bank/SSLCommerz integration, webhook signature verification, merchant approval, refund, payout, Staging apply, Production migration ও live deployment অন্তর্ভুক্ত নয়। Provider approval ও Staging acceptance ছাড়া সদস্যদের কাছ থেকে টাকা নেওয়া যাবে না।

## Acceptance checklist
- [ ] Disposable PostgreSQL migration/runtime test.
- [ ] Admin Free, Member without plan, valid Paid Plan, expired plan, amount/currency mismatch ও duplicate provider event tests.
- [ ] All project work/order entry points enforce my_project_plan_access server-side.
- [ ] Staging Auth/RLS/Admin/Member acceptance.
- [ ] Payment provider approval and signed webhook verification.
- [ ] Explicit Production migration and deployment approval.
