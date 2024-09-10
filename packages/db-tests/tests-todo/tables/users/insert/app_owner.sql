
\set role $$'app_owner'$$
\set user1_id $$'00000000-0000-0000-0000-000000000001'$$
\set user2_id $$'00000000-0000-0000-0000-000000000002'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name)
  values
  (:user1_id, random_email(), random_string(), random_string());

set local role :role;
set local jwt.claims.user_id to :user1_id;
select is(current_user, :role);

prepare inserter as
  insert into app_public.users
  values (:user2_id, 'user2@mail.com', random_string(), random_string())
  returning *;

-- cant insert another user

select throws_ok('inserter');

select finish();

rollback;
