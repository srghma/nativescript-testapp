module NextjsApp.Navigate where

import Protolude

import Control.Monad.Reader (asks)

import NextjsApp.Route as NextjsApp.Route

navigate ::
  forall r m routes.
  MonadEffect m =>
  MonadAsk { navigate :: Variant routes -> Effect Unit | r } m =>
  Variant routes ->
  m Unit
navigate route = do
  navigate' <- asks _.navigate
  liftEffect $ navigate' route
