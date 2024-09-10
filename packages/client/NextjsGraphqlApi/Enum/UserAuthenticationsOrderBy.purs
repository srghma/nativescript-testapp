module NextjsGraphqlApi.Enum.UserAuthenticationsOrderBy where

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

-- | original name - UserAuthenticationsOrderBy
data UserAuthenticationsOrderBy
  = IdAsc
  | IdDesc
  | Natural
  | PrimaryKeyAsc
  | PrimaryKeyDesc
  | ServiceAsc
  | ServiceDesc

derive instance genericUserAuthenticationsOrderBy :: Generic UserAuthenticationsOrderBy _

instance showUserAuthenticationsOrderBy :: Show UserAuthenticationsOrderBy where
  show = genericShow

derive instance eqUserAuthenticationsOrderBy :: Eq UserAuthenticationsOrderBy

derive instance ordUserAuthenticationsOrderBy :: Ord UserAuthenticationsOrderBy

fromToMap :: Array (Tuple String UserAuthenticationsOrderBy)
fromToMap = [ Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "NATURAL" Natural
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            , Tuple "SERVICE_ASC" ServiceAsc
            , Tuple "SERVICE_DESC" ServiceDesc
            ]

instance userAuthenticationsOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                                          UserAuthenticationsOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder
                                        "UserAuthenticationsOrderBy"
                                        fromToMap

instance userAuthenticationsOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                                             UserAuthenticationsOrderBy where
  toGraphQLArgumentValue =
    case _ of
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      Natural -> ArgumentValueEnum "NATURAL"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"
      ServiceAsc -> ArgumentValueEnum "SERVICE_ASC"
      ServiceDesc -> ArgumentValueEnum "SERVICE_DESC"
