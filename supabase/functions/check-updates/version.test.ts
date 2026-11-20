import { assertEquals, assertThrows } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { compareVersions, parseVersion } from "./version.ts";

Deno.test("parses stable versions and optional v prefix", () => {
  assertEquals(parseVersion("3.3.0")?.major, 3);
  assertEquals(parseVersion("v3.3.0")?.patch, 0);
});

Deno.test("rejects malformed versions and leading zero components", () => {
  assertEquals(parseVersion("3.3"), null);
  assertEquals(parseVersion("03.3.0"), null);
  assertEquals(parseVersion("3.x.0"), null);
});

Deno.test("compares major, minor and patch numbers", () => {
  assertEquals(compareVersions("3.4.0", "3.3.9"), 1);
  assertEquals(compareVersions("3.3.0", "3.3.1"), -1);
  assertEquals(compareVersions("3.3.0", "3.3.0"), 0);
});

Deno.test("stable release sorts after prerelease", () => {
  assertEquals(compareVersions("3.3.0", "3.3.0-rc.2"), 1);
  assertEquals(compareVersions("3.3.0-beta.2", "3.3.0-beta.10"), -1);
});

Deno.test("rejects invalid comparison input", () => {
  assertThrows(() => compareVersions("latest", "3.3.0"), Error);
});
