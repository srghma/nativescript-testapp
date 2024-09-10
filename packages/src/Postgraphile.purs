module Postgraphile where

import Data.Function.Uncurried (Fn3)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Node.Express.Types (Middleware, Request)
import Protolude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Database.PostgreSQL (Pool)
import Foreign.Object (Object)
import Node.HTTP as Node.HTTP

data PostgraphileServerPlugin
data PostgraphileServerPluginHook
data PostgraphileAppendPlugin

foreign import postgraphile
  :: forall additionalGraphQLContextFromRequest
   . Fn3 Pool String (PostgraphileOptions additionalGraphQLContextFromRequest) Middleware

foreign import makePluginHook
  :: Array PostgraphileServerPlugin
  -> PostgraphileServerPluginHook

foreign import graphileSupporter :: PostgraphileServerPlugin

foreign import enhanceHttpServerWithSubscriptions :: EffectFn2 Node.HTTP.Server Middleware Unit

foreign import pgPubsub :: PostgraphileServerPlugin

foreign import pgSimplifyInflectorPlugin :: PostgraphileAppendPlugin

foreign import pgMutationUpsertPlugin :: PostgraphileAppendPlugin

type PostgraphileOptions additionalGraphQLContextFromRequest =
  { pluginHook                 :: PostgraphileServerPluginHook
  , classicIds                 :: Boolean
  , enableCors                 :: Boolean
  , ownerConnectionString      :: String
  , subscriptions              :: Boolean
  , simpleSubscriptions        :: Boolean
  , enableQueryBatching        :: Boolean
  , dynamicJson                :: Boolean
  , ignoreRBAC                 :: Boolean
  , ignoreIndexes              :: Boolean
  , setofFunctionsContainNulls :: Boolean
  , graphiql                   :: Boolean
  , enhanceGraphiql            :: Boolean
  , disableQueryLog            :: Boolean
  , extendedErrors             :: Array String
  , showErrorStack             :: Boolean
  , watchPg                    :: Boolean
  , sortExport                 :: Boolean
  , exportGqlSchemaPath        :: Nullable String
  , exportJsonSchemaPath       :: Nullable String
  , appendPlugins              :: Array PostgraphileAppendPlugin

  , graphileBuildOptions ::
    { pgSkipInstallingWatchFixtures :: Boolean
    }

  , pgSettings ::
      EffectFn1
      Request
      (Promise (Object String))

  , websocketMiddlewares :: Array Middleware
  , additionalGraphQLContextFromRequest :: Nullable (EffectFn1 Request (Promise additionalGraphQLContextFromRequest))
  }
