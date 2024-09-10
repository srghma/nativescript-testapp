create function app_public.user_by_username_or_verified_email(username_or_email text) returns app_public.users as $$
  select users.*
  from app_public.users
  where
    -- Match username against users username, or any verified email address
    (
      users.username = user_by_username_or_verified_email.username_or_email
    or
      exists(
        select 1
        from app_hidden.user_emails
        where user_id = users.id
        and is_verified is true
        and email = user_by_username_or_verified_email.username_or_email::citext
      )
    );
$$ language sql
  stable
  strict -- all args are required
  set search_path from current;
