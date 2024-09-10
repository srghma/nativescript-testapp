module NextjsApp.Queries.IsUsernameOrEmailInUse where

import Protolude

import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import NextjsApp.Queries.Utils (graphqlApiQueryRequestOrThrow)

isUsernameOrEmailInUse :: NonEmptyString -> Aff Boolean
isUsernameOrEmailInUse usernameOrEmail = graphqlApiQueryRequestOrThrow $
  NextjsGraphqlApi.Query.userByUsernameOrVerifiedEmail
    { usernameOrEmail: NonEmptyString.toString usernameOrEmail
    }
    (NextjsGraphqlApi.Object.User.id)
    <#> Maybe.isJust
