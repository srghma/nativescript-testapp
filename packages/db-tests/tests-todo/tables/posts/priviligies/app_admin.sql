
\set schema $$'app_public'$$ :: name
\set table $$'posts'$$ :: name
\set role $$'app_admin'$$

begin;

select no_plan();

SELECT table_privs_are(
  :schema,
  :table,
  :role,
  ARRAY[
    'SELECT',
    'INSERT',
    'UPDATE',
    'DELETE',
    'REFERENCES',
    'TRIGGER',
    'TRUNCATE'
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

SELECT column_privs_are(:schema, :table, col, :role, ARRAY['SELECT', 'UPDATE', 'INSERT', 'REFERENCES'])
FROM (
  VALUES('id'), ('name'), ('user_id'), ('content'), ('created_at'), ('updated_at')
) AS tableAlias (col);


select finish();

rollback;
