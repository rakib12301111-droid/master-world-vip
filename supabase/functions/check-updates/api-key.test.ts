import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { isPublicApiKey } from "./api-key.ts";

function jwtWithRole(role: string): string {
  const payload = btoa(JSON.stringify({ role }))
    .replace(/=/g, "")
    .replace(/\+/g, "-")
    .replace(/\//g, "_");
  return "eyJhbGciOiJub25lIn0." + payload + ".signature";
}

Deno.test("accepts a Supabase publishable key", () => {
  assertEquals(isPublicApiKey("sb_publishable_example123"), true);
});

Deno.test("accepts only legacy anon JWTs", () => {
  assertEquals(isPublicApiKey(jwtWithRole("anon")), true);
  assertEquals(isPublicApiKey(jwtWithRole("service_role")), false);
  assertEquals(isPublicApiKey(jwtWithRole("authenticated")), false);
});

Deno.test("rejects malformed JWTs and secret keys", () => {
  assertEquals(isPublicApiKey("sb_secret_example123"), false);
  assertEquals(isPublicApiKey("not-a-jwt"), false);
  assertEquals(isPublicApiKey("a.b.c"), false);
  assertEquals(isPublicApiKey("eyJhbGciOiJub25lIn0.@@@.signature"), false);
});
