{ pkgs, rootProjectDir }:
{
  useHostStore = true;

  volumes = [
    "${rootProjectDir}/db_tests:/db_tests:ro"
    "/tmp" # for shmig
  ];

  working_dir = "/db_tests/tests";

  environment = rec {
    POSTGRES_USER     = "app_admin";
    POSTGRES_PASSWORD = "app_admin_pass";
    PGPASSWORD        = POSTGRES_PASSWORD; # for db-tests-prepare (for psql)
    POSTGRES_HOST     = "postgres";
    POSTGRES_PORT     = 5432;
    POSTGRES_DB       = "nextjsdemo_test";
  };

  depends_on = [
    "postgres"
  ];
}

