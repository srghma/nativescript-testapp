module Example.Lazy.LazyLoaded (component) where

import Protolude

import Halogen as H
import Halogen.HTML as HH

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

render :: forall m query. Unit -> H.ComponentHTML query () m
render _ =
  HH.div_
    [ HH.text "I'm lazy loaded child (LOADED)"
    ]
