\set role $$'app_anonymous'$$

begin;

select no_plan();

select database_privs_are(
  current_database(),
  :role,
  array['CONNECT', 'TEMPORARY']::text[]
);

select schema_privs_are(
  'public',
  :role,
  array['USAGE', 'CREATE']::text[]
);

select schema_privs_are(
  'app_public',
  :role,
  array['USAGE']::text[]
);

select schema_privs_are(
  'app_private',
  :role,
  array[]::text[]
);

select finish();

rollback;
