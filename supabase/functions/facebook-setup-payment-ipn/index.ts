import { createClient } from "npm:@supabase/supabase-js@2";

const reply = (body: string, status = 200) =>
  new Response(body, { status, headers: { "Content-Type": "text/plain" } });

Deno.serve(async (req) => {
  if (req.method !== "POST") return reply("Method not allowed", 405);
  const url = Deno.env.get("SUPABASE_URL");
  const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const storeId = Deno.env.get("SSLCOMMERZ_STORE_ID");
  const storePassword = Deno.env.get("SSLCOMMERZ_STORE_PASSWORD");
  const mode = Deno.env.get("SSLCOMMERZ_MODE") ?? "sandbox";
  if (!url || !service || !storeId || !storePassword || !["sandbox", "live"].includes(mode)) {
    return reply("Gateway verification is not configured", 503);
  }

  let fields: Record<string, string> = {};
  try {
    const type = req.headers.get("content-type") ?? "";
    if (type.includes("application/json")) fields = await req.json();
    else {
      const form = new URLSearchParams(await req.text());
      form.forEach((v, k) => fields[k] = v);
    }
  } catch { return reply("Invalid notification", 400); }

  const valId = String(fields.val_id ?? "");
  const tranId = String(fields.tran_id ?? "");
  if (!valId || !tranId) return reply("Missing validation identifiers", 400);

  const admin = createClient(url, service, { auth: { persistSession: false } });
  const { data: attempt, error } = await admin.from("facebook_setup_payment_attempts")
    .select("id,order_id,tran_id,amount,currency,status")
    .eq("tran_id", tranId).maybeSingle();
  if (error || !attempt) return reply("Unknown transaction", 404);
  if (attempt.status === "paid") return reply("Already verified");

  const base = mode === "live" ? "https://securepay.sslcommerz.com" : "https://sandbox.sslcommerz.com";
  const validationUrl = new URL(`${base}/validator/api/validationserverAPI.php`);
  validationUrl.search = new URLSearchParams({
    val_id: valId, store_id: storeId, store_passwd: storePassword, format: "json",
  }).toString();

  try {
    const validationResponse = await fetch(validationUrl);
    if (!validationResponse.ok) return reply("Provider validation unavailable", 502);
    const validation = await validationResponse.json();
    const validStatus = ["VALID", "VALIDATED"].includes(String(validation.status ?? "").toUpperCase());
    const valid = validStatus &&
      String(validation.tran_id) === attempt.tran_id &&
      String(validation.currency).toUpperCase() === attempt.currency &&
      Number(validation.amount) === Number(attempt.amount) &&
      String(validation.val_id) === valId;
    if (!valid) {
      console.warn("payment_validation_mismatch", tranId, validation.status);
      return reply("Payment not verified", 400);
    }

    const now = new Date().toISOString();
    const { data: changed, error: updateAttemptError } = await admin.from("facebook_setup_payment_attempts")
      .update({ status: "paid", val_id: valId, verified_at: now, updated_at: now })
      .eq("id", attempt.id).eq("status", "pending").select("id").maybeSingle();
    if (updateAttemptError) return reply("Could not record verification", 500);
    if (changed) {
      const { error: orderError } = await admin.from("facebook_setup_orders")
        .update({ payment_status: "paid", paid_at: now, status: "approved" })
        .eq("id", attempt.order_id).eq("payment_status", "pending");
      if (orderError) {
        console.error("verified_payment_order_update_failed", tranId, orderError.message);
        return reply("Verified but order update requires reconciliation", 500);
      }
    }
    return reply("Verified");
  } catch (error) {
    console.error("provider_validation_error", String(error));
    return reply("Provider validation failed", 502);
  }
});
