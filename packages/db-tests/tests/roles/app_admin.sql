\set role $$'app_admin'$$

begin;

select no_plan();

select database_privs_are(
  current_database(),
  :role,
  array['CONNECT', 'TEMPORARY', 'CREATE']
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
  array['USAGE', 'CREATE']
);

select schema_privs_are(
  'app_private',
  :role,
  array['USAGE', 'CREATE']
);

select finish();

rollback;
