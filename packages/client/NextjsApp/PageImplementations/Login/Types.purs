module NextjsApp.PageImplementations.Login.Types where

import Protolude

import Halogen.Hooks.Formless as F
import Halogen as H
import NextjsApp.PageImplementations.Login.Form (FormChildSlots, LoginDataValidated, LoginForm)

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

data Action
  = Action__HandleLoginForm LoginDataValidated

type ChildSlots
  = ( formless :: H.Slot (F.Query LoginForm (Const Void) FormChildSlots) LoginDataValidated Unit )

data LoginError
  = LoginError__LoginFailed
  | LoginError__UnknownError String
  -- | | LoginError__UsernameOrEmailNotRegistered

type State = { loginError :: Maybe LoginError }
