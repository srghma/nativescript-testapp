module NextjsApp.Router.Shared where

import Protolude

import FRP.Event as Event
import Halogen as H
import Halogen.HTML as HH
import Nextjs.Page as Nextjs.Page
import NextjsApp.AppM (AppM)
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.PageLoader as NextjsApp.PageLoader
import NextjsApp.Route as NextjsApp.Route
import Type.Proxy (Proxy(..))
import Web.HTML as Web.HTML

type CurrentPageInfo
  = { pageSpecWithInputBoxed :: Nextjs.Page.PageSpecWithInputBoxed
    , route :: Variant NextjsApp.Route.WebRoutesWithParamRow
    }

type HtmlContextInfo
  = { window :: Web.HTML.Window
    , document :: Web.HTML.HTMLDocument
    , body :: Web.HTML.HTMLElement
    , head :: Web.HTML.HTMLHeadElement
    }

----------------------
type ServerState
  = { currentPageInfo :: Maybe CurrentPageInfo -- todo: render not found page on nothing, remove maybe
    }

type ClientState
  = { currentPageInfo :: Maybe CurrentPageInfo
    , htmlContextInfo :: HtmlContextInfo
    , pageRegisteredEvent :: Event.Event NextjsApp.PageLoader.PageRegisteredEventData
    , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
    }

type MobileState
  = { currentPageInfo :: CurrentPageInfo
    , htmlContextInfo :: HtmlContextInfo
    }

data Query a
  = Navigate (Variant NextjsApp.Route.WebRoutesWithParamRow) a

type ChildSlots
    -- the index here ((Variant NextjsApp.Route.WebRoutesWithParamRow)) is very important, the page won't just update if we replace it with Unit
  = ( page :: H.Slot (Const Void) Void (Variant NextjsApp.Route.WebRoutesWithParamRow)
    )

renderPage :: forall action. CurrentPageInfo -> H.ComponentHTML action ChildSlots AppM
renderPage { route, pageSpecWithInputBoxed } =
  Nextjs.Page.unPageSpecWithInputBoxed
    (\pageSpecWithInput -> HH.slot (Proxy :: Proxy "page") route pageSpecWithInput.component pageSpecWithInput.input absurd)
    pageSpecWithInputBoxed

maybeRenderPage :: forall action r. { currentPageInfo :: Maybe CurrentPageInfo | r } -> H.ComponentHTML action ChildSlots AppM
maybeRenderPage { currentPageInfo } = case currentPageInfo of
  Nothing -> HH.div_ [ HH.text "Oh no! That page wasn't found." ]
  Just currentPageInfo' -> renderPage currentPageInfo'

callNavigateQueryIfNew :: forall output. H.HalogenIO Query output Aff -> Maybe (Variant NextjsApp.Route.WebRoutesWithParamRow) -> (Variant NextjsApp.Route.WebRoutesWithParamRow) -> Effect Unit
callNavigateQueryIfNew halogenIO oldRoute newRoute = when (oldRoute /= Just newRoute) (callNavigateQuery halogenIO newRoute)

callNavigateQuery :: forall output. H.HalogenIO Query output Aff -> (Variant NextjsApp.Route.WebRoutesWithParamRow) -> Effect Unit
callNavigateQuery halogenIO newRoute = launchAff_ $ halogenIO.query $ H.mkTell $ Navigate newRoute
