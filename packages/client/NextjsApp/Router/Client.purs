module NextjsApp.Router.Client where

import Protolude
import Halogen as H
import Nextjs.Page as Nextjs.Page
import NextjsApp.PageLoader as NextjsApp.PageLoader
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.AppM (AppM)
import NextjsApp.Router.Shared (ChildSlots, ClientState, Query(..), maybeRenderPage)

component ::
  H.Component Query ClientState Void AppM
component =
  H.mkComponent
    { initialState: identity
    , render: maybeRenderPage
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleQuery = handleQuery
            }
    }

handleQuery :: forall next action. Query next -> H.HalogenM ClientState action ChildSlots Void AppM (Maybe next)
handleQuery = case _ of
  Navigate destRoute a -> do
    currentState <- H.get
    -- | traceM { currentState, destRoute }
    -- don't re-render unnecessarily if the route is unchanged
    case currentState.currentPageInfo of
      Just { route } -> when (route /= destRoute) (clientLoadAndPutNewPage currentState destRoute)
      Nothing -> clientLoadAndPutNewPage currentState destRoute
    pure (Just a)

clientLoadAndPutNewPage :: forall action. ClientState -> (Variant NextjsApp.Route.WebRoutesWithParamRow) -> H.HalogenM ClientState action ChildSlots Void AppM Unit
clientLoadAndPutNewPage currentState destRoute = do
  page <-
    H.liftAff
      $ NextjsApp.PageLoader.loadPage
          { clientPagesManifest: currentState.clientPagesManifest
          , document: currentState.htmlContextInfo.document
          , body: currentState.htmlContextInfo.body
          , head: currentState.htmlContextInfo.head
          , pageRegisteredEvent: currentState.pageRegisteredEvent
          }
          destRoute
  (H.liftAff $ Nextjs.Page.pageSpecBoxed_to_PageSpecWithInputBoxed_request Nextjs.Page.PageData_DynamicRequestOptions__Client page)
    >>= case _ of
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error str -> H.liftEffect $ throwError $ error $ "PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Error (TODO: render error page): " <> str
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Redirect { redirectToLocation } ->
          clientLoadAndPutNewPage currentState redirectToLocation
        Nextjs.Page.PageSpecBoxed_To_PageSpecWithInputBoxed_Response__Success pageSpecWithInputBoxed -> do
          -- | traceM { message: "clientLoadAndPutNewPage put", pageSpecWithInputBoxed }
          H.put
            $ currentState
                { currentPageInfo =
                  Just
                    { route: destRoute
                    , pageSpecWithInputBoxed
                    }
                }
