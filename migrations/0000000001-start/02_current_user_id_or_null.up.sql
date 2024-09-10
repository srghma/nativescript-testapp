-- TODO: should be in app_hidden?

create or replace function app_public.current_user_id_or_null() returns uuid as $function$
  select nullif(current_setting('jwt.claims.user_id', true), '')::uuid;
$function$ LANGUAGE sql stable;

comment on function app_public.current_user_id_or_null() is
  '@omit
Handy method to get the current user ID for use in RLS policies, etc; in GraphQL, use `query { currentUser { id } }` instead.';

grant execute on function app_public.current_user_id_or_null() to public;
