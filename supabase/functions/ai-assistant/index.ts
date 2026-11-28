// MASTER WORLD VIP — authenticated AI proxy
// Configure AI_PROVIDER_API_KEY, AI_PROVIDER_URL and AI_MODEL as Edge Function secrets.
// Browser requests are restricted to the official GitHub Pages origin.
import { createClient } from "npm:@supabase/supabase-js@2";

const ALLOWED_ORIGIN = "https://rakib12301111-droid.github.io";
const corsHeaders = (origin: string | null): Record<string, string> => ({
  ...(origin === ALLOWED_ORIGIN ? { "Access-Control-Allow-Origin": ALLOWED_ORIGIN } : {}),
  "Vary": "Origin",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
});
const json = (body: unknown, status = 200, origin: string | null = null) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders(origin), "Content-Type": "application/json", "Cache-Control": "no-store" },
  });

Deno.serve(async (req) => {
  const origin = req.headers.get("Origin");
  if (origin && origin !== ALLOWED_ORIGIN) return json({ error: "Origin not allowed" }, 403);
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders(origin) });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405, origin);

  const auth = req.headers.get("Authorization") || "";
  if (!auth.startsWith("Bearer ")) return json({ error: "Sign in required" }, 401, origin);

  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY") ||
    JSON.parse(Deno.env.get("SUPABASE_PUBLISHABLE_KEYS") || "{}").default;
  if (!url || !anon) return json({ error: "Authentication service is unavailable" }, 503, origin);

  const sb = createClient(url, anon, { global: { headers: { Authorization: auth } } });
  const { data: { user }, error } = await sb.auth.getUser();
  if (error || !user) return json({ error: "Invalid session" }, 401, origin);

  const key = Deno.env.get("AI_PROVIDER_API_KEY");
  const endpoint = Deno.env.get("AI_PROVIDER_URL") || "https://api.openai.com/v1/chat/completions";
  const model = Deno.env.get("AI_MODEL") || "gpt-4o-mini";
  if (!key) return json({ error: "AI provider is not configured" }, 503, origin);

  let body: { prompt?: unknown; language?: unknown };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400, origin);
  }
  const prompt = typeof body.prompt === "string" ? body.prompt.trim() : "";
  if (!prompt || prompt.length > 12000) {
    return json({ error: "Prompt must be 1–12000 characters" }, 400, origin);
  }
  const lang = body.language === "en" ? "English" : "Bengali";

  try {
    const upstream = await fetch(endpoint, {
      method: "POST",
      headers: { "Authorization": `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model,
        messages: [
          { role: "system", content: `You are MASTER WORLD VIP's helpful assistant. Reply in ${lang}. Be safe, truthful and concise.` },
          { role: "user", content: prompt },
        ],
        temperature: 0.6,
        max_tokens: 1200,
      }),
      signal: AbortSignal.timeout(30000),
    });
    if (!upstream.ok) {
      // Do not return provider error bodies: they can contain sensitive diagnostics.
      return json({ error: "AI provider request failed" }, 502, origin);
    }
    const result = await upstream.json().catch(() => ({}));
    const reply = result?.choices?.[0]?.message?.content;
    if (typeof reply !== "string" || !reply.trim()) {
      return json({ error: "AI provider returned an empty response" }, 502, origin);
    }
    return json({ reply, usage: result.usage || null }, 200, origin);
  } catch {
    return json({ error: "AI provider timed out or is temporarily unavailable" }, 502, origin);
  }
});
