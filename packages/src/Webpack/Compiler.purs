module Webpack.Compiler where

import Effect.Uncurried (EffectFn2, mkEffectFn2, runEffectFn2)
import Data.Function.Uncurried (Fn1, runFn1)
import Protolude
import Foreign (Foreign)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Unsafe.Coerce (unsafeCoerce)
import Webpack.Types (Configuration)

-- https://github.com/DefinitelyTyped/DefinitelyTyped/blob/7bcd046f24df925802e1d1d04a7fd6f19b54cde0/types/webpack/index.d.ts#L1312
type Compilation
  = { errors :: Array Error
    }

type Stats
  = { compilation :: Compilation
    }

type MultiStats
  = { stats :: Array Stats
    }

----------
data Compiler

data MultiCompiler

----------
-- https://github.com/DefinitelyTyped/DefinitelyTyped/blob/7bcd046f24df925802e1d1d04a7fd6f19b54cde0/types/webpack/index.d.ts#L1335
foreign import _webpackCompilerRun :: EffectFn2 Foreign Foreign Unit

webpackCompilerRun ::
  Compiler ->
  (Maybe Error -> Stats -> Effect Unit) ->
  Effect Unit
webpackCompilerRun = \compiler handler -> runEffectFn2 _webpackCompilerRun (coerceCompiler compiler) (coerceHandler' $ coerceHandler handler)
  where
  coerceCompiler = (unsafeCoerce :: Compiler -> Foreign)

  coerceHandler' = (unsafeCoerce :: EffectFn2 (Nullable Error) Stats Unit -> Foreign)

  coerceHandler :: (Maybe Error -> Stats -> Effect Unit) -> EffectFn2 (Nullable Error) Stats Unit
  coerceHandler multihandler = mkEffectFn2 \nerror stats -> multihandler (Nullable.toMaybe nerror) stats

webpackCompilerRunMulti ::
  MultiCompiler ->
  (Maybe Error -> MultiStats -> Effect Unit) ->
  Effect Unit
webpackCompilerRunMulti = \compiler multihandler -> runEffectFn2 _webpackCompilerRun (coerceCompiler compiler) (coerceMultiHandler' $ coerceMultiHandler multihandler)
  where
  coerceCompiler = (unsafeCoerce :: MultiCompiler -> Foreign)

  coerceMultiHandler' = (unsafeCoerce :: EffectFn2 (Nullable Error) MultiStats Unit -> Foreign)

  coerceMultiHandler :: (Maybe Error -> MultiStats -> Effect Unit) -> EffectFn2 (Nullable Error) MultiStats Unit
  coerceMultiHandler multihandler = mkEffectFn2 \nerror stats -> multihandler (Nullable.toMaybe nerror) stats

----------
foreign import _webpack :: Fn1 Foreign Foreign

webpackCompiler :: Configuration -> Compiler
webpackCompiler = \compiler -> runFn1 _webpack (coerceConfig compiler) # coerceToCompiler
  where
  coerceToCompiler = (unsafeCoerce :: Foreign -> Compiler)

  coerceConfig = (unsafeCoerce :: Configuration -> Foreign)

webpackCompilerMulti :: Array Configuration -> MultiCompiler
webpackCompilerMulti = \compiler -> runFn1 _webpack (coerceConfig compiler) # coerceToCompiler
  where
  coerceToCompiler = (unsafeCoerce :: Foreign -> MultiCompiler)

  coerceConfig = (unsafeCoerce :: Array Configuration -> Foreign)
