# SSLCommerz integration — rollout checklist

## Implemented in this commit
- Server-only checkout-session creation in `facebook-setup-create-payment`.
- Provider IPN callback and server-side Order Validation API verification in `facebook-setup-payment-ipn`.
- Separate provider payment state and immutable-to-browser payment-attempt records.
- A payment is marked `paid` only after SSLCommerz validation confirms transaction ID, amount, currency, validation ID, and valid status.
- Browser return URLs do not mark an order paid.
- Existing customer-entered Transaction IDs remain unverified and are never promoted to paid by this integration.

## Required Supabase Edge Function secrets
Set these in Supabase Dashboard → Edge Functions → Secrets (never in website JavaScript or chat):
- `SSLCOMMERZ_STORE_ID`
- `SSLCOMMERZ_STORE_PASSWORD`
- `SSLCOMMERZ_MODE=sandbox` initially; change to `live` only after merchant approval and sandbox testing.
- `APP_BASE_URL=https://rakib12301111-droid.github.io/master-world-vip`
Existing project secrets also required:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

## Deployment order
1. Apply migration `20261121140000_verified_payment_state.sql` in Supabase SQL Editor.
2. Add the secrets above.
3. Deploy both Edge Functions.
4. Test using SSLCommerz sandbox and confirm failed/cancelled/invalid/mismatched payments never set `payment_status=paid`.
5. Only after merchant live approval, set `SSLCOMMERZ_MODE=live` and use live credentials.

## Important limitations
- This commit does not create a merchant account or supply credentials.
- The existing website payment form is not yet switched to the hosted checkout button. Until that UI is connected, customers must not be told that automated checkout is available.
- Supabase migration and Edge Function deployment are not performed by a GitHub source commit alone.
- Never collect Facebook passwords, OTPs, login codes, or identity-document images.
- SSLCommerz channel availability depends on the merchant account and provider approval. Do not promise a specific mobile wallet until it appears in the merchant's enabled channels.
