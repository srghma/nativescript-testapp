\set schema $$'app_public'$$
\set func $$'user_by_username_or_verified_email'$$
\set args $$'{text}'$$::text[]

begin;

select no_plan();

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_owner',
  '{"EXECUTE"}'
);

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_user',
  '{"EXECUTE"}'
);

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_anonymous',
  '{"EXECUTE"}'
);

select finish();

rollback;
