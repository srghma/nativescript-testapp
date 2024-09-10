create table app_public.user_authentications (
  id uuid not null primary key default uuid_generate_v4(),
  user_id uuid not null references app_public.users on delete cascade,
  service text not null,
  identifier text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint uniq_user_authentications unique(service, identifier)
);

create index on app_public.user_authentications (user_id);

alter table app_public.user_authentications enable row level security;

create trigger _100_timestamps
  before update on app_public.user_authentications
  for each row
  execute function app_private.tg__set_updated_at();

comment on table app_public.user_authentications is
  E'@omit all\nContains information about the login providers this user has used, so that they may disconnect them should they wish.';

comment on column app_public.user_authentications.user_id is
  E'@omit';

comment on column app_public.user_authentications.service is
  E'The login service used, e.g. `twitter` or `github`.';

comment on column app_public.user_authentications.identifier is
  E'A unique identifier for the user within the login service.';

comment on column app_public.user_authentications.details is
  E'@omit\nAdditional profile details extracted from this login method';

create policy select_own on app_public.user_authentications for select using (user_id = app_public.current_user_id_or_null());

create policy delete_own on app_public.user_authentications for delete using (user_id = app_public.current_user_id_or_null()); -- TODO check this isn't the last one, or that they have a verified email address

grant select on app_public.user_authentications to app_user;
grant delete on app_public.user_authentications to app_user;
