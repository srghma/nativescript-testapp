module Worker.Config.FromCli where

import Pathy (Path, Abs, File, AnyFile)
import Protolude
import PathyOptparse as PathyOptparse
import Data.Maybe as Maybe

import Options.Applicative

data TransportConfigType
  = TransportConfigType__NodemailerReal
  | TransportConfigType__NodemailerTest

transportConfigTypeParser :: ReadM TransportConfigType
transportConfigTypeParser = eitherReader
  \s -> case s of
      "nodemailer-real" -> Right TransportConfigType__NodemailerReal
      "nodemailer-test" -> Right TransportConfigType__NodemailerTest
      _ -> Left $ "Can't parse TransportConfigType: `" <> show s <> "`"

type CliConfig =
  { transportType  :: TransportConfigType
  , databaseName              :: String
  , databaseHost              :: String
  , databasePort              :: Maybe Int
  }

configParser :: Parser CliConfig
configParser = ado
  transportType  <- option transportConfigTypeParser $ long "transportType"
  databaseName <- option str $ long "databaseName"
  databaseHost <- option str $ long "databaseHost"
  databasePort <- Maybe.optional $ option int $ long "databasePort"

  in
    { transportType
    , databaseName
    , databaseHost
    , databasePort
    }

opts :: ParserInfo CliConfig
opts =
  info (configParser <**> helper) $
    fullDesc
    <> progDesc "worker"
    <> header "worker - starts worker"
