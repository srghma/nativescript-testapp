module NextjsApp.AppM where

import Protolude
import Control.Monad.Reader (ReaderT, asks, runReaderT)
import Halogen as H
import NextjsApp.Link.Types as NextjsApp.Link.Types
import NextjsApp.Route as NextjsApp.Route
import Type.Equality (class TypeEquals, from)

type Env routes
  = { navigate :: Variant routes -> Effect Unit
    }

newtype AppM routes a
  = AppM (ReaderT (Env routes) Aff a)

runAppM :: forall routes . Env routes -> AppM routes ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance functorAppM :: Functor (AppM routes)

derive newtype instance applyAppM :: Apply (AppM routes)

derive newtype instance applicativeAppM :: Applicative (AppM routes)

derive newtype instance bindAppM :: Bind (AppM routes)

derive newtype instance monadAppM :: Monad (AppM routes)

derive newtype instance monadEffectAppM :: MonadEffect (AppM routes)

derive newtype instance monadAffAppM :: MonadAff (AppM routes)

instance monadAskAppM :: TypeEquals e (Env routes) => MonadAsk e (AppM routes) where
  ask = AppM $ asks from
