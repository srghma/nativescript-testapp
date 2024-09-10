module NextjsApp.PageImplementations.Secret (component) where

import NextjsApp.PageImplementations.Secret.Types
import Protolude
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import NextjsApp.Route as NextjsApp.Route

type Query
  = Const Void

type Input
  = SecretPageUserData

type Message
  = Void

type State
  = SecretPageUserData

type Action
  = Void

type ChildSlots
  = ()

component :: H.Component Query Input Message AppM
component =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval $ H.defaultEval
    }

render
  :: forall (slots :: Row Type) routes
   . State
  -> HH.ComponentHTML
     Action
     (slots :: Row Type)
     (AppM routes)
render (SecretPageUserData input) =
  HH.div_
  [ HH.text "You are on secret page"
  , HH.text $ show input
  ]
