{ pkgs, config }:

# with config;

let
  lib = import ./lib.nix { inherit pkgs; };
in

config.mkScripts {
  dev__cat = ''
    arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      cat
  '';

  dev__down = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      down
  '';

  dev__up_detach = ''
    COMPOSE_PROJECT_NAME="nextjsdemo_import" \
      arion \
      --file docker/import.nix \
      --pkgs nix/pkgs.nix \
      up --detach
  '';

  dev__db_tests = config.mkCommand
    {
      inherit (import "${pkgs.rootProjectDir}/config/public/database.nix")
        POSTGRES_USER
        DATABASE_NAME;

      inherit (import "${pkgs.rootProjectDir}/config/ignored/passwords.nix")
        DATABASE_OWNER_PASSWORD
        POSTGRES_PASSWORD;

      inherit (lib.config)
        POSTGRES_HOST
        POSTGRES_PORT;
    }
    ''
      waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

      PGPASSWORD=$DATABASE_OWNER_PASSWORD \
        DB_TESTS_PREPARE_ARGS="--quiet -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U app_owner" \
        db-tests-prepare ./packages/db-tests/extensions

      PGPASSWORD=$POSTGRES_PASSWORD \
        pg_prove -h $POSTGRES_HOST -p $POSTGRES_PORT -d $DATABASE_NAME -U $POSTGRES_USER --recurse --ext .sql ./packages/db-tests/tests/
    '';

  dev__db__dump_schema = config.mkCommand lib.migratorEnv ''
    DATABASE_URL=postgres://app_owner:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME \
      dump-schema
  '';

  dev__db__migrate = config.mkCommand lib.migratorEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    wait-for-postgres --dbname=postgres://app_owner:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME

    # for relative imports using \include command (shimg is using psql internally)
    cd ./migrations

    shmig -t postgresql \
      -m ./ \
      -C always \
      -l app_owner \
      -p $DATABASE_OWNER_PASSWORD \
      -H $POSTGRES_HOST \
      -P $POSTGRES_PORT \
      -d $DATABASE_NAME \
      migrate

    ${pkgs.rootProjectDir}/node_modules/.bin/graphile-worker --connection "postgres://app_owner:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME" --schema-only
  '';

  dev__api_server = config.mkCommand lib.serverEnv ''
    waitforit -host=$POSTGRES_HOST -port=$POSTGRES_PORT -timeout=30

    wait-for-postgres --dbname=postgres://app_owner:$DATABASE_OWNER_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$DATABASE_NAME

    mkdir -p ./schemas

    GRAPHILE_LICENSE="${pkgs.lib.fileContents "${pkgs.rootProjectDir}/config/ignored/graphile-license"}" \
    sessionSecret="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").SESSION_SECRET}" \
    databaseOwnerPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_OWNER_PASSWORD}" \
    databaseAnonymousPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_ANONYMOUS_PASSWORD}" \
    oauthGithubClientSecret="${(import "${pkgs.rootProjectDir}/config/ignored/github-oauth.nix").CLIENT_SECRET}" \
      spago --config spago-api-server.dhall run --main ApiServer.Main --node-args '\
        --exportGqlSchemaPath "${pkgs.rootProjectDir}/schemas/schema.graphql" \
        --exportJsonSchemaPath "${pkgs.rootProjectDir}/schemas/schema.json" \
        --port 3000 \
        --clientPort 3001 \
        --hostname localhost \
        --rootUrl "http://localhost:3000" \
        --databaseName "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_NAME}" \
        --databaseHost "$POSTGRES_HOST" \
        --databasePort "$POSTGRES_PORT" \
        --oauthGithubClientID "${(import "${pkgs.rootProjectDir}/config/ignored/github-oauth.nix").CLIENT_ID}" \
      '
  '';

  dev__db__drop = ''
    docker-volume-rm-if-exists nextjsdemo_import_postgres_data
  '';

  dev__feature_tests__run_chromedriver = ''
    chromedriver --verbose --port=9515
  '';

  dev__feature_tests__run = config.mkCommand lib.serverEnv ''
    remoteDownloadDirPath="${pkgs.rootProjectDir}/.feature-tests/remoteDownloadDir"
    chromeUserDataDirPath="${pkgs.rootProjectDir}/.feature-tests/chromeUserDataDir"

    mkdir -p "$remoteDownloadDirPath"
    mkdir -p "$chromeUserDataDirPath"

    databaseName="${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_NAME}" \
    databaseHost="$POSTGRES_HOST" \
    databasePort="$POSTGRES_PORT" \
    databaseOwnerPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_OWNER_PASSWORD}" \
    clientRootUrl="http://localhost" \
    chromedriverUrl="http://localhost:9515" \
    chromeBinaryPath="${pkgs.chromium}/bin/chromium" \
    remoteDownloadDirPath="$remoteDownloadDirPath" \
    chromeUserDataDirPath="$chromeUserDataDirPath" \
      exec spago --config spago-feature-tests.dhall run --main FeatureTests.Main
  '';

  dev__worker__run = config.mkCommand {} ''
    databaseOwnerPassword="${(import "${pkgs.rootProjectDir}/config/ignored/passwords.nix").DATABASE_OWNER_PASSWORD}" \
      spago --config spago-worker.dhall run --main Worker.Main --node-args '\
        --transportType "nodemailer-test" \
        --databaseName "${(import "${pkgs.rootProjectDir}/config/public/database.nix").DATABASE_NAME}" \
        --databaseHost "${lib.config.POSTGRES_HOST}" \
        --databasePort "${builtins.toString lib.config.POSTGRES_PORT}" \
      '
  '';
}
