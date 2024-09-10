
\set schema $$'app_public'$$
\set table $$'user_oauths'$$
\set role $$'app_admin'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'DELETE',
    'INSERT',
    'REFERENCES',
    'TRIGGER',
    'TRUNCATE',
    'UPDATE'
  ]
);

SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'UPDATE',
    'INSERT',
    'REFERENCES'
  ]
);

SELECT column_privs_are(:schema, :table, 'id',                 :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'user_id',            :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'service',            :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'service_identifier', :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'created_at',         :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);
SELECT column_privs_are(:schema, :table, 'updated_at',         :role, ARRAY['SELECT', 'INSERT', 'REFERENCES', 'UPDATE']);

select finish();

rollback;
