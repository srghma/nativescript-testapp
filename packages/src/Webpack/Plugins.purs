module Webpack.Plugins where

import Foreign (Foreign)
import Foreign.Object (Object)
import Webpack.Types (WebpackPluginInstance)

foreign import webpack ::
  { _DefinePlugin :: Object Foreign -> WebpackPluginInstance
  , _ProvidePlugin :: forall options. { | options } -> WebpackPluginInstance
  , _NoEmitOnErrorsPlugin :: WebpackPluginInstance
  , optimize ::
    { _LimitChunkCountPlugin :: forall options. { | options } -> WebpackPluginInstance
    }
  }
