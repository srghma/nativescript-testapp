module ApiServer.Postgraphile where

import ApiServer.Config
import ApiServer.PostgraphilePassportAuthPlugin
import Data.Function.Uncurried
import Effect.Uncurried
import Node.Express.Types
import PathyExtra
import Postgraphile
import Protolude

import ApiServer.PassportMethodsFixed (UserUUID(..))
import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Array as Array
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Database.PostgreSQL (Pool)
import Foreign.Object as Object
import Node.Express.App as Express
import Node.Express.Passport as Passport
import Node.HTTP as Node.HTTP
import Postgraphile as Postgraphile
import ApiServer.PostgraphilePassportAuthPlugin.Types

postgraphileOptions
  :: { databaseHost :: String
     , databaseName :: String
     , databaseOwnerPassword :: NonEmptyString
     , ownerPgPool :: Pool
     , target :: ConfigTarget
     , websocketMiddlewares :: Array (EffectFn3 Request Response (Effect Unit) Unit)
     }
  -> PostgraphileOptions { | ContextInjectedByUsRow + () }
postgraphileOptions config =
  { pluginHook: makePluginHook [pgPubsub, graphileSupporter]
  , ownerConnectionString: "postgres://app_owner:" <> NonEmptyString.toString config.databaseOwnerPassword <> "@" <> config.databaseHost <> "/" <> config.databaseName

  , subscriptions: true
  , simpleSubscriptions: true
  -- | subscriptionAuthorizationFunction: 'app_hidden.validate_subscription',

  , enableQueryBatching: true
  , dynamicJson: true
  , ignoreRBAC: false
  , ignoreIndexes: false
  , setofFunctionsContainNulls: false

  , graphiql:
      case config.target of
           ConfigTarget__Development _ -> true
           _ -> false
  , enhanceGraphiql: true

  , disableQueryLog: true

  -- when false (default):
  -- 1. `id` field on table is exposed as `id: <TYPE>` in schema
  -- 2. on schema added field `nodeId: ID` - globally unique id, base64 encoded string "<TABLE_NAME>:<PRIM_KEY>"
  -- when true:
  -- 1. `id` field on table is exposed as `rowId: <TYPE>` in schema
  -- 2. on schema added field `id: ID` - globally unique id, base64 encoded string "<TABLE_NAME>:<PRIM_KEY>"
  , classicIds: true
  , enableCors: true

  , extendedErrors:
      case config.target of
           ConfigTarget__Development _ ->
             [ "errcode"
             , "severity"
             , "detail"
             , "hint"
             , "positon"
             , "internalPosition"
             , "internalQuery"
             , "where"
             , "schema"
             , "table"
             , "column"
             , "dataType"
             , "constraint"
             , "file"
             , "line"
             , "routine"
             ]
           _ -> ["errcode"]

  , showErrorStack:
      case config.target of
           ConfigTarget__Development _ -> true
           _ -> false

  , watchPg:
      case config.target of
           ConfigTarget__Development _ -> true
           _ -> false

  , sortExport: true
  , exportGqlSchemaPath:
      case config.target of
           ConfigTarget__Production -> Nullable.null
           ConfigTarget__Development developmentConfigTarget -> Nullable.notNull $ either printPathPosixSandboxAny printPathPosixSandboxAny developmentConfigTarget.exportGqlSchemaPath
  , exportJsonSchemaPath:
      case config.target of
           ConfigTarget__Production -> Nullable.null
           ConfigTarget__Development developmentConfigTarget -> Nullable.notNull $ either printPathPosixSandboxAny printPathPosixSandboxAny developmentConfigTarget.exportJsonSchemaPath

  , appendPlugins:
      [ pgSimplifyInflectorPlugin
      , pgMutationUpsertPlugin
      , postgraphilePassportLoginPlugin
      ]

  , graphileBuildOptions:
      { pgSkipInstallingWatchFixtures: true
      }

  , pgSettings: mkEffectFn1 \req -> Promise.fromAff $ liftEffect do
     (userUUID :: Maybe UserUUID) <- ApiServer.PassportMethodsFixed.getUser req
     pure $ Object.fromFoldable $ Array.catMaybes
      [ Just $ "role" /\ "app_user"
      , userUUID <#> \userUUID -> "jwt.claims.user_id" /\ ApiServer.PassportMethodsFixed.userUUIDToString userUUID
      ]

  , websocketMiddlewares: config.websocketMiddlewares

  , additionalGraphQLContextFromRequest: Nullable.notNull $ mkEffectFn1 \req -> Promise.fromAff $ liftEffect $ pure
      { ownerPgPool: config.ownerPgPool
      , req
      }
  }

mkMiddleware
  :: { anonymousPgPool ∷ Pool
     , databaseHost ∷ String
     , databaseName ∷ String
     , databaseOwnerPassword ∷ NonEmptyString
     , ownerPgPool ∷ Pool
     , target ∷ ConfigTarget
     , websocketMiddlewares ∷ Array (EffectFn3 Request Response (Effect Unit) Unit)
     }
  -> EffectFn3 Request Response (Effect Unit) Unit
mkMiddleware
  { anonymousPgPool
  , ownerPgPool
  , websocketMiddlewares
  , target

  , databaseName
  , databaseHost
  , databaseOwnerPassword
  } =
    runFn3
    Postgraphile.postgraphile
    anonymousPgPool
    "app_public"
    ( postgraphileOptions
      { databaseName
      , databaseHost
      , databaseOwnerPassword
      , target
      , websocketMiddlewares
      , ownerPgPool
      }
    )

