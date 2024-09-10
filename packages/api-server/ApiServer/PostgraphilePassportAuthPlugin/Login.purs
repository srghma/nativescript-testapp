module ApiServer.PostgraphilePassportAuthPlugin.Login where

import ApiServerExceptions.PostgraphilePassportAuthPlugin.Login
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
import Database.PostgreSQL (Connection, PGError, Pool, Row1(..))
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

type WebLoginInput =
  { username :: String
  , password :: String
  }

decodeWebLoginInput :: Foreign -> Except MultipleErrors WebLoginInput
decodeWebLoginInput value = ado
  username <- value Foreign.! "username" >>= Foreign.readString
  password <- value Foreign.! "password" >>= Foreign.readString
  in
    { username
    , password
    }

runExceptWebLoginExceptions :: forall a . ExceptT WebLoginExceptionsServer Aff a -> Effect (Promise a)
runExceptWebLoginExceptions = runExceptT >>> (_ >>= either logAndThrowError pure) >>> Promise.fromAff
  where
    logAndThrowError e = do
      -- TODO: log properly
      traceM e

      throwError $ error $ webLoginExceptionsClientToString $ webLoginExceptionsServer__to__WebLoginExceptionsClient e

webLogin :: Build -> MutationPluginFunc
webLogin build = mkEffectFn5 \mutation args context resolveInfo helpers -> runExceptWebLoginExceptions do
  -- | traceM { mutation, args, context, resolveInfo, helpers }
  -- | traceM { context }

  (input ::WebLoginInput) <- runExcept (decodeWebLoginInput args.input)
      # either (throwError <<< WebLoginExceptionsServer__Internal__CannotDecodeInput) pure

  -- | traceM { input }

  user <- withConnectionExceptT context.ownerPgPool WebLoginExceptionsServer__Internal__CannotCreateDbConnect \connection -> do
    (result :: Array (Row1 String)) <-
      mapErrorExceptT WebLoginExceptionsServer__Internal__LoginFailed
      $ ExceptT
      $ PostgreSQL.query connection
        ( PostgreSQL.Query
          """
          select users.id
          from app_private.web_login($1, $2) users
          where not (users is null)
          """
        )
        (PostgreSQL.Row2 input.username input.password)

    -- | traceM { result }

    user <-
      case result of
          [] -> throwError WebLoginExceptionsServer__LoginFailed
          [Row1 id] -> pure { id }
          _ -> throwError WebLoginExceptionsServer__Internal__Login__ExpectedArrayWith1Elem

    -- | traceM { user }

    pure user

  mapErrorExceptT WebLoginExceptionsServer__Internal__SetId
    $ maybeToExceptT
    $ PostgreSQL.execute context.pgClient
    ( PostgreSQL.Query
      """
      select set_config($1, $2, true);
      """
    )
    (PostgreSQL.Row2 "jwt.claims.user_id" user.id)

  -- | traceM "set_config"

  mapErrorExceptT WebLoginExceptionsServer__Internal__PassportLoginError
    $ maybeToExceptT
    $ ApiServer.PassportMethodsFixed.login
      (ApiServer.PassportMethodsFixed.UserUUID user.id)
      Passport.defaultLoginOptions
      context.req

  traceM "passport login"

  output <- liftAff $ Promise.toAffE $
    runEffectFn2
    helpers.selectGraphQLResultFromTable
    (appPublicUsersFragment build.pgSql.fragment)
    (runFn2 mkSelectGraphQLResultFromTable user.id build.pgSql)

  output' <-
    case output of
      [output'] -> pure output'
      _ -> throwError WebLoginExceptionsServer__Internal__Output__ExpectedArrayWith1Elem

  traceM { "web login output": output }

  pure { "data": output' }

