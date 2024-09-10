module ApiServer.DatabasePools where

import Database.PostgreSQL
import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

createPools
  :: { databaseName :: String
     , databaseHost :: String
     , databasePort :: Maybe Int

     -- This pool runs as the database owner, so it can do anything.
     , databaseOwnerPassword :: NonEmptyString

     -- This pool runs as the unprivileged user, it's what PostGraphile uses.
     , databaseAnonymousPassword :: NonEmptyString
     }
  -> Effect
     { ownerPgPool :: Pool
     , anonymousPgPool :: Pool
     }
createPools config = do
  ownerPgPool <- new
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ NonEmptyString.toString config.databaseOwnerPassword
    , port:              config.databasePort
    , user:              Just "app_owner"
    }
  anonymousPgPool <- new
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ NonEmptyString.toString config.databaseAnonymousPassword
    , port:              config.databasePort
    , user:              Just "app_anonymous"
    }
  pure { ownerPgPool, anonymousPgPool }

