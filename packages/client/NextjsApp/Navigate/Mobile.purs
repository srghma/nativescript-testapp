module NextjsApp.Navigate.Mobile where

import Protolude

import FRP.Event (EventIO)

import NextjsApp.Route as NextjsApp.Route

navigate :: EventIO (Variant NextjsApp.Route.WebRoutesWithParamRow) -> (Variant NextjsApp.Route.WebRoutesWithParamRow) -> Effect Unit
navigate newRouteEventIO route = newRouteEventIO.push route
