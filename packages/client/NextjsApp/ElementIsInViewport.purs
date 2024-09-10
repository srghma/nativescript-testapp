module NextjsApp.ElementIsInViewport where

import Protolude
import Data.Array as Array
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import FRP.Event as FRP.Event
import Halogen.VDom.Util as Halogen.VDom.Util
import Data.Function.Uncurried as Fn
import Web.DOM as Web.DOM

filterAndThrow :: forall a b. b -> (a -> Boolean) -> FRP.Event.Event a -> FRP.Event.Event b
filterAndThrow b p event = FRP.Event.makeEvent \k -> FRP.Event.subscribe event \a -> if p a then k b else pure unit

elementIsInViewport :: forall action. FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry) -> action -> Web.DOM.Element -> FRP.Event.Event action
elementIsInViewport intersectionObserverEvent action element = do
  let
    isElementInViewport :: Array Web.IntersectionObserverEntry.IntersectionObserverEntry -> Boolean
    isElementInViewport =
      Array.any \entry ->
        let
          target = Web.IntersectionObserverEntry.target entry
        in
          Fn.runFn2 Halogen.VDom.Util.refEq element target
  filterAndThrow action isElementInViewport intersectionObserverEvent
