-- MASTER WORLD VIP — payout reference integrity hardening
-- Prevent duplicate "Paid" records and require a real transfer reference + audit metadata.
-- This migration does not initiate payments or create wallet funds.

do $$
begin
  if exists (
    select 1
    from public.referral_withdrawal_requests
    where status='paid'
      and (
        nullif(btrim(coalesce(payment_reference,'')),'') is null
        or char_length(btrim(payment_reference)) < 4
        or char_length(btrim(payment_reference)) > 120
        or paid_at is null
        or reviewed_by is null
      )
  ) then
    raise exception 'Payout hardening stopped: existing Paid withdrawal rows need a valid reference, paid_at, and reviewer before this migration can continue.';
  end if;

  if exists (
    select 1
    from public.referral_withdrawal_requests
    where status='paid'
      and nullif(btrim(coalesce(payment_reference,'')),'') is not null
    group by payout_method, lower(btrim(payment_reference))
    having count(*) > 1
  ) then
    raise exception 'Payout hardening stopped: duplicate Paid transfer references exist for the same payout method. Review them before retrying.';
  end if;
end;
$$;

create unique index if not exists referral_withdrawal_paid_reference_unique_idx
  on public.referral_withdrawal_requests(payout_method, lower(btrim(payment_reference)))
  where status='paid'
    and nullif(btrim(payment_reference),'') is not null;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname='referral_paid_requires_transfer_audit'
      and conrelid='public.referral_withdrawal_requests'::regclass
  ) then
    alter table public.referral_withdrawal_requests
      add constraint referral_paid_requires_transfer_audit
      check (
        status <> 'paid'
        or (
          nullif(btrim(coalesce(payment_reference,'')),'') is not null
          and char_length(btrim(payment_reference)) between 4 and 120
          and paid_at is not null
          and reviewed_by is not null
        )
      );
  end if;
end;
$$;

comment on index public.referral_withdrawal_paid_reference_unique_idx is
  'Blocks reuse of a bKash/Nagad transfer reference across Paid withdrawal records for the same payout method.';
