module NextjsApp.Pages.Examples.EffectsAffAjax (page) where

import Protolude
import Example.Effects.Aff.Ajax.Component as Example.Effects.Aff.Ajax.Component
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import Halogen as H
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: H.hoist liftAff $ Example.Effects.Aff.Ajax.Component.component
  , title: "Halogen Example - EffectsAffAjax button"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
