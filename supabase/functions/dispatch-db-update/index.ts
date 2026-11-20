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
    if (!user?.id || !user?.email) return reply({ success: false, error: "Authenticated user details unavailable" }, 401);

    const roleUrl = new URL(supabaseUrl.replace(/\/$/, "") + "/rest/v1/app_user_roles");
    roleUrl.search = new URLSearchParams({
      select: "role",
      user_id: "eq." + user.id,
      limit: "1",
    }).toString();
    const roleResponse = await fetch(roleUrl, {
      headers: { apikey: serviceRoleKey, Authorization: "Bearer " + serviceRoleKey },
    });
    if (!roleResponse.ok) return reply({ success: false, error: "Unable to verify Owner permission" }, 503);
    const roles = await roleResponse.json();
    if (!Array.isArray(roles) || roles[0]?.role !== "owner") {
      return reply({ success: false, error: "Only the verified Owner can run database updates" }, 403);
    }

    const body = await req.json().catch(() => null);
    const mode = body?.mode;
    if (mode !== "dry_run" && mode !== "apply") {
      return reply({ success: false, error: "mode must be dry_run or apply" }, 400);
    }
    if (mode === "apply" && (body?.confirm_apply !== "APPLY-MASTER-WORLD-VIP-MIGRATIONS" || body?.backup_confirmed !== true)) {
      return reply({ success: false, error: "Apply requires the exact confirmation phrase and backup acknowledgement" }, 400);
    }

    const dispatchUrl = "https://api.github.com/repos/" + repository + "/actions/workflows/" + workflow + "/dispatches";
    const dispatch = await fetch(dispatchUrl, {
      method: "POST",
      headers: {
        Authorization: "Bearer " + githubToken,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        ref: "main",
        inputs: {
          confirm_project: "MASTER-WORLD-VIP",
          apply_migrations: mode === "apply" ? "true" : "false",
        },
      }),
    });
    if (dispatch.status !== 204) {
      const detail = await dispatch.text();
      console.error("GitHub workflow dispatch failed", dispatch.status, detail.slice(0, 500));
      return reply({ success: false, error: "GitHub Actions could not be started. Check server-side GitHub token permissions." }, 502);
    }
    return reply({
      success: true,
      mode,
      status: "queued",
      message: mode === "dry_run" ? "Dry Run queued. No database changes will be applied." : "Apply workflow queued after Owner confirmation and backup acknowledgement.",
      requested_by: user.email,
      workflow: workflow,
    }, 202);
  } catch (error) {
    console.error("Database update dispatch error", error);
    return reply({ success: false, error: "Unexpected server error while requesting database update" }, 500);
  }
});
