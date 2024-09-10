module NextjsApp.Link.Mobile where

import NextjsApp.AppM (AppM)
import Protolude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import NextjsApp.Navigate as NextjsApp.Navigate
import Routing.Duplex as Routing.Duplex
import Web.Event.Event as Web.Event.Event
import Web.UIEvent.MouseEvent as Web.UIEvent.MouseEvent
import NextjsApp.Link.Types
import NextjsApp.Link.Lib
import NextjsApp.Route as NextjsApp.Route

data Action
  = Navigate Web.UIEvent.MouseEvent.MouseEvent

type State
  = { route :: Variant NextjsApp.Route.MobileRoutesWithParamRow
    , text :: String
    }

component :: H.Component Query State Message AppM
component =
  H.mkComponent
    { initialState: identity
    , render: \state ->
        HH.a
          [ HE.onClick Navigate
          , HP.ref elementLabel
          ]
          [ HH.text state.text
          ]
    , eval:
      H.mkEval
        $ H.defaultEval
            { handleAction =
                case _ of
                    Navigate mouseEvent -> do
                       -- TODO: ignore newtab clicks https://github.com/vercel/next.js/blob/8dd3d2a8e2b266611a60b9550d2ecac02f14fd57/packages/next/client/link.tsx#L171-L182
                       H.liftEffect $ Web.Event.Event.preventDefault (Web.UIEvent.MouseEvent.toEvent mouseEvent)

                       H.gets _.route >>= NextjsApp.Navigate.navigate
            }
    }
