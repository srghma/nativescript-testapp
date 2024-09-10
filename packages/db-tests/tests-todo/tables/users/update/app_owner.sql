
\set role $$'app_owner'$$
\set user1_id $$'00000000-0000-0000-0000-000000000001'$$
\set user2_id $$'00000000-0000-0000-0000-000000000002'$$

begin;

select no_plan();

insert into app_public.users
  (id, email, first_name, last_name)
  values
  (:user1_id, 'user@mail.com', random_string(), random_string()),
  (:user2_id, 'user2@mail.com', random_string(), random_string());

set local role :role;
set local jwt.claims.user_id to :user1_id;
select is(current_user, :role);

update app_public.users set email = 'new_user@mail.com' where id = :user1_id;
update app_public.users set email = 'new_user2@mail.com' where id = :user2_id;

-- cant update another user
prepare expected as values ('new_user@mail.com'), ('user2@mail.com');

select set_eq(
  'select email from app_public.users',
  'expected'
);

select finish();

rollback;
