module HeterogeneousExtraShow where

import Protolude
import Heterogeneous.Mapping (class Mapping)

data Show = Show

instance showMappingAction :: (Show n) => Mapping Show n String where
  mapping Show = show
