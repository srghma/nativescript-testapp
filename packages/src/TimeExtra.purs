module TimeExtra where

import Prelude
import Data.Time.Duration (class Duration, Milliseconds)
import Effect.Now (nowDateTime)
import Data.DateTime (diff)
import Data.Time.Duration (class Duration)
import Debug.Trace (traceM)
import Data.Tuple (Tuple(..))
import Effect.Class (liftEffect, class MonadEffect)

time :: forall a d m. MonadEffect m => Duration d => m a -> m (Tuple d a)
time action = do
  dateTimeVal <- liftEffect nowDateTime
  output <- action
  dateTimeVal' <- liftEffect nowDateTime
  pure (Tuple (diff dateTimeVal' dateTimeVal) output)

traceTime :: forall a m. MonadEffect m => String -> m a -> m a
traceTime name action = do
  Tuple (milliseconds :: Milliseconds) output <- time action
  traceM $ "Time diff for action \"" <> name <> "\": " <> show milliseconds
  pure output
