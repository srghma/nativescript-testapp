
\set schema $$'app_public'$$ :: name
\set table $$'users'$$ :: name

begin;

select no_plan();

select has_table(:schema, :table);

select columns_are(
  :schema,
  :table,
  '{
    "id",
    "first_name",
    "last_name",
    "email",
    "password_hash",
    "confirmation_token",
    "avatar_url",
    "is_confirmed",
    "reset_password_token",
    "reset_password_token_generated",
    "created_at",
    "updated_at"
  }'
);

select indexes_are(
  :schema,
  :table,
  '{
    "users_pkey",
    "users_email_key",
    "users_confirmation_token_key",
    "users_reset_password_token_key"
  }'
);

/*
  rules are like triggers, but faster (https://www.postgresql.org/docs/8.2/rules-triggers.html)

  A trigger is fired for any affected row once. A rule manipulates the query or generates an additional query.

  triggers are better than rules because:
  - with rule you can't implement constraints that throw error (e.g. on INSERT), but can with triggers

  rules are better than triggers because:
  - trigger cannot insert data on UPDATE or DELETE (because there is no real data in the view relation that could be scanned, and thus the trigger would never get called)
 */

select rules_are(
  :schema,
  :table,
  '{}'
);

select triggers_are(
  :schema,
  :table,
  '{
    "set_updated_at"
  }'
);

select finish();

rollback;
