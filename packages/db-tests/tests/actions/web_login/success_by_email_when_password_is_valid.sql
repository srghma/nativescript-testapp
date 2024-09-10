\set role     $$'app_owner'$$
\set user_secret_id  $$'00000000-0000-0000-0000-000000000001'$$
\set user_id  $$'00000000-0000-0000-0000-000000000001'$$
\set email    $$'user@mail.com'$$
\set username $$'username2'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

INSERT INTO app_private.user_secrets (id, password_hash)
  VALUES (:user_secret_id, crypt(:password, gen_salt('bf')));

INSERT INTO app_public.users (id, user_secret_id, username)
  VALUES (:user_id, :user_secret_id, :username);

INSERT INTO app_hidden.user_emails (user_id, email, is_verified)
  VALUES (:user_id, :email, true);

set local role :role;
select is(current_user, :role);

prepare actual as
  select id from app_private.web_login(:email, :password);

prepare expected as values
  (:user_id::uuid);

select set_eq(
  'actual',
  'expected'
);

select finish();

rollback;
