create table app_hidden.user_emails (
  id uuid not null primary key default uuid_generate_v4(),
  user_id uuid not null references app_public.users on delete cascade,
  email citext not null check (email ~ '[^@]+@[^@]+\.[^@]+'),

  is_verified boolean not null default false,

  verification_token text check (app_hidden.biconditional_statement(is_verified = true, verification_token IS NULL)),

  -- if not yet verified - null (job didnt yet sent email) or not-null (job didnt yet process email sending request)
  -- if verified - only null
  verification_email_sent_at timestamptz check (app_hidden.implication(is_verified = true, verification_email_sent_at IS NULL)),

  -- if not verified - only null (only verified users can change password)
  -- if verified - null or not-null
  password_reset_email_sent_at timestamptz check (app_hidden.implication(is_verified = false, password_reset_email_sent_at IS NULL)),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique(user_id, email)
);

create unique index uniq_user_emails_verified_email on app_hidden.user_emails(email) where is_verified is true;

alter table app_hidden.user_emails enable row level security;

create trigger _100_timestamps
  before update on app_hidden.user_emails
  for each row
  execute function app_private.tg__set_updated_at();

-- `@omit all` because there's no point exposing `allUserEmails` - you can only
-- see your own, and having this behaviour can lead to bad practices from
-- frontend teams.

comment on table app_hidden.user_emails is
  E'@omit all\nInformation about a user''s email address.';

comment on column app_hidden.user_emails.email is
  E'The users email address, in `a@b.c` format.';

comment on column app_hidden.user_emails.is_verified is
  E'True if the user has is_verified their email address (by clicking the link in the email we sent them, or logging in with a social login provider), false otherwise.';

create policy select_own on app_hidden.user_emails for select using (true);
create policy insert_own on app_hidden.user_emails for insert with check (user_id = app_public.current_user_id_or_null());
create policy delete_own on app_hidden.user_emails for delete using (user_id = app_public.current_user_id_or_null()); -- TODO check this isn't the last one!

grant select on app_hidden.user_emails to app_anonymous, app_user;
grant insert (email) on app_hidden.user_emails to app_user;
grant delete on app_hidden.user_emails to app_user;
