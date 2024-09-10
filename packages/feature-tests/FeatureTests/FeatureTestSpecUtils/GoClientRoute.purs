module FeatureTests.FeatureTestSpecUtils.GoClientRoute where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Data.Identity
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import Effect.Console
import Effect.Exception
import Protolude
import Test.Spec
import Unsafe.Coerce

import Data.Either (hush)
import Data.Functor.Variant (FProxy(..))
import Data.String (Pattern(..), stripPrefix)
import Data.Variant (Variant)
import Effect.Ref as Ref
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)
import Lunapark as Lunapark
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.WebRouteDuplexCodec as NextjsApp.WebRouteDuplexCodec
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Routing.Duplex as Routing.Duplex
import Run as Run

goClientRoute
  :: ∀ r m
   . MonadAff m
  => MonadAsk { clientRootUrl :: String, interpreter :: Lunapark.Interpreter () | r } m
  => MonadThrow Error m
  => Variant NextjsApp.Route.WebRoutesWithParamRow
  -> m Unit
goClientRoute route = ask >>= \config -> do
  url <- Routing.Duplex.print NextjsApp.WebRouteDuplexCodec.routeCodec route
    # either (\e -> throwError $ error $ "[goClientRoute]: " <> show e) pure
  runLunapark $ Lunapark.go $ config.clientRootUrl <> url

parseRouteImplementation :: String -> String -> Maybe (Variant NextjsApp.Route.WebRoutesWithParamRow)
parseRouteImplementation clientRootUrl currentUrl =
  stripPrefix (Pattern clientRootUrl) currentUrl
  >>= \currentUrl' -> hush (Routing.Duplex.parse NextjsApp.WebRouteDuplexCodec.routeCodec currentUrl')

getCurrentRoute
  :: ∀ r m
   . MonadAff m
  => MonadAsk { clientRootUrl :: String, interpreter :: Lunapark.Interpreter () | r } m
  => MonadThrow Error m
  => m (Maybe (Variant NextjsApp.Route.WebRoutesWithParamRow))
getCurrentRoute = ask >>= \config -> (runLunapark Lunapark.getUrl) <#> parseRouteImplementation config.clientRootUrl
