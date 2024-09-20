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
