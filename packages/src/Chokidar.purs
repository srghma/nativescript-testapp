module Chokidar where

import Effect.Uncurried (EffectFn1, mkEffectFn1, runEffectFn1)
import Protolude
import Data.Array.NonEmpty (NonEmptyArray)
import FRP.Event (Event)
import FRP.Event as Event

-- | data ChokidarEvent
foreign import _watch ::
  EffectFn1
    { files :: NonEmptyArray String
    -- | , options ::
    -- |   { ignored :: String
    -- |   , ignoreInitial :: Boolean
    -- |   , cwd :: String
    -- |   }
    , onAll :: EffectFn1 String Unit
    }
    (Effect Unit)

watch :: NonEmptyArray String -> Event String
watch files = Event.makeEvent \push -> runEffectFn1 _watch { files, onAll: mkEffectFn1 push }
