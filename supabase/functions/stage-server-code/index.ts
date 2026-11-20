const corsHeaders = {
  "Access-Control-Allow-Origin": "https://rakib12301111-droid.github.io",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
};
function reply(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders });
}
function base64Utf8(value: string) {
  const bytes = new TextEncoder().encode(value);
  let binary = "";
  for (let i = 0; i < bytes.length; i += 0x8000) binary += String.fromCharCode(...bytes.subarray(i, i + 0x8000));
  return btoa(binary);
}
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return reply({ success: false, error: "Method not allowed" }, 405);
  const auth = req.headers.get("Authorization") || "";
  if (!auth.startsWith("Bearer ")) return reply({ success: false, error: "Login required" }, 401);
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const githubToken = Deno.env.get("GITHUB_ACTIONS_TOKEN");
  const repository = Deno.env.get("GITHUB_REPOSITORY") || "rakib12301111-droid/master-world-vip";
  if (!supabaseUrl || !anonKey || !serviceRoleKey || !githubToken) {
    return reply({ success: false, error: "Server setup incomplete: required server-side secrets are missing." }, 503);
  }
  try {
    const userResponse = await fetch(supabaseUrl.replace(/\/$/, "") + "/auth/v1/user", {
      headers: { apikey: anonKey, Authorization: auth },
    });
    if (!userResponse.ok) return reply({ success: false, error: "Session invalid or expired" }, 401);
    const user = await userResponse.json();
    if (!user?.id || !user?.email) return reply({ success: false, error: "Authenticated user details unavailable" }, 401);
    const roleUrl = new URL(supabaseUrl.replace(/\/$/, "") + "/rest/v1/app_user_roles");
    roleUrl.search = new URLSearchParams({ select: "role", user_id: "eq." + user.id, limit: "1" }).toString();
    const roleResponse = await fetch(roleUrl, { headers: { apikey: serviceRoleKey, Authorization: "Bearer " + serviceRoleKey } });
    if (!roleResponse.ok) return reply({ success: false, error: "Unable to verify Owner permission" }, 503);
    const roles = await roleResponse.json();
    if (!Array.isArray(roles) || roles[0]?.role !== "owner") return reply({ success: false, error: "Only the verified Owner can stage server code" }, 403);

    const body = await req.json().catch(() => null);
    const kind = body?.kind;
    const code = body?.code;
    const name = body?.name;
    if (!["sql", "edge_function"].includes(kind)) return reply({ success: false, error: "Choose SQL or Edge Function code." }, 400);
    if (typeof code !== "string" || !code.trim()) return reply({ success: false, error: "Code box is empty." }, 400);
    if (new TextEncoder().encode(code).length > 48000) return reply({ success: false, error: "Code is too large (maximum 48 KB)." }, 413);
    if (kind === "sql" && (body?.confirm_apply !== "APPLY-MASTER-WORLD-VIP-CUSTOM-SQL" || body?.backup_confirmed !== true)) {
      return reply({ success: false, error: "SQL Apply requires the exact confirmation phrase and backup acknowledgement." }, 400);
    }

    let path = "";
    if (kind === "sql") {
      const slug = typeof name === "string" ? name.toLowerCase().replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "").slice(0, 32) : "";
      if (!slug) return reply({ success: false, error: "SQL migration name is required (English letters/numbers)." }, 400);
      const d = new Date();
      const stamp = [d.getUTCFullYear(), String(d.getUTCMonth()+1).padStart(2,"0"), String(d.getUTCDate()).padStart(2,"0"), String(d.getUTCHours()).padStart(2,"0"), String(d.getUTCMinutes()).padStart(2,"0"), String(d.getUTCSeconds()).padStart(2,"0")].join("");
      path = "supabase/migrations/" + stamp + "_" + slug + ".sql";
    } else {
      const slug = typeof name === "string" ? name.toLowerCase().replace(/[^a-z0-9-]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 40) : "";
      if (!/^[a-z][a-z0-9-]{1,39}$/.test(slug)) return reply({ success: false, error: "Edge Function name must start with a letter and contain 2–40 lowercase letters, numbers or hyphens." }, 400);
      path = "supabase/functions/" + slug + "/index.ts";
    }

    const api = "https://api.github.com/repos/" + repository + "/contents/" + path.split("/").map(encodeURIComponent).join("/");
    const commitResponse = await fetch(api, {
      method: "PUT",
      headers: { Authorization: "Bearer " + githubToken, Accept: "application/vnd.github+json", "X-GitHub-Api-Version": "2022-11-28", "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Add Owner-submitted " + (kind === "sql" ? "SQL migration" : "Edge Function") + ": " + name, content: base64Utf8(code), branch: "main" }),
    });
    const commitPayload = await commitResponse.json().catch(() => ({}));
    if (!commitResponse.ok) {
      console.error("GitHub code staging failed", commitResponse.status, JSON.stringify(commitPayload).slice(0, 500));
      return reply({ success: false, error: commitResponse.status === 409 ? "A file conflict occurred. Change the name and try again." : "Could not save code to the private project repository. Check server GitHub token Contents: Read and write permission." }, 502);
    }
    const commitSha = commitPayload?.commit?.sha || null;

    if (kind === "sql") {
      const requestId = crypto.randomUUID();
      const dispatch = await fetch("https://api.github.com/repos/" + repository + "/actions/workflows/secure-supabase-db-update.yml/dispatches", {
        method: "POST",
        headers: { Authorization: "Bearer " + githubToken, Accept: "application/vnd.github+json", "X-GitHub-Api-Version": "2022-11-28", "Content-Type": "application/json" },
        body: JSON.stringify({ ref: "main", inputs: { request_id: requestId, confirm_project: "MASTER-WORLD-VIP", apply_migrations: "true" } }),
      });
      if (dispatch.status !== 204) return reply({ success: false, committed: true, commit_sha: commitSha, path, error: "Migration file was saved, but the database workflow could not be started. Check GitHub Actions permission." }, 502);
      return reply({ success: true, kind, status: "queued", request_id: requestId, commit_sha: commitSha, path, message: "SQL migration committed and Apply workflow queued. Check Update Status for the final result." }, 202);
    }
    return reply({ success: true, kind, status: "committed", commit_sha: commitSha, path, message: "Edge Function code committed. GitHub Actions will attempt automatic deployment; deployment secrets must be configured." }, 202);
  } catch (error) {
    console.error("Server code staging error", error);
    return reply({ success: false, error: "Unexpected server error while staging code." }, 500);
  }
});
