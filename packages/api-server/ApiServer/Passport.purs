module ApiServer.Passport where

import Node.Express.Handler
import Node.Express.Passport
import Node.Express.Types
import Protolude

import ApiServer.PassportMethodsFixed (UserUUID(..))
import ApiServer.PassportMethodsFixed as ApiServer.PassportMethodsFixed
import Data.Argonaut as Argonaut
import Data.Argonaut.Core as Json
import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Time.Duration (Days(..))
import Data.Time.Duration as Duration
import Database.PostgreSQL (Pool)
import Effect.Exception.Unsafe (unsafeThrowException)
import Node.Express.Passport as Passport
import Node.Express.Response as Express
import PassportGithub as PassportGithub
import Type.Prelude (Proxy(..))

passportMiddlewareAndRoutes :: _ -> Effect { middlewares :: Array Middleware, routes :: Array (Tuple String Handler) }
passportMiddlewareAndRoutes config = do
  (passport :: Passport) <- Passport.getPassport

  ApiServer.PassportMethodsFixed.serializeUser passport \req (UserUUID userUUID) ->
    pure $ SerializedUser__Result $ Json.fromString userUUID
  ApiServer.PassportMethodsFixed.deserializeUser passport \req json -> do
    (userUUID :: String) <- Argonaut.decodeJson json
      # either (throwError <<< error <<< Argonaut.printJsonDecodeError) pure
    pure $ DeserializedUser__Result $ UserUUID userUUID

  let githubCallbackPath = "/auth/github/callback"

  Passport.useStrategy passport PassportGithub.githubStrategyId $
    ApiServer.PassportMethodsFixed.passportStrategyGithub
    { clientID: config.oauthGithubClientID
    , clientSecret: NonEmptyString.toString config.oauthGithubClientSecret
    , includeEmail: true
    , callbackURL: config.rootUrl <> githubCallbackPath
    }
    \request accesstoken refreshtoken params profile -> unsafeThrowException $ error "githubStrategyId"

  let (githubHandler :: Handler) =
        ApiServer.PassportMethodsFixed.authenticate
        passport
        PassportGithub.githubStrategyId
        ( Passport.defaultAuthenticateOptions
          { failureRedirect = Just "/login"
          , successReturnToOrRedirect = Just "/" -- use `req.session.returnTo` or fallback
          }
        )
        Nothing

  pure
    { middlewares:
      [ Passport.passportInitialize passport Passport.defaultPassportInitializeOptions
      , Passport.passportSession passport Passport.defaultPassportSessionOptions
      ]
    , routes:
      [ "/logout" /\ do
          Passport.logout
          Express.redirect "/"
      , "/auth/github" /\ do
          throwError $ error "/auth/github"
          -- setReturnTo
      , githubCallbackPath /\ githubHandler
      ]
    }
