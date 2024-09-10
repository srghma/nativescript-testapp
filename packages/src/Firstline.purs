module Firstline where

import Control.Promise (Promise)
import Effect.Uncurried (EffectFn1)
import Protolude
import Pathy (Abs, File, Path)

foreign import _firstline :: EffectFn1 String (Promise String)
