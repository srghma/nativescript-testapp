module Worker.Config.FromEnv where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type EnvConfig =
  { nodemailerRealPass :: Maybe String
  , nodemailerRealUser :: Maybe String
  , databaseOwnerPassword :: String
  }

envConfig :: Effect EnvConfig
envConfig = Env.parse Env.defaultInfo $ ado
  nodemailerRealPass    <- Env.optionalVar Env.nonempty "nodemailerRealPass" (Env.defaultOptionalVarOptions { sensitive = true })
  nodemailerRealUser    <- Env.optionalVar Env.nonempty "nodemailerRealUser" (Env.defaultOptionalVarOptions { sensitive = true })
  databaseOwnerPassword <- Env.var Env.nonempty "databaseOwnerPassword" (Env.defaultVarOptions { sensitive = true })

  in
    { nodemailerRealPass
    , nodemailerRealUser
    , databaseOwnerPassword
    }
