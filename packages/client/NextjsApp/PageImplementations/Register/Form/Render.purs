module NextjsApp.PageImplementations.Register.Form.Render where

import Protolude

import Data.Time.Duration (Milliseconds(..))
import Data.Variant (inj)
import Halogen.Hooks.Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import NextjsApp.Data.NonUsedUsername (NonUsedUsername__Error(..))
import NextjsApp.Data.NonUsedUsername as NonUsedUsername
import NextjsApp.Data.NonUsedEmail (NonUsedEmail__Error(..))
import NextjsApp.Data.NonUsedEmail as NonUsedEmail
import NextjsApp.Data.Password (PasswordError(..))
import NextjsApp.Data.Password as Password
import NextjsApp.Data.MatchingPassword (MatchingPasswordError(..))
import NextjsApp.Data.MatchingPassword as MatchingPassword
import NextjsApp.PageImplementations.Register.Css as NextjsApp.PageImplementations.Register.Css
import NextjsApp.PageImplementations.Register.Form.Types (FormChildSlots, RegisterForm, UserAction(..), prx)
import Halogen.Hooks.FormlessExtra
import NextjsApp.Route as NextjsApp.Route

renderUsernameHelper =
  case _ of
       NonUsedUsername__Error__Empty -> "Should not be empty"
       NonUsedUsername__Error__BadLength l -> "Should be between " <> show NonUsedUsername.minUsernameLength <> " and " <> show NonUsedUsername.maxUsernameLength <> " (currently " <> show l <> ")"
       NonUsedUsername__Error__BadFormat -> "Should contain only numbers, letter and underscore"
       NonUsedUsername__Error__InUse -> "Already in use"

renderEmailHelper =
  case _ of
       NonUsedEmail__Error__Empty -> "Should not be empty"
       NonUsedEmail__Error__BadFormat -> "Bad format"
       NonUsedEmail__Error__InUse -> "Already in use"

render
  :: forall st
   . F.PublicState RegisterForm st
  -> F.ComponentHTML RegisterForm UserAction FormChildSlots Aff
render state =
  HH.div
    [ Halogen.HTML.Properties.ARIA.role "form" ]
    [ HH.slot
        prx.username
        unit
        TextField.Outlined.outlined
        (
          let
            field = spy "rendering username field" $ F.getField prx.username state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With
              { id: "username"
              , labelText: "Username"
              }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Register.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "username-helper"
                , errorToErrorText: renderUsernameHelper
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.asyncSetValidate (Milliseconds 300.0) prx.username string
        )
    , HH.slot
        prx.email
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.email state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With
              { id: "email"
              , labelText: "Email"
              }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Register.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "email-helper"
                , errorToErrorText: renderEmailHelper
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.asyncSetValidate (Milliseconds 300.0) prx.email string
        )
    , HH.slot
        prx.password
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.password state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With { id: "password", labelText: "Password" }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Register.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "password-helper"
                , errorToErrorText: MatchingPassword.printMatchingPasswordError
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.injAction $ UserAction__PasswordUpdated string
        )
    , HH.slot
        prx.passwordConfirmation
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.passwordConfirmation state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With { id: "passwordConfirmation", labelText: "PasswordConfirmation" }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Register.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "password-helper"
                , errorToErrorText: MatchingPassword.printMatchingPasswordError
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.injAction $ UserAction__PasswordConfirmationUpdated string
        )
    , HH.div
      [ HP.class_ NextjsApp.PageImplementations.Register.Css.styles.buttons ]
      [ HH.slot
          (Proxy :: Proxy "submit-button")
          unit
          Button.button
          { variant: Button.Raised
          , config: Button.defaultConfig
            { additionalClasses = [ NextjsApp.PageImplementations.Register.Css.styles.buttons__button ]
            , disabled =
              case spy "rendering state.validity" state.validity of
                   F.Valid -> false
                   _       -> trace state $ const true
            }
          , content: [ HH.text "Submit" ]
          }
          (\(_ :: Button.Message) -> F.submit)
      , HH.slot
          (Proxy :: Proxy "login-button")
          unit
          Button.button
          { variant: Button.Text
          , config: Button.defaultConfig { additionalClasses = [ NextjsApp.PageImplementations.Register.Css.styles.buttons__button ] }
          , content: [ HH.text "Go to sign up" ]
          }
          (const $ inj (Proxy :: Proxy "userAction") $ UserAction__Navigate NextjsApp.Route.route__Login)
      ]
    ]
