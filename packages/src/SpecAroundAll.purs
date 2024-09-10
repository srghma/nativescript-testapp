module SpecAroundAll where

import Prelude
import Effect.Aff (Aff, Error, Fiber, forkAff, killFiber)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect)
import Effect.Exception as Effect.Exception
import Effect.Aff.AVar as Effect.Aff.AVar
import Control.Monad.Error.Class (class MonadError)
import Test.Spec (SpecT, afterAll, beforeAll, beforeWith)

data AroundAllState config = AroundAllState config (Fiber Unit)

-- | Run a custom action before and/or after every spec item.
-- it's possible to make `withFunc` argument to have type
--
-- ((config -> g Unit) -> g Unit)
--
-- instead of
--
-- ((config -> g Unit) -> Aff Unit)
--
-- but it would require g to implement `MonadUnliftAff` class (there should be function `g Unit -> Aff Unit`)

aroundAll :: forall config m g. MonadEffect m => MonadAff g => MonadError Error g => ((config -> g Unit) -> Aff Unit) -> SpecT g config m Unit -> SpecT g Unit m Unit
aroundAll withFunc specWith = beforeAll start $ afterAll stop $ beforeWith (pure <<< getConfig) specWith
  where

  start :: g (AroundAllState config)
  start = do
    (avar :: Effect.Aff.AVar.AVar config) <- liftAff $ Effect.Aff.AVar.empty -- 1
    fiber <-
      liftAff $ forkAff $ withFunc
        $ \value -> do
            liftAff $ Effect.Aff.AVar.put value avar -- 2
            liftAff $ void $ Effect.Aff.AVar.take avar -- 3
    theConfig <- liftAff $ Effect.Aff.AVar.take avar -- 2
    pure (AroundAllState theConfig fiber)

  stop :: AroundAllState config -> g Unit
  stop (AroundAllState _config fiber) = liftAff $ killFiber (Effect.Exception.error "Kill fiber") fiber

  getConfig :: AroundAllState config -> config
  getConfig (AroundAllState config _fiber) = config
