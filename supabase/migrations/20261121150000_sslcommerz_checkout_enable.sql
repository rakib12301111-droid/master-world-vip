-- Enable SSLCOMMERZ hosted checkout for Facebook setup assistance.
-- Provider credentials remain Edge Function secrets; never place them in client code.
alter table public.facebook_setup_orders
  drop constraint if exists facebook_setup_orders_payment_method_check;
alter table public.facebook_setup_orders
  add constraint facebook_setup_orders_payment_method_check
  check (payment_method in ('nagad','bkash','sslcommerz'));

comment on column public.facebook_setup_orders.payment_status is
  'Only the server-side SSLCOMMERZ validation function may set paid; browser redirects and manual transaction IDs never qualify.';
