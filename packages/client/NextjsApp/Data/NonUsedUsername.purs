module NextjsApp.Data.NonUsedUsername where

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

data NonUsedUsername__Error
  = NonUsedUsername__Error__Empty
  | NonUsedUsername__Error__BadLength Int
  | NonUsedUsername__Error__BadFormat
  | NonUsedUsername__Error__InUse

newtype NonUsedUsername = NonUsedUsername NonEmptyString

toString :: NonUsedUsername -> String
toString (NonUsedUsername s) = NonEmptyString.toString s

minUsernameLength :: Int
minUsernameLength = 2

maxUsernameLength :: Int
maxUsernameLength = 24

fromString :: String -> Aff (Either NonUsedUsername__Error NonUsedUsername)
fromString = \str -> runExceptT do
  nstr <- NonEmptyString.fromString str # maybe (throwError NonUsedUsername__Error__Empty) pure

  unless (validLength nstr) (throwError $ NonUsedUsername__Error__BadLength (NonEmptyString.length nstr))
  unless (validFormat nstr) (throwError NonUsedUsername__Error__BadFormat)

  unlessM (liftAff $ validNotInUse nstr) (throwError NonUsedUsername__Error__InUse)

  pure $ NonUsedUsername nstr

  where

  validLength :: NonEmptyString -> Boolean
  validLength = NonEmptyString.length >>> \l -> l > minUsernameLength && l <= maxUsernameLength

  validFormat :: NonEmptyString -> Boolean
  validFormat = NonEmptyString.toString >>> Regex.test r
    where
      r = Regex.unsafeRegex """^[a-zA-Z]([a-zA-Z0-9][_]?)+$""" Regex.noFlags

  validNotInUse :: NonEmptyString -> Aff Boolean
  validNotInUse nstr =
    graphqlApiQueryRequestOrThrow $
      NextjsGraphqlApi.Query.userByUsername
        { username: NonEmptyString.toString nstr
        }
        (NextjsGraphqlApi.Object.User.id)
        <#> Maybe.isNothing
