module NextjsApp.PageImplementations.Login.Form.Types where

import Protolude

import Halogen.Hooks.Formless as F
import Halogen as H
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail, InUseUsernameOrEmail__Error)
import NextjsApp.Data.Password (Password, PasswordError)

import NextjsApp.Route as NextjsApp.Route

data UserAction
  = UserAction__Navigate (Variant NextjsApp.Route.WebRoutesWithParamRow)

type LoginFormRow f =
  ( usernameOrEmail :: f InUseUsernameOrEmail__Error String InUseUsernameOrEmail
  , password :: f PasswordError String Password
  )

newtype LoginForm r f = LoginForm (r (LoginFormRow f))

derive instance newtypeLoginForm :: Newtype (LoginForm r f) _

-- equivalent to { email :: Email, ... }
type LoginDataValidated = { | LoginFormRow F.OutputType }

type FormChildSlots =
  ( usernameOrEmail   :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , password          :: H.Slot (Const Void) TextField.Outlined.Message Unit
  , "register-button" :: H.Slot (Const Void) Button.Message Unit
  , "submit-button"   :: H.Slot (Const Void) Button.Message Unit
  )

prx ::
  { password :: Proxy "password"
  , usernameOrEmail :: Proxy "usernameOrEmail"
  }
prx = F.mkSProxies (F.FormProxy :: F.FormProxy LoginForm)
