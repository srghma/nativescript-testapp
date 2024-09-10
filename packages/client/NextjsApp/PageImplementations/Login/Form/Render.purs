module NextjsApp.PageImplementations.Login.Form.Render where

import Protolude

import Data.Time.Duration (Milliseconds(..))
import Data.Variant (inj)
import Halogen.Hooks.Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as Halogen.HTML.Properties.ARIA
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail__Error(..))
import NextjsApp.Data.Password (PasswordError(..))
import NextjsApp.Data.Password as Password
import NextjsApp.Data.MatchingPassword (MatchingPasswordError(..))
import NextjsApp.Data.MatchingPassword as MatchingPassword
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css
import NextjsApp.PageImplementations.Login.Form.Types (FormChildSlots, LoginForm, UserAction(..), prx)
import Halogen.Hooks.FormlessExtra
import NextjsApp.Route as NextjsApp.Route

render
  :: forall st
   . F.PublicState LoginForm st
  -> F.ComponentHTML LoginForm UserAction FormChildSlots Aff
render state =
  HH.div
    [ Halogen.HTML.Properties.ARIA.role "form" ]
    [ HH.slot
        prx.usernameOrEmail
        unit
        TextField.Outlined.outlined
        (
          let
            field = F.getField prx.usernameOrEmail state.form
          in TextField.Outlined.defaultConfig
            { label = TextField.Outlined.LabelConfig__With
              { id: "usernameOrEmail"
              , labelText: "Username / email"
              }
            , value = field.input
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "usernameOrEmail-helper"
                , errorToErrorText:
                    case _ of
                         InUseUsernameOrEmail__Error__Empty -> "Username or email is empty"
                         InUseUsernameOrEmail__Error__NotInUse -> "Username or email is not found"
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.asyncSetValidate (Milliseconds 300.0) prx.usernameOrEmail string
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
            , additionalClassesRoot = [ NextjsApp.PageImplementations.Login.Css.styles.input ]
            , invalid = isErrorFormFieldResult field.result
            , helperText =
                mkHelperText
                { result: field.result
                , id: "password-helper"
                , errorToErrorText: Password.printPasswordError
                }
            }
        )
        (\(message :: TextField.Outlined.Message) ->
          case message of
               TextField.Outlined.Message__Input string -> F.setValidate prx.password string
        )
    , HH.div
      [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.buttons ]
      [ HH.slot
          (Proxy :: Proxy "submit-button")
          unit
          Button.button
          { variant: Button.Raised
          , config: Button.defaultConfig
            { additionalClasses = [ NextjsApp.PageImplementations.Login.Css.styles.buttons__button ]
            , disabled =
              case state.validity of
                   F.Valid -> false
                   _       -> true
            }
          , content: [ HH.text "Submit" ]
          }
          (\(_ :: Button.Message) -> F.submit)
      , HH.slot
          (Proxy :: Proxy "register-button")
          unit
          Button.button
          { variant: Button.Text
          , config: Button.defaultConfig { additionalClasses = [ NextjsApp.PageImplementations.Login.Css.styles.buttons__button ] }
          , content: [ HH.text "Go to login page" ]
          }
          (\_ -> inj (Proxy :: Proxy "userAction") $ UserAction__Navigate NextjsApp.Route.route__Register)
      ]
    ]
