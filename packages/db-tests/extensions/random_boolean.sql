
begin;

create or replace function random_boolean() returns boolean as $$
begin
   return random() > 0.5;
end;
$$ language plpgsql strict;

commit;
