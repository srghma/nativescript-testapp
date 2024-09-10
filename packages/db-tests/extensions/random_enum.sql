
begin;

  -- call as random_enum(null::app_public.leed_rating_enum)
create or replace function random_enum(relation_name anyelement, out result anyenum)
returns anyenum as $func$
begin
  execute format(
    $sql$
      select unnest(enum_range(null::%1$I))
      order by random()
      limit 1;
    $sql$,
    pg_typeof(relation_name)
  ) into result;
  return;
end;
$func$ language plpgsql;

commit;
