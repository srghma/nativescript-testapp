
\set schema $$'app_public'$$ :: name
\set table $$'posts'$$ :: name

begin;

select no_plan();

select has_table(:schema, :table);

select columns_are(
  :schema,
  :table,
  ARRAY[
    'id',
    'user_id',
    'name',
    'content',
    'created_at',
    'updated_at'
  ]
);

select indexes_are(
  :schema,
  :table,
  ARRAY[
    'posts_pkey',
    'app_public_posts_user_id'
  ]
);

select rules_are(
  :schema,
  :table,
  ARRAY[]::text[]
);

select triggers_are(
  :schema,
  :table,
  ARRAY['set_updated_at']
);

select finish();

rollback;
