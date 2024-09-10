module NextjsApp.Pages.Index (page) where

import Protolude
import NextjsApp.PageImplementations.Index as NextjsApp.PageImplementations.Index
import Nextjs.Page (PageSpecBoxed, PageData(..), PageSpec, mkPageSpecBoxed)
import NextjsApp.Link.Client as NextjsApp.Link.Client
import NextjsApp.AppM (AppM(..))
import NextjsApp.Route as NextjsApp.Route

allRoutesWeb :: Array (Variant WebRoutesWithParamRow)
allRoutesWeb =
  [ route__Examples__Ace
  , route__Examples__Basic
  , route__Examples__Components
  , route__Examples__ComponentsInputs
  , route__Examples__ComponentsMultitype
  , route__Examples__EffectsAffAjax
  , route__Examples__EffectsEffectRandom
  , route__Examples__HigherOrderComponents
  , route__Examples__Interpret
  , route__Examples__KeyboardInput
  , route__Examples__Lifecycle
  , route__Examples__DeeplyNested
  , route__Examples__TextNodes
  , route__Examples__Lazy
  , route__Index
  , route__Login
  , route__Register
  , route__Secret
  , route__VerifyUserEmailWeb "dummy_token"
  ]

allRoutesMobile :: Array (Variant MobileRoutesWithParamRow)
allRoutesMobile =
  [ route__Examples__Ace
  , route__Examples__Basic
  , route__Examples__Components
  , route__Examples__ComponentsInputs
  , route__Examples__ComponentsMultitype
  , route__Examples__EffectsAffAjax
  , route__Examples__EffectsEffectRandom
  , route__Examples__HigherOrderComponents
  , route__Examples__Interpret
  , route__Examples__KeyboardInput
  , route__Examples__Lifecycle
  , route__Examples__DeeplyNested
  , route__Examples__TextNodes
  , route__Examples__Lazy
  , route__Index
  , route__Login
  , route__Register
  , route__Secret
  , route__VerifyUserEmailMobile
  ]

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.Index.component
    { allRoutes: allRoutesWeb
    , linkComponent: NextjsApp.Link.Client.component
    }
  , title: "Index"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
