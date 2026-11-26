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
    if (!response.ok) throw new Error(`${name} failed (${response.status}): ${text.slice(0, 500)}`);
    return text ? JSON.parse(text) : null;
  };
  try {
    await rpc("worker_register_project_automation", { p_worker_key: workerKey, p_display_name: "MASTER WORLD VIP Edge Worker", p_currencies: ["USD", "BDT"] });
    await rpc("worker_heartbeat_project_automation", { p_worker_key: workerKey });
    const maxTasks = 5;
    const outcomes: Array<{ task_id: string; task_type: string; outcome: string }> = [];
    for (let i = 0; i < maxTasks; i++) {
      await rpc("worker_heartbeat_project_automation", { p_worker_key: workerKey });
      const claimed = await rpc("worker_claim_project_automation_task", { p_worker_key: workerKey });
      const task = Array.isArray(claimed) ? claimed[0] : claimed;
      if (!task) break;
      // No business task handlers are deployed yet. Fail closed rather than
      // pretending that a generic project_cycle generated work or revenue.
      const supported = new Set<string>([]);
      const success = supported.has(String(task.task_type));
      await rpc("worker_finish_project_automation_task", {
        p_task_id: task.id,
        p_lease_token: task.lease_token,
        p_success: success,
        p_actual_cost: 0,
        p_error: success ? null : "No approved task handler is deployed for this task type"
      });
      outcomes.push({ task_id: String(task.id), task_type: String(task.task_type), outcome: success ? "succeeded" : "rejected_no_handler" });
    }
    return json({ status: "ok", worker: workerKey, claimed: outcomes.length, outcomes, execution_handlers_ready: false, revenue_enabled: false });
  } catch (error) {
    return json({ error: error instanceof Error ? error.message : String(error) }, 500);
  }
});
