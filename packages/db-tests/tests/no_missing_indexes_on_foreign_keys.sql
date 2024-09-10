-- check for fks where there is no matching index
-- on the referencing side
-- or a bad index

begin;

select plan(1);

-- this is what you want
select is_empty('select find_missing_indexes_on_foreign_keys()');

-- but sometimes you'll want it to return non-empty records

/* select set_eq( */
/*    -- no need to create this index, because unique constraint creates it */
/*   'select * from find_missing_indexes_on_foreign_keys()', */
/*   $$values */
/*     ( */
/*       'app_public'::name, */
/*       'users__mtm__projects'::name, */
/*       'users__mtm__projects_project_id_fkey'::name, */
/*       'no index', */
/*       'projects'::name */
/*     ) */
/*   $$ */
/* ); */

select finish();

rollback;
