module Webpack.FFI where

import Effect.Uncurried (EffectFn1, EffectFn3)
import Protolude
import Webpack.Types (Assets, Compilation, RawSource, WebpackEntrypont)
import Foreign (Foreign)
import Foreign.JsMap (JsMap)
import Node.Buffer (Buffer)
import Unsafe.Coerce (unsafeCoerce)

foreign import webpackEntrypontName :: EffectFn1 WebpackEntrypont String

foreign import webpackEntrypontGetFiles :: EffectFn1 WebpackEntrypont (Array String)

foreign import _rawSource :: Foreign -> RawSource

rawSourceFromString :: String -> RawSource
rawSourceFromString = _rawSource <<< unsafeCoerce

rawSourceFromBuffer :: Buffer -> RawSource
rawSourceFromBuffer = _rawSource <<< unsafeCoerce

foreign import setAsset :: EffectFn3 Assets String RawSource Unit

foreign import compilationGetEntrypoints :: EffectFn1 Compilation (JsMap String WebpackEntrypont)
