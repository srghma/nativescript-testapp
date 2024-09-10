module ApiServer.Config where

import Data.Maybe
import Pathy
import Protolude

import ApiServer.DatabasePools as ApiServer.DatabasePools
import ApiServer.Passport as ApiServer.Passport
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
import ApiServer.Config.FromCli as ApiServer.Config.FromCli
import ApiServer.Config.FromEnv as ApiServer.Config.FromEnv

type DevelopmentConfig =
  { exportGqlSchemaPath  :: AnyFile
  , exportJsonSchemaPath :: AnyFile
  , clientPort :: Int
  }

data ConfigTarget
  = ConfigTarget__Production
  | ConfigTarget__Development DevelopmentConfig

-- from args
type Config =
  { target       :: ConfigTarget

  -- listen to, before the proxy
  , port         :: Int    -- e.g. "3000"
  , hostname         :: String -- e.g. "127.0.0.1", N.B. host is hostname + port

  -- for callbackURL, after the proxy
  , rootUrl :: String -- e.g. "http://mysite"

  , databaseName :: String
  , databaseHost :: String
  , databasePort :: Maybe Int
  , databaseOwnerPassword         :: NonEmptyString
  , databaseAnonymousPassword :: NonEmptyString

  , oauthGithubClientID     :: String
  , oauthGithubClientSecret :: NonEmptyString

  , sessionSecret             :: NonEmptyString
  }

config :: Effect Config
config = do
  cliConfig <- Options.Applicative.execParser ApiServer.Config.FromCli.opts
  envConfig <- ApiServer.Config.FromEnv.envConfig

  target <-
    if cliConfig.isProduction
      then pure ConfigTarget__Production
      else do
        let
            (developmentConfigTarget :: Maybe DevelopmentConfig) =
              { exportGqlSchemaPath: _
              , exportJsonSchemaPath: _
              , clientPort: _
              }
              <$> cliConfig.exportGqlSchemaPath
              <*> cliConfig.exportJsonSchemaPath
              <*> cliConfig.clientPort

        maybe (throwError $ error "invalid developmentConfigTarget") (pure <<< ConfigTarget__Development) developmentConfigTarget

  pure
    { target

    , port: cliConfig.port
    , hostname: cliConfig.hostname

    , rootUrl: cliConfig.rootUrl

    , databaseName:              cliConfig.databaseName
    , databaseHost:              cliConfig.databaseHost
    , databasePort:              cliConfig.databasePort
    , databaseOwnerPassword:     envConfig.databaseOwnerPassword
    , databaseAnonymousPassword: envConfig.databaseAnonymousPassword

    , oauthGithubClientID:     cliConfig.oauthGithubClientID
    , oauthGithubClientSecret: envConfig.oauthGithubClientSecret

    , sessionSecret: envConfig.sessionSecret
    }
