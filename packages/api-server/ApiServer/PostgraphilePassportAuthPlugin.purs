module ApiServer.PostgraphilePassportAuthPlugin where

import Control.Promise
import Data.Function.Uncurried
import Effect.Uncurried
import Postgraphile
import Protolude

import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Control.Monad.Except (Except)
import Control.Promise as Promise
import Data.List.NonEmpty as NonEmptyList
import Data.Newtype (over)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Database.PostgreSQL (Connection, PGError, Pool, Row4(..))
import Database.PostgreSQL as PostgreSQL
import Effect.Aff (bracket)
import Effect.Exception.Unsafe (unsafeThrowException)
import Foreign (F, Foreign, MultipleErrors)
import Foreign as Foreign
import Foreign.Index as Foreign
import Node.Express.Passport as Passport
import Node.Express.Types (Request)
import Unsafe.Coerce (unsafeCoerce)
import ApiServer.PostgraphilePassportAuthPlugin.Utils
import ApiServer.PostgraphilePassportAuthPlugin.Shared
import ApiServer.PostgraphilePassportAuthPlugin.Types
import ApiServer.PostgraphilePassportAuthPlugin.Login as ApiServer.PostgraphilePassportAuthPlugin.Login
import ApiServer.PostgraphilePassportAuthPlugin.Register as ApiServer.PostgraphilePassportAuthPlugin.Register

type MutationsImplementation =
  { webRegister :: MutationPluginFunc
  , webLogin :: MutationPluginFunc
  }

foreign import mkPassportLoginPlugin :: (Build -> { "Mutation" :: MutationsImplementation }) -> PostgraphileAppendPlugin

postgraphilePassportLoginPlugin :: PostgraphileAppendPlugin
postgraphilePassportLoginPlugin = mkPassportLoginPlugin \build ->
  { "Mutation":
    { webRegister: ApiServer.PostgraphilePassportAuthPlugin.Register.webRegister build
    , webLogin: ApiServer.PostgraphilePassportAuthPlugin.Login.webLogin build
    }
  }
