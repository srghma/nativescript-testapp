#!/bin/bash
set -e

# Read environment variables
DATABASE_OWNER_PASSWORD=${DATABASE_OWNER_PASSWORD:-""}  # Default to empty string
DATABASE_ANONYMOUS_PASSWORD=${DATABASE_ANONYMOUS_PASSWORD:-""}
DATABASE_NAME=${DATABASE_NAME:-""}
IS_PRODUCTION=${IS_PRODUCTION:-""}

# Check for required variables
if [[ -z "$DATABASE_OWNER_PASSWORD" || -z "$DATABASE_ANONYMOUS_PASSWORD" || -z "$DATABASE_NAME" ]]; then
  echo "Error: Missing required environment variables: DATABASE_OWNER_PASSWORD, DATABASE_ANONYMOUS_PASSWORD, DATABASE_NAME"
  exit 1
fi

# Define logic for maybeSuperuser and maybeRevokePublic based on environment variable
maybeSuperuser=""
if [[ "$IS_PRODUCTION" != "true" ]]; then
  maybeSuperuser="SUPERUSER"
fi

maybeRevokePublic=""
if [[ "$IS_PRODUCTION" == "true" ]]; then
  # for db tests
  maybeRevokePublic="REVOKE ALL ON DATABASE ${DATABASE_NAME} FROM public;"
fi

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  # Now to set up the database cleanly:
  # Ref: https://devcenter.heroku.com/articles/heroku-postgresql#connection-permissions

  # This is the root role for the database
  # IMPORTANT: don't grant SUPERUSER in production, we only need this so we can load the watch fixtures!
  CREATE ROLE app_owner WITH LOGIN PASSWORD '${DATABASE_OWNER_PASSWORD}' ${maybeSuperuser};

  # This is the no-access role that PostGraphile will run as by default
  CREATE ROLE app_anonymous WITH LOGIN PASSWORD '${DATABASE_ANONYMOUS_PASSWORD}' NOINHERIT;

  # This is the role that PostGraphile will switch to (from app_anonymous) during a GraphQL request
  CREATE ROLE app_user;

  # This enables PostGraphile to switch from app_anonymous to app_user
  GRANT app_user TO app_anonymous;

  # Here's our main database
  CREATE DATABASE ${DATABASE_NAME} OWNER app_owner;
  ${maybeRevokePublic}
  GRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_owner;
 aGRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_anonymous;
  GRANT ALL ON DATABASE ${DATABASE_NAME} TO app_owner;

  # Some extensions require superuser privileges, so we create them before migration time.
  \\connect ${DATABASE_NAME}
  CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
  CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
  CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
EOSQL
