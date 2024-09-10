module NextjsGraphqlApi.Enum.PostsOrderBy where

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

-- | original name - PostsOrderBy
data PostsOrderBy
  = IdAsc
  | IdDesc
  | Natural
  | PrimaryKeyAsc
  | PrimaryKeyDesc
  | UserIdAsc
  | UserIdDesc

derive instance genericPostsOrderBy :: Generic PostsOrderBy _

instance showPostsOrderBy :: Show PostsOrderBy where
  show = genericShow

derive instance eqPostsOrderBy :: Eq PostsOrderBy

derive instance ordPostsOrderBy :: Ord PostsOrderBy

fromToMap :: Array (Tuple String PostsOrderBy)
fromToMap = [ Tuple "ID_ASC" IdAsc
            , Tuple "ID_DESC" IdDesc
            , Tuple "NATURAL" Natural
            , Tuple "PRIMARY_KEY_ASC" PrimaryKeyAsc
            , Tuple "PRIMARY_KEY_DESC" PrimaryKeyDesc
            , Tuple "USER_ID_ASC" UserIdAsc
            , Tuple "USER_ID_DESC" UserIdDesc
            ]

instance postsOrderByGraphQLDefaultResponseScalarDecoder :: GraphQLDefaultResponseScalarDecoder
                                                            PostsOrderBy where
  graphqlDefaultResponseScalarDecoder = enumDecoder "PostsOrderBy" fromToMap

instance postsOrderByToGraphQLArgumentValue :: ToGraphQLArgumentValue
                                               PostsOrderBy where
  toGraphQLArgumentValue =
    case _ of
      IdAsc -> ArgumentValueEnum "ID_ASC"
      IdDesc -> ArgumentValueEnum "ID_DESC"
      Natural -> ArgumentValueEnum "NATURAL"
      PrimaryKeyAsc -> ArgumentValueEnum "PRIMARY_KEY_ASC"
      PrimaryKeyDesc -> ArgumentValueEnum "PRIMARY_KEY_DESC"
      UserIdAsc -> ArgumentValueEnum "USER_ID_ASC"
      UserIdDesc -> ArgumentValueEnum "USER_ID_DESC"
