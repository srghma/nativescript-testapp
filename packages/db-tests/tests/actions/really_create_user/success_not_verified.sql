\set role     $$'app_owner'$$
\set email    $$'user@mail.com'$$
\set username $$'username2'$$
\set password $$'secret_pass'$$

begin;

select no_plan();

set local role :role;
select is(current_user, :role);

prepare actual as
  select username from app_private.really_create_user(
    username          => :username,
    email             => :email,
    email_is_verified => false,
    name              => null,
    avatar_url        => null,
    password          => :password
  );

prepare expected as values
  (:username);

select set_eq(
  'actual',
  'expected'
);

set local role 'app_admin';

select set_eq(
  'select task_identifier from "graphile_worker".jobs',
  ARRAY['JOB__SEND_VERIFICATION_EMAIL_FOR_USER_EMAIL']
);

select finish();

rollback;
