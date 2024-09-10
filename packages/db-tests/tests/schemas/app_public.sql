
\set schema $$'app_public'$$

begin;

select no_plan();

select tables_are(
  :schema,
  array[
    'users',
    'user_authentications',
    'posts'
  ]::text[]
);

select types_are(:schema, array[]::text[]);

select domains_are(:schema, array[]::text[]);

select enums_are(
  :schema,
  array[]::text[]
);

select functions_are(
  :schema,
  array[
    'forgot_password',
    'user_by_username_or_verified_email',
    'verify_user_email',
    'current_user',
    'current_user',
    'current_user_id_required',
    'current_user_id_or_null',
    'generate_url_safe_token',
    'reset_password'
    /* 'login', */
    /* 'register', */
    /* 'confirm', */
    /* 'resend_confirmation', */
    /* 'send_reset_password', */
    /* 'next_users_confirmation_token', */
    /* 'next_users_reset_password_token', */
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
