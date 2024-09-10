module ApiServer.PostgraphilePassportAuthPlugin.Types where

import Control.Promise
import Effect.Uncurried
import Protolude

import Foreign (Foreign)
import Database.PostgreSQL (Connection, PGError, Pool, Row4(..))
import Node.Express.Types (Request)

data FragmentMaker

data SqlValueFn

data FnArgMutation
data FnArgResolveInfo

data SqlFragment
data QueryBuilder
data SelectGraphQLResultFromTable__Result

type ContextInjectedByUsRow r =
  ( ownerPgPool :: Pool
  , req :: Request
  | r )

type ContextInjectedByPostgraphileRow r =
  ( pgClient :: Connection
  | r )

type Context = Record (ContextInjectedByUsRow + ContextInjectedByPostgraphileRow + ())

type FnArgHelpers =
  { selectGraphQLResultFromTable ::
    EffectFn2
    SqlFragment
    (EffectFn2 String QueryBuilder Unit)
    (Promise (Array SelectGraphQLResultFromTable__Result))
  }

type MutationPluginFunc =
  EffectFn5
  FnArgMutation
  { input :: Foreign
  }
  Context
  FnArgResolveInfo
  FnArgHelpers
  (Promise { "data" :: SelectGraphQLResultFromTable__Result })

type Build =
  { pgSql ::
    { fragment :: FragmentMaker
    , value :: SqlValueFn
    }
  }
