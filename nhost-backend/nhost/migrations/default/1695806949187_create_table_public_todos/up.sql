CREATE TABLE "public"."todos" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "title" text NOT NULL,
  "done" boolean NOT NULL DEFAULT false,
  "created_at" Timestamp NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "user_id" uuid NOT NULL,
  "file_id" uuid,
  PRIMARY KEY ("id") ,
  FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY ("file_id") REFERENCES "storage"."files"("id") ON UPDATE cascade ON DELETE cascade
);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
