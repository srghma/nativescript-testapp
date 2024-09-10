module NextjsApp.Data.Password where

import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Unsafe.Coerce (unsafeCoerce)

newtype Password = Password NonEmptyString

toString :: Password -> String
toString = unsafeCoerce

minPasswordLength :: Int
minPasswordLength = 8

maxPasswordLength :: Int
maxPasswordLength = 200

data PasswordError
  = PasswordError__Empty
  | PasswordError__TooShort Int
  | PasswordError__TooLong Int

printPasswordError :: PasswordError -> String
printPasswordError =
  case _ of
      PasswordError__Empty -> "Should not be empty"
      PasswordError__TooShort l -> "Too short (currently - "  <> show l <> ", min - " <> show minPasswordLength <> ")"
      PasswordError__TooLong l -> "Too long (currently - "  <> show l <> ", max - " <> show maxPasswordLength <> ")"

fromString :: String -> Either PasswordError Password
fromString = NonEmptyString.fromString >>>
  case _ of
      Nothing -> Left PasswordError__Empty
      Just str ->
              let
                l = NonEmptyString.length str
              in case unit of
                _ | l < minPasswordLength -> Left $ PasswordError__TooShort l
                  | l > maxPasswordLength -> Left $ PasswordError__TooLong l
                  | otherwise -> Right $ Password str
