
\set role $$'app_user'$$
\set user_id $$'00000000-0000-0000-0000-000000000001'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name)
  values
  (:user_id, random_email(), random_string(), random_string());

set local role :role;
select is(current_user, :role);

select is_empty(
  'select id from app_public.users'
);

select finish();

rollback;
