module NextjsApp.Data.InUseUsernameOrEmail where

import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import NextjsApp.Queries.IsUsernameOrEmailInUse (isUsernameOrEmailInUse)

data InUseUsernameOrEmail__Error
  = InUseUsernameOrEmail__Error__Empty
  | InUseUsernameOrEmail__Error__NotInUse

newtype InUseUsernameOrEmail = InUseUsernameOrEmail NonEmptyString

toString :: InUseUsernameOrEmail -> String
toString (InUseUsernameOrEmail s) = NonEmptyString.toString s

fromString :: String -> Aff (Either InUseUsernameOrEmail__Error InUseUsernameOrEmail)
fromString = NonEmptyString.fromString >>>
  case _ of
    Nothing -> pure $ Left InUseUsernameOrEmail__Error__Empty
    Just usernameOrEmail -> isUsernameOrEmailInUse usernameOrEmail <#>
      if _
        then Right (InUseUsernameOrEmail usernameOrEmail)
        else Left InUseUsernameOrEmail__Error__NotInUse
