create or replace function app_public.current_user_id_required() returns uuid as $function$
  select current_setting('jwt.claims.user_id', false)::uuid;
$function$ LANGUAGE sql stable;

comment on function app_public.current_user_id_required() is
  '@omit
Get current user id or raise error that returns 403 status code';

grant execute on function app_public.current_user_id_required() to public;
