{pkgs, ...}: let
  inherit (pkgs) rootProjectDir;
in {
  project.name = "nextjsdemo_import";

  docker-compose = {
    volumes = {
      postgres_data = null;
    };
  };

  services = {
    # pgadmin = {
    #   service = import ./common/pgadmin.nix {};
    # };

    postgres = {
      service = {
        image = "postgres:16";

        # drmaci && (docker volume rm nextjsdemo_import_postgres_data || true) && arion --file docker/import.nix up
        volumes = [
          "postgres_data:/var/lib/postgresql/data"
          "${import ./utils/mkInitDbScript.nix {
            inherit (pkgs) writeTextFile;
            IS_PRODUCTION = "false"; # Adjust based on the environment
            inherit (import "${rootProjectDir}/config/public/database.nix") DATABASE_NAME DATABASE_SHADOW_NAME;
            inherit (import "${rootProjectDir}/config/ignored/passwords.nix") DATABASE_OWNER_PASSWORD DATABASE_ANONYMOUS_PASSWORD;
          }}:/docker-entrypoint-initdb.d/init.sql:ro"
        ];

        environment = {
          inherit (import "${rootProjectDir}/config/public/database.nix") POSTGRES_USER;
          inherit (import "${rootProjectDir}/config/ignored/passwords.nix") POSTGRES_PASSWORD;
        };

        ports = [
          "5432:5432"
        ];
      };
    };
  };
}
