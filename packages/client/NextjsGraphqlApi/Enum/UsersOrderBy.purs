module NextjsGraphqlApi.Enum.UsersOrderBy where

import Data.Generic.Rep (class Generic)
import Data.Show (class Show)
import Data.Show.Generic (genericShow)
import Prelude (class Eq, class Ord)
import Data.Tuple (Tuple(..))
import GraphQLClient
  ( class GraphQLDefaultResponseScalarDecoder
  , enumDecoder
  , class ToGraphQLArgumentValue
  , ArgumentValue(..)
  )

-- | original name - UsersOrderBy
data UsersOrderBy
  = IdAsc
  | IdDesc
  | Natural
  | PrimaryKeyAsc
  | PrimaryKeyDesc
  | UserSecretIdAsc
  | UserSecretIdDesc
  | UsernameAsc
  | UsernameDesc

derive instance genericUsersOrderBy :: Generic UsersOrderBy _

instance showUsersOrderBy :: Show UsersOrderBy where
  show = genericShow

derive instance eqUsersOrderBy :: Eq UsersOrderBy

derive instance ordUsersOrderBy :: Ord UsersOrderBy

fromToMap :: Array (Tuple String UsersOrderBy)
fromToMap = [ Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "NATURAL" Natural
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            , Tuple "USER_SECRET_ID_ASC" UserSecretIdAsc
            , Tuple "USER_SECRET_ID_DESC" UserSecretIdDesc
            , Tuple "USERNAME_ASC" UsernameAsc
            , Tuple "USERNAME_DESC" UsernameDesc
            ]

instance usersOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                            UsersOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder "UsersOrderBy" fromToMap

instance usersOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                               UsersOrderBy where
  toGraphQLArgumentValue =
    case _ of
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      Natural -> ArgumentValueEnum "NATURAL"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"
      UserSecretIdAsc -> ArgumentValueEnum "USER_SECRET_ID_ASC"
      UserSecretIdDesc -> ArgumentValueEnum "USER_SECRET_ID_DESC"
      UsernameAsc -> ArgumentValueEnum "USERNAME_ASC"
      UsernameDesc -> ArgumentValueEnum "USERNAME_DESC"
