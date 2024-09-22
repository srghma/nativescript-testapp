create table app_public.posts (
  id                       uuid                                   primary key default uuid_generate_v4(),
  name                     varchar(255)                           not null CHECK (name <> ''),
  content                  varchar(255)                           not null CHECK (name <> ''),

  user_id
    uuid
    not null
    references app_public.users(id)
    on delete cascade
    on update cascade,

  created_at               timestamptz                            not null default now(),
  updated_at               timestamptz                            not null default now()
);

create index app_public_posts_user_id on app_public.posts (user_id);

------------------

create trigger _100_timestamps
  before update on app_public.posts
  for each row
  execute function app_private.tg__set_updated_at();

------------------

alter table app_public.posts enable row level security;

create policy select_posts on app_public.posts for select using (true);
create policy update_posts on app_public.posts for update using (user_id = app_public.current_user_id_or_null());
create policy delete_posts on app_public.posts for delete using (user_id = app_public.current_user_id_or_null());

grant select on table app_public.posts to app_user;
