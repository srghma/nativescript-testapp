module Worker.Main where

import Protolude
import Worker.JobIds

import Data.Argonaut (Json, JsonDecodeError)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..), Row3(..), fromSQLValue, Pool)
import Database.PostgreSQL as PostgreSQL
import Database.PostgreSQL.Pool as PostgreSQL
import GraphileWorker as GraphileWorker
import NodeMailer (Transporter)
import NodeMailer as NodeMailer
import Worker.Config as Config
import Worker.Jobs.SendVerificationEmailForUserEmail as Worker.Jobs.SendVerificationEmailForUserEmail
import Worker.Types

type RunGraphileWorkerConfig =
  { sendEmail :: Email -> Aff Unit
  , pgPool :: Pool
  }

runGraphileWorker :: RunGraphileWorkerConfig -> Aff GraphileWorker.GraphileWorkerRunner
runGraphileWorker { sendEmail, pgPool } = do
  let
    mkEmailJob :: (EmailJobInput -> Aff Unit) -> Json -> GraphileWorker.JobHelpers -> Aff Unit
    mkEmailJob f json helpers =
      GraphileWorker.runWithPgClient
      helpers.withPgClient
      \connection -> f
        { json
        , connection
        , sendEmail
        }

    taskList :: JobIds (Json -> GraphileWorker.JobHelpers -> Aff Unit)
    taskList =
      { "JOB__SEND_PASSWORD_CHANGED_EMAIL": undefined
      , "JOB__SEND_PASSWORD_RESET_EMAIL": undefined
      , "JOB__SEND_VERIFICATION_EMAIL_FOR_USER_EMAIL": mkEmailJob Worker.Jobs.SendVerificationEmailForUserEmail.job
      }

  GraphileWorker.run
    { pgPool
    , taskList
    }

main :: Effect Unit
main = launchAff_ do
  config <- liftEffect Config.config

  pgPool <- liftEffect $ PostgreSQL.new
    { database:          config.databaseName
    , host:              Just config.databaseHost
    , idleTimeoutMillis: Nothing
    , max:               Nothing
    , password:          Just $ config.databaseOwnerPassword
    , port:              config.databasePort
    , user:              Just "app_owner"
    }

  transportConfig <- NodeMailer.createTestAccount

  traceM transportConfig

  transporter <- liftEffect $ NodeMailer.createTransporter transportConfig

  void $ runGraphileWorker
    { pgPool
    , sendEmail: \input -> do
        messageInfo <- NodeMailer.sendMail transporter
          { from: "purescript-nextjs@gmail.com"
          , to: NonEmptyArray.toArray input.to
          , cc: []
          , bcc: []
          , subject: input.subject
          , text: input.text
          , attachments: []
          }
        traceM (NodeMailer.getTestMessageUrl messageInfo)
    }
