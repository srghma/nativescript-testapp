
\set schema $$'app_hidden'$$

begin;

select no_plan();

select tables_are(
  :schema,
  array['user_emails']::text[]
);

select types_are(:schema, array[]::text[]);

select domains_are(:schema, array[]::text[]);

select enums_are( :schema, array[]::text[]);

select functions_are(
  :schema,
  array[
    'biconditional_statement',
    'implication',
    'is_from_0_to_100'
  ]::text[]
);

select views_are(
  :schema,
  array[]::text[]
);

select materialized_views_are(
  :schema,
  array[]::text[]
);

select finish();

rollback;
