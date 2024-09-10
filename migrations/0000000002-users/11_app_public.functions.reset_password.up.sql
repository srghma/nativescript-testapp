create function app_public.reset_password(user_id uuid, token text, new_password text) returns app_public.users as $$
declare
  v_user app_public.users;
  v_user_email app_hidden.user_emails;
  v_user_secret app_private.user_secrets;
  v_reset_max_duration interval = interval '3 days';
  v_max_reset_password_attempts int = 20;
begin
  select users.* into v_user
  from app_public.users
  where id = user_id;

  if not (v_user is null) then
    -- Load their secrets
    select * into v_user_secret from app_private.user_secrets
    where user_secrets.user_id = v_user.id;

    -- Have there been too many reset attempts?
    if (
      v_user_secret.first_failed_reset_password_attempt is not null
    and
      v_user_secret.first_failed_reset_password_attempt > NOW() - v_reset_max_duration
    and
      v_user_secret.reset_password_attempts >= v_max_reset_password_attempts
    ) then
      -- Password reset locked - too many reset attempts
      raise exception 'APP_EXCEPTION__RESET_PASSWORD__ACCOUNT_LOCKED_TOO_MANY_ATTEMPTS' using errcode = 'LOCKD';
    end if;

    -- Not too many reset attempts, let's check the token
    if v_user_secret.reset_password_token = token then
      -- Excellent - they're legit; let's reset the password as requested
      update app_private.user_secrets
      set
        password_hash = crypt(new_password, gen_salt('bf')),
        password_attempts = 0,
        first_failed_password_attempt = null,
        reset_password_token = null,
        reset_password_token_generated_at = null,
        reset_password_attempts = 0,
        first_failed_reset_password_attempt = null
      where user_secrets.user_id = v_user.id;

      -- Notify that password has been reset
      select * into v_user_email
      from app_hidden.user_emails
      where user_emails.user_id = reset_password.user_id
      and is_verified = true
      order by created_at
      limit 1;

      if v_user_email is not NULL then
        perform graphile_worker.add_job(
          'JOB__SEND_PASSWORD_CHANGED_EMAIL',
          json_build_object(
            'email', v_user_email.email
          )
        );
      end if;

      return v_user;
    else
      -- Wrong token, bump all the attempt tracking figures
      update app_private.user_secrets
      set
        reset_password_attempts = (
          case
          when first_failed_reset_password_attempt is null
            or first_failed_reset_password_attempt < now() - v_reset_max_duration
            then 1
          else reset_password_attempts + 1
          end
        ),

        first_failed_reset_password_attempt = (
          case when first_failed_reset_password_attempt is null
            or first_failed_reset_password_attempt < now() - v_reset_max_duration
            then now()
          else first_failed_reset_password_attempt
          end
        )
      where user_secrets.user_id = v_user.id;
      /* Invalid token */
      raise exception 'APP_EXCEPTION__RESET_PASSWORD__INVALID_TOKEN' using errcode='INVLD';
    end if;
  else
    -- No user with that id was found
    /* Invalid user ID */
    raise exception 'APP_EXCEPTION__RESET_PASSWORD__INVALID_USER_ID' using errcode='INVLD';
  end if;
end;
$$ language plpgsql strict volatile security definer set search_path from current;

comment on function app_public.reset_password(user_id uuid, token text, new_password text) is
  E'After triggering forgotPassword, you''ll be sent a reset token. Combine this with your user ID and a new password to reset your password.';
