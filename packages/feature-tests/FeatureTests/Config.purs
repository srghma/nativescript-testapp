module FeatureTests.Config where

import Protolude

import Data.NonEmpty (NonEmpty(..))
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Env as Env
import Foreign.Object (Object)

type Config =
  { databaseName          :: String
  , databaseHost          :: String
  , databasePort          :: Maybe Int
  , databaseOwnerPassword :: String
  , clientRootUrl         :: String
  , chromedriverUrl       :: String
  , chromeBinaryPath      :: String
  , remoteDownloadDirPath :: String
  , chromeUserDataDirPath :: String
  }

config :: Effect Config
config = Env.parse Env.defaultInfo $ ado
  databaseName          <- Env.var Env.nonempty "databaseName" Env.defaultVarOptions
  databaseHost          <- Env.var Env.nonempty "databaseHost" Env.defaultVarOptions
  databasePort          <- Env.optionalVar Env.int "databasePort" Env.defaultOptionalVarOptions
  databaseOwnerPassword <- Env.var Env.nonempty "databaseOwnerPassword" (Env.defaultVarOptions { sensitive = true })
  clientRootUrl         <- Env.var Env.nonempty "clientRootUrl" Env.defaultVarOptions
  chromedriverUrl       <- Env.var Env.nonempty "chromedriverUrl" Env.defaultVarOptions
  chromeBinaryPath      <- Env.var Env.nonempty "chromeBinaryPath" Env.defaultVarOptions
  remoteDownloadDirPath <- Env.var Env.nonempty "remoteDownloadDirPath" Env.defaultVarOptions
  chromeUserDataDirPath <- Env.var Env.nonempty "chromeUserDataDirPath" Env.defaultVarOptions

  in
    { databaseName
    , databaseHost
    , databasePort
    , databaseOwnerPassword
    , clientRootUrl
    , chromedriverUrl
    , chromeBinaryPath
    , remoteDownloadDirPath
    , chromeUserDataDirPath
    }
