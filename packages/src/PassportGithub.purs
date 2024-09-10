module PassportGithub where

import Data.Function.Uncurried (Fn2, runFn2)
import Effect.Uncurried (EffectFn3, EffectFn6, mkEffectFn6, runEffectFn3)
import Protolude

import Data.Argonaut (Json)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect.Aff (runAff_)
import Node.Express.Passport (PassportStrategy, StrategyId(..))
import Node.Express.Types (Request)

-- for "passport.authenticate"
githubStrategyId :: StrategyId
githubStrategyId = StrategyId "github"

-------------------------------------------------

type PassportStrategyGithubOptions
  = { clientID :: String
    , clientSecret :: String
    , includeEmail :: Boolean
    , callbackURL :: String
    }

newtype AccessToken = AccessToken String

newtype RefreshToken = RefreshToken String

-- ??
newtype Params = Params Json

newtype Profile = Profile Json

type PassportStrategyGithub__Implementation__Callback user info
  = EffectFn3 (Nullable Error) (Nullable user) (Nullable info) Unit

-- from https://github.com/jaredhanson/passport-oauth2/blob/e20f26aad60ed54f0e7952928cbb64979ef8da2b/lib/strategy.js#L193
type PassportStrategyGithub__Implementation__Verify user info
  = EffectFn6 Request AccessToken RefreshToken Params Profile (PassportStrategyGithub__Implementation__Callback user info) Unit

foreign import _passportStrategyGithub ::
  forall user info.
  Fn2
  PassportStrategyGithubOptions
  (PassportStrategyGithub__Implementation__Verify user info)
  PassportStrategy

data PassportStrategyGithub__CredentialsVerifiedResult user
  = PassportStrategyGithub__CredentialsVerifiedResult__AuthenticationError
  | PassportStrategyGithub__CredentialsVerifiedResult__Success user

type PassportStrategyGithub__Verify user info
  = Request -> AccessToken -> RefreshToken -> Params -> Profile
  -> Aff
    { result :: PassportStrategyGithub__CredentialsVerifiedResult user
    , info :: Maybe info
    }

unsafePassportStrategyGithub ::
  forall user info.
  PassportStrategyGithubOptions ->
  PassportStrategyGithub__Verify user info ->
  PassportStrategy
unsafePassportStrategyGithub options verify =
  runFn2
  _passportStrategyGithub
  options
  (mkEffectFn6 \request accesstoken refreshtoken params profile verified ->
    runAff_
    (case _ of
          Left error ->
            runEffectFn3
            verified
            (Nullable.notNull error)
            (Nullable.null)
            (Nullable.null)
          Right { result, info } ->
            runEffectFn3
            verified
            Nullable.null
            ( case result of
                  PassportStrategyGithub__CredentialsVerifiedResult__Success user -> Nullable.notNull user
                  _ -> Nullable.null
            )
            (Nullable.toNullable info)
    )
    (verify request accesstoken refreshtoken params profile)
  )

passportStrategyGithub ::
  forall proxy user info.
  proxy user ->
  proxy info ->
  PassportStrategyGithubOptions ->
  PassportStrategyGithub__Verify user info ->
  PassportStrategy
passportStrategyGithub _ _ = unsafePassportStrategyGithub
