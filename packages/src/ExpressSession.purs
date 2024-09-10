module ExpressSession where

import Protolude

import Data.Function as Data.Function
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.Time.Duration (Milliseconds)
import Node.Express.Types (Request, Middleware)
import Unsafe.Coerce (unsafeCoerce)

data ExpressSession

data ExpressSessionStore

-- get singleton
foreign import expressSession :: Effect ExpressSession

type ExpressSessionConfigCookie__Internal =
  { path :: String
  , httpOnly :: Boolean
  , secure :: Boolean
  , maxAge :: Nullable Milliseconds
  , expires :: Nullable Milliseconds
  , sameSite :: String
  }

type ExpressSessionConfig__Internal =
  { cookie :: ExpressSessionConfigCookie__Internal
  , genid :: Nullable (Request -> String)
  , name :: String -- The default value is 'connect.sid'
  , proxy :: Nullable Boolean
  , saveUninitialized :: Boolean
  , resave :: Boolean
  , rolling :: Boolean
  , store :: ExpressSessionStore
  , secret :: String
  , unset :: String
  }

---------------------------------

data ExpiresCookieCalculation
  = ExpiresCookieCalculation__MaxAge Milliseconds -- uses current time
  | ExpiresCookieCalculation__Expires Milliseconds

-- for some browsers it's lax, for others - none
data SameSite
  = SameSite__Lax
  | SameSite__None
  | SameSite__Strict

data Unset
  = Unset__Destroy
  | Unset__Keep

type ExpressSessionConfigCookie =
  { path :: String
  , httpOnly :: Boolean
  , secure :: Boolean
  , maxAgeOrExpires :: Maybe ExpiresCookieCalculation
  , sameSite :: SameSite
  }

type ExpressSessionConfig =
  { cookie :: ExpressSessionConfigCookie
  , genid :: Maybe (Request -> String)
  , name :: String -- The default value is 'connect.sid'
  , proxy :: Maybe Boolean
  , saveUninitialized :: Boolean
  , resave :: Boolean
  , rolling :: Boolean
  , store :: ExpressSessionStore
  , secret :: String
  , unset :: Unset
  }

convertConfigCookie :: ExpressSessionConfigCookie -> ExpressSessionConfigCookie__Internal
convertConfigCookie config =
  { path: config.path
  , httpOnly: config.httpOnly
  , secure: config.secure
  , maxAge:
      case config.maxAgeOrExpires of
          Just (ExpiresCookieCalculation__MaxAge milliseconds) -> Nullable.notNull milliseconds
          _ -> Nullable.null
  , expires:
      case config.maxAgeOrExpires of
           Just (ExpiresCookieCalculation__Expires milliseconds) -> Nullable.notNull milliseconds
           _ -> Nullable.null
  , sameSite:
      case config.sameSite of
          SameSite__Lax -> "lax"
          SameSite__None -> "none"
          SameSite__Strict -> "strict"
  }

convertConfig :: ExpressSessionConfig -> ExpressSessionConfig__Internal
convertConfig config =
  { cookie: convertConfigCookie config.cookie
  , genid: Nullable.toNullable config.genid
  , name: config.name
  , proxy: Nullable.toNullable config.proxy
  , saveUninitialized: config.saveUninitialized
  , resave: config.resave
  , rolling: config.rolling
  , store: config.store
  , secret: config.secret
  , unset:
      case config.unset of
           Unset__Destroy -> "destroy"
           Unset__Keep -> "keep"
  }

createMiddleware :: ExpressSession -> ExpressSessionConfig -> Middleware
createMiddleware expressSession config = createMiddleware' expressSession (convertConfig config)
  where
    createMiddleware' :: ExpressSession -> ExpressSessionConfig__Internal -> Middleware
    createMiddleware' = unsafeCoerce Data.Function.apply
