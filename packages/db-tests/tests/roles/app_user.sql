\set role $$'app_user'$$

begin;

select no_plan();

select database_privs_are(
  current_database(),
  :role,
  array['CONNECT', 'TEMPORARY']::text[]
);

-- TODO: should create?
select schema_privs_are(
  'public',
  :role,
  array['USAGE', 'CREATE']
);

select schema_privs_are(
  'app_public',
  :role,
  array['USAGE']
);

select schema_privs_are(
  'app_private',
  :role,
  array[]::text[]
);

select finish();

rollback;
