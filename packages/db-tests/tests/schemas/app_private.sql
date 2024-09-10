
\set schema $$'app_private'$$

begin;

select no_plan();

select tables_are(
  :schema,
  array[
    'user_authentication_secrets',
    'user_secrets',
    'user_sessions'
  ]::text[]
);

select types_are(:schema, array[]::text[]);

select domains_are(:schema, array[]::text[]);

select enums_are(:schema, array[]::text[]);

select functions_are(
  :schema,
  array[
    'tg__set_updated_at',
    'link_or_register_user',
    'web_login',
    'really_create_user',
    'register_user'
    /* 'tg_send_verification_email_for_user_email', */
    /* 'tg_user_email_secrets__insert_with_user_email', */
    /* 'tg_user_secrets__insert_with_user', */
    /* 'tg_users__make_first_user_admin' */
  ]::text[]
);

select views_are(
  :schema,
  array[]::text[]
);

select materialized_views_are(
  :schema,
  array[]::text[]
);

select finish();

rollback;
