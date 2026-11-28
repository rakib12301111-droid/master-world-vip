# MASTER WORLD VIP — Staging Auth Preflight Audit (Run #16)

**তারিখ:** ২৮ নভেম্বর ২০২৬  
**Repository:** `rakib12301111-droid/master-world-vip`  
**Audit base commit:** `4f8e2911aae0da45bbad79242d1eb20625aa229a`  
**Workflow run:** [#16 — 46132939047](https://github.com/rakib12301111-droid/master-world-vip/actions/runs/46132939047)

## সিদ্ধান্ত

এই Run-এ Staging migration workflow migration ধাপে পৌঁছায়নি। ব্যর্থতার সুনির্দিষ্ট ধাপ হলো:

`Preflight existing confirmed Owner, Admin and Member Auth accounts before any migration`

লগে তিনটি পৃথক ফল:

- Staging OWNER: Auth login rejected — credentials rejected অথবা account Staging project-এ নেই।
- Staging ADMIN: Auth login rejected — credentials rejected অথবা account Staging project-এ নেই।
- Staging MEMBER: Auth login rejected — credentials rejected অথবা account Staging project-এ নেই।

Workflow safe error category অনুযায়ী এই ফল জানিয়েছে; কোনো password, token বা response body প্রকাশ করেনি।

## প্রমাণিত ধাপ

- Staging-only DB URL / Session Pooler secret precheck: PASS
- Ordered migration set / duplicate version validation: PASS
- Encrypted Staging logical backup: PASS
- Backup decrypt + disposable PostgreSQL restore: PASS
- Auth preflight: FAIL (তিনটি account)
- Migration preview: SKIPPED
- Staging migration apply: SKIPPED
- Owner RPC দিয়ে Admin/Member role assignment: SKIPPED
- Role/RPC acceptance: SKIPPED

## Root cause boundary

বর্তমান evidence অনুযায়ী failure SQL migration, backup, restore, বা migration ordering-এ নয়। Password-grant Auth endpoint তিনটি Staging login-ই প্রত্যাখ্যান করেছে। GitHub Actions secret-এর encrypted values connector দিয়ে দেখা যায় না; তাই কোন email/password secret ভুল বা কোন account অনুপস্থিত তা অনুমান করে নির্দিষ্ট account-কে দায়ী করা যাবে না।

মূল Production Supabase project ref `lztbbrzeuyjkuiyzrsxp` এবং Staging project ref `awatzrapqrteybgspqlq` আলাদা। Production Auth Users-এ account থাকা Staging Auth-এ account থাকার প্রমাণ নয়।

## নিরাপদ সমাধানের শর্ত

1. Supabase Dashboard-এ Staging project ref `awatzrapqrteybgspqlq` নির্বাচন করে Auth → Users-এ Owner, Admin ও Member—তিনটি পৃথক account আছে কি না যাচাই।
2. GitHub Actions-এর `STAGING_OWNER_EMAIL`, `STAGING_ADMIN_EMAIL`, `STAGING_MEMBER_EMAIL` যেন Staging Auth-এর সঠিক email-এর সঙ্গে মেলে তা নিশ্চিত করা।
3. সংশ্লিষ্ট `STAGING_OWNER_PASSWORD`, `STAGING_ADMIN_PASSWORD`, `STAGING_MEMBER_PASSWORD` যেন ওই Staging account-গুলোর বর্তমান password হয় তা Dashboard থেকে যাচাই/প্রয়োজনে reset করে GitHub Secret-এ আপডেট করা। Secret value কখনো log বা chat-এ প্রকাশ নয়।
4. তারপর একই Staging workflow পুনরায় চালিয়ে Auth preflight PASS না হওয়া পর্যন্ত migration ধাপ চালানো যাবে না।

## নিরাপত্তা অবস্থা

- Production migration/apply: **বন্ধ; কোনো Production পরিবর্তন করা হয়নি।**
- এই Run-এ Staging migration apply-ও হয়নি।
- Auth preflight bypass বা disabled করা হয়নি।
- Scheduler/worker execution enable করার অনুমোদন নয়।
- এই audit note কোনো migration বা live deployment অনুমোদন করে না।

## পরবর্তী যাচাই

Staging Auth login তিনটি PASS হওয়ার পরই Staging migration preview, Staging-only migration, role/RPC এবং worker deployment skip/guard পুনরায় যাচাই করতে হবে। বাস্তব Run/log ছাড়া PASS ঘোষণা করা যাবে না।
