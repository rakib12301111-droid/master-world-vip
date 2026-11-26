-- MASTER WORLD VIP release metadata for the in-app update checker.
-- Preserve compatibility with the existing Update Center table and UUID primary keys.

create table if not exists public.update_releases (
  id uuid primary key default gen_random_uuid(),
  version text not null unique,
  release_notes text default '',
  manifest_url text,
  status text not null default 'draft'
    check (status in ('draft','published','withdrawn')),
  created_at timestamptz not null default now(),
  published_at timestamptz,
  constraint update_releases_semver_check
    check (version ~ '^v?[0-9]+[.][0-9]+[.][0-9]+(-[0-9A-Za-z.-]+)?([+][0-9A-Za-z.-]+)?$')
);

-- Existing installations may have created this table before migration history
-- was adopted. Keep UUID IDs and extra manifest_url data; never rebuild the table.
alter table public.update_releases alter column release_notes set default '';
do $migration$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.update_releases'::regclass
      and conname = 'update_releases_semver_check'
  ) then
    alter table public.update_releases
      add constraint update_releases_semver_check
      check (version ~ '^v?[0-9]+[.][0-9]+[.][0-9]+(-[0-9A-Za-z.-]+)?([+][0-9A-Za-z.-]+)?$')
      not valid;
  end if;
end;
$migration$;

create index if not exists update_releases_published_idx
  on public.update_releases(published_at desc nulls last,created_at desc)
  where status='published';

alter table public.update_releases enable row level security;
revoke all on public.update_releases from anon, authenticated;
grant select on public.update_releases to anon, authenticated;

drop policy if exists "Read published releases" on public.update_releases;
drop policy if exists "clients read published releases" on public.update_releases;
create policy "clients read published releases"
  on public.update_releases for select to anon, authenticated
  using (status='published');

-- Publishing is intentionally a trusted operator action, never a browser action:
-- insert into public.update_releases(version,release_notes,status,published_at)
-- values ('3.3.0','Initial 3.3.0 release notes','published',now());
