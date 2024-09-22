create table app_private.user_secrets (
  id uuid not null primary key default uuid_generate_v4(),
  password_hash text,
  reset_password_token text,
  reset_password_token_generated_at timestamptz,
  first_failed_reset_password_attempt timestamptz,
  first_failed_password_attempt timestamptz,
  reset_password_attempts int default 0 not null,
  password_attempts int4 default 0 not null
);

alter table app_private.user_secrets enable row level security;

comment on table app_private.user_secrets is
  E'The contents of this table should never be visible to the user. Contains data mostly related to authentication.';
