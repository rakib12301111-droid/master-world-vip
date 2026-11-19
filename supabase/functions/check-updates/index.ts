const SUPABASE_URL = "https://lztbbrzeuyjkuiyzrsxp.supabase.co";
const CURRENT_APP_VERSION = "3.2.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Content-Type": "application/json",
};

function jsonResponse(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: corsHeaders,
  });
}

function parseVersion(version: string) {
  const match = version.trim().match(
    /^v?(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?(?:\+[0-9A-Za-z.-]+)?$/,
  );

  if (!match) return null;

  return {
    major: Number(match[1]),
    minor: Number(match[2]),
    patch: Number(match[3]),
    prerelease: match[4] ?? null,
  };
}

function compareVersions(a: string, b: string): number {
  const va = parseVersion(a);
  const vb = parseVersion(b);

  if (!va || !vb) {
    throw new Error("Invalid version format");
  }

  for (const key of ["major", "minor", "patch"] as const) {
    if (va[key] > vb[key]) return 1;
    if (va[key] < vb[key]) return -1;
  }

  if (va.prerelease === vb.prerelease) return 0;
  if (va.prerelease === null) return 1;
  if (vb.prerelease === null) return -1;

  return va.prerelease.localeCompare(vb.prerelease);
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      status: 200,
      headers: corsHeaders,
    });
  }

  if (!["GET", "POST"].includes(req.method)) {
    return jsonResponse({
      success: false,
      error: "Method not allowed",
    }, 405);
  }

  const apiKey = req.headers.get("apikey") ?? "";

  if (!/^sb_publishable_[A-Za-z0-9_-]+$/.test(apiKey)) {
    return jsonResponse({
      success: false,
      error: "A valid publishable API key is required",
    }, 401);
  }

  try {
    const query = new URLSearchParams({
      select: "version,release_notes",
      status: "eq.published",
      order: "published_at.desc.nullslast,created_at.desc",
      limit: "1",
    });

    const response = await fetch(
      `${SUPABASE_URL}/rest/v1/update_releases?${query.toString()}`,
      {
        method: "GET",
        headers: {
          apikey: apiKey,
          Accept: "application/json",
        },
      },
    );

    if (!response.ok) {
      return jsonResponse({
        success: false,
        error: "Unable to check for updates",
      }, 502);
    }

    const releases = await response.json();

    if (!Array.isArray(releases) || releases.length === 0) {
      return jsonResponse({
        success: true,
        latest_version: null,
        release_notes: null,
        update_available: false,
      });
    }

    const release = releases[0];

    if (
      typeof release.version !== "string" ||
      !parseVersion(release.version)
    ) {
      return jsonResponse({
        success: false,
        error: "Invalid release version",
      }, 500);
    }

    const updateAvailable =
      compareVersions(release.version, CURRENT_APP_VERSION) > 0;

    return jsonResponse({
      success: true,
      latest_version: release.version,
      release_notes: release.release_notes ?? null,
      update_available: updateAvailable,
    });
  } catch {
    return jsonResponse({
      success: false,
      error: "Update check failed",
    }, 500);
  }
});
