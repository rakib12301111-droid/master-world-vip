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
  const workflow = "secure-supabase-db-update.yml";
  if (!supabaseUrl || !anonKey || !serviceRoleKey || !githubToken) {
    return reply({ success: false, error: "Server setup incomplete. Required Edge Function secrets are missing." }, 503);
  }

  try {
    const userResponse = await fetch(supabaseUrl.replace(/\/$/, "") + "/auth/v1/user", {
      headers: { apikey: anonKey, Authorization: auth },
    });
    if (!userResponse.ok) return reply({ success: false, error: "Session invalid or expired" }, 401);
    const user = await userResponse.json();
    if (!user?.id) return reply({ success: false, error: "Authenticated user details unavailable" }, 401);

    const roleUrl = new URL(supabaseUrl.replace(/\/$/, "") + "/rest/v1/app_user_roles");
    roleUrl.search = new URLSearchParams({ select: "role", user_id: "eq." + user.id, limit: "1" }).toString();
    const roleResponse = await fetch(roleUrl, {
      headers: { apikey: serviceRoleKey, Authorization: "Bearer " + serviceRoleKey },
    });
    if (!roleResponse.ok) return reply({ success: false, error: "Unable to verify Owner permission" }, 503);
    const roles = await roleResponse.json();
    if (!Array.isArray(roles) || roles[0]?.role !== "owner") {
      return reply({ success: false, error: "Only the verified Owner can view database update status" }, 403);
    }

    const body = await req.json().catch(() => null);
    const requestId = body?.request_id;
    if (typeof requestId !== "string" || !/^[0-9a-fA-F-]{36}$/.test(requestId)) {
      return reply({ success: false, error: "A valid request_id is required" }, 400);
    }

    const runsUrl = "https://api.github.com/repos/" + repository +
      "/actions/workflows/" + workflow + "/runs?branch=main&event=workflow_dispatch&per_page=20";
    const runsResponse = await fetch(runsUrl, {
      headers: {
        Authorization: "Bearer " + githubToken,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
      },
    });
    if (!runsResponse.ok) {
      console.error("GitHub workflow status lookup failed", runsResponse.status);
      return reply({ success: false, error: "Unable to read GitHub Actions status. Check server token Actions: Read permission." }, 502);
    }

    const payload = await runsResponse.json();
    const expectedTitle = "MASTER WORLD VIP DB Update · " + requestId;
    const run = (payload.workflow_runs || []).find((item: any) => item.display_title === expectedTitle);
    if (!run) {
      return reply({ success: true, status: "queued", request_id: requestId, message: "GitHub Actions run is being created or is not visible yet." }, 202);
    }

    return reply({
      success: true,
      request_id: requestId,
      status: run.status || "unknown",
      conclusion: run.conclusion || null,
      run_number: run.run_number || null,
      html_url: run.html_url || null,
      created_at: run.created_at || null,
      updated_at: run.updated_at || null,
    });
  } catch (error) {
    console.error("Database update status error", error);
    return reply({ success: false, error: "Unexpected server error while checking database update status" }, 500);
  }
});
