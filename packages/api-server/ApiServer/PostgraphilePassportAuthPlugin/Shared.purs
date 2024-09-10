module ApiServer.PostgraphilePassportAuthPlugin.Shared where

import ApiServer.PostgraphilePassportAuthPlugin.Types

import Protolude
import Effect.Uncurried
import Data.Function.Uncurried

foreign import appPublicUsersFragment :: FragmentMaker -> SqlFragment

foreign import mkSelectGraphQLResultFromTable ::
  Fn2
  String
  { fragment :: FragmentMaker, value :: SqlValueFn }
  (EffectFn2 String QueryBuilder Unit)
