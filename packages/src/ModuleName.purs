module ModuleName where

import Protolude
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Unsafe.Coerce (unsafeCoerce)
import Type.Proxy (Proxy(..))

newtype ModuleName
  = ModuleName (NonEmptyArray NonEmptyString) -- e.g. [ 'Data', 'String' ]

derive instance newtypeModuleName :: Newtype ModuleName _

derive newtype instance eqModuleName :: Eq ModuleName

derive newtype instance ordModuleName :: Ord ModuleName

printModuleName :: ModuleName -> NonEmptyString
printModuleName (ModuleName m) = NonEmptyString.joinWith1 (NonEmptyString.nes (Proxy :: Proxy ".")) (map NonEmptyString.toString m)

-- XXX: should be non empty
unsafeModuleName :: Array String -> ModuleName
unsafeModuleName = unsafeCoerce

moduleNameToArrayString :: ModuleName -> Array String
moduleNameToArrayString = unsafeCoerce

moduleNameToArrayNonEmptyString :: ModuleName -> Array NonEmptyString
moduleNameToArrayNonEmptyString = unsafeCoerce

moduleNameFromString :: String.Pattern -> String -> Maybe (NonEmptyArray NonEmptyString)
moduleNameFromString pattern = String.split pattern >>> moduleNameFromArrayString

moduleNameFromArrayString :: Array String -> Maybe (NonEmptyArray NonEmptyString)
moduleNameFromArrayString = map NonEmptyString.fromString >>> Array.catMaybes >>> NonEmptyArray.fromArray
