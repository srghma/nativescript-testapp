module BuildSeleniumChromeDriver where

import Prelude
import Test.Spec (Spec, describe, it)
import Data.Maybe (maybe)
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (launchAff, delay)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Selenium
import Selenium.Browser
import Selenium.Builder
import Selenium.Types
import Control.Monad.Error.Class (throwError)
import Effect.Exception (error)
import Unsafe.Coerce
import Effect.Aff
import Effect.Aff.Compat

buildSeleniumChromeDriver :: Aff Driver
buildSeleniumChromeDriver = fromEffectFnAff _buildSeleniumChromeDriver

foreign import _buildSeleniumChromeDriver ∷ EffectFnAff Driver
