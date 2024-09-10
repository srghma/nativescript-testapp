module NextjsApp.Pages.Examples.Ace (page) where

import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Protolude
import Halogen as H
import Example.Ace.Container as Example.Ace.Container
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Ace.Container.component
  , title: "Halogen Example - Ace button"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
