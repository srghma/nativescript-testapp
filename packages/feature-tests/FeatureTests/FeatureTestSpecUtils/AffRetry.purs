module FeatureTests.FeatureTestSpecUtils.AffRetry where

import Prelude
import Effect.Aff.Retry as AffRetry
import Data.Time.Duration

retryAction action =
  AffRetry.recovering
    (AffRetry.constantDelay (Milliseconds 200.0) <> AffRetry.limitRetries 10)
    [\_ _ -> pure true]
    (\_ -> action)
