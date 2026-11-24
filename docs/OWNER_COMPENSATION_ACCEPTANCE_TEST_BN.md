# Owner Compensation Ledger — Acceptance Test (Bangla)

## এই পরীক্ষার উদ্দেশ্য

নিশ্চিত করা যে:
- কেবল verified owner role মাসিক সম্মানীর হিসাব দেখতে ও পরিবর্তন করতে পারে।
- মাসিক ন্যূনতম সম্মানী ৳১,০০০।
- কমিশন ৳১,০০০-এর বেশি হলে বেশি পাওনা হয়; কম হলে ঘাটতি যোগ হয়।
- সাধারণ সদস্য কোনো Owner compensation তথ্য বা RPC ব্যবহার করতে পারে না।
- প্রকৃত transfer reference ছাড়া payment record করা যায় না।
- সদস্যদের কোনো ফি বা deposit লাগে না।

## Production apply-এর আগে

1. বর্তমান backup এবং আলাদা restore test সম্পন্ন করুন।
2. Migration dry-run review করুন।
3. Owner account bootstrap এবং role নিশ্চিত করুন।
4. Guarded migration workflow-এর সব বাধ্যতামূলক confirmation সত্যি সম্পন্ন না হলে production apply করবেন না।

## Migration apply-এর পরে

Supabase SQL Editor বা অনুমোদিত secure database connection থেকে চালান:

```bash
psql "$SUPABASE_DB_URL" \
  -v owner_id="VERIFIED_OWNER_AUTH_UUID" \
  -v member_id="ORDINARY_MEMBER_AUTH_UUID" \
  -f supabase/audits/owner-compensation-access-test.sql
```

এখানে শুধু দুই test account-এর UUID স্থানীয়ভাবে দিন। Password, database URL, access token, OTP বা payment PIN কোনো chat, source file বা issue-তে দেবেন না।

## Owner UI test

1. Verified Owner account দিয়ে MASTER WORLD VIP-এ লগইন করুন।
2. Admin & Security খুলুন; Owner compensation panel দেখা উচিত।
3. Current month-এর হিসাব refresh করুন; ৳১,০০০ minimum এবং outstanding দেখা উচিত।
4. Settled commission শূন্য রাখলে top-up ৳১,০০০ হবে।
5. Test-only commission ৳১,২৫০ লিখলে source ও non-secret reference দিয়ে save করুন; due ৳১,২৫০ হওয়া উচিত।
6. Commission আবার ৳৪০০ করলে due ৳১,০০০ এবং top-up ৳৬০০ হওয়া উচিত।
7. বাস্তব টাকা পাঠানো হয়নি এমন অবস্থায় payment record করবেন না। Test database হলে আলাদা test reference ব্যবহার করুন এবং transaction rollback/cleanup নিশ্চিত করুন।
8. Past months backfill, duplicate month prevention, partial payment, overpayment rejection এবং audit log যাচাই করুন।
9. GitHub Actions-এর Monthly Owner Compensation Accrual workflow-এ প্রথমে manual run করুন; migration এবং SUPABASE_DB_URL secret ঠিক থাকলে সফল হওয়া উচিত। এরপর পরবর্তী মাসের ১ তারিখে scheduled run যাচাই করুন।

## Ordinary member test

1. আলাদা সাধারণ সদস্য account দিয়ে লগইন করুন।
2. Admin & Security page-এ Owner compensation panel দেখা যাবে না।
3. get_my_owner_compensation, commission update ও payment record RPC প্রত্যাখ্যাত হতে হবে।
4. Member সরাসরি compensation table পড়তে বা লিখতে পারবে না।

## সীমাবদ্ধতা

- Monthly accrual panel খোলার সময় server-side RPC দিয়ে তৈরি/backfill হয়; এটি background scheduler নয়।
- Settled commission source/amount Owner-কে হাতে যাচাই করে দিতে হবে; automatic revenue-share calculation এখনো নেই।
- Payment API নেই। টাকা বাইরে সত্যিই পাঠানোর পরই ledger-এ reference নথিভুক্ত হবে।
- এই test pass না হওয়া পর্যন্ত feature-কে production-live বলা যাবে না।
