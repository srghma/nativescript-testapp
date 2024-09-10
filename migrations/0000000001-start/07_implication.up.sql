/*
implication (that is used in nix language, `a ~> b`) is written as `!a || b` and means "if a is true, then b is true too, in other case I dont care"

implication :: Boolean -> Boolean -> Boolean
implication true b = b
implication false _ = true


biconditional_statement means "if a is true, then b is true too, if a is false, then b is false too"

biconditional_statement :: Boolean -> Boolean -> Boolean
biconditional_statement true true = true
biconditional_statement false fasle = true
biconditional_statement _ _ = false
*/


create or replace function app_hidden.implication(
  a boolean,
  b boolean
) returns boolean as $$
  select not a or b
$$ immutable strict language sql;

grant execute on function app_hidden.implication(boolean, boolean) to public;

create or replace function app_hidden.biconditional_statement(
  a boolean,
  b boolean
) returns boolean as $$
  select (a and b) or (not a and not b)
$$ immutable strict language sql;

grant execute on function app_hidden.biconditional_statement(boolean, boolean) to public;
