
begin;

select no_plan();

select is(current_user, 'app_admin');
select db_owner_is(current_database(), 'app_owner');

select tablespaces_are(array[
  'pg_global',
  'pg_default'
]);

select schemas_are(array[
  'public',
  'app_public',
  'app_hidden',
  'app_private',
  'postgraphile_watch',
  'graphile_worker'
]);

select roles_are(array[
  'app_admin',
  'app_user',
  'app_owner',
  'app_anonymous',
  'pg_stat_scan_tables',
  'pg_read_all_settings',
  'pg_signal_backend',
  'pg_read_all_stats',
  'pg_monitor',
  'pg_execute_server_program',
  'pg_read_server_files',
  'pg_write_server_files'
]);

select users_are(array[
  'app_owner',
  'app_anonymous',
  'app_admin'
]);

select groups_are(array[
  'app_user',
  'pg_stat_scan_tables',
  'pg_read_all_settings',
  'pg_signal_backend',
  'pg_read_all_stats',
  'pg_monitor',
  'pg_execute_server_program',
  'pg_read_server_files',
  'pg_write_server_files'
]);

select languages_are(array[
  'plpgsql'
]);

-- tables from other servers
-- https://www.postgresql.org/docs/9.3/ddl-foreign-data.html
select foreign_tables_are(
  array[]::text[]
);

select finish();

rollback;
