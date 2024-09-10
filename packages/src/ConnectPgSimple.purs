module ConnectPgSimple where

import ExpressSession (ExpressSession, ExpressSessionStore)

import Database.PostgreSQL (Pool)

type Config =
  { pool :: Pool
  , schemaName :: String
  , tableName :: String
  -- | , ttl
  }

foreign import mkExpressSessionStore :: ExpressSession -> Config -> ExpressSessionStore
