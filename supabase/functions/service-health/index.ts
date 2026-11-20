const corsHeaders = {
  "Access-Control-Allow-Origin": "https://rakib12301111-droid.github.io",
  "Access-Control-Allow-Headers": "apikey, authorization, content-type, x-client-info",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
};

function reply(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders });
}

const REQUIRED_TABLES = [
  "profiles",
  "conversations",
  "conversation_members",
  "messages",
  "community_groups",
  "group_members",
  "group_messages",
  "notifications",
  "push_subscriptions",
  "app_user_roles",
  "member_broadcasts",
  "member_broadcast_deliveries",
  "update_releases",
];

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "GET") return reply({ success: false, error: "Method not allowed" }, 405);

  const supabaseUrl = (Deno.env.get("SUPABASE_URL") || "").replace(/\/$/, "");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY") || "";
  const githubToken = Deno.env.get("GITHUB_ACTIONS_TOKEN") || "";
  const pushSecret = Deno.env.get("PUSH_WEBHOOK_SECRET") || "";
  const vapidPublic = Deno.env.get("VAPID_PUBLIC_KEY") || "";
  const vapidPrivate = Deno.env.get("VAPID_PRIVATE_KEY") || "";
  const vapidSubject = Deno.env.get("VAPID_SUBJECT") || "";

  if (!supabaseUrl) return reply({ success: false, error: "Supabase URL is not configured" }, 503);

  const secrets = {
    supabaseAnonKey: !!anonKey,
    supabaseServiceRoleKey: !!serviceRoleKey,
    githubActionsToken: !!githubToken,
    pushWebhookSecret: !!pushSecret,
    vapidPublicKey: !!vapidPublic,
    vapidPrivateKey: !!vapidPrivate,
    vapidSubject: !!vapidSubject,
  };

  const tables: Record<string, boolean> = {};
  if (serviceRoleKey) {
    const results = await Promise.all(REQUIRED_TABLES.map(async (table) => {
      try {
        const response = await fetch(
          supabaseUrl + "/rest/v1/" + table + "?select=*&limit=0",
          { headers: { apikey: serviceRoleKey, Authorization: "Bearer " + serviceRoleKey }, cache: "no-store" },
        );
        return [table, response.ok] as const;
      } catch {
        return [table, false] as const;
      }
    }));
    for (const [table, ok] of results) tables[table] = ok;
  } else {
    for (const table of REQUIRED_TABLES) tables[table] = false;
  }

  const missingTables = Object.entries(tables).filter(([, ok]) => !ok).map(([name]) => name);
  const missingSecrets = Object.entries(secrets).filter(([, ok]) => !ok).map(([name]) => name);
  const schemaReady = missingTables.length === 0;
  const pushReady = secrets.pushWebhookSecret && secrets.vapidPublicKey &&
    secrets.vapidPrivateKey && secrets.vapidSubject && schemaReady;
  const updateDispatchReady = secrets.githubActionsToken && secrets.supabaseServiceRoleKey &&
    secrets.supabaseAnonKey && schemaReady;

  return reply({
    success: true,
    checked_at: new Date().toISOString(),
    project_ref: "lztbbrzeuyjkuiyzrsxp",
    database: { schema_ready: schemaReady, tables, missing_tables: missingTables },
    secrets,
    capabilities: {
      update_dispatch_ready: updateDispatchReady,
      web_push_sender_ready: pushReady,
      live_messaging_schema_ready: schemaReady,
      group_broadcast_schema_ready: schemaReady,
    },
    note: "This is a configuration/schema preflight only. It does not prove message delivery, Owner role assignment, backup readiness, or actual push delivery.",
  });
});
