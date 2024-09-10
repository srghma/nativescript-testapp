-- Based on
-- https://github.com/graphile/bootstrap-react-apollo/blob/master/tasks/sendVerificationEmailForUserEmail.js

module Worker.Jobs.SendVerificationEmailForUserEmail where

import Foreign
import Protolude
import Worker.EmailUI

import Data.Argonaut (Json, JsonDecodeError)
import Data.Argonaut as Argonaut
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..), Row3(..), fromSQLValue)
import Database.PostgreSQL as PostgreSQL
import Foreign as Foreign
import GraphileWorker (JobHelpers, runWithPgClient)
import GraphileWorker as GraphileWorker
import Halogen.HTML (prop, PropName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenVdomStringRendererRaw as HalogenVdomStringRendererRaw
import Mjml as Mjml
import MjmlHalogenElements as MjmlHalogenElements
import NodeMailer as NodeMailer
import PostgreSQLExtra as PostgreSQLExtra
import Worker.Types

html
  :: forall w i
   . UserDataFromDb
  -> HH.HTML w i
html (UserDataFromDb user) =
  MjmlHalogenElements.mjml_
  [ MjmlHalogenElements.mj_body_
    [ MjmlHalogenElements.mj_section
      [ prop (PropName "full-width") "full-width" ]
      [ MjmlHalogenElements.mj_column_
        [ MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ HH.text "Dear "
          , HH.strong_ [ HH.text (fromMaybe user.email user.name) ]
          , HH.text ","
          ]
        , MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ HH.text "Thanks for your interest in "
          , HH.strong_ [ HH.text "Nextjs" ]
          , HH.text "."
          ]
        , MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ HH.text "Click the link below to verify your email and get started using your "
          , HH.strong_ [ HH.text "Nextjs" ]
          , HH.text "account."
          ]
        , MjmlHalogenElements.mj_text [ prop (PropName "padding-bottom") "10px" ]
          [ link_to_styled "Get started" user.verificationToken
          ]
        ]
      ]
    ]
  ]

newtype Input = Input
  { id :: String
  }

derive instance newtypeInput :: Newtype Input _
derive instance genericInput :: Generic Input _

inputCodec ∷ CA.JsonCodec { id :: String }
inputCodec =
  CA.object "Input" $
    CAR.record
      { id: CA.string
      }

newtype UserDataFromDb
  = UserDataFromDb
    { name :: Maybe String
    , email :: String
    , isVerified :: Boolean
    , verificationToken :: String
    }

derive instance newtypeUserDataFromDb :: Newtype UserDataFromDb _

instance userDataFromDbFromSQLRow :: FromSQLRow UserDataFromDb where
  fromSQLRow
    [ v_name
    , v_email
    , v_isVerified
    , v_verificationToken
    ] = ado
      name <- fromSQLValue v_name
      email <- fromSQLValue v_email
      isVerified <- fromSQLValue v_isVerified
      verificationToken  <- fromSQLValue v_verificationToken
      in UserDataFromDb
        { name
        , email
        , isVerified
        , verificationToken
        }
  fromSQLRow xs = Left $ "Row has only " <> show (Array.length xs) <> " fields."

job :: EmailJobInput -> Aff Unit
job jobInput = do
  input <- CA.decode inputCodec jobInput.json
    # either (throwError <<< error <<< CA.printJsonDecodeError) pure

  (userData :: UserDataFromDb) <-
    PostgreSQLExtra.queryHeadOrThrow jobInput.connection
      ( Query """
      SELECT
        t_user.name AS name,
        t_user_email.email AS email,
        t_user_email.is_verified AS is_verified,
        t_user_email.verification_token AS verification_token
      FROM app_hidden.user_emails AS t_user_email
        JOIN app_public.users AS t_user
        ON t_user.id = t_user_email.user_id
      WHERE t_user_email.id = $1
      """
      )
      (Row1 input.id)

  email <- liftEffect $
    Mjml.mjml2html
    ( HalogenVdomStringRendererRaw.renderHtmlWithRawTextSupport (html userData)
    )
    Mjml.defaultMjmlOptions

  traceM email.errors

  messageInfo <- jobInput.sendEmail
    { to: NonEmptyArray.singleton "useremail@gmail.com"
    , subject: "Verify yourself"
    , text: email.html
    }

  PostgreSQLExtra.executeOrThrow jobInput.connection
    ( Query """
    UPDATE app_hidden.user_emails AS t_user_email
    SET verification_email_sent_at = now()
    WHERE t_user_email.id = $1
    """
    )
    (Row1 input.id)
