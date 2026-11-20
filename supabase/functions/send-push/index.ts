import webpush from "npm:web-push@3.6.7";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "https://rakib12301111-droid.github.io",
  "Access-Control-Allow-Headers": "content-type, x-push-webhook-secret",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
};

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  const expectedSecret = Deno.env.get("PUSH_WEBHOOK_SECRET") ?? "";
  if (!expectedSecret || req.headers.get("x-push-webhook-secret") !== expectedSecret) {
    return json({ error: "Unauthorized webhook" }, 401);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const publicKey = Deno.env.get("VAPID_PUBLIC_KEY") ?? "";
  const privateKey = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
  const subject = Deno.env.get("VAPID_SUBJECT") ?? "";
  if (!supabaseUrl || !serviceRoleKey || !publicKey || !privateKey || !subject) {
    return json({ error: "Push sender secrets are not configured" }, 503);
  }

  let record: { id?: string; user_id?: string; title?: string; body?: string; category?: string };
  try {
    const payload = await req.json();
    record = payload?.record ?? payload;
  } catch {
    return json({ error: "Invalid JSON payload" }, 400);
  }
  if (!record.id || !record.user_id) return json({ error: "Notification id and user_id are required" }, 400);

  const db = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: notification, error: notificationError } = await db
    .from("notifications")
    .select("id,user_id,title,body,category")
    .eq("id", record.id)
    .eq("user_id", record.user_id)
    .maybeSingle();
  if (notificationError) return json({ error: "Unable to verify notification" }, 500);
  if (!notification) return json({ error: "Notification not found" }, 404);

  const { data: subscriptions, error } = await db
    .from("push_subscriptions")
    .select("id,endpoint,p256dh,auth_secret")
    .eq("user_id", notification.user_id);
  if (error) return json({ error: "Unable to load push subscriptions" }, 500);
  if (!subscriptions?.length) return json({ sent: 0, expired: 0, message: "No subscribed devices" });

  webpush.setVapidDetails(subject, publicKey, privateKey);
  let sent = 0;
  let expired = 0;
  const failures: string[] = [];
  const message = JSON.stringify({
    title: notification.title || "MASTER WORLD VIP",
    body: notification.body || "আপনার নতুন নোটিফিকেশন এসেছে।",
    url: "./",
    tag: "mwvip-" + notification.id,
  });

  for (const sub of subscriptions) {
    try {
      await webpush.sendNotification({
        endpoint: sub.endpoint,
        keys: { p256dh: sub.p256dh, auth: sub.auth_secret },
      }, message);
      sent++;
    } catch (error) {
      const statusCode = (error as { statusCode?: number }).statusCode;
      if (statusCode === 404 || statusCode === 410) {
        await db.from("push_subscriptions").delete().eq("id", sub.id);
        expired++;
      } else {
        failures.push(String(statusCode ?? "unknown"));
      }
    }
  }

  return json({ sent, expired, failed: failures.length });
});
