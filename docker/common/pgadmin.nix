{}:

# -- user - pgadmin4@pgadmin.org
# -- user pass - admin
# -- hostname - postgres (yes, pgadmin4 client reaches postgres through pgadmin4 server, you dont need to expose $POSTGRES_PORT port)
# -- username - $POSTGRES_USER
# -- password - $POSTGRES_PASSWORD

{
  image = "dpage/pgadmin4:latest";
  ports = [
    "5050:80"
  ];
  depends_on = [
    "postgres"
  ];

  environment = {
    PGADMIN_DEFAULT_EMAIL = "foo";
    PGADMIN_DEFAULT_PASSWORD = "foo";
  };
}
