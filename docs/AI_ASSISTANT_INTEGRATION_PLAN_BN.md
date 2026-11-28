# MASTER WORLD VIP — AI Assistant / OpenAI Integration Plan

**তারিখ:** ২৮ নভেম্বর ২০২৬  
**Repository:** `rakib12301111-droid/master-world-vip`

## প্রকল্প-মালিকের লক্ষ্য

MASTER WORLD VIP ওয়েব অ্যাপ ও Admin/Member অভিজ্ঞতার সঙ্গে OpenAI-ভিত্তিক AI সহকারী যুক্ত করা। এটি ChatGPT-এর বর্তমান ব্যক্তিগত কথোপকথনকে সরাসরি embed করবে না; OpenAI API দিয়ে MASTER WORLD VIP-এর নিজস্ব authenticated assistant তৈরি হবে।

## বর্তমান repository-তে যা পাওয়া গেছে

- Edge Function source আছে: `supabase/functions/ai-assistant/index.ts`।
- `supabase/config.toml`-এ `[functions.ai-assistant]` এবং `verify_jwt = true` আছে।
- Function authenticated Supabase user যাচাই করে এবং `AI_PROVIDER_API_KEY`, optional `AI_PROVIDER_URL`, `AI_MODEL` secrets থেকে provider configuration নেয়।
- Default upstream বর্তমানে `https://api.openai.com/v1/chat/completions`; default model `gpt-4o-mini`।
- Source code-এ provider secret hardcode করা নেই।
- এই source file থাকা মানেই Edge Function Staging/Production-এ deploy হয়েছে, API key configured, frontend UI wired, বা live request সফল—এমন প্রমাণ নয়।
- Default CORS origin `*`; production launch-এর আগে allowlist করা প্রয়োজন।
- Function-এ per-user rate limit, usage/cost cap, abuse protection, durable audit/usage ledger এবং privacy controls সম্পূর্ণ প্রমাণিত নয়।

## নিরাপদ বাস্তবায়নের ধাপ

1. **Staging-only baseline:** Function source, frontend call sites, auth/session behavior, Supabase Edge Function deployment state এবং tests audit।
2. **API design:** OpenAI Responses API-তে server-side proxy; user input, conversation context, timeout, retry, safe error, request ID handling এবং output-size limit।
3. **Secret isolation:** dedicated OpenAI project/service-account key; Supabase Staging Edge Function secret-এ রাখা; browser, Android app, GitHub source, logs বা database-এ raw key নয়।
4. **Access control:** Supabase JWT verification; Owner/Admin/Member role policy; per-user/IP rate limit; abuse throttling; CORS allowlist।
5. **Usage control:** Admin-configurable daily/monthly budget, per-user quota, model selection, token/usage tracking এবং hard stop; API usage paid service এবং খরচ হতে পারে।
6. **Privacy:** sensitive profile, password, payment data, auth token বা unnecessary member records prompt-এ পাঠানো নয়; retention/logging policy স্পষ্ট করা।
7. **Staging acceptance:** no-key response, invalid-session rejection, valid session response, role authorization, rate-limit, budget cap, timeout/provider failure এবং no-secret-leak tests।
8. **Production:** Staging acceptance ও আলাদা অনুমোদন ছাড়া deploy নয়।

## প্রস্তাবিত UX

- Member Hub: “VIP AI Assistant” — বাংলা/English প্রশ্নোত্তর, সাইট ব্যবহারে সহায়তা, কাজের নির্দেশনা ও FAQ।
- Admin Center: AI সহায়তায় রিপোর্টের সারাংশ, কাজের বিবরণ/অনুবাদ/ডকুমেন্ট draft; Admin approval ছাড়া কোনো wallet, payout, payment, account role বা production setting পরিবর্তন নয়।
- Member AI response কখনো guaranteed earning, fake customer order, বা unverified payment/settlement দাবি করবে না।

## গুরুত্বপূর্ণ প্রযুক্তিগত সিদ্ধান্ত

OpenAI-এর বর্তমান API documentation direct model requests-এর জন্য Responses API-কে recommended starting point হিসেবে দেখায়। Existing Chat Completions proxy-কে migration করার আগে behavior ও compatibility tests দরকার। OpenAI API key অবশ্যই server-side secret manager-এ থাকবে; browser/mobile client-এ নয়।

References:
- OpenAI API overview: https://developers.openai.com/api/reference/overview/
- API key safety: https://developers.openai.com/api/docs/guides/api-keys
- Developer quickstart: https://developers.openai.com/api/docs/quickstart

## বর্তমান অবস্থা

- Existing Edge Function source: **FOUND**.
- Frontend UI integration: **NOT YET VERIFIED**.
- Staging deployment and API secret: **NOT VERIFIED / NOT CONFIGURED BY THIS CHANGE**.
- Responses API migration: **PLANNED; NOT IMPLEMENTED**.
- Production deployment: **NOT DONE**.
- User request to integrate an AI assistant: **RECORDED**.
