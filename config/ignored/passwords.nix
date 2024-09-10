{
  # superuser
  POSTGRES_PASSWORD="app_admin_pass";

  # for migrations
  DATABASE_OWNER_PASSWORD="app_owner_pass";

  # Password for the app_anonymous user, which has very limited privileges, but can switch into app_user
  DATABASE_ANONYMOUS_PASSWORD="app_anonymous_pass";

  # This secret is used for signing cookies
  # why this length - https://stackoverflow.com/a/64702641/3574379
  SESSION_SECRET="very_very_very_very_very_very_very_very_very_long_session_secret";

  # This secret is used for signing JWT tokens (we don't use this by default)
  JWT_SECRET="very_very_very_very_very_very_very_very_very_long_jwt_secret";
}
