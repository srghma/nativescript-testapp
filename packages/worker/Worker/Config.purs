module Worker.Config where

import Data.Maybe
import Pathy
import Protolude

import Control.Monad.Error.Class (throwError)
import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Effect (Effect)
import Effect.Console (log)
import Env as Env
import Node.Express.App as Express
import Node.Express.Response as Express
import Options.Applicative as Options.Applicative
import Worker.Config.FromCli as Worker.Config.FromCli
import Worker.Config.FromEnv as Worker.Config.FromEnv

type TransportConfig_NodemailerReal =
  { pass :: String
  , user :: String
  }

type TransportConfig_Websocket =
  { url :: String
  }

data TransportConfig
  = TransportConfig__NodemailerReal TransportConfig_NodemailerReal
  | TransportConfig__NodemailerTest

-- from args
type Config =
  { transportConfig :: TransportConfig

  , databaseName :: String
  , databaseHost :: String
  , databasePort :: Maybe Int
  , databaseOwnerPassword :: String
  }

config :: Effect Config
config = do
  cliConfig <- Options.Applicative.execParser Worker.Config.FromCli.opts
  envConfig <- Worker.Config.FromEnv.envConfig

  (transportConfig :: TransportConfig) <-
    case cliConfig.transportType of
      Worker.Config.FromCli.TransportConfigType__NodemailerReal ->
        maybe
        (throwError $ error "invalid TransportConfig__NodemailerReal")
        (pure <<< TransportConfig__NodemailerReal)
        ( { pass: _
          , user: _
          }
          <$> envConfig.nodemailerRealPass
          <*> envConfig.nodemailerRealUser
        )
      Worker.Config.FromCli.TransportConfigType__NodemailerTest -> pure TransportConfig__NodemailerTest

  pure
    { transportConfig

    , databaseName:              cliConfig.databaseName
    , databaseHost:              cliConfig.databaseHost
    , databasePort:              cliConfig.databasePort
    , databaseOwnerPassword:     envConfig.databaseOwnerPassword
    }
