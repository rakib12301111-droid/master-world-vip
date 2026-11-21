-- Consent-based live member location lookup. Verified phone numbers only.
create table if not exists public.member_location_shares (
  user_id uuid primary key references auth.users(id) on delete cascade,
  sharing_enabled boolean not null default false,
  latitude double precision,
  longitude double precision,
  accuracy_m real,
  updated_at timestamptz,
  created_at timestamptz not null default now(),
  check (latitude is null or latitude between -90 and 90),
  check (longitude is null or longitude between -180 and 180),
  check ((latitude is null) = (longitude is null))
);
create table if not exists public.member_location_audit (
  id bigint generated always as identity primary key,
  actor_id uuid references auth.users(id) on delete set null,
  target_user_id uuid references auth.users(id) on delete set null,
  action text not null check (action in ('sharing_enabled','sharing_disabled','lookup')),
  created_at timestamptz not null default now()
);
alter table public.member_location_shares enable row level security;
alter table public.member_location_audit enable row level security;
revoke all on public.member_location_shares from anon, authenticated;
revoke all on public.member_location_audit from anon, authenticated;

create or replace function public.set_my_location_sharing(p_enabled boolean)
returns boolean language plpgsql security definer set search_path = '' as $$
declare v_user uuid := auth.uid();
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  insert into public.member_location_shares(user_id,sharing_enabled)
  values(v_user,coalesce(p_enabled,false))
  on conflict(user_id) do update set
    sharing_enabled=excluded.sharing_enabled,
    latitude=case when excluded.sharing_enabled then public.member_location_shares.latitude else null end,
    longitude=case when excluded.sharing_enabled then public.member_location_shares.longitude else null end,
    accuracy_m=case when excluded.sharing_enabled then public.member_location_shares.accuracy_m else null end,
    updated_at=case when excluded.sharing_enabled then public.member_location_shares.updated_at else null end;
  insert into public.member_location_audit(actor_id,target_user_id,action)
  values(v_user,v_user,case when p_enabled then 'sharing_enabled' else 'sharing_disabled' end);
  return coalesce(p_enabled,false);
end;
$$;

create or replace function public.update_my_live_location(p_latitude double precision,p_longitude double precision,p_accuracy_m real default null)
returns timestamptz language plpgsql security definer set search_path = '' as $$
declare v_user uuid := auth.uid(); v_updated timestamptz;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  if p_latitude is null or p_longitude is null or p_latitude < -90 or p_latitude > 90 or p_longitude < -180 or p_longitude > 180 then raise exception 'Invalid GPS coordinates'; end if;
  if p_accuracy_m is not null and (p_accuracy_m < 0 or p_accuracy_m > 100000) then raise exception 'Invalid GPS accuracy'; end if;
  update public.member_location_shares set latitude=p_latitude,longitude=p_longitude,accuracy_m=p_accuracy_m,updated_at=now()
   where user_id=v_user and sharing_enabled=true returning updated_at into v_updated;
  if v_updated is null then raise exception 'Location sharing is not enabled'; end if;
  return v_updated;
end;
$$;

create or replace function public.lookup_member_location_by_phone(p_phone text)
returns table(display_name text,status text,latitude double precision,longitude double precision,accuracy_m real,updated_at timestamptz)
language plpgsql security definer set search_path = '' as $$
declare
  v_caller uuid := auth.uid();
  v_digits text := regexp_replace(coalesce(p_phone,''),'[^0-9]','','g');
  v_target uuid;
  v_name text;
  v_share public.member_location_shares%rowtype;
begin
  if v_caller is null then raise exception 'Authentication required'; end if;
  if length(v_digits)<8 or length(v_digits)>15 then raise exception 'Enter a valid international phone number'; end if;
  if (select count(*) from public.member_location_audit a where a.actor_id=v_caller and a.action='lookup' and a.created_at>now()-interval '1 minute')>=10 then
    raise exception 'Too many searches. Please wait one minute.';
  end if;
  select u.id,coalesce(p.display_name,'Member') into v_target,v_name
    from auth.users u left join public.profiles p on p.id=u.id
   where u.phone_confirmed_at is not null and regexp_replace(coalesce(u.phone,''),'[^0-9]','','g')=v_digits limit 1;
  insert into public.member_location_audit(actor_id,target_user_id,action) values(v_caller,v_target,'lookup');
  if v_target is null then return; end if;
  select * into v_share from public.member_location_shares s where s.user_id=v_target;
  if v_share.user_id is not null and v_share.sharing_enabled=true and v_share.updated_at is not null and v_share.updated_at>now()-interval '2 minutes' then
    return query select v_name,'online',v_share.latitude,v_share.longitude,v_share.accuracy_m,v_share.updated_at;
  else
    return query select v_name,'offline',null::double precision,null::double precision,null::real,case when v_share.sharing_enabled then v_share.updated_at else null end;
  end if;
end;
$$;
revoke all on function public.set_my_location_sharing(boolean) from public,anon;
revoke all on function public.update_my_live_location(double precision,double precision,real) from public,anon;
revoke all on function public.lookup_member_location_by_phone(text) from public,anon;
grant execute on function public.set_my_location_sharing(boolean) to authenticated;
grant execute on function public.update_my_live_location(double precision,double precision,real) to authenticated;
grant execute on function public.lookup_member_location_by_phone(text) to authenticated;
comment on table public.member_location_shares is 'Private consent-based GPS sharing. No direct client table access; only approved RPCs.';
