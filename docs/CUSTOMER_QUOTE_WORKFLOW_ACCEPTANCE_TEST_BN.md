# MASTER WORLD VIP — Customer Quote Workflow Acceptance Test

**Status:** Repository implementation / NOT DEPLOYED / NOT PRODUCTION-VERIFIED  
**Migration:** `20261127140000_customer_quote_workflow.sql`

## Safety boundary
- Apply and test this migration only in a separate Staging Supabase project first.
- Do not run it against Production merely because the code is committed.
- No checkout, customer charge, escrow, bank custody, member assignment, payout or paid order is created by this quote workflow.
- A customer accepting a quote records consent to the proposed terms only. Conversion to `customer_service_orders` must be a separate reviewed integration that reuses the existing order table and its verified-settlement / three locked-allocation gates.
- Never use real customer PII or real funds in disposable tests. Never put Supabase secrets in chat, source files or browser code.

## Preconditions
1. Use a separate Staging Supabase project with Auth, base schema, RBAC and helpdesk dependencies configured.
2. Apply migrations in order through `20261127140000_customer_quote_workflow.sql` in Staging only.
   Use the manual-only `.github/workflows/apply-staging-supabase-migrations.yml` workflow. Its default is preview-only; apply requires a Staging backup, successful restore test and exact authorization phrase.
   Configure only these GitHub Actions secrets: `SUPABASE_STAGING_ACCESS_TOKEN`, `SUPABASE_STAGING_PROJECT_REF`, `SUPABASE_STAGING_DB_URL`. Never paste secret values into chat.
3. Verify the Owner/Admin role with `get_my_admin_access()`; ordinary members must remain `member`.
4. Deploy the matching GitHub Pages branch only to a controlled preview or use a local/static preview; confirm the site uses the Staging project's public URL/key, not Production.
5. Create Customer A, Customer B and an authorized Admin test account. Confirm email verification as configured.

## Customer submission and privacy
1. Sign in as Customer A and submit one request for each allowed service key.
2. Confirm the request appears in Customer A's **My Quote Requests** list and the Admin notification is created.
3. Sign in as Customer B. Confirm Customer A's request and event history are not visible.
4. Attempt direct INSERT/UPDATE/DELETE against quote request tables as an authenticated customer; all must be denied.
5. Submit invalid service key, too-short/too-long scope, invalid country and excessive requests; the database must reject them.
6. Confirm no uploaded files, passwords, OTPs, PINs, recovery codes or identity documents are collected.

## Admin review and quote
1. Sign in as an ordinary member and open `admin-quotes.html`; confirm access is denied and no request data is returned.
2. Sign in as Owner, Super Admin or Admin; confirm the Admin Quote Inbox is visible and lists all requests under RLS.
3. Move a request to `under_review`; confirm the event, audit log and customer notification.
4. Send a valid BDT quote and a separate USD quote using a positive finite amount, explicit deliverable/scope, delivery days and expiry between 1 hour and 30 days.
5. Try zero, negative, NaN/Infinity, unsupported currency, empty scope, invalid delivery days and invalid expiry; all must be rejected.
6. Confirm the customer sees the quote but other customers cannot.

## Customer response and lifecycle
1. As Customer A, accept a quote; confirm status `accepted`, event history and Admin notification.
2. Confirm acceptance does **not** insert a row into `customer_service_orders`, charge a payment method, create a ledger entry or assign work.
3. Repeat with another quote and decline it; confirm status `declined`.
4. Cancel a request in `submitted`, `under_review` or `quote_sent`; confirm cancellation is recorded. Closed requests cannot be cancelled again.
5. Create an expired quote and run the Admin expiry action; confirm status `expired`, one event and one customer notification. The customer cannot accept an expired quote.
6. Confirm all event rows are append-only, including when a privileged database role attempts to update/delete them.

## Release gates
- Static verifier: `python3 scripts/verify-customer-quote-workflow.py` passes.
- Disposable migration workflow applies the complete migration chain to fresh and legacy-shape disposable PostgreSQL databases.
- Runtime SQL test passes for customer isolation, Admin review, quote sending, customer acceptance and append-only events.
- Staging manual test passes with Customer A, Customer B and Admin.
- Android Chrome responsive layout, keyboard navigation, screen-reader labels, no horizontal overflow and safe error handling pass.
- Only then consider a narrow release PR. Production migration, production deployment and live customer intake remain separate explicit release decisions.
