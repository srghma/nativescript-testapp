SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")

cat > $SCRIPT_DIR/passwords.nix <<CONFIG
{
  # superuser
  POSTGRES_PASSWORD="$(openssl rand -base64 48 | tr '+/' '-_')";

  # for migrations
  DATABASE_OWNER_PASSWORD="$(openssl rand -base64 48 | tr '+/' '-_')";

  # Password for the app_anonymous user, which has very limited privileges, but can switch into app_user
  DATABASE_ANONYMOUS_PASSWORD="$(openssl rand -base64 48 | tr '+/' '-_')";

  # This secret is used for signing cookies
  # why this length - https://stackoverflow.com/a/64702641/3574379
  SESSION_SECRET="$(openssl rand -base64 256)";

  # This secret is used for signing JWT tokens (we don't use this by default)
  JWT_SECRET="$(openssl rand -base64 256)";
}
CONFIG
