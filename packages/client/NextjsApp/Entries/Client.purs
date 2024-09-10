module NextjsApp.Entries.Client where

import Data.Argonaut.Core as ArgonautCore
import Data.Argonaut.Decode as ArgonautCodecs
import Data.Either (hush)
import Effect.Aff as Effect.Aff
import FRP.Event as FRP.Event
import Halogen as H
import Halogen.Aff.Util as Halogen.Aff.Util
import Halogen.VDom.Driver as Halogen.VDom.Driver
import NextjsApp.AppM (Env, runAppM)
import NextjsApp.Constants as NextjsApp.Constants
import Nextjs.Page as Nextjs.Page
import Nextjs.Utils (findJsonFromScriptElement, getPathWithoutOrigin, getHtmlEntities)
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.Navigate.Client as NextjsApp.Navigate.Client
import NextjsApp.PageLoader as NextjsApp.PageLoader
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.Router.Client as NextjsApp.Router.Client
import NextjsApp.Router.Shared as NextjsApp.Router.Shared
import Protolude
import Routing.Duplex as Routing.Duplex
import Routing.Duplex.Parser as Routing.Duplex
import Routing.PushState as Routing.PushState
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML as Web.HTML
import Web.HTML.Window as Web.HTML.Window
import Web.IntersectionObserver as Web.IntersectionObserver
import Web.IntersectionObserverEntry as Web.IntersectionObserverEntry
import NextjsApp.Link.Client as NextjsApp.Link.Client
import NextjsApp.WebRouteDuplexCodec as NextjsApp.WebRouteDuplexCodec

getPrerenderedJson :: Aff ArgonautCore.Json
getPrerenderedJson = findJsonFromScriptElement (Web.DOM.ParentNode.QuerySelector NextjsApp.Constants.pagesDataId)

getInitialRouteFromLocation :: Effect (Either Routing.Duplex.RouteError (Variant NextjsApp.Route.WebRoutesWithParamRow))
getInitialRouteFromLocation = Routing.Duplex.parse NextjsApp.WebRouteDuplexCodec.routeCodec <$> (Web.HTML.window >>= Web.HTML.Window.location >>= getPathWithoutOrigin)

intersectionObserverEventAndCallback ::
  Effect
    { intersectionObserverCallback :: Array Web.IntersectionObserverEntry.IntersectionObserverEntry -> Web.IntersectionObserver.IntersectionObserver -> Effect Unit
    , intersectionObserverEvent :: FRP.Event.Event (Array Web.IntersectionObserverEntry.IntersectionObserverEntry)
    }
intersectionObserverEventAndCallback = do
  { event, push } <- FRP.Event.create
  pure
    { intersectionObserverCallback: \entries _ -> push entries
    , intersectionObserverEvent: event
    }

intersectionObserverOptions :: Web.IntersectionObserver.IntersectionObserverInit
intersectionObserverOptions = Web.IntersectionObserver.defaultIntersectionObserverInit { rootMargin = "200px" }

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities
  { intersectionObserverEvent, intersectionObserverCallback } <- intersectionObserverEventAndCallback
  (intersectionObserver :: Web.IntersectionObserver.IntersectionObserver) <- Web.IntersectionObserver.create intersectionObserverCallback intersectionObserverOptions
  pageRegisteredEvent <- NextjsApp.PageLoader.createPageRegisteredEvent

  -- https://github.com/slamdata/purescript-routing/blob/v8.0.0/GUIDE.md
  -- https://github.com/natefaubion/purescript-routing-duplex/blob/v0.2.0/README.md
  pushStateInterface <- Routing.PushState.makeInterface

  -- first we'll get the route the user landed on
  maybeRoute <- getInitialRouteFromLocation <#> hush

  Effect.Aff.launchAff_ do
    (clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest) <- NextjsApp.Manifest.ClientPagesManifest.getBuildManifest

    currentPageInfo <-
      case maybeRoute of
           Nothing -> pure Nothing
           Just route -> do
              page <- NextjsApp.PageLoader.loadPage clientPagesManifest document body head pageRegisteredEvent route

              (pageSpecWithInputBoxed :: Nextjs.Page.PageSpecWithInputBoxed) <-
                Nextjs.Page.pageSpecBoxed_to_PageSpecWithInputBoxed_givenInitialJson getPrerenderedJson page
                  >>= (throwError <<< error <<< ArgonautCodecs.printJsonDecodeError)
                  \/ pure

              pure $ Just
                  { pageSpecWithInputBoxed
                  , route
                  }

    let
      initialState =
        { pageRegisteredEvent
        , clientPagesManifest
        , htmlContextInfo:
          { window
          , document
          , body
          , head
          }
        , currentPageInfo
        }

      (env :: Env) =
        { navigate: NextjsApp.Navigate.Client.navigate pushStateInterface
        , linkHandleActions:
          NextjsApp.Link.Client.mkLinkHandleActions
            { intersectionObserver
            , intersectionObserverEvent
            , clientPagesManifest
            , document
            , head
            }
        }

      component = H.hoist (runAppM env) NextjsApp.Router.Client.component
    rootElement <- Halogen.Aff.Util.awaitElement (Web.DOM.ParentNode.QuerySelector "#root")

    halogenIO <- Halogen.VDom.Driver.hydrateUI component initialState rootElement

    void $ liftEffect $ Routing.PushState.matchesWith (Routing.Duplex.parse NextjsApp.WebRouteDuplexCodec.routeCodec) (NextjsApp.Router.Shared.callNavigateQueryIfNew halogenIO) pushStateInterface
