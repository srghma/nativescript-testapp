module ApiServer.PostgraphilePassportAuthPlugin.Register where

import ApiServerExceptions.PostgraphilePassportAuthPlugin.Register
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

type WebRegisterInput =
  { username  :: String
  , email     :: String
  , password  :: String
  , name      :: Maybe String
  , avatarUrl :: Maybe String
  }

decodeWebRegisterInput :: Foreign -> Except MultipleErrors WebRegisterInput
decodeWebRegisterInput value = ado
  username  <- value Foreign.! "username" >>= Foreign.readString
  email     <- value Foreign.! "email" >>= Foreign.readString
  password  <- value Foreign.! "password" >>= Foreign.readString
  name      <- value Foreign.! "name" >>= Foreign.readNullOrUndefined >>= traverse Foreign.readString
  avatarUrl <- value Foreign.! "avatarUrl" >>= Foreign.readNullOrUndefined >>= traverse Foreign.readString
  in
    { username
    , email
    , password
    , name
    , avatarUrl
    }

runExceptWebRegisterExceptions :: forall a . ExceptT WebRegisterExceptionsServer Aff a -> Effect (Promise a)
runExceptWebRegisterExceptions = runExceptT >>> (_ >>= either logAndThrowError pure) >>> Promise.fromAff
  where
    logAndThrowError e = do
      -- TODO: log properly
      traceM e

      throwError $ error $ webRegisterExceptionsClientToString $ webRegisterExceptionsServer__to__WebRegisterExceptionsClient e

webRegister :: Build -> MutationPluginFunc
webRegister build = mkEffectFn5 \mutation args context resolveInfo helpers -> runExceptWebRegisterExceptions do
  -- | traceM { mutation, args, context, resolveInfo, helpers }
  -- | traceM { context }

  (input ::WebRegisterInput) <- runExcept (decodeWebRegisterInput args.input)
      # either (throwError <<< WebRegisterExceptionsServer__Internal__CannotDecodeInput) pure

  -- | traceM { input }

  user <- withConnectionExceptT context.ownerPgPool WebRegisterExceptionsServer__Internal__CannotCreateDbConnect \connection -> do
    (result :: Array (Row1 String)) <-
      mapErrorExceptT WebRegisterExceptionsServer__Internal__RegisterFailed
      $ ExceptT
      $ PostgreSQL.query connection
        ( PostgreSQL.Query
          """
          select users.id from app_private.really_create_user(
            username          => $1,
            email             => $2,
            email_is_verified => false,
            name              => $3,
            avatar_url        => $4,
            password          => $5
          ) users where not (users is null)
          """
        )
        ( PostgreSQL.Row5
          input.username
          input.email
          input.name
          input.avatarUrl
          input.password
        )

    -- | traceM { result }

    user <-
      case result of
          [] -> throwError WebRegisterExceptionsServer__RegisterFailed
          [Row1 id] -> pure { id }
          _ -> throwError WebRegisterExceptionsServer__Internal__Register__ExpectedArrayWith1Elem

    -- | traceM { user }

    pure user

  mapErrorExceptT WebRegisterExceptionsServer__Internal__SetId
    $ maybeToExceptT
    $ PostgreSQL.execute context.pgClient
    ( PostgreSQL.Query
      """
      select set_config($1, $2, true);
      """
    )
    (PostgreSQL.Row2 "jwt.claims.user_id" user.id)

  -- | traceM "set_config"

  mapErrorExceptT WebRegisterExceptionsServer__Internal__PassportRegisterError
    $ maybeToExceptT
    $ ApiServer.PassportMethodsFixed.login
      (ApiServer.PassportMethodsFixed.UserUUID user.id)
      Passport.defaultLoginOptions
      context.req

  traceM "passport register"

  output <- liftAff $ Promise.toAffE $
    runEffectFn2
    helpers.selectGraphQLResultFromTable
    (appPublicUsersFragment build.pgSql.fragment)
    (runFn2 mkSelectGraphQLResultFromTable user.id build.pgSql)

  output' <-
    case output of
      [output'] -> pure output'
      _ -> throwError WebRegisterExceptionsServer__Internal__Output__ExpectedArrayWith1Elem

  traceM { "web register output": output }

  pure { "data": output' }

