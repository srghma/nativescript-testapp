module LoaderUtils where

import Effect.Uncurried (EffectFn1, runEffectFn1)
import Protolude
import Webpack.Loader (LoaderContext)
import Node.URL (Query)

foreign import _getOptions :: EffectFn1 LoaderContext Query

getOptions :: LoaderContext -> Effect Query
getOptions = runEffectFn1 _getOptions
