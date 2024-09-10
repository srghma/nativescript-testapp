module HalogenVdomStringRendererRaw where

import Protolude

import Halogen.HTML                     as Halogen.HTML
import Halogen.HTML.Core                as Halogen.HTML.Core
import Halogen.VDom.DOM.StringRenderer  as HalogenVdomStringRenderer.DOM

newtype RawTextWidget = RawTextWidget String

rawText :: ∀ i . String -> Halogen.HTML.HTML RawTextWidget i
rawText string = Halogen.HTML.Core.widget (RawTextWidget string)

renderHtmlWithRawTextSupport :: ∀ i . Halogen.HTML.HTML RawTextWidget i -> String
renderHtmlWithRawTextSupport html = HalogenVdomStringRenderer.DOM.render renderWidget (unwrap html)
  where
    renderWidget (RawTextWidget string) = string
