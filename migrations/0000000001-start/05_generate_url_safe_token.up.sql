-- From https://stackoverflow.com/a/1374794/3574379
-- base64 strings can contains the "+", "=" and "/" which are unsafe
-- remove these characters

create or replace function app_public.generate_url_safe_token() returns text as $function$
  select translate(
    encode(gen_random_bytes(8), 'base64'),
    '+/=',
    ''
  )
$function$ LANGUAGE sql stable;

comment on function app_public.generate_url_safe_token() is
  '@omit';

grant execute on function app_public.generate_url_safe_token() to public;
