
begin;

create or replace function random_email() returns text as $$
begin
   return md5(random()::text) || '@mail.com';
end;
$$ language plpgsql strict;

commit;
