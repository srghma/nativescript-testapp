create trigger _100_timestamps
  before update on app_public.posts
  for each row
  execute function app_private.tg__set_updated_at();
