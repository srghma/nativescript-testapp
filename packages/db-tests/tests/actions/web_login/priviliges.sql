\set schema $$'app_private'$$
\set func $$'web_login'$$
\set args $$'{"text", "text"}'$$::text[]

begin;

select no_plan();

SELECT function_privs_are(
  :schema,
  :func,
  :args,
  'app_admin',
  '{"EXECUTE"}'
);

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
