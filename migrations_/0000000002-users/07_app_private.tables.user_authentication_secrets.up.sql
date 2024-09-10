create table app_private.user_authentication_secrets (
  user_authentication_id uuid not null primary key references app_public.user_authentications on delete cascade default uuid_generate_v4(),
  details jsonb not null default '{}'::jsonb
);

alter table app_private.user_authentication_secrets enable row level security;

-- NOTE: user_authentication_secrets doesn't need an auto-inserter as we handle
-- that everywhere that can create a user_authentication row.
