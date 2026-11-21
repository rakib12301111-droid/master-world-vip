export function isPublicApiKey(value: string): boolean {
  if (/^sb_publishable_[A-Za-z0-9_-]+$/.test(value)) return true;

  // Legacy JWTs are accepted only when their decoded role is exactly "anon".
  // A JWT shape alone is not sufficient: service_role tokens must be rejected.
  const parts = value.split(".");
  if (
    parts.length !== 3 ||
    !parts.every((part) => /^[A-Za-z0-9_-]+$/.test(part))
  ) return false;

  try {
    const payloadBase64 = parts[1].replace(/-/g, "+").replace(/_/g, "/");
    const paddedPayload = payloadBase64.padEnd(
      payloadBase64.length + (4 - payloadBase64.length % 4) % 4,
      "=",
    );
    const payload = JSON.parse(atob(paddedPayload));
    return payload !== null && typeof payload === "object" &&
      payload.role === "anon";
  } catch {
    return false;
  }
}
