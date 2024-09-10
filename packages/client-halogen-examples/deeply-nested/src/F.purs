module Example.DeeplyNested.F (component) where

import Prelude

import Halogen as H
import Halogen.HTML as HH

type State = Unit

data Action = Void

type ChildSlots = ()

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
    [ HH.li_ [ HH.text "f" ]
    ]
