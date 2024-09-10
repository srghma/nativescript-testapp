{ pkgs, ... }:

let
  inherit (pkgs) rootProjectDir;

  mkInitDbScript = import ./utils/mkInitDbScript.nix { inherit pkgs; };

  # rootProjects = import "${rootProjectDir}/default.nix" { inherit pkgs; };
  # inherit (rootProjects) rootYarnModules;
in

{
  project.name = "webapp";

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
      service =
        {
          image = "postgres:16";

          volumes = [
            "postgres_data:/var/lib/postgresql/data"
            "${./utils/mkInitDbScript.sh}:/docker-entrypoint-initdb.d/init.sh"
          ];

          environment = {
            # for ./utils/mkInitDbScript.sh
            IS_PRODUCTION = "false";
            inherit (import "${rootProjectDir}/config/public/database.nix") DATABASE_NAME;
            inherit (import "${rootProjectDir}/config/ignored/passwords.nix") DATABASE_OWNER_PASSWORD DATABASE_ANONYMOUS_PASSWORD;

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
