module NextjsApp.PageImplementations.Register.Form.Types where

import NextjsApp.Data.MatchingPassword
import NextjsApp.Data.NonUsedEmail
import NextjsApp.Data.NonUsedUsername
import Protolude

import Halogen.Hooks.Formless as F
import Halogen as H
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined

import NextjsApp.Route as NextjsApp.Route

data UserAction
  = UserAction__Navigate (Variant NextjsApp.Route.WebRoutesWithParamRow)
  | UserAction__PasswordUpdated String
  | UserAction__PasswordConfirmationUpdated String

type RegisterFormRow f =
  ( username             :: f NonUsedUsername__Error String NonUsedUsername
  , email                :: f NonUsedEmail__Error String NonUsedEmail
  , password             :: f MatchingPasswordError String MatchingPassword
  , passwordConfirmation :: f MatchingPasswordError String MatchingPassword
  )

newtype RegisterForm r f = RegisterForm (r (RegisterFormRow f))

derive instance newtypeRegisterForm :: Newtype (RegisterForm r f) _

-- equivalent to { email :: Email, ... }
type RegisterDataValidated = { | RegisterFormRow F.OutputType }

type FormChildSlots =
  ( username             :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , email                :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password             :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , passwordConfirmation :: H.Slot (Const Void) TextField.Outlined.Message Unit

  , "login-button"  :: H.Slot (Const Void) Button.Message Unit
  , "submit-button" :: H.Slot (Const Void) Button.Message Unit
  )

prx ::
  { username             :: Proxy "username"
  , email                :: Proxy "email"
  , password             :: Proxy "password"
  , passwordConfirmation :: Proxy "passwordConfirmation"
  }
prx = F.mkSProxies (F.FormProxy :: F.FormProxy RegisterForm)
