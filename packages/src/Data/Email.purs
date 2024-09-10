module Data.Email where

import Protolude
import Unsafe.Coerce (unsafeCoerce)
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import EmailValidator

newtype Email = Email NonEmptyString

toNonEmptyString :: Email -> NonEmptyString
toNonEmptyString = unsafeCoerce

toString :: Email -> String
toString = unsafeCoerce

fromNonEmptyString :: NonEmptyString -> Maybe Email
fromNonEmptyString email =
  if emailValidate (NonEmptyString.toString email)
    then Just (Email email)
    else Nothing

fromString :: String -> Maybe Email
fromString = NonEmptyString.fromString >=> fromNonEmptyString
