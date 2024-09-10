module Example.DeeplyNested.B (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Example.DeeplyNested.D as D
import Example.DeeplyNested.E as E
import Data.Const (Const)
import Type.Proxy (Proxy(..))

type State = Unit

data Action = Void

type ChildSlots =
  ( d :: H.Slot (Const Void) Void Unit
  , e :: H.Slot (Const Void) Void Unit
  )

_d :: Proxy "d"
_d = Proxy

_e :: Proxy "e"
_e = Proxy

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

render :: forall m. State -> H.ComponentHTML Action ChildSlots m
render state =
  HH.ul_
    [ HH.li_ [ HH.text "b" ]
    , HH.li_ [ HH.slot _d unit D.component unit absurd ]
    , HH.li_ [ HH.slot _e unit E.component unit absurd ]
    , HH.li_ [ HH.text "b end" ]
    ]
