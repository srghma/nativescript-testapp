module NextjsApp.Pages.Examples.HigherOrderComponents (page) where

import Protolude
import Example.HOC.Harness as Example.HOC.Harness
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.HOC.Harness.component
  , title: "Halogen Example - HigherOrderComponents button"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
