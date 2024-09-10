module ApiServer.SessionMiddleware where

import Node.Express.Types
import Protolude

import ApiServer.Config
import ConnectPgSimple as ConnectPgSimple
import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import ExpressSession (ExpiresCookieCalculation(..), ExpressSessionStore, SameSite(..), Unset(..))
import ExpressSession as ExpressSession
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import ApiServerConfig as ApiServerConfig

sessionMiddleware
  :: { target :: ConfigTarget
     , ownerPgPool :: Pool
     , sessionSecret :: NonEmptyString
     }
   -> Effect Middleware
sessionMiddleware config = do
  expressSession <- ExpressSession.expressSession

  let (store :: ExpressSessionStore) =
        ConnectPgSimple.mkExpressSessionStore
        expressSession
        { pool: config.ownerPgPool
        , schemaName: "app_private"
        , tableName: "user_sessions"
        }

  let isProduction =
        case config.target of
            ConfigTarget__Production -> true
            _ -> false

  -- https://github.com/graphile/bootstrap-react-apollo/blob/fbeab7b9c2/server/middleware/installSession.js
  pure $ ExpressSession.createMiddleware expressSession
    { cookie:
      { path: "/"
      , httpOnly: isProduction
      , secure: isProduction
      , maxAgeOrExpires: Just $ ExpiresCookieCalculation__MaxAge $ Duration.fromDuration $ Days 3.0
      , sameSite: SameSite__Strict
      }
    , genid: Nothing
    , name: ApiServerConfig.expressSessionMiddleware_cookieName -- default value
    , proxy: Nothing
    , saveUninitialized: false
    , resave: false
    , rolling: true
    , store
    , secret: NonEmptyString.toString config.sessionSecret
    , unset: Unset__Destroy
    }
