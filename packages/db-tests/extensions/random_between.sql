
begin;

create or replace function random_between(low int, high int) returns int as $$
begin
   return floor(random()* (high-low + 1) + low);
end;
$$ language plpgsql strict;

commit;
