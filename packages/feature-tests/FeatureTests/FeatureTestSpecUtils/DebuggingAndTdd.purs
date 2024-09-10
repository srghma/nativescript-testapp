module FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Control.Monad.Rec.Class
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

import Data.Functor.Variant (FProxy(..))
import Effect.Ref as Ref
import Lunapark as Lunapark
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine (Interface)
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Run (Run)
import Run as Run
import Run.Reader as Run

readlineQuestion :: String -> Node.ReadLine.Interface -> Aff String
readlineQuestion questionString interface = makeAff \callback -> do
  Node.ReadLine.question questionString (callback <<< Right) interface
  pure nonCanceler

pressEnterToContinue' :: Node.ReadLine.Interface -> Aff Unit
pressEnterToContinue' readLineInterface = void $ readlineQuestion "Press \"Enter\" (but not \"CTRL-D\") to continue: " readLineInterface

pressEnterToContinue
  :: forall m r
   . MonadAsk { readLineInterface :: Node.ReadLine.Interface | r } m
  => MonadAff m
  => m Unit
pressEnterToContinue = ask >>= \config -> liftAff $ pressEnterToContinue' config.readLineInterface
