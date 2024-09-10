-- from https://github.com/voxpelli/node-connect-pg-simple/blob/master/table.sql

-- based on guide from https://www.npmjs.com/package/express-pg-session

CREATE TABLE app_private.user_sessions (
  "sid" varchar NOT NULL COLLATE "default",
  "sess" json NOT NULL,
  "expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);

ALTER TABLE app_private.user_sessions ADD CONSTRAINT "app_private_user_sessions_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE INDEX "IDX_session_expire" ON app_private.user_sessions ("expire");
