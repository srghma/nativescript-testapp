module NextjsApp.Pages.Login (page) where

import Protolude
import NextjsApp.PageImplementations.Login as NextjsApp.PageImplementations.Login
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Login.component
  , title: "Login"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
