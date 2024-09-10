module FeatureTests.FeatureTestSpecUtils.EmailAVar where

import Protolude

import Control.Monad.Reader.Class (asks)
import Effect.AVar (AVar)
import Effect.Aff.AVar as AVar
import Worker.Main as Worker
import Worker.Types as Worker

waitForEmail
  :: forall m r
   . MonadAsk { emailAVar :: AVar Worker.Email | r } m
  => MonadAff m
  => m Worker.Email
waitForEmail = asks _.emailAVar >>= liftAff <<< AVar.take

