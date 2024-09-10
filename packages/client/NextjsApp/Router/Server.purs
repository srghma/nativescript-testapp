module NextjsApp.Router.Server where

import Protolude
import Halogen as H
import NextjsApp.AppM (AppM)
import NextjsApp.Router.Shared (CurrentPageInfo, Query, maybeRenderPage)

serverComponent ::
  forall r.
  H.Component Query { currentPageInfo :: Maybe CurrentPageInfo | r } Void AppM
serverComponent =
  H.mkComponent
    { initialState: identity
    , render: maybeRenderPage
    , eval: H.mkEval $ H.defaultEval
    }
