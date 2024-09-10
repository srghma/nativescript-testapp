module SpecAssertsExtra where

import Control.Monad.Error.Class
import Effect.Exception
import Data.String (Pattern(..), contains)
import Prelude
import Test.Spec.Assertions (fail, shouldContain, shouldEqual)

shouldContainString
  :: forall m f
   . MonadThrow Error m
  => String
  -> Pattern
  -> m Unit
shouldContainString e c =
  unless (contains c e) $
    fail $ (show c) <> " ∉ " <> (show e)

