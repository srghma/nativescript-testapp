module Worker.Types where

import Protolude
import Worker.JobIds

import Data.Argonaut (Json, JsonDecodeError)
import Data.Array.NonEmpty (NonEmptyArray)
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..), Row3(..), fromSQLValue)
import Database.PostgreSQL as PostgreSQL
import Database.PostgreSQL.Pool as PostgreSQL
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker as GraphileWorker
import NodeMailer as NodeMailer

type Email =
  { subject :: String
  , text :: String
  , to :: NonEmptyArray String
  }

type EmailJobInput =
  { json :: Json
  , connection :: Connection
  , sendEmail :: Email -> Aff Unit
  }

