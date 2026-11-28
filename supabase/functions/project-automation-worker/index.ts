// MASTER WORLD VIP queue worker — fail-closed, allowlisted execution.
// Implemented read-only handlers: system_health_check, project_usage_digest, work_order_validate.
// No handler performs external or financial effects; database gates remain authoritative.
// The database kill switch and per-project execution/budget checks are authoritative.
const cors = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

type ClaimedTask = {
  id: string;
  project_id: string;
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

type LocalWorkTask = {
  id: string;
  task_type: "text_cleanup" | "text_quality_report" | "json_validate" | "csv_validate";
  payload: Record<string, unknown>;
  lease_token: string;
};

function countWords(value: string): number {
  return (value.trim().match(/\S+/g) ?? []).length;
}

function parseCsv(value: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < value.length; i++) {
    const ch = value[i];
    if (quoted) {
      if (ch === '"' && value[i + 1] === '"') { field += '"'; i++; }
      else if (ch === '"') quoted = false;
      else field += ch;
    } else if (ch === '"' && field.length === 0) quoted = true;
    else if (ch === ",") { row.push(field); field = ""; }
    else if (ch === "\n") { row.push(field); rows.push(row); row = []; field = ""; }
    else if (ch !== "\r") field += ch;
  }
  if (quoted) throw new Error("CSV contains an unclosed quoted field.");
  if (field.length > 0 || row.length > 0) { row.push(field); rows.push(row); }
  return rows.filter((entry) => entry.some((cell) => cell.length > 0));
}

function executeLocalWork(task: LocalWorkTask): Record<string, unknown> {
  if (task.task_type === "text_cleanup" || task.task_type === "text_quality_report") {
    const input = task.payload.text;
    if (typeof input !== "string" || input.length > 50000) throw new Error("Text input missing or too large.");
    const normalized = input.replace(/\r\n?/g, "\n");
    const cleaned = normalized.split("\n").map((line) => line.trim().replace(/[ \t]+/g, " ")).join("\n").replace(/\n{3,}/g, "\n\n").trim();
    const lines = normalized.length ? normalized.split("\n") : [];
    const report = {
      characters: input.length,
      words: countWords(input),
      lines: lines.length,
      blank_lines: lines.filter((line) => line.trim().length === 0).length,
      normalized_line_endings: normalized !== input,
      leading_or_trailing_whitespace: input !== input.trim(),
    };
    return task.task_type === "text_cleanup"
      ? { task_type: task.task_type, cleaned_text: cleaned, quality_report: report, processor: "mwvip-local-worker-1.0.0" }
      : { task_type: task.task_type, quality_report: report, processor: "mwvip-local-worker-1.0.0" };
  }
  if (task.task_type === "json_validate") {
    const input = task.payload.json_text;
    if (typeof input !== "string" || input.length > 50000) throw new Error("JSON input missing or too large.");
    const parsed = JSON.parse(input);
    return {
      task_type: task.task_type,
      valid: true,
      root_type: Array.isArray(parsed) ? "array" : parsed === null ? "null" : typeof parsed,
      top_level_keys: parsed && typeof parsed === "object" && !Array.isArray(parsed) ? Object.keys(parsed).length : null,
      array_items: Array.isArray(parsed) ? parsed.length : null,
      processor: "mwvip-local-worker-1.0.0",
    };
  }
  if (task.task_type === "csv_validate") {
    const input = task.payload.csv_text;
    if (typeof input !== "string" || input.length > 50000) throw new Error("CSV input missing or too large.");
    const rows = parseCsv(input);
    if (rows.length === 0) throw new Error("CSV is empty.");
    const width = rows[0].length;
    const inconsistent = rows.slice(1).map((row, index) => ({ row: index + 2, columns: row.length })).filter((row) => row.columns !== width);
    return {
      task_type: task.task_type,
      valid: inconsistent.length === 0 && width > 0,
      header_columns: width,
      data_rows: Math.max(0, rows.length - 1),
      headers: rows[0],
      inconsistent_rows: inconsistent.slice(0, 100),
      processor: "mwvip-local-worker-1.0.0",
    };
  }
  throw new Error("Unsupported local work task type.");
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

    // No-money local work queue is checked first. These handlers process only supplied
    // text/JSON/CSV content locally; they never call providers or move funds.
    const localClaimed = await rpc("worker_claim_local_work_task") as LocalWorkTask[] | null;
    const localTask = Array.isArray(localClaimed) ? localClaimed[0] : undefined;
    if (localTask) {
      try {
        const result = executeLocalWork(localTask);
        await rpc("worker_finish_local_work_task", {
          p_task_id: localTask.id,
          p_lease_token: localTask.lease_token,
          p_success: true,
          p_result: result,
          p_error: null,
        });
        return json({
          status: "local_work_available_for_member_review",
          task_id: localTask.id,
          task_type: localTask.task_type,
          result,
          financial_effects: false,
          external_side_effects: false,
        });
      } catch {
        await rpc("worker_finish_local_work_task", {
          p_task_id: localTask.id,
          p_lease_token: localTask.lease_token,
          p_success: false,
          p_result: {},
          p_error: "Local content task failed validation or processing.",
        });
        return json({ status: "local_work_failed_or_requeued", task_id: localTask.id, financial_effects: false });
      }
    }

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

    let outcome: { success: boolean; result: Record<string, unknown>; error?: string };
    try {
      if (task.task_type === "system_health_check") {
        outcome = executeAllowlistedTask(task);
      } else if (task.task_type === "project_usage_digest") {
        const digest = await rpc("worker_read_project_usage_digest", {
          p_project_id: task.project_id,
        });
        outcome = {
          success: true,
          result: {
            handler: "project_usage_digest",
            handler_version: "1.0.0",
            read_only: true,
            external_side_effects: false,
            financial_effects: false,
            digest,
          },
        };
      } else if (task.task_type === "work_order_validate") {
        const orderId = task.payload?.order_id;
        if (typeof orderId !== "string" || !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(orderId)) {
          outcome = { success: false, result: {}, error: "Invalid or missing order_id in task payload." };
        } else {
          const validation = await rpc("worker_validate_work_order", {
            p_project_id: task.project_id,
            p_order_id: orderId,
          });
          outcome = {
            success: true,
            result: {
              handler: "work_order_validate",
              handler_version: "1.0.0",
              read_only: true,
              external_side_effects: false,
              financial_effects: false,
              validation,
            },
          };
        }
      } else {
        outcome = { success: false, result: {}, error: "Task type is not implemented by this worker." };
      }
    } catch {
      // Release the lease through the database retry/dead-letter policy instead of
      // leaving a failed handler running until the five-minute lease expires.
      // Keep provider/database error details out of the HTTP response and task row.
      outcome = { success: false, result: {}, error: "Allowlisted task handler failed; retry under database policy." };
    }
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
