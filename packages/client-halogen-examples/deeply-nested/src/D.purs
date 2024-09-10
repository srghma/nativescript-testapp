module Example.DeeplyNested.D (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Example.DeeplyNested.F as F
import Data.Const (Const)
import Type.Proxy (Proxy(..))

type State = Unit

data Action = Void

type ChildSlots =
  ( f :: H.Slot (Const Void) Void Unit
  )

_f :: Proxy "f"
_f = Proxy

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
    [ HH.li_ [ HH.text "d" ]
    , HH.li_ [ HH.slot _f unit F.component unit absurd ]
    , HH.li_ [ HH.text "d end" ]
    ]
