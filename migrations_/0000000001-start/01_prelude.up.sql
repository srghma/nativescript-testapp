-- tables and functions to be exposed to graphql
create schema app_public;
grant usage on schema app_public to app_anonymous, app_user;
alter default privileges in schema app_public grant usage, select on sequences to app_anonymous, app_user;

-- same privileges as app_public, but simply not exposed to graphql
create schema app_hidden;
grant usage on schema app_hidden to app_anonymous, app_user;
alter default privileges in schema app_hidden grant usage, select on sequences to app_anonymous, app_user;

-- secrets that require elevated privileges to access
create schema app_private;
grant usage on schema app_hidden to app_user;
alter default privileges in schema app_hidden grant usage, select on sequences to app_user;
