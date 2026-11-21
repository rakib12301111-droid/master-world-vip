import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": Deno.env.get("APP_BASE_URL") ?? "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: cors });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const storeId = Deno.env.get("SSLCOMMERZ_STORE_ID");
  const storePassword = Deno.env.get("SSLCOMMERZ_STORE_PASSWORD");
  const appBase = Deno.env.get("APP_BASE_URL");
  const mode = Deno.env.get("SSLCOMMERZ_MODE") ?? "sandbox";
  if (!url || !anon || !service || !storeId || !storePassword || !appBase ||
      !["sandbox", "live"].includes(mode)) {
    return json({ error: "Payment gateway is not configured. No payment was taken." }, 503);
  }

  const auth = req.headers.get("Authorization") ?? "";
  if (!auth.startsWith("Bearer ")) return json({ error: "Login required" }, 401);
  const userClient = createClient(url, anon, {
    global: { headers: { Authorization: auth } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: { user }, error: userError } = await userClient.auth.getUser();
  if (userError || !user) return json({ error: "Invalid session" }, 401);

  let body: { package_price?: number; customer_name?: string; customer_phone?: string };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400); }
  const amount = Number(body.package_price);
  const allowed = [500, 750, 1000];
  const name = String(body.customer_name ?? "").trim().slice(0, 80);
  const phone = String(body.customer_phone ?? "").trim().slice(0, 24);
  if (!allowed.includes(amount) || name.length < 2 || !/^[0-9+() -]{8,24}$/.test(phone)) {
    return json({ error: "Invalid package or customer details" }, 400);
  }

  const admin = createClient(url, service, { auth: { persistSession: false } });
  const tranId = `MWVIP${Date.now()}${crypto.randomUUID().replaceAll("-", "").slice(0, 8)}`;
  const { data: order, error: orderError } = await admin.from("facebook_setup_orders")
    .insert({
      user_id: user.id, package_price: amount, customer_name: name,
      customer_phone: phone, payment_method: "sslcommerz",
      transaction_id: tranId, status: "pending_payment",
      payment_status: "pending", payment_provider: "sslcommerz",
    }).select("id").single();
  if (orderError || !order) {
    console.error("order_create_failed", orderError?.message);
    return json({ error: "Could not create payment order" }, 500);
  }

  const { error: attemptError } = await admin.from("facebook_setup_payment_attempts")
    .insert({ order_id: order.id, user_id: user.id, provider: "sslcommerz", tran_id: tranId, amount });
  if (attemptError) {
    await admin.from("facebook_setup_orders").delete().eq("id", order.id);
    console.error("attempt_create_failed", attemptError.message);
    return json({ error: "Could not create payment attempt" }, 500);
  }

  const base = mode === "live" ? "https://securepay.sslcommerz.com" : "https://sandbox.sslcommerz.com";
  const edgeBase = `${url}/functions/v1/facebook-setup-payment-ipn`;
  const form = new URLSearchParams({
    store_id: storeId, store_passwd: storePassword,
    total_amount: String(amount), currency: "BDT", tran_id: tranId,
    success_url: `${appBase.replace(/\/$/, "")}/?payment=return`,
    fail_url: `${appBase.replace(/\/$/, "")}/?payment=return`,
    cancel_url: `${appBase.replace(/\/$/, "")}/?payment=return`,
    ipn_url: edgeBase,
    product_name: "MASTER WORLD VIP Facebook Setup Service",
    product_category: "Digital Service", product_profile: "non-physical-goods",
    cus_name: name, cus_email: user.email ?? "customer@example.com",
    cus_add1: "Not provided", cus_city: "Dhaka", cus_postcode: "0000",
    cus_country: "Bangladesh", shipping_method: "NO",
    num_of_item: "1",
  });
  try {
    const response = await fetch(`${base}/gwprocess/v4/api.php`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: form,
    });
    const result = await response.json();
    if (!response.ok || result.status !== "SUCCESS" || typeof result.GatewayPageURL !== "string") {
      await admin.from("facebook_setup_orders").update({ payment_status: "failed", status: "pending_payment" }).eq("id", order.id);
      await admin.from("facebook_setup_payment_attempts").update({ status: "failed" }).eq("tran_id", tranId);
      console.error("gateway_session_failed", result.failedreason ?? result.status);
      return json({ error: "Gateway could not create checkout session. No payment was taken." }, 502);
    }
    return json({ checkout_url: result.GatewayPageURL, order_id: order.id, payment_status: "pending" });
  } catch (error) {
    console.error("gateway_request_failed", String(error));
    return json({ error: "Gateway temporarily unavailable. Payment remains pending." }, 502);
  }
});
