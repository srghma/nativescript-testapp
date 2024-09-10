module NextjsApp.PageImplementations.Login.Form
  ( module NextjsApp.PageImplementations.Login.Form
  , module NextjsApp.PageImplementations.Login.Form.Types
  )
  where

import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Data.InUseUsernameOrEmail as NextjsApp.Data.InUseUsernameOrEmail
import Protolude

import Halogen.Hooks.Formless as F
import Halogen.Component as Halogen.Component
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Login.Form.Render (render)
import NextjsApp.PageImplementations.Login.Form.Types (FormChildSlots, LoginDataValidated, LoginForm(..), LoginFormRow, UserAction(..))

formComponent ::
  forall m r.
  MonadAsk { navigate :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  F.Component LoginForm (Const Void) FormChildSlots Unit LoginDataValidated m
formComponent = F.component (const formInput) formSpec
  where
    formInput :: F.Input' LoginForm m
    formInput =
      { initialInputs: Nothing -- same as: Just (F.wrapInputFields { name: "", age: "" })
      , validators: LoginForm
          { password: F.hoistFnE_ $ NextjsApp.Data.Password.fromString
          , usernameOrEmail: F.hoistFnME_ (\s -> liftAff $ NextjsApp.Data.InUseUsernameOrEmail.fromString s)
          }
      }

    formSpec :: forall input st . F.Spec LoginForm st (Const Void) UserAction FormChildSlots input LoginDataValidated m
    formSpec = F.defaultSpec
      { render = render >>> lmap (Halogen.Component.hoistSlot liftAff)
      , handleEvent = F.raiseResult
      , handleAction = handleAction
      }
      where

      handleAction ::
        UserAction ->
        F.HalogenM LoginForm st UserAction FormChildSlots LoginDataValidated m Unit
      handleAction =
        case _ of
             UserAction__Navigate route -> NextjsApp.Navigate.navigate route
