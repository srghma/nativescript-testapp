
begin;

create or replace function random_string() returns text as $$
begin
   return md5(random()::text);
end;
$$ language plpgsql strict;

commit;
