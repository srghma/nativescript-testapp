
\set schema $$'app_public'$$
\set table $$'users'$$
\set role $$'app_user'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT'
  ]
);

SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT'
  ]
);

SELECT column_privs_are(:schema, :table, 'id',         :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'first_name', :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'last_name',  :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'created_at', :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'updated_at', :role, ARRAY['SELECT']);

select finish();

rollback;
