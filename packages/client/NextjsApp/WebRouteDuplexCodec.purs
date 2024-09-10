module NextjsApp.WebRouteDuplexCodec where

import NextjsApp.Route as NextjsApp.Route
import Protolude
import Routing.Duplex
import Routing.Duplex ((%=))
import Routing.Duplex.Generic
import Routing.Duplex.Generic.Syntax ((/))

routeCodec :: RouteDuplex' (Variant NextjsApp.Route.WebRoutesWithParamRow)
routeCodec =
  root
    $ variant
      # ((SProxy :: _ "route__Index")                           %= pure unit)
      # ((SProxy :: _ "route__Login")                           %= (path "login" $ pure unit))
      # ((SProxy :: _ "route__Register")                        %= (path "register" $ pure unit))
      # ((SProxy :: _ "route__Secret")                          %= (path "secret" $ pure unit))
      # ((SProxy :: _ "route__VerifyUserEmailWeb")              %= (path "verify-user-email" $ param "token"))
      # ((SProxy :: _ "route__Examples__Ace")                   %= (path "examples" $ path "ace" $ pure unit))
      # ((SProxy :: _ "route__Examples__Basic")                 %= (path "examples" $ path "basic" $ pure unit))
      # ((SProxy :: _ "route__Examples__Components")            %= (path "examples" $ path "components" $ pure unit))
      # ((SProxy :: _ "route__Examples__ComponentsInputs")      %= (path "examples" $ path "components-inputs" $ pure unit))
      # ((SProxy :: _ "route__Examples__ComponentsMultitype")   %= (path "examples" $ path "components-multitype" $ pure unit))
      # ((SProxy :: _ "route__Examples__EffectsAffAjax")        %= (path "examples" $ path "effects-aff-ajax" $ pure unit))
      # ((SProxy :: _ "route__Examples__EffectsEffectRandom")   %= (path "examples" $ path "effects-effect-random" $ pure unit))
      # ((SProxy :: _ "route__Examples__HigherOrderComponents") %= (path "examples" $ path "higher-order-components" $ pure unit))
      # ((SProxy :: _ "route__Examples__Interpret")             %= (path "examples" $ path "interpret" $ pure unit))
      # ((SProxy :: _ "route__Examples__KeyboardInput")         %= (path "examples" $ path "keyboard-input" $ pure unit))
      # ((SProxy :: _ "route__Examples__Lifecycle")             %= (path "examples" $ path "lifecycle" $ pure unit))
      # ((SProxy :: _ "route__Examples__DeeplyNested")          %= (path "examples" $ path "deeply-nested" $ pure unit))
      # ((SProxy :: _ "route__Examples__TextNodes")             %= (path "examples" $ path "text-nodes" $ pure unit))
      # ((SProxy :: _ "route__Examples__Lazy")                  %= (path "examples" $ path "lazy" $ pure unit))
