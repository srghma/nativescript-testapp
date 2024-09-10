
-- allow our application roles execute pg_tap functions (like foreign_tables_are)
grant usage on schema public to app_user, app_anonymous;
grant select, insert, update, delete on all tables in schema public to app_user, app_anonymous;
grant execute on all functions in schema public to app_user, app_anonymous;
