-- Customer feedback and complaint moderation for Facebook Setup Service.
create table if not exists public.facebook_setup_feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  display_name text not null check (char_length(trim(display_name)) between 2 and 60),
  feedback_type text not null check (feedback_type in ('review','complaint','suggestion')),
  rating integer not null check (rating between 1 and 5),
  message text not null check (char_length(trim(message)) between 3 and 1200),
  status text not null default 'pending' check (status in ('pending','published','rejected')),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null
);
create index if not exists facebook_setup_feedback_public_idx
 on public.facebook_setup_feedback(status,created_at desc);
alter table public.facebook_setup_feedback enable row level security;
revoke all on public.facebook_setup_feedback from anon, public;
grant select,insert,update on public.facebook_setup_feedback to authenticated;

drop policy if exists "public read published feedback" on public.facebook_setup_feedback;
create policy "public read published feedback" on public.facebook_setup_feedback
 for select to authenticated using(status='published');

drop policy if exists "members submit feedback" on public.facebook_setup_feedback;
create policy "members submit feedback" on public.facebook_setup_feedback
 for insert to authenticated with check(
  user_id=(select auth.uid()) and status='pending'
  and reviewed_at is null and reviewed_by is null
 );

drop policy if exists "admins review feedback" on public.facebook_setup_feedback;
create policy "admins review feedback" on public.facebook_setup_feedback
 for select to authenticated using(
  public.get_my_admin_access() in ('owner','super_admin','admin')
 );

drop policy if exists "admins update feedback moderation" on public.facebook_setup_feedback;
create policy "admins update feedback moderation" on public.facebook_setup_feedback
 for update to authenticated
 using(public.get_my_admin_access() in ('owner','super_admin','admin'))
 with check(public.get_my_admin_access() in ('owner','super_admin','admin'));

comment on table public.facebook_setup_feedback is
 'Moderated customer reviews, suggestions and complaints. Genuine complaints must not be hidden solely for being negative.';
