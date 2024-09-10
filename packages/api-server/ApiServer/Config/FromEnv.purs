module ApiServer.Config.FromEnv where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type EnvConfig =
  { sessionSecret :: NonEmptyString
  , databaseOwnerPassword :: NonEmptyString
  , databaseAnonymousPassword :: NonEmptyString
  , oauthGithubClientSecret :: NonEmptyString
  }

envConfig :: Effect EnvConfig
envConfig = Env.parse Env.defaultInfo $ ado
  sessionSecret                 <- Env.var Env.nonEmptyString "sessionSecret" (Env.defaultVarOptions { sensitive = true })
  databaseOwnerPassword         <- Env.var Env.nonEmptyString "databaseOwnerPassword" (Env.defaultVarOptions { sensitive = true })
  databaseAnonymousPassword <- Env.var Env.nonEmptyString "databaseAnonymousPassword" (Env.defaultVarOptions { sensitive = true })
  oauthGithubClientSecret       <- Env.var Env.nonEmptyString "oauthGithubClientSecret" (Env.defaultVarOptions { sensitive = true })

  in
    { sessionSecret
    , databaseOwnerPassword
    , databaseAnonymousPassword
    , oauthGithubClientSecret
    }
