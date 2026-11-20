export type ParsedVersion = {
  major: number;
  minor: number;
  patch: number;
  prerelease: string[] | null;
};

export function parseVersion(input: string): ParsedVersion | null {
  const match = input.trim().match(
    /^v?(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-([0-9A-Za-z.-]+))?(?:\\+[0-9A-Za-z.-]+)?$/,
  );
  if (!match) return null;

  return {
    major: Number(match[1]),
    minor: Number(match[2]),
    patch: Number(match[3]),
    prerelease: match[4] ? match[4].split(".") : null,
  };
}

function comparePrerelease(a: string[], b: string[]): number {
  const length = Math.max(a.length, b.length);
  for (let i = 0; i < length; i++) {
    if (a[i] === undefined) return -1;
    if (b[i] === undefined) return 1;
    if (a[i] === b[i]) continue;

    const aNumeric = /^\\d+$/.test(a[i]);
    const bNumeric = /^\\d+$/.test(b[i]);
    if (aNumeric && bNumeric) {
      const an = Number(a[i]);
      const bn = Number(b[i]);
      if (an !== bn) return an > bn ? 1 : -1;
      continue;
    }
    if (aNumeric !== bNumeric) return aNumeric ? -1 : 1;
    return a[i] > b[i] ? 1 : -1;
  }
  return 0;
}

export function compareVersions(a: string, b: string): number {
  const va = parseVersion(a);
  const vb = parseVersion(b);
  if (!va || !vb) throw new Error("Invalid version format");

  for (const key of ["major", "minor", "patch"] as const) {
    if (va[key] !== vb[key]) return va[key] > vb[key] ? 1 : -1;
  }

  if (va.prerelease === null && vb.prerelease === null) return 0;
  if (va.prerelease === null) return 1;
  if (vb.prerelease === null) return -1;
  return comparePrerelease(va.prerelease, vb.prerelease);
}
