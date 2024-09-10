module NextjsApp.Router.Mobile where

import Protolude

import Halogen as H
import Nextjs.Page as Nextjs.Page
import NextjsApp.AppM (AppM)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.WebRouteToPageServer as NextjsApp.WebRouteToPageServer
import NextjsApp.Router.Shared (ChildSlots, MobileState, Query(..), renderPage)

component :: H.Component Query MobileState Void AppM
component =
  H.mkComponent
    { initialState: identity
    , render: \{ currentPageInfo } -> renderPage currentPageInfo
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleQuery = handleQuery
            }
    }

handleQuery :: forall next action. Query next -> H.HalogenM MobileState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get
    -- don't re-render unnecessarily if the route is unchanged
    when (currentState.currentPageInfo.route /= destRoute) (mobileLoadAndPutNewPage currentState destRoute)
    pure (Just a)

getMobileSessionHeaderFromSecureStorage :: Effect (Maybe (Tuple String String))
getMobileSessionHeaderFromSecureStorage = throwError $ error "TODO"

renderErrorPage :: forall action . String -> H.HalogenM MobileState action ChildSlots Void AppM Unit
renderErrorPage str = H.liftEffect $ throwError $ error $ "PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error (TODO: render error page): " <> str

logoutByRemovingJwtFromSecureStorage :: Effect Unit
logoutByRemovingJwtFromSecureStorage = throwError $ error $ "TODO: logout on mobile is not yet possible"

mobileLoadAndPutNewPage
  :: forall action
   . MobileState
  -> Variant NextjsApp.Route.WebRoutesWithParamRow
  -> H.HalogenM MobileState action ChildSlots Void AppM Unit
mobileLoadAndPutNewPage currentState destRoute = do
  sessionHeader <- H.liftEffect getMobileSessionHeaderFromSecureStorage

  ( H.liftAff
    $ Nextjs.Page.pageSpecBoxed_to_PageSpecWithInputBoxed_request
      ( Nextjs.Page.PageData_DynamicRequestOptions__Mobile { sessionHeader })
      ( NextjsApp.WebRouteToPageServer.webRouteToPageSpecBoxed
        destRoute
      )
  )
    >>= case _ of
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error x -> renderErrorPage x
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Redirect { redirectToLocation, logout } -> do
           when logout (H.liftEffect logoutByRemovingJwtFromSecureStorage)

           -- TODO: fix: infinite loop is possible (1st route redirects to 2nd, 2nd to 1st) (but this is not possible when one of routes is static)
           -- TODO: feture: show redirect notice alert
           mobileLoadAndPutNewPage currentState redirectToLocation
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success pageSpecWithInputBoxed ->
          H.put
            $ currentState
                { currentPageInfo =
                  { route: destRoute
                  , pageSpecWithInputBoxed
                  }
                }
