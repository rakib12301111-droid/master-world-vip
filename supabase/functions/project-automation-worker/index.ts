// MASTER WORLD VIP queue worker — fail-closed, allowlisted execution.
// Only system_health_check is implemented. It is read-only and performs no external or financial effects.
// The database kill switch and per-project execution/budget checks are authoritative.
const cors = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

type ClaimedTask = {
  id: string;
  task_type: string;
  payload: Record<string, unknown>;
  lease_token: string;
};

function executeAllowlistedTask(task: ClaimedTask): { success: boolean; result: Record<string, unknown>; error?: string } {
  if (task.task_type !== "system_health_check") {
    return { success: false, result: {}, error: "Task type is not implemented by this worker." };
  }
  // Intentionally ignores payload: this handler reads no customer/member records and writes no business data.
  return {
    success: true,
    result: {
      handler: "system_health_check",
      handler_version: "1.0.0",
      read_only: true,
      external_side_effects: false,
      financial_effects: false,
    },
  };
}

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
    await rpc("worker_register_project_automation", {
      p_worker_key: workerKey,
      p_display_name: "MASTER WORLD VIP Edge Worker",
      p_currencies: ["USD", "BDT"],
    });
    await rpc("worker_heartbeat_project_automation", { p_worker_key: workerKey });

    const claimed = await rpc("worker_claim_project_automation_task", { p_worker_key: workerKey }) as ClaimedTask[] | null;
    const task = Array.isArray(claimed) ? claimed[0] : undefined;
    if (!task) {
      return json({
        status: "idle",
        worker_registered: true,
        claimed: 0,
        execution_handlers_ready: true,
        revenue_enabled: false,
        note: "No eligible task. The database emergency stop, project gate, budget gate and handler allowlist are enforced before claim.",
      });
    }

    const outcome = executeAllowlistedTask(task);
    await rpc("worker_finish_project_automation_task", {
      p_task_id: task.id,
      p_lease_token: task.lease_token,
      p_success: outcome.success,
      p_actual_cost: 0,
      p_error: outcome.error ?? null,
    });

    return json({
      status: outcome.success ? "completed" : "retry_or_dead_letter",
      worker_registered: true,
      claimed: 1,
      task_type: task.task_type,
      task_id: task.id,
      handler_result: outcome.result,
      revenue_enabled: false,
    });
  } catch {
    console.error("Worker operation failed; inspect protected function logs.");
    return json({ error: "Worker operation failed" }, 500);
  }
});
