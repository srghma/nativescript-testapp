module NextjsApp.Entries.Mobile where

import Protolude

import Cordova.EventTypes as Cordova
import Effect.Aff as Effect.Aff
import Effect.Exception.Unsafe (unsafeThrowException)
import FRP.Event as FRP.Event
import Halogen as H
import Halogen.VDom.Driver as Halogen.VDom.Driver
import Nextjs.Page as Nextjs.Page
import Nextjs.Utils (getHtmlEntities, selectElementRequired)
import NextjsApp.AppM (Env, runAppM)
import NextjsApp.Link.Mobile as NextjsApp.Link.Mobile
import NextjsApp.Navigate.Mobile as NextjsApp.Navigate.Mobile
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.WebRouteToPageServer as NextjsApp.WebRouteToPageServer
import NextjsApp.Router.Mobile as NextjsApp.Router.Mobile
import NextjsApp.Router.Shared (MobileState, HtmlContextInfo)
import NextjsApp.Router.Shared as NextjsApp.Router.Shared
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.Event.Event (EventType)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML as Web.HTML
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument

onDocumentEvent ::
  forall e.
  EventType ->
  Web.HTML.HTMLDocument ->
  Effect Unit ->
  Effect Unit
onDocumentEvent eventType document callback = do
  eventListener' <- eventListener \_ -> callback
  addEventListener eventType eventListener' false (Web.HTML.HTMLDocument.toEventTarget document)

goToRouteAndHandleRedirect
  :: { document ∷ Web.HTML.HTMLDocument
     , env ∷ Env
     , htmlContextInfo ∷ HtmlContextInfo
     , newRouteEventIO ∷ FRP.Event.EventIO (Variant NextjsApp.Route.WebRoutesWithParamRow)
     , route ∷ (Variant NextjsApp.Route.WebRoutesWithParamRow)
     , sessionHeader ∷ Maybe (Tuple String String)
     }
  → Aff Unit
goToRouteAndHandleRedirect input@{ document, newRouteEventIO, env, sessionHeader, htmlContextInfo, route } = do
  let
    (page :: Nextjs.Page.PageSpecBoxed) = NextjsApp.WebRouteToPageServer.webRouteToPageSpecBoxed route NextjsApp.WebRouteToPageServer.routeIdMapping

  Nextjs.Page.pageSpecBoxed_to_PageSpecWithInputBoxed_request (Nextjs.Page.PageData_DynamicRequestOptions__Mobile { sessionHeader }) page
    >>= case _ of
      Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error x -> do
         let
            initialState :: MobileState
            initialState =
              { htmlContextInfo
              , currentPageInfo:
                { pageSpecWithInputBoxed: unsafeThrowException $ error "TODO"
                , route
                }
              }

         unsafeThrowException $ error "TODO"
         -- | NextjsApp.Router.Mobile.renderErrorPage initialState x
      Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Redirect { redirectToLocation, logout } -> do
        when logout (liftEffect NextjsApp.Router.Mobile.logoutByRemovingJwtFromSecureStorage)

        goToRouteAndHandleRedirect (input { route = redirectToLocation })
      Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success pageSpecWithInputBoxed -> do
        let
          component = H.hoist (runAppM env) NextjsApp.Router.Mobile.component

          initialState =
            { htmlContextInfo
            , currentPageInfo:
              { pageSpecWithInputBoxed
              , route
              }
            }
        rootElement <- selectElementRequired (Web.DOM.ParentNode.QuerySelector "#root") -- selectElement instead of awaitElement because there is no need to wait for window to load
        halogenIO <- Halogen.VDom.Driver.runUI component initialState rootElement

        void $ liftEffect $ FRP.Event.subscribe newRouteEventIO.event \newRoute -> NextjsApp.Router.Shared.callNavigateQuery halogenIO newRoute

        -- TODO: go back in history
        void $ liftEffect $ onDocumentEvent Cordova.backbutton document (NextjsApp.Router.Shared.callNavigateQuery halogenIO NextjsApp.Route.route__Index)

main :: Effect Unit
main = do
  { window, document, body, head } <- getHtmlEntities
  (newRouteEventIO :: FRP.Event.EventIO (Variant NextjsApp.Route.WebRoutesWithParamRow)) <- FRP.Event.create
  -- first we'll get the route the user landed on
  let
    (route :: (Variant NextjsApp.Route.WebRoutesWithParamRow)) = NextjsApp.Route.route__Index
    (env :: Env) =
      { navigate: NextjsApp.Navigate.Mobile.navigate newRouteEventIO
      , linkHandleActions: NextjsApp.Link.Mobile.mkLinkHandleActions
      }
  onDocumentEvent Cordova.deviceready document $ Effect.Aff.launchAff_ do
    sessionHeader <- liftEffect NextjsApp.Router.Mobile.getMobileSessionHeaderFromSecureStorage

    let
      htmlContextInfo :: HtmlContextInfo
      htmlContextInfo =
        { window
        , document
        , body
        , head
        }

    goToRouteAndHandleRedirect { document, newRouteEventIO, env, sessionHeader, htmlContextInfo, route }
