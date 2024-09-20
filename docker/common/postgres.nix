{}: {
  image = "postgres:latest";

  volumes = [
    "postgres_data:/var/lib/postgresql/data"
  ];

  environment = {
    POSTGRES_USER = "app_admin"; # superuser, only for running migrations
    POSTGRES_PASSWORD = "app_admin_pass";
    POSTGRES_DB = "nextjsdemo_test";
  };
}
