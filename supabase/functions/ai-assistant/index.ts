// MASTER WORLD VIP — authenticated AI proxy
// Configure AI_PROVIDER_API_KEY, AI_PROVIDER_URL and AI_MODEL as Edge Function secrets.
import { createClient } from "npm:@supabase/supabase-js@2";
const cors = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
const json = (body: unknown, status=200) => new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });
Deno.serve(async (req) => {
 if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
 if (req.method !== "POST") return json({error:"Method not allowed"},405);
 const auth = req.headers.get("Authorization") || "";
 if (!auth.startsWith("Bearer ")) return json({error:"Sign in required"},401);
 const url=Deno.env.get("SUPABASE_URL")!, anon=Deno.env.get("SUPABASE_ANON_KEY") || JSON.parse(Deno.env.get("SUPABASE_PUBLISHABLE_KEYS") || "{}").default;
 const sb=createClient(url,anon,{global:{headers:{Authorization:auth}}});
 const {data:{user},error}=await sb.auth.getUser();
 if(error || !user) return json({error:"Invalid session"},401);
 const key=Deno.env.get("AI_PROVIDER_API_KEY"), endpoint=Deno.env.get("AI_PROVIDER_URL") || "https://api.openai.com/v1/chat/completions", model=Deno.env.get("AI_MODEL") || "gpt-4o-mini";
 if(!key) return json({error:"AI provider is not configured. Add AI_PROVIDER_API_KEY in Supabase Edge Function Secrets."},503);
 let body; try { body=await req.json(); } catch { return json({error:"Invalid JSON"},400); }
 const prompt=typeof body.prompt==="string"?body.prompt.trim():"";
 if(!prompt || prompt.length>12000) return json({error:"Prompt must be 1–12000 characters"},400);
 const lang=body.language==="en"?"English":"Bengali";
 const upstream=await fetch(endpoint,{method:"POST",headers:{"Authorization":`Bearer ${key}`,"Content-Type":"application/json"},body:JSON.stringify({model,messages:[{role:"system",content:`You are MASTER WORLD VIP's helpful assistant. Reply in ${lang}. Be safe, truthful and concise.`},{role:"user",content:prompt}],temperature:0.6})});
 const result=await upstream.json().catch(()=>({}));
 if(!upstream.ok) return json({error:"AI provider request failed",details:result.error?.message || upstream.statusText},502);
 return json({reply:result.choices?.[0]?.message?.content || "No response",usage:result.usage || null});
});
