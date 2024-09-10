module HalogenElementsExtra where

import Halogen.HTML as Halogen.HTML
import Halogen.HTML.Properties as Halogen.HTML.Properties

content :: ∀ r i. String -> Halogen.HTML.IProp ( content :: String | r ) i
content = Halogen.HTML.Properties.prop (Halogen.HTML.PropName "content")

async :: ∀ r i. String -> Halogen.HTML.IProp ( id :: String | r ) i
async = Halogen.HTML.prop (Halogen.HTML.PropName "async")

media_ :: forall r i. String -> Halogen.HTML.IProp ( media :: String | r ) i
media_ = Halogen.HTML.prop (Halogen.HTML.PropName "media")

as_ :: forall r i. String -> Halogen.HTML.IProp ( as :: String | r ) i
as_ = Halogen.HTML.prop (Halogen.HTML.PropName "as")
