{
  pkgs,
  rootProjectDir,
}: {
  useHostStore = true;

  entrypoint = ""; # I hate people that use custom entrypoints

  command = "${pkgs.coreutils}/bin/true"; # do nothing on `docker-compose up`

  working_dir = "/migrations";

  environment = {
    TYPE = "postgresql";
    LOGIN = "app_admin";
    PASSWORD = "app_admin_pass";
    HOST = "postgres";
    PORT = 5432;
    DATABASE = "nextjsdemo_test";

    PATH = let
      env = pkgs.buildEnv {
        name = "system-path";
        paths = with pkgs; [
          waitforit
          wait-for-postgres
          shmig
        ];
      };
    in "${env}/bin:/bin:/run/system/bin";
  };

  volumes = [
    "${rootProjectDir}/migrations:/migrations:ro"
    "/tmp" # for shmig
  ];

  depends_on = [
    "postgres"
  ];
}
