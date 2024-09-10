
\set schema $$'app_public'$$ :: name
\set table $$'posts'$$ :: name
\set role $$'app_user'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY['SELECT']::text[]
);

SELECT any_column_privs_are(
  :schema,
  :table,
  :role,
  ARRAY['SELECT']::text[]
);

SELECT column_privs_are(:schema, :table, col, :role, ARRAY['SELECT']::text[])
FROM (
  VALUES('id'), ('name'), ('user_id'), ('content'), ('created_at'), ('updated_at')
) AS tableAlias (col);


select finish();

rollback;
