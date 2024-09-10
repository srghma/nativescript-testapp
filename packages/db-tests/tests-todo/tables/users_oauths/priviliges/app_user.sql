
\set schema $$'app_public'$$
\set table $$'user_oauths'$$
\set role $$'app_user'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[]::text[]
);

SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[]::text[]
);

SELECT column_privs_are(:schema, :table, 'id',                 :role, ARRAY[]::text[]);
SELECT column_privs_are(:schema, :table, 'user_id',            :role, ARRAY[]::text[]);
SELECT column_privs_are(:schema, :table, 'service',            :role, ARRAY[]::text[]);
SELECT column_privs_are(:schema, :table, 'service_identifier', :role, ARRAY[]::text[]);
SELECT column_privs_are(:schema, :table, 'created_at',         :role, ARRAY[]::text[]);
SELECT column_privs_are(:schema, :table, 'updated_at',         :role, ARRAY[]::text[]);

select finish();

rollback;
