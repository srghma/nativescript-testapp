{ pkgs, rootProjectDir, rootYarnModules }:

{
  useHostStore = true;

  environment = rec {
    POSTGRES_USER     = "app_admin";
    POSTGRES_PASSWORD = "app_admin_pass";
    POSTGRES_HOST     = "postgres";
    POSTGRES_PORT     = 5432;
    POSTGRES_DB       = "nextjsdemo_test";

    PORT              = 5000;
    HOST              = "0.0.0.0";
    EXPOSED_SCHEMA    = "app_public";
    NODE_ENV          = "development";
    DATABASE_URL      = "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${toString POSTGRES_PORT}/${POSTGRES_DB}";
    JWT_SECRET        = "change_me";
    CORS_ALLOW_ORIGIN = "*";
  };
}
