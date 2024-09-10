\set schema $$'app_public'$$
\set func $$'current_user'$$
\set args $$'{}'$$::text[]

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
