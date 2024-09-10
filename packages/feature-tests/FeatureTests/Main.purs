module FeatureTests.Main where

import Prelude
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (launchAff_, delay)
import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner
import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception as Effect.Exception
import Prelude
import Test.Spec
import Unsafe.Coerce
import Data.Identity
import Data.Foldable
import Control.Monad.Except.Trans (ExceptT, runExceptT)
import Database.PostgreSQL as Database.PostgreSQL
import Database.PostgreSQL (ConnectResult, Configuration, Pool)
import Database.PostgreSQL.Row (Row0(..), Row3(..))
import Data.Decimal as Decimal
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff
import Effect.Aff as Effect.Aff
import Effect.Class (liftEffect)
import Effect.Aff.AVar as Effect.Aff.AVar
import Effect.AVar (AVar)
import Node.Process
import Foreign.Object
import Data.Either
import Data.Int as Data.Int
import Control.Monad.Error.Class (throwError)
import Effect.Exception (error)
import Effect.Now (nowDateTime)
import Data.DateTime (Time, diff)
import Data.Time.Duration (class Duration)
import Debug.Trace (traceM)
import Control.Parallel
import SpecAroundAll
import FeatureTests.FeatureTestSpec
import FeatureTests.AllTests
import FeatureTests.Config as Config
import Lunapark as Lunapark
import Lunapark.Types as Lunapark
import Run (Run)
import Run as Run
import Run.Reader as Run
import Run.Except as Run
import Node.ReadLine as Node.ReadLine
import Node.Process as Node.Process
import Data.Posix.Signal
import Node.Stream as Node.Stream
import Data.Exists (Exists)
import Data.Exists as Exists
import FeatureTests.FeatureTestSpecUtils.Lunapark as FeatureTests.FeatureTestSpecUtils.Lunapark
import FeatureTests.ChromeLunaparkOptions as FeatureTests.ChromeLunaparkOptions
import Worker.Main as Worker.Main

main :: Effect Unit
main = do
  readLineInterface <- Node.ReadLine.createConsoleInterface Node.ReadLine.noCompletion
  config <- Config.config

  launchAff_ do
     -- | TODO:
     -- | (interpreter :: Exists Lunapark.Interpreter)
     -- | so it's not instantiated and I dont have to handle Run.Reader on cleanup

    interpreter <-
      Lunapark.init config.chromedriverUrl (FeatureTests.ChromeLunaparkOptions.chromeLunaparkOptions config)
      >>=
        either
        (\e -> throwError $ error $ "An error during selenium session initialization occured: " <> Lunapark.printError e)
        pure

    (pool :: Pool) <- liftEffect $ Database.PostgreSQL.new
      { database:          config.databaseName
      , host:              Just config.databaseHost
      , idleTimeoutMillis: Nothing
      , max:               Nothing
      , password:          Just config.databaseOwnerPassword
      , port:              config.databasePort
      , user:              Just "app_owner"
      }

    let
      testsConfig =
        { clientRootUrl: config.clientRootUrl
        , interpreter
        , readLineInterface
        , pool
        }

      onExit = do
        FeatureTests.FeatureTestSpecUtils.Lunapark.runLunaparkImplementation interpreter Lunapark.quit >>=
          either
          (\e -> throwError $ error $ "Error when quitting: " <> Lunapark.printError e)
          pure

    liftEffect $ do
       -- from https://nodejs.org/api/process.html#process_signal_events
       -- Begin reading from stdin so the process does not exit.
       Node.Stream.resume Node.Process.stdin

       -- when it is called?
       Node.Process.onBeforeExit $ launchAff_ onExit

       -- do something when app is closing
       Node.Process.onExit $ const $ launchAff_ onExit

       -- catches ctrl+c event
       Node.Process.onSignal SIGINT $ launchAff_ onExit -- not handling CTRL-D?
       Node.Process.onSignal SIGTERM $ launchAff_ onExit

      -- catches uncaught exceptions
      -- | process.on('uncaughtException', generalUtil.exitHandler.bind(null, {exit:false,event: "uncaughtException"}));

    runSpec' (defaultConfig { timeout = Nothing }) [ consoleReporter ]
      ( before (pure testsConfig)
        $ afterAll_ onExit
        $ allTests
      )
