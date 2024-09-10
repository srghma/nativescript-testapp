module NextjsApp.PageImplementations.Register.Form
  ( module NextjsApp.PageImplementations.Register.Form
  , module NextjsApp.PageImplementations.Register.Form.Types
  )
  where

import Protolude

import Halogen.Hooks.Formless as F
import Halogen.Component as Halogen.Component
import NextjsApp.Data.MatchingPassword as NextjsApp.Data.MatchingPassword
import NextjsApp.Data.NonUsedEmail as NextjsApp.Data.NonUsedEmail
import NextjsApp.Data.NonUsedUsername as NextjsApp.Data.NonUsedUsername
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.PageImplementations.Register.Form.Render (render)
import NextjsApp.PageImplementations.Register.Form.Types (FormChildSlots, RegisterDataValidated, RegisterForm(..), RegisterFormRow, UserAction(..), prx)
import NextjsApp.Route as NextjsApp.Route

formComponent ::
  forall m r.
  MonadAsk { navigate :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  F.Component RegisterForm (Const Void) FormChildSlots Unit RegisterDataValidated m
formComponent = F.component (const formInput) formSpec
  where
    formInput :: F.Input' RegisterForm m
    formInput =
      { initialInputs: Nothing
      , validators: RegisterForm
        { password:             F.hoistFnE \form input -> NextjsApp.Data.MatchingPassword.fromString { current: input, expectedToEqualTo: F.getInput prx.passwordConfirmation form }
        , passwordConfirmation: F.hoistFnE \form input -> NextjsApp.Data.MatchingPassword.fromString { current: input, expectedToEqualTo: F.getInput prx.password form }
        , username:             F.hoistFnME_ \s -> liftAff $ NextjsApp.Data.NonUsedUsername.fromString s
        , email:                F.hoistFnME_ \s -> liftAff $ NextjsApp.Data.NonUsedEmail.fromString s
        }
      }

    formSpec :: forall input . F.Spec RegisterForm _ (Const Void) UserAction FormChildSlots input RegisterDataValidated m
    formSpec = F.defaultSpec
      { render = render >>> lmap (Halogen.Component.hoistSlot liftAff)
      , handleEvent = handleEvent
      , handleAction = handleAction
      }
      where

      handleEvent :: F.Event RegisterForm _ -> F.HalogenM RegisterForm _ UserAction FormChildSlots _ m Unit
      handleEvent = F.raiseResult

      handleAction ::
        UserAction ->
        F.HalogenM RegisterForm _ UserAction FormChildSlots RegisterDataValidated m Unit
      handleAction =
        case _ of
             UserAction__Navigate route -> NextjsApp.Navigate.navigate route
             UserAction__PasswordUpdated string -> do
                eval $ F.setValidate prx.password string
                eval $ F.validate prx.passwordConfirmation
             UserAction__PasswordConfirmationUpdated string -> do
                eval $ F.setValidate prx.passwordConfirmation string
                eval $ F.validate prx.password

        where
        eval :: F.Action RegisterForm UserAction -> _
        eval act = F.handleAction handleAction handleEvent act
