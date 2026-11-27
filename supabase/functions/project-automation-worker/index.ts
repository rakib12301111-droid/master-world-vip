// MASTER WORLD VIP queue worker — fail-closed Supabase Edge Function.
// This service consumes only task types with an explicitly implemented handler.
// It never enables projects/schedules or performs payments/payouts.
const cors = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "POST required" }, 405);
  const url = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const workerKey = Deno.env.get("MWVIP_WORKER_KEY") ?? "";
  if (!url || !serviceKey || !workerKey) return json({ error: "Worker configuration missing" }, 503);
  if (Deno.env.get("MWVIP_WORKER_ENABLED") !== "true") return json({ status: "disabled", claimed: 0 });
  const auth = req.headers.get("authorization") ?? "";
  if (auth !== `Bearer ${serviceKey}`) return json({ error: "Unauthorized" }, 401);
  const headers = { apikey: serviceKey, authorization: `Bearer ${serviceKey}`, "content-type": "application/json" };
  const rpc = async (name: string, body: Record<string, unknown> = {}) => {
    const response = await fetch(`${url}/rest/v1/rpc/${name}`, { method: "POST", headers, body: JSON.stringify(body) });
    const text = await response.text();
    if (!response.ok) throw new Error(`${name} failed (${response.status})`);
    return text ? JSON.parse(text) : null;
  };
  try {
    await rpc("worker_register_project_automation", { p_worker_key: workerKey, p_display_name: "MASTER WORLD VIP Edge Worker", p_currencies: ["USD", "BDT"] });
    await rpc("worker_heartbeat_project_automation", { p_worker_key: workerKey });
    // Fail closed until reviewed task handlers are implemented and allow-listed.
    // Do not claim queue items that this worker cannot safely execute.
    const registeredHandlerCount = 0;
    return json({
      status: "idle",
      worker_registered: true,
      worker_name: "MASTER WORLD VIP Edge Worker",
      claimed: 0,
      execution_handlers_ready: registeredHandlerCount > 0,
      revenue_enabled: false,
      note: "Worker registration and heartbeat are active; no approved business task handlers are deployed, so queue claims remain disabled."
    });
  } catch {
    console.error("Worker operation failed; inspect protected function logs.");
    return json({ error: "Worker operation failed" }, 500);
  }
});
