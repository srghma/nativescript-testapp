module NextjsApp.PageImplementations.Register.Types where

import Protolude

import Halogen.Hooks.Formless as F
import Halogen as H
import NextjsApp.PageImplementations.Register.Form (FormChildSlots, RegisterDataValidated, RegisterForm)

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

data Action
  = Action__HandleRegisterForm RegisterDataValidated

type ChildSlots
  = ( formless :: H.Slot (F.Query RegisterForm (Const Void) FormChildSlots) RegisterDataValidated Unit )

data RegisterError
  = RegisterError__RegisterFailed
  | RegisterError__UnknownError String
  -- | | RegisterError__UsernameOrEmailNotRegistered

type State = { registerError :: Maybe RegisterError }
