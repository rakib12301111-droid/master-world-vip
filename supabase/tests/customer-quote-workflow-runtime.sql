\set ON_ERROR_STOP on
begin;

insert into auth.users(id,email,confirmed_at)
values
 ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','quote-customer-a@example.invalid',now()),
 ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','quote-customer-b@example.invalid',now()),
 ('cccccccc-cccc-4ccc-8ccc-cccccccccccc','quote-admin@example.invalid',now())
on conflict(id) do nothing;

insert into public.app_user_roles(user_id,role)
values ('cccccccc-cccc-4ccc-8ccc-cccccccccccc','admin')
on conflict(user_id) do update set role='admin';

set local role authenticated;
select set_config('request.jwt.claim.sub','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',true);
select public.submit_my_customer_quote_request(
 'typing','Bangladesh','Please type and format a 5-page Bengali document.',
 'Within 5 days','BDT 1,000'
) as quote_id \gset
select set_config('mwvip.test_quote_id', :'quote_id', true);

do $$
begin
  if (select count(*) from public.customer_quote_requests
      where id=current_setting('mwvip.test_quote_id')::uuid and customer_user_id=auth.uid()) <> 1 then
    raise exception 'Customer A cannot read own quote request';
  end if;
end $$;

select set_config('request.jwt.claim.sub','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',true);
do $$
begin
  if (select count(*) from public.customer_quote_requests) <> 0 then
    raise exception 'Customer B can read another customer quote request';
  end if;
end $$;

select set_config('request.jwt.claim.sub','cccccccc-cccc-4ccc-8ccc-cccccccccccc',true);
do $$
begin
  if (select count(*) from public.customer_quote_requests) <> 1 then
    raise exception 'Admin cannot read quote inbox';
  end if;
end $$;

select public.admin_review_customer_quote_request(:'quote_id'::uuid,'under_review','Disposable runtime review');
select public.admin_send_customer_quote(
 :'quote_id'::uuid,1250.00,'BDT',
 'Type five pages in editable DOCX and provide one proofread revision.',
 5,now()+interval '7 days','Disposable runtime quote'
);

select set_config('request.jwt.claim.sub','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',true);
do $$
begin
  if not exists (
    select 1 from public.customer_quote_requests
    where id=current_setting('mwvip.test_quote_id')::uuid and status='quote_sent'
      and quote_amount=1250.00 and quote_currency='BDT'
  ) then raise exception 'Customer did not receive the quote'; end if;
end $$;
select public.customer_respond_to_quote(:'quote_id'::uuid,true);
do $$
begin
  if not exists (select 1 from public.customer_quote_requests
    where id=current_setting('mwvip.test_quote_id')::uuid and status='accepted') then
    raise exception 'Customer quote acceptance was not recorded';
  end if;
end $$;

select public.submit_my_customer_quote_request(
 'document_formatting','Bangladesh','Please format a short two-page report.'
) as cancel_quote_id \gset
select set_config('mwvip.test_cancel_quote_id', :'cancel_quote_id', true);
select public.cancel_my_customer_quote_request(:'cancel_quote_id'::uuid);
do $$
begin
  if not exists (select 1 from public.customer_quote_requests
    where id=current_setting('mwvip.test_cancel_quote_id')::uuid and status='cancelled') then
    raise exception 'Customer quote cancellation was not recorded';
  end if;
end $$;

-- Even the database owner cannot rewrite the append-only event history.
reset role;
do $$
begin
  begin
    update public.customer_quote_request_events
    set details='{"tampered":true}'::jsonb
    where request_id=current_setting('mwvip.test_quote_id')::uuid;
    raise exception 'Append-only quote event mutation unexpectedly succeeded';
  exception when others then
    if sqlerrm not like '%append-only%' then raise; end if;
  end;
end $$;

do $$
begin
  begin
    update public.customer_quote_requests
    set scope_description='tampered scope'
    where id=current_setting('mwvip.test_quote_id')::uuid;
    raise exception 'Customer quote scope mutation unexpectedly succeeded';
  exception when others then
    if sqlerrm not like '%identity and submitted scope are immutable%' then raise; end if;
  end;
  begin
    delete from public.customer_quote_requests
    where id=current_setting('mwvip.test_quote_id')::uuid;
    raise exception 'Customer quote deletion unexpectedly succeeded';
  exception when others then
    if sqlerrm not like '%cannot be deleted%' then raise; end if;
  end;
end $$;

rollback;
