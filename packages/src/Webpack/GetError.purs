module Webpack.GetError where

import Protolude
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Webpack.Compiler (MultiStats)

webpackGetErrors :: Maybe Error -> MultiStats -> Maybe (NonEmptyArray Error)
webpackGetErrors = \error stats -> case error of
  Just e -> Just $ NonEmptyArray.singleton e
  Nothing -> Array.findMap (\stat -> NonEmptyArray.fromArray stat.compilation.errors) stats.stats
