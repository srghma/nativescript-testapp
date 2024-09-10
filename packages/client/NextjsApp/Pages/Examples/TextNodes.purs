module NextjsApp.Pages.Examples.TextNodes (page) where

import Protolude
import Example.TextNodes.Main as Example.TextNodes.Main
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.TextNodes.Main.component
  , title: "Halogen Example - Text nodes"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
