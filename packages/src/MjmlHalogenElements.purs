module MjmlHalogenElements where

import Protolude
import Halogen.HTML.Core (ElemName(..), HTML(..), Namespace, Prop)
import Halogen.HTML.Core as Core
import Halogen.HTML.Properties (IProp)
import Halogen.HTML.Elements (Node, Leaf, element)

type HTMLmjml =
  ( owa :: String
  , lang :: String
  )

mjml :: forall w i. Node HTMLmjml w i
mjml = element (ElemName "mjml")

mjml_ :: forall w i. Array (HTML w i) -> HTML w i
mjml_ = mjml []

--------------------

type HTMLmj_body =
  ( "background-color" :: String
  , "css-class" :: String
  , width :: String
  )

mj_body :: forall w i. Node HTMLmj_body w i
mj_body = element (ElemName "mj-body")

mj_body_ :: forall w i. Array (HTML w i) -> HTML w i
mj_body_ = mj_body []

--------------------

type HTMLmj_section =
  ( "background-color" :: String
  , "background-position" :: String
  , "background-position-x" :: String
  , "background-position-y" :: String
  , "background-repeat" :: String
  , "background-size" :: String
  , "background-url" :: String
  , "border" :: String
  , "border-bottom" :: String
  , "border-left" :: String
  , "border-radius" :: String
  , "border-right" :: String
  , "border-top" :: String
  , "css-class" :: String
  , "direction" :: String
  , "full-width" :: String
  , "padding" :: String
  , "padding-bottom" :: String
  , "padding-left" :: String
  , "padding-right" :: String
  , "padding-top" :: String
  , "text-align" :: String
  )

mj_section :: forall w i. Node HTMLmj_section w i
mj_section = element (ElemName "mj-section")

mj_section_ :: forall w i. Array (HTML w i) -> HTML w i
mj_section_ = mj_section []

--------------------

type HTMLmj_column =
  ( "background-color" :: String
  , "inner-background-color" :: String
  , "border" :: String
  , "border-bottom" :: String
  , "border-left" :: String
  , "border-right" :: String
  , "border-top" :: String
  , "border-radius" :: String
  , "inner-border" :: String
  , "inner-border-bottom" :: String
  , "inner-border-left" :: String
  , "inner-border-right" :: String
  , "inner-border-top" :: String
  , "inner-border-radius" :: String
  , "width" :: String
  , "vertical-align" :: String
  , "padding" :: String
  , "padding-top" :: String
  , "padding-bottom" :: String
  , "padding-left" :: String
  , "padding-right" :: String
  , "css-class" :: String
  )

mj_column :: forall w i. Node HTMLmj_column w i
mj_column = element (ElemName "mj-column")

mj_column_ :: forall w i. Array (HTML w i) -> HTML w i
mj_column_ = mj_column []


--------------------

type HTMLmj_text =
  ( "color" :: String
  , "font-family" :: String
  , "font-size" :: String
  , "font-style" :: String
  , "font-weight" :: String
  , "line-height" :: String
  , "letter-spacing" :: String
  , "height" :: String
  , "text-decoration" :: String
  , "text-transform" :: String
  , "align" :: String
  , "container-background-color" :: String
  , "padding" :: String
  , "padding-top" :: String
  , "padding-bottom" :: String
  , "padding-left" :: String
  , "padding-right" :: String
  , "css-class" :: String
  )

mj_text :: forall w i. Node HTMLmj_text w i
mj_text = element (ElemName "mj-text")

mj_text_ :: forall w i. Array (HTML w i) -> HTML w i
mj_text_ = mj_text []
