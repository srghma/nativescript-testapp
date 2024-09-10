module FeatureTests.FeatureTestSpec where

import Data.Identity
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Exception
import Protolude
import Unsafe.Coerce

import Control.Monad.Reader.Trans (runReaderT, ReaderT)
import Database.PostgreSQL as PostgreSQL
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd as DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.GoClientRoute as GoClientRoute
import Lunapark as Lunapark
import Node.ReadLine as Node.ReadLine
import PostgreSQLTruncateSchemas as PostgreSQLTruncateSchemas
import Test.Spec (SpecT(..))
import Test.Spec as Test.Spec
import Worker.Types as Worker
import Worker.Main as Worker
import Effect.AVar (AVar)
import Effect.Aff.AVar as AVar
import GraphileWorker as GraphileWorker

type FeatureTestEnv
  = { interpreter :: Lunapark.Interpreter ()
    , clientRootUrl :: String -- e.g. "http://localhost:3000"
    , readLineInterface :: Node.ReadLine.Interface
    , dbConnection :: PostgreSQL.Connection
    , emailAVar :: AVar Worker.Email
    }

type FeatureSpecConfig
  = { interpreter :: Lunapark.Interpreter ()
    , clientRootUrl :: String -- e.g. "http://localhost:3000"
    , readLineInterface :: Node.ReadLine.Interface
    , pool :: PostgreSQL.Pool
    }

-- | withTransactionOrThrow :: ∀ a. PostgreSQL.Connection -> Aff a → Aff a
-- | withTransactionOrThrow dbConnection action = do
-- |   (PostgreSQL.withTransaction dbConnection action) >>=
-- |     either (\e -> throwError $ error $ "[withTransactionOrThrow] PgError: " <> show e) pure

-- SpecT monadOfExample exampleConfig monadOfSpec a

withGraphileWorker :: forall a . Worker.RunGraphileWorkerConfig -> (GraphileWorker.GraphileWorkerRunner -> Aff a) -> Aff a
withGraphileWorker config action = bracket (Worker.runGraphileWorker config) GraphileWorker.stop action

withConnection' ::
  forall a.
  PostgreSQL.Pool ->
  (PostgreSQL.Connection -> Aff a) ->
  Aff a
withConnection' pool action = PostgreSQL.withConnection pool
  case _ of
       Left pgError -> throwError $ error $ "[withConnection]" <> show pgError
       Right connection -> action connection

runFeatureTestWithEverythingElse :: ReaderT FeatureTestEnv Aff Unit → FeatureSpecConfig → Aff Unit
runFeatureTestWithEverythingElse spec = \config ->
  withConnection' config.pool \connection -> do
    PostgreSQLTruncateSchemas.truncateTablesInSchemas connection
      -- ordinary tables
      [ "app_public"
      , "app_private"
      , "app_hidden"
      ]

    PostgreSQLTruncateSchemas.truncateTables connection
      -- truncate all except migrations table OR it will retry jobs on errors
      [ Tuple "graphile_worker" "jobs"
      , Tuple "graphile_worker" "job_queues"
      ]

    (emailAVar :: AVar Worker.Email) <- AVar.empty

    withGraphileWorker
      { sendEmail: \email -> AVar.put email emailAVar
      , pgPool: config.pool
      }
      (\_ -> runReaderT spec
        { interpreter: config.interpreter
        , clientRootUrl: config.clientRootUrl
        , readLineInterface: config.readLineInterface
        , dbConnection: connection
        , emailAVar
        }
      )

it :: String -> ReaderT FeatureTestEnv Aff Unit -> SpecT Aff FeatureSpecConfig Identity Unit
it name spec = Test.Spec.it name $ runFeatureTestWithEverythingElse spec

itOnly :: String -> ReaderT FeatureTestEnv Aff Unit -> SpecT Aff FeatureSpecConfig Identity Unit
itOnly name spec = Test.Spec.itOnly name $ runFeatureTestWithEverythingElse spec
