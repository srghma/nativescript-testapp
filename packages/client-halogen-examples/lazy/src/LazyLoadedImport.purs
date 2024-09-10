module Example.Lazy.LazyLoadedImport where

import Protolude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Time.Duration (Milliseconds(..))
import Effect.Aff (delay)
import Halogen as H

foreign import lazyLoadedImport_ :: forall q i o m . Effect (Promise { component :: H.Component q i o m })

lazyLoadedImport :: forall q i o m . Aff (H.Component q i o m)
lazyLoadedImport = do
  delay (Milliseconds 3000.0)
  Promise.toAffE lazyLoadedImport_ <#> _.component
