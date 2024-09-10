module NextjsApp.PageImplementations.Index (component) where

import Data.Variant
import NextjsApp.Route
import Protolude

import Halogen (Slot)
import Halogen as H
import Halogen.HTML as HH
import NextjsApp.AppM (AppM)
import Type.Proxy (Proxy(..))

type Query
  = Const Void

type Input
  = Unit

type Message
  = Void

type State
  = Unit

data Action
  = Void

component ::
  forall routes (output :: Type) .
  { allRoutes :: Array { route :: Variant routes, routeName :: String }
  , linkComponent :: H.Component (Const Void) { route :: Variant routes, text :: String } output AppM
  } ->
  H.Component Query Input Message AppM
component { allRoutes, linkComponent } =
  H.mkComponent
    { initialState: const unit
    , render: const $
        HH.div_
          [ HH.text "test"
          , HH.ul_
              $ allRoutes
              <#> \route ->
                  HH.li_
                    $ [ HH.slot
                          (Proxy :: Proxy "mylink")
                          route.routeName
                          linkComponent
                          { route: route.route, text: route.routeName }
                          absurd
                      ]
          ]
    , eval: H.mkEval $ H.defaultEval
    }
