module WebpackSpagoLoader where

import Webpack.Types (Rule)
import Effect.Uncurried (EffectFn1)

type SpagoOptions
  = { output :: String
    , pursFiles :: Array String
    , compiler :: String
    , compilerOptions :: { censorCodes :: String }
    }

foreign import getAbsoluteOutputDirFromSpago :: EffectFn1 String String

foreign import getSourcesFromSpago :: EffectFn1 String (Array String)

foreign import rules :: { spagoAbsoluteOutputDir :: String } -> Array Rule
