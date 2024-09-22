create or replace function app_hidden.is_from_0_to_100(
  num decimal(3,0)
) returns boolean as $$
  select (num >= 0) AND (num <= 100);
$$ immutable strict language sql;

grant execute on function app_hidden.is_from_0_to_100(decimal) to public;
