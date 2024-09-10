module NextjsApp.PageImplementations.VerifyUserEmailWeb.Types where

import Protolude

import Halogen as H

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

data Action
  = Action__Initialize

type ChildSlots = ()

data VerifyUserEmailError
  = VerifyUserEmailError__TokenExpired
  | VerifyUserEmailError__Unknown String

type State =
  { loginError :: Maybe VerifyUserEmailError
  }
