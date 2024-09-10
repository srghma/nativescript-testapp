-- Create an "url" Postgres type that is an alias for "text"
-- Which validates the input is an URL
CREATE DOMAIN url AS text CHECK (VALUE ~ 'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#()?&//=]*)');

COMMENT ON DOMAIN url IS 'Match URLs (http or https)';
