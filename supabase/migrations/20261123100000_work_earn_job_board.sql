-- MASTER WORLD VIP — Work & Earn member job board
-- Additive migration. Apply only after the documented recoverable-backup and restore-test gate.
create table if not exists public.work_posts (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 4 and 100),
  category text not null check (category in (
    'Typing & Data Entry','Design & Creative','Writing & Translation',
    'Marketing & Sales','Development & IT','Education & Tutoring','Other'
  )),
  description text not null check (char_length(btrim(description)) between 20 and 3000),
  pay_type text not null check (pay_type in ('fixed','hourly','negotiable','volunteer')),
  pay_amount numeric(12,2),
  currency text not null default 'BDT' check (currency in ('BDT','USD')),
  location text not null default 'Remote' check (char_length(location) <= 120),
  status text not null default 'open' check (status in ('open','closed','removed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint work_posts_pay_amount_nonnegative check (pay_amount is null or pay_amount >= 0),
  constraint work_posts_pay_type_amount_check check (
    (pay_type in ('fixed','hourly') and pay_amount is not null)
    or (pay_type in ('negotiable','volunteer'))
  )
);

create table if not exists public.work_applications (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.work_posts(id) on delete cascade,
  applicant_id uuid not null references auth.users(id) on delete cascade,
  message text not null check (char_length(btrim(message)) between 20 and 1500),
  status text not null default 'pending' check (status in ('pending','accepted','rejected','withdrawn')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint work_applications_one_per_member unique(post_id,applicant_id)
);

create index if not exists work_posts_open_created_idx
  on public.work_posts(status,created_at desc);
create index if not exists work_posts_owner_created_idx
  on public.work_posts(owner_id,created_at desc);
create index if not exists work_applications_post_created_idx
  on public.work_applications(post_id,created_at desc);
create index if not exists work_applications_applicant_created_idx
  on public.work_applications(applicant_id,created_at desc);

alter table public.work_posts enable row level security;
alter table public.work_applications enable row level security;

drop policy if exists "members read open work posts" on public.work_posts;
create policy "members read open work posts" on public.work_posts
  for select to authenticated
  using (status='open' or owner_id=auth.uid() or public.has_role('admin'));

drop policy if exists "members create own work posts" on public.work_posts;
create policy "members create own work posts" on public.work_posts
  for insert to authenticated
  with check (owner_id=auth.uid() and status='open');

drop policy if exists "owners update own work posts" on public.work_posts;
create policy "owners update own work posts" on public.work_posts
  for update to authenticated
  using (owner_id=auth.uid() or public.has_role('admin'))
  with check (owner_id=auth.uid() or public.has_role('admin'));

drop policy if exists "owners delete own work posts" on public.work_posts;
create policy "owners delete own work posts" on public.work_posts
  for delete to authenticated
  using (owner_id=auth.uid() or public.has_role('admin'));

drop policy if exists "applicant or job owner reads applications" on public.work_applications;
create policy "applicant or job owner reads applications" on public.work_applications
  for select to authenticated
  using (
    applicant_id=auth.uid()
    or exists (
      select 1 from public.work_posts wp
      where wp.id=work_applications.post_id
        and (wp.owner_id=auth.uid() or public.has_role('admin'))
    )
  );

drop policy if exists "members apply to open work" on public.work_applications;
create policy "members apply to open work" on public.work_applications
  for insert to authenticated
  with check (
    applicant_id=auth.uid()
    and status='pending'
    and exists (
      select 1 from public.work_posts wp
      where wp.id=work_applications.post_id
        and wp.status='open'
        and wp.owner_id<>auth.uid()
    )
  );

-- Job owners can accept/reject only applications for their own posts.
create or replace function public.review_work_application(p_application_id uuid,p_status text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare v_owner uuid;
begin
  if auth.uid() is null or p_status not in ('accepted','rejected') then
    raise exception 'Not authorized or invalid status';
  end if;
  select wp.owner_id into v_owner
  from public.work_applications wa
  join public.work_posts wp on wp.id=wa.post_id
  where wa.id=p_application_id and wa.status='pending'
  for update of wa;
  if v_owner is null or (v_owner<>auth.uid() and not public.has_role('admin')) then
    raise exception 'Only the job owner or admin can review this application';
  end if;
  update public.work_applications
  set status=p_status,updated_at=now()
  where id=p_application_id and status='pending';
  return found;
end;
$$;
revoke all on function public.review_work_application(uuid,text) from public,anon;
grant execute on function public.review_work_application(uuid,text) to authenticated;

create or replace function public.withdraw_work_application(p_application_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  update public.work_applications
  set status='withdrawn',updated_at=now()
  where id=p_application_id and applicant_id=auth.uid() and status='pending';
  return found;
end;
$$;
revoke all on function public.withdraw_work_application(uuid) from public,anon;
grant execute on function public.withdraw_work_application(uuid) to authenticated;

drop trigger if exists work_posts_touch_updated_at on public.work_posts;
create trigger work_posts_touch_updated_at before update on public.work_posts
  for each row execute function public.touch_updated_at();

-- No public/anonymous access, no payment handling, no client access to other members' private applications.
