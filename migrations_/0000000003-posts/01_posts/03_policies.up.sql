alter table app_public.posts enable row level security;

create policy select_posts on app_public.posts for select using (true);
create policy update_posts on app_public.posts for update using (user_id = app_public.current_user_id_or_null());
create policy delete_posts on app_public.posts for delete using (user_id = app_public.current_user_id_or_null());

grant select on table app_public.posts to app_user;
