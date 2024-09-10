module NextjsApp.Server.Config where

import Protolude
import Ansi.Codes as Ansi
import Ansi.Output as Ansi
import Data.Int as Integers
import Effect.Class.Console as Console
import Node.Process as NodeProcess.Process
import Protolude.Node as Protolude.Node
import Options.Applicative
import Node.FS.Sync as Node.FS.Sync
import Node.FS.Sync as Node.FS.Sync
import Data.Argonaut.Core
import Node.Encoding as Node.Encoding
import Node.Path (FilePath)
import Node.Path as Node.Path
import Effect.Exception
import Data.Argonaut.Parser as Data.Argonaut.Parser
import Pathy hiding (Parser(..))
import Pathy as Pathy
import Data.Maybe as Maybe
import PathyOptparse as PathyOptparse

type Config
  = { rootPath :: Path Abs Dir
    , port :: Int
    , livereloadPort :: Maybe Int
    }

configParser :: Parser Config
configParser =
  { rootPath: _, port: _, livereloadPort: _ }
    <$> option PathyOptparse.absDirPosixParser
        ( long "root-path"
            <> metavar "TARGET"
            <> help "root path"
        )
    <*> option int
        ( long "port"
            <> help "0 - means random port"
            <> showDefault
            <> value 0
            <> metavar "INT"
        )
    <*> Maybe.optional
        ( option int
            ( long "livereload-port"
                <> metavar "INT"
            )
        )

opts :: ParserInfo Config
opts =
  info (configParser <**> helper)
    ( fullDesc
        <> progDesc "starts server"
        <> header "server - starts server"
    )

-- | getPortOrRandomPortFromEnv :: Effect Int
-- | getPortOrRandomPortFromEnv = NodeProcess.Process.lookupEnv "PORT" >>=
-- |   case _ of
-- |        Nothing -> do
-- |          Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using random port"
-- |          pure 0
-- |        Just portString ->
-- |          case Integers.fromString portString of
-- |            Nothing -> Protolude.Node.exitWith 1 $ "Cannot parse PORT: " <> portString
-- |            Just port -> do
-- |              Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using port: " <> show port
-- |              pure port
