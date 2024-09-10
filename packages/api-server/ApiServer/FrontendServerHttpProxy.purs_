module ApiServer.FrontendServerHttpProxy where

import Data.Function.Uncurried
import Effect
import Effect.Uncurried
import Node.Express.App
import Node.Express.Passport
import Node.Express.Types
import Protolude

import Data.Argonaut (Json)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect.Aff (Aff, runAff_)
import Effect.Exception (Error)
import Node.HTTP (Server)

foreign import _installFrontendServerProxy ::
  EffectFn3
  Server
  Application
  String
  Unit

installFrontendServerProxy = runEffectFn3 _installFrontendServerProxy
