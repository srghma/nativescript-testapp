module NextjsApp.Data.NonUsedEmail where

import Protolude

import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex
import Data.String.Regex.Unsafe as Regex
import NextjsApp.Queries.Utils (graphqlApiQueryRequestOrThrow)
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsApp.Queries.IsUsernameOrEmailInUse
import Data.Email (Email)
import Data.Email as Email
import Unsafe.Coerce (unsafeCoerce)

data NonUsedEmail__Error
  = NonUsedEmail__Error__Empty
  | NonUsedEmail__Error__BadFormat
  | NonUsedEmail__Error__InUse

newtype NonUsedEmail = NonUsedEmail Email

toString :: NonUsedEmail -> String
toString = unsafeCoerce

fromString :: String -> Aff (Either NonUsedEmail__Error NonUsedEmail)
fromString = \str -> runExceptT do
  traceM { m: "NonUsedEmail", str }

  nstr <- NonEmptyString.fromString str # maybe (throwError NonUsedEmail__Error__Empty) pure

  email <- Email.fromNonEmptyString nstr # maybe (throwError NonUsedEmail__Error__BadFormat) pure

  unlessM (liftAff $ validNotInUse email) (throwError NonUsedEmail__Error__InUse)

  traceM { m: "NonUsedEmail responding", str }

  pure $ NonUsedEmail email

  where

  validNotInUse :: Email -> Aff Boolean
  validNotInUse email = isUsernameOrEmailInUse (Email.toNonEmptyString email) <#> not
