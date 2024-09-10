create function app_private.really_create_user(
  username text,
  email text,
  email_is_verified bool,
  name text,
  avatar_url text,
  password text default null
) returns app_public.users as $$
declare
  v_user app_public.users;
  v_user_secret_id uuid;
  v_user_email_id uuid;
begin
  -- Store the password
  insert into app_private.user_secrets (password_hash) values
    (
      case
      when password is null
      then null
      else crypt(password, gen_salt('bf'))
      end
    )
    returning id into v_user_secret_id;

  -- Insert the new user
  insert into app_public.users (user_secret_id, username, name, avatar_url) values
    (v_user_secret_id, username, name, avatar_url)
    returning * into v_user;

  -- Add the user's email
  if email is not null then
    insert into app_hidden.user_emails
      (
        user_id,
        email,
        is_verified,
        verification_token,
        verification_email_sent_at
      )
    values
      (
        v_user.id,
        email,
        email_is_verified,
        case
          when email_is_verified = true
          then null
          else encode(gen_random_bytes(4), 'hex')
        end,
        null
      )
    returning id into v_user_email_id;

    if email_is_verified = false then
      perform graphile_worker.add_job(
        'JOB__SEND_VERIFICATION_EMAIL_FOR_USER_EMAIL',
        json_build_object(
          'id', v_user_email_id
        )
      );
    end if;
  end if;

  return v_user;
end;
$$ language plpgsql volatile set search_path from current;

comment on function app_private.really_create_user(username text, email text, email_is_verified bool, name text, avatar_url text, password text) is
  E'Creates a user account. All arguments are optional, it trusts the calling method to perform sanitisation.';
