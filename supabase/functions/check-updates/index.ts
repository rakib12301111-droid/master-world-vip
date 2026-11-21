import { isPublicApiKey } from "./api-key.ts";
import { compareVersions, parseVersion } from "./version.ts";

const FALLBACK_APP_VERSION = "3.3.0";
const DEFAULT_SUPABASE_URL = "https://lztbbrzeuyjkuiyzrsxp.supabase.co";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store, max-age=0",
};

function jsonResponse(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders });
}

async function readCurrentVersion(req: Request): Promise<string> {
  const url = new URL(req.url);
  let candidate = url.searchParams.get("current_version");
  if (req.method === "POST") {
    let body: unknown;
    try {
      body = await req.json();
    } catch {
      throw new Error("Request body must be valid JSON");
    }
    if (body && typeof body === "object" && "current_version" in body) {
      const value = (body as { current_version?: unknown }).current_version;
      if (typeof value === "string") candidate = value;
      else throw new Error("current_version must be a string");
    }
  }
  const version = candidate?.trim() || FALLBACK_APP_VERSION;
  if (!parseVersion(version)) throw new Error("Invalid current_version format");
  return version;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { status: 200, headers: corsHeaders });
  }
  if (req.method !== "GET" && req.method !== "POST") {
    return jsonResponse({ success: false, error: "Method not allowed" }, 405);
  }

  const apiKey = req.headers.get("apikey") ?? "";
  if (!isPublicApiKey(apiKey)) {
    return jsonResponse({
      success: false,
      error: "A valid Supabase publishable/anon API key is required",
    }, 401);
  }

  try {
    const currentVersion = await readCurrentVersion(req);
    const supabaseUrl = (Deno.env.get("SUPABASE_URL") || DEFAULT_SUPABASE_URL)
      .replace(/\/$/, "");
    const query = new URLSearchParams({
      select: "version,release_notes",
      status: "eq.published",
      order: "published_at.desc.nullslast,created_at.desc",
      limit: "1",
    });
    const response = await fetch(
      supabaseUrl + "/rest/v1/update_releases?" + query.toString(),
      {
        method: "GET",
        headers: { apikey: apiKey, Accept: "application/json" },
        cache: "no-store",
      },
    );
    if (!response.ok) {
      return jsonResponse({
        success: false,
        error: "Unable to check for updates",
        upstream_status: response.status,
      }, 502);
    }

    const releases: unknown = await response.json();
    if (!Array.isArray(releases)) {
      return jsonResponse({ success: false, error: "Invalid release response" }, 502);
    }
    if (releases.length === 0) {
      return jsonResponse({
        success: true,
        current_version: currentVersion,
        latest_version: null,
        release_notes: null,
        update_available: false,
      });
    }

    const release = releases[0] as { version?: unknown; release_notes?: unknown };
    if (typeof release.version !== "string" || !parseVersion(release.version)) {
      return jsonResponse({ success: false, error: "Invalid release version" }, 500);
    }
    return jsonResponse({
      success: true,
      current_version: currentVersion,
      latest_version: release.version,
      release_notes: typeof release.release_notes === "string" ? release.release_notes : null,
      update_available: compareVersions(release.version, currentVersion) > 0,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Update check failed";
    const status = message.includes("current_version") || message.includes("Request body")
      ? 400
      : 500;
    return jsonResponse({ success: false, error: message }, status);
  }
});
