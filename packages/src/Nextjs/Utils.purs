module Nextjs.Utils where

import Protolude
import Data.Argonaut as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Halogen.Aff.Util as Halogen.Aff.Util
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.HTML.HTMLScriptElement as Web.HTML.HTMLScriptElement
import Web.HTML.Location as Web.HTML.Location
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.Window as Web.HTML.Window
import Web.HTML.HTMLHeadElement as Web.HTML.HTMLHeadElement

-- extracted from https://github.com/purescript-contrib/purescript-routing/blob/62742c314b7a30118399f1b98fdec27212f8f40e/src/Routing/PushState.purs#L81-L87
getPathWithoutOrigin :: Web.HTML.Location.Location -> Effect String
getPathWithoutOrigin loc = do
  pathname <- Web.HTML.Location.pathname loc
  search <- Web.HTML.Location.search loc
  hash <- Web.HTML.Location.hash loc
  let
    path = pathname <> search <> hash
  pure path

------------------
selectElementRequired :: Web.DOM.ParentNode.QuerySelector -> Aff Web.HTML.HTMLElement.HTMLElement
selectElementRequired query = Halogen.Aff.Util.selectElement query >>= maybe (throwError (error $ "Could not find " <> unwrap query)) pure

findJsonFromScriptElement :: Web.DOM.ParentNode.QuerySelector -> Aff ArgonautCore.Json
findJsonFromScriptElement querySelector = do
  element <- selectElementRequired querySelector
  let
    (htmlScriptElement :: Maybe Web.HTML.HTMLScriptElement.HTMLScriptElement) = Web.HTML.HTMLScriptElement.fromHTMLElement element
  htmlScriptElement' <- maybe (throwError (error "Not an HTMLScriptElement")) pure htmlScriptElement
  text <- liftEffect $ Web.HTML.HTMLScriptElement.text htmlScriptElement'
  let
    (json :: Either String ArgonautCore.Json) = ArgonautCore.jsonParser text
  json' <- either (throwError <<< error) pure json
  pure json'

------------------
requiredJsonDecodeResult :: forall a m. MonadThrow Error m => Either ArgonautCodecs.JsonDecodeError a -> m a
requiredJsonDecodeResult = ArgonautCodecs.printJsonDecodeError >>> error >>> throwError \/ pure

------------------
getHtmlEntities ::
  Effect
    { window :: Web.HTML.Window.Window
    , document :: Web.HTML.HTMLDocument
    , body :: Web.HTML.HTMLElement
    , head :: Web.HTML.HTMLHeadElement
    }
getHtmlEntities = do
  (window :: Web.HTML.Window.Window) <- Web.HTML.window
  (document :: Web.HTML.HTMLDocument) <- Web.HTML.Window.document window
  (body :: Web.HTML.HTMLElement) <- Web.HTML.HTMLDocument.body document >>= maybe (throwError $ error "Cannot find body") pure
  (head :: Web.HTML.HTMLHeadElement) <- do
    (head :: Web.HTML.HTMLElement) <- Web.HTML.HTMLDocument.head document >>= maybe (throwError $ error "Cannot find head") pure
    Web.HTML.HTMLHeadElement.fromHTMLElement head # maybe (throwError $ error "not head") pure
  pure { window, document, body, head }
