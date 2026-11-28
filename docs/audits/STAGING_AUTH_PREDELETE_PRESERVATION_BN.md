# Staging Auth অ্যাকাউন্ট পুনর্গঠনের আগে সংরক্ষণ পরিকল্পনা

**তারিখ:** ২৮ নভেম্বর ২০২৬  
**Target project:** Staging Supabase — awatzrapqrteybgspqlq  
**Production project:** lztbbrzeuyjkuiyzrsxp — এই কাজের বাইরে

## সিদ্ধান্ত
প্রকল্প-মালিকের নির্দেশ অনুযায়ী Staging-এর Owner, Admin ও Member Auth account পুনর্গঠন বিবেচনা করা হবে। কোনো অ্যাকাউন্ট Delete করার আগে বিদ্যমান তথ্য সংরক্ষণ ও যাচাই করতে হবে। শুধু এই নথি তৈরি হওয়া মানে বাস্তব Auth export বা database backup তৈরি হয়েছে—এমন নয়।

## Delete-এর আগে বাধ্যতামূলক সংরক্ষণ
1. Staging Auth Users তালিকা থেকে তিনটি account-এর সঠিক email, UUID/User ID, created_at, updated_at, email-confirmed অবস্থা এবং provider/metadata-র প্রয়োজনীয় non-secret তথ্য নথিভুক্ত করা।
2. Auth account-এর সঙ্গে যুক্ত profile row, role/permission mapping, owner/admin assignment এবং সংশ্লিষ্ট foreign-key/reference পরীক্ষা করা।
3. Wallet, ledger, referral, task/job, audit log বা অন্য business record থাকলে সংশ্লিষ্ট row-গুলোর count ও reference সংরক্ষণ করা; আর্থিক/অডিট রেকর্ড কখনো কেবল Auth user পুনর্গঠনের জন্য মুছে ফেলা যাবে না।
4. Staging database-এর encrypted backup তৈরি এবং আলাদা disposable database-এ restore test সফল হওয়া নিশ্চিত করা। Backup artifact ID, run URL, creation time, retention এবং restore result লিখে রাখা।
5. Auth Users-এর প্রয়োজনীয় metadata-র নিরাপদ export/snapshot তৈরি করা—password, access token, refresh token, OTP, secret বা password hash এই নথি/সাধারণ artifact-এ রাখা যাবে না।
6. প্রতিটি account-এর আগের Login/preflight ফলাফল ও Workflow run/job link সংরক্ষণ করা।

## নিরাপদ পুনর্গঠন পদ্ধতি
- প্রথম পছন্দ: account Delete না করে Staging-এ password reset/update করে login preflight পুনরায় পরীক্ষা।
- Password reset-এ কাজ না হলে কারণ এবং linked data/reference যাচাই করে তবেই নির্দিষ্ট Staging account delete/recreate বিবেচনা।
- একই email ব্যবহার করলে নতুন UUID তৈরি হবে কি না এবং পুরোনো UUID-নির্ভর record/role mapping কীভাবে সামলানো হবে, আগে নির্ধারণ করতে হবে।
- Recreate-এর পর তিনটি আলাদা Auth User ID, সঠিক role assignment, profile/RLS/RPC এবং password-grant login যাচাই করতে হবে।
- GitHub Actions-এর Staging secret values কখনো রিপোর্টে লিখবে না; শুধু secret name ও verification outcome নথিভুক্ত করা যাবে।

## নিষেধাজ্ঞা
- Production project বা Production Auth user-এ কোনো Delete/Update/Create নয়।
- Production migration বন্ধ থাকবে।
- Auth preflight bypass নয়; ভুল/অজানা credentials অনুমান করে বসানো নয়।
- Backup/restore evidence ও linked-data review ছাড়া Staging account Delete নয়।
- এই নথি কোনো Delete-এর অনুমোদন নয়; প্রকল্প-মালিকের আগের সম্মতি কেবল নিরাপদ Staging পুনর্গঠন পরিকল্পনার জন্য। প্রতিটি destructive delete-এর আগে নির্দিষ্ট account ও তার data impact পুনরায় নিশ্চিত করতে হবে।

## বর্তমান প্রমাণ/অসম্পন্ন কাজ
- Staging Auth account-এর পূর্ণ তালিকা, UUID এবং linked business records এখনো এই সেশনে সরাসরি পড়া/সংরক্ষণ করা হয়নি।
- বাস্তব pre-delete Auth export বা নতুন backup artifact এই commit-এ তৈরি হয়নি।
- Run #16 (46132939047) encrypted backup/isolated restore PASS; Auth login preflight OWNER, ADMIN, MEMBER—তিনটির জন্যই rejected; কারণ wrong password বনাম missing account নির্দিষ্ট করা যায়নি।
- পরবর্তী পদক্ষেপ: Staging Auth Users-এর account তালিকা ও সংশ্লিষ্ট linked data যাচাই; বিদ্যমান account reset করে পরীক্ষা; Delete কেবল শেষ বিকল্প।
