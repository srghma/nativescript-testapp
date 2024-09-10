module NextjsApp.Link.Lib where

import Protolude

import Control.Monad.Reader.Class (class MonadAsk)
import Control.Monad.State (class MonadState)
import Effect.Class (class MonadEffect)
import Halogen as H
import NextjsApp.Navigate as NextjsApp.Navigate
import Web.Event.Event as Web.Event.Event
import Web.UIEvent.MouseEvent (MouseEvent)
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent

elementLabel :: H.RefLabel
elementLabel = H.RefLabel "link"

handleMouseEvent :: ∀ t16 t17 t19 t4. Bind t4 ⇒ MonadEffect t4 ⇒ MonadState { route :: Variant t17 | t16 } t4 ⇒ MonadAsk { navigate :: Variant t17 -> Effect Unit | t19 } t4 ⇒ MouseEvent → t4 Unit
handleMouseEvent mouseEvent = do
  -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
  H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

  H.gets _.route >>= NextjsApp.Navigate.navigate
