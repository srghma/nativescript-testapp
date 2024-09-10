module LunaparkExtra where

import Lunapark.Types
import Protolude

import Data.String.CodeUnits (toCharArray)
import Data.Time.Duration (Milliseconds(..))
import Foreign.Object as Object
import Lunapark as Lunapark
import Lunapark.UnicodeCharacters as Lunapark.UnicodeCharacters
import Run (Run(..))

inputField :: forall r. Lunapark.Locator -> String -> Run ( lunapark :: Lunapark.LUNAPARK | r) Unit
inputField locator s = do
  element ← Lunapark.findElement locator
  -- | Lunapark.clearElement element

  Lunapark.clickElement element
  Lunapark.performActions $ Object.fromFoldable
    [ Tuple "1" $ Key
      [ keyDown Lunapark.UnicodeCharacters.controlLeft
      , keyDown 'a'
      , keyUp Lunapark.UnicodeCharacters.controlLeft
      , keyUp 'a'
      , keyDown Lunapark.UnicodeCharacters.delete
      , keyUp Lunapark.UnicodeCharacters.delete
      ]
    ]

  Lunapark.performActions $ Object.fromFoldable
    [ Tuple "1" $ Key $
      toCharArray s >>= \c ->
      [ keyDown c
      , keyUp c
      ]
    ]

  -- | Lunapark.sendKeysElement element s
