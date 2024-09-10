
\set schema $$'app_public'$$
\set table $$'user_oauths'$$
\set role $$'app_owner'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'DELETE'
  ]
);

-- TODO: what is this?
SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT'
  ]
);

SELECT column_privs_are(:schema, :table, 'id',                 :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'user_id',            :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'service',            :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'service_identifier', :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'created_at',         :role, ARRAY['SELECT']);
SELECT column_privs_are(:schema, :table, 'updated_at',         :role, ARRAY['SELECT']);

select finish();

rollback;
