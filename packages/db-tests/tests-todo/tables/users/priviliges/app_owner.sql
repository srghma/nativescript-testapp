
\set schema $$'app_public'$$
\set table $$'users'$$
\set role $$'app_owner'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'DELETE',
    'UPDATE'
  ]
);

-- TODO: what is this?
SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'UPDATE'
  ]
);

-- TODO: what is this too?
SELECT column_privs_are(:schema, :table, 'id',         :role, ARRAY['SELECT', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'first_name', :role, ARRAY['SELECT', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'last_name',  :role, ARRAY['SELECT', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'created_at', :role, ARRAY['SELECT', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'updated_at', :role, ARRAY['SELECT', 'UPDATE']);

select finish();

rollback;
