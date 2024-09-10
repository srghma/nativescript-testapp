module NextjsApp.Data.MatchingPassword where

import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import NextjsApp.Data.Password (Password, PasswordError)
import NextjsApp.Data.Password as Password
import Unsafe.Coerce (unsafeCoerce)

newtype MatchingPassword = MatchingPassword Password

toString :: MatchingPassword -> String
toString = unsafeCoerce

data MatchingPasswordError
  = MatchingPasswordError__Invalid PasswordError
  | MatchingPasswordError__DoesntMatch { current :: Password, expectedToEqualTo :: String }

printMatchingPasswordError :: MatchingPasswordError -> String
printMatchingPasswordError =
  case _ of
       MatchingPasswordError__Invalid passwordError -> Password.printPasswordError passwordError
       MatchingPasswordError__DoesntMatch { current, expectedToEqualTo } -> "This field contains \"" <> Password.toString current <> "\" but must be equal to \"" <> expectedToEqualTo <> "\" to validate."

fromString :: { current :: String, expectedToEqualTo :: String } -> Either MatchingPasswordError MatchingPassword
fromString { current, expectedToEqualTo } =
  (Password.fromString current # lmap MatchingPasswordError__Invalid)
  >>= \currentPassword -> if current == expectedToEqualTo
        then Right $ MatchingPassword currentPassword
        else Left $ MatchingPasswordError__DoesntMatch { current: currentPassword, expectedToEqualTo }
