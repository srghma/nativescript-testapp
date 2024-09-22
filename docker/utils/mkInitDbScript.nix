{
  writeTextFile,
  DATABASE_OWNER_PASSWORD,
  DATABASE_ANONYMOUS_PASSWORD,
  DATABASE_NAME,
  DATABASE_SHADOW_NAME,
  IS_PRODUCTION,
}: let
  revokePublicSQL =
    if IS_PRODUCTION == "true"
    then ''
      REVOKE ALL ON DATABASE ${DATABASE_NAME} FROM public;
    ''
    else "";

  maybeSuperuser =
    if IS_PRODUCTION != "true"
    then "SUPERUSER"
    else "";
in
  writeTextFile {
    name = "init.sql";
    text = ''
      -- Create the main owner role for the database
      -- Don't grant SUPERUSER in production; we need it only for setup here
      CREATE ROLE app_owner WITH LOGIN PASSWORD '${DATABASE_OWNER_PASSWORD}' ${maybeSuperuser};

      -- This is the no-access role that the application (PostGraphile, for example) will run as by default
      CREATE ROLE app_anonymous WITH LOGIN PASSWORD '${DATABASE_ANONYMOUS_PASSWORD}' NOINHERIT;

      -- This is the role that will have database access during a request
      CREATE ROLE app_user;

      -- Enable the application to switch from app_anonymous to app_user during requests
      GRANT app_user TO app_anonymous;

      -- Create the main database and set ownership to the owner role
      CREATE DATABASE ${DATABASE_NAME} OWNER app_owner;
      -- Create a shadow database for testing or staging purposes
      CREATE DATABASE ${DATABASE_SHADOW_NAME} OWNER app_owner;

      -- Revoke default public access (optional, depends on security requirements)
      ${revokePublicSQL}

      -- Grant permissions to the app_owner role
      GRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_owner;
      GRANT CONNECT ON DATABASE ${DATABASE_NAME} TO app_anonymous;
      GRANT ALL ON DATABASE ${DATABASE_NAME} TO app_owner;

      -- Connect to the main database and create extensions
      \connect ${DATABASE_NAME}
      CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
      CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
      CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    '';
  }
