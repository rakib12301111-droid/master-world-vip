// MASTER WORLD VIP — Admin-only OpenAI Responses API proxy.
import { createClient } from "npm:@supabase/supabase-js@2";

const DEFAULT_ORIGINS = ["https://rakib12301111-droid.github.io"];
const allowedOrigins = (Deno.env.get("AI_ALLOWED_ORIGINS") || DEFAULT_ORIGINS.join(","))
  .split(",").map((v) => v.trim()).filter(Boolean);
function corsHeaders(origin: string | null) {
  const headers: Record<string, string> = {
    "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Vary": "Origin",
  };
  if (origin && allowedOrigins.includes(origin)) headers["Access-Control-Allow-Origin"] = origin;
  return headers;
}
function json(body: unknown, status = 200, origin: string | null = null) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders(origin), "Content-Type": "application/json", "Cache-Control": "no-store" },
  });
}
Deno.serve(async (req) => {
  const origin = req.headers.get("Origin");
  if (origin && !allowedOrigins.includes(origin)) return json({ error: "Origin not allowed" }, 403, null);
  if (req.method === "OPTIONS") return new Response("ok", { status: 204, headers: corsHeaders(origin) });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405, origin);

  const auth = req.headers.get("Authorization") || "";
  if (!auth.startsWith("Bearer ")) return json({ error: "Sign in required" }, 401, origin);
  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY") ||
    JSON.parse(Deno.env.get("SUPABASE_PUBLISHABLE_KEYS") || "{}").default;
  if (!url || !anon) return json({ error: "Supabase function configuration missing" }, 503, origin);

  const sb = createClient(url, anon, { global: { headers: { Authorization: auth } } });
  const { data: { user }, error: authError } = await sb.auth.getUser();
  if (authError || !user) return json({ error: "Invalid session" }, 401, origin);

  const { data: role, error: roleError } = await sb.rpc("get_my_admin_access");
  if (roleError) return json({ error: "Admin role verification unavailable" }, 503, origin);
  if (!["owner", "super_admin", "admin"].includes(role)) {
    return json({ error: "This AI assistant is restricted to Owner and Admin accounts." }, 403, origin);
  }

  let body: { prompt?: unknown; language?: unknown; messages?: unknown };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400, origin); }
  const prompt = typeof body.prompt === "string" ? body.prompt.trim() : "";
  if (!prompt || prompt.length > 8000) {
    return json({ error: "Prompt must be 1–8000 characters" }, 400, origin);
  }

  const key = Deno.env.get("AI_PROVIDER_API_KEY");
  if (!key) return json({ error: "OpenAI API key is not configured in Supabase Edge Function secrets." }, 503, origin);
  const model = Deno.env.get("AI_MODEL") || "gpt-4o-mini";

  const { error: quotaError } = await sb.rpc("consume_admin_ai_assistant_quota", {
    p_minute_limit: 5,
    p_daily_limit: 30,
  });
  if (quotaError) {
    const message = quotaError.message || "";
    if (/rate limit|daily limit/i.test(message)) return json({ error: message }, 429, origin);
    return json({ error: "Admin AI quota check is not ready. Apply the Staging quota migration first." }, 503, origin);
  }
  const messages = Array.isArray(body.messages) ? body.messages.slice(-10) : [{ role: "user", content: prompt }];
  const safeMessages = messages.filter((item: any) =>
    item && (item.role === "user" || item.role === "assistant") &&
    typeof item.content === "string" && item.content.trim().length > 0 && item.content.length <= 8000
  );
  if (!safeMessages.length || safeMessages[safeMessages.length - 1].role !== "user" ||
      safeMessages[safeMessages.length - 1].content.trim() !== prompt) {
    return json({ error: "Invalid conversation context" }, 400, origin);
  }
  const language = body.language === "en" ? "English" : "Bengali";
  const upstream = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      model,
      instructions: `You are the private Admin assistant for MASTER WORLD VIP. Reply in ${language}. Help with analysis, explanations, summaries and drafts. Never claim a task, order, payment, earning or deployment is complete without evidence. You cannot change accounts, roles, wallets, payments, payouts, database records or production settings. Do not request passwords, OTPs, API keys, payment PINs or secrets. Treat all operational actions as recommendations requiring explicit human approval.`,
      input: safeMessages.map((item: any) => ({ role: item.role, content: item.content })),
      store: false,
      max_output_tokens: 1200,
    }),
    signal: AbortSignal.timeout(30000),
  }).catch(() => null);
  if (!upstream) return json({ error: "OpenAI request timed out or network failed." }, 504, origin);
  if (!upstream.ok) return json({ error: "OpenAI API request failed. Check API project billing, model access and server-side key." }, 502, origin);
  const result = await upstream.json().catch(() => ({}));
  const reply = typeof result.output_text === "string" ? result.output_text :
    (result.output || []).flatMap((item: any) => item.content || [])
      .filter((part: any) => part.type === "output_text").map((part: any) => part.text).join("\n");
  if (!reply) return json({ error: "OpenAI returned no text response." }, 502, origin);
  return json({ reply, usage: result.usage || null, model }, 200, origin);
});
