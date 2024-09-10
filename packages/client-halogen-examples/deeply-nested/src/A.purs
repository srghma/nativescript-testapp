module Example.DeeplyNested.A (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Example.DeeplyNested.B as B
import Example.DeeplyNested.C as C
import Data.Const (Const)
import Type.Proxy (Proxy(..))

type State = Unit

data Action = Void

type ChildSlots =
  ( b :: H.Slot (Const Void) Void Unit
  , c :: H.Slot (Const Void) Void Unit
  )

_b :: Proxy "b"
_b = Proxy

_c :: Proxy "c"
_c = Proxy

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
    [ HH.li_ [ HH.text "a" ]
    , HH.li_ [ HH.slot _b unit B.component unit absurd ]
    , HH.li_ [ HH.slot _c unit C.component unit absurd ]
    , HH.li_ [ HH.text "a end" ]
    ]
