-- MASTER WORLD VIP release metadata for the in-app update checker.
-- Apply after the core foundation. Published releases are readable by app clients;
-- release creation remains an owner/service-role operation in Supabase SQL Editor.

create table if not exists public.update_releases (
  id bigint generated always as identity primary key,
  version text not null unique,
  release_notes text not null default '',
  status text not null default 'draft'
    check (status in ('draft','published','withdrawn')),
  created_at timestamptz not null default now(),
  published_at timestamptz,
  constraint update_releases_semver_check
    check (version ~ '^v?[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?(\\+[0-9A-Za-z.-]+)?$')
);

create index if not exists update_releases_published_idx
  on public.update_releases(published_at desc nulls last,created_at desc)
  where status='published';

alter table public.update_releases enable row level security;
revoke all on public.update_releases from anon, authenticated;
grant select on public.update_releases to anon, authenticated;

drop policy if exists "clients read published releases" on public.update_releases;
create policy "clients read published releases"
  on public.update_releases for select to anon, authenticated
  using (status='published');

-- Publishing is intentionally a trusted operator action, never a browser action:
-- insert into public.update_releases(version,release_notes,status,published_at)
-- values ('3.3.0','Initial 3.3.0 release notes','published',now());
