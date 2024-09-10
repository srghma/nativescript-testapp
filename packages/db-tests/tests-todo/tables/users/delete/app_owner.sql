
\set role $$'app_owner'$$
\set user1_id $$'00000000-0000-0000-0000-000000000001'$$
\set user2_id $$'00000000-0000-0000-0000-000000000002'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name)
  values
  (:user1_id, random_email(), random_string(), random_string()),
  (:user2_id, random_email(), random_string(), random_string());

set local role :role;
set local jwt.claims.user_id to :user1_id;
select is(current_user, :role);

delete from app_public.users where id in (:user1_id, :user2_id);
-- cant delete another user
prepare expected as values(:user2_id :: uuid);

select set_eq(
  'select id from app_public.users',
  'expected'
);

select finish();

rollback;
