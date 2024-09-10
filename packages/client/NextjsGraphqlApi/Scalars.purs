module NextjsGraphqlApi.Scalars where

import Data.Newtype (class Newtype)
import Prelude (class Eq, class Ord, class Show)
import GraphQLClient
  (class GraphQLDefaultResponseScalarDecoder, class ToGraphQLArgumentValue)

-- | original name - Cursor
newtype Cursor = Cursor String

derive instance newtypeCursor :: Newtype Cursor _

derive newtype instance eqCursor :: Eq Cursor

derive newtype instance ordCursor :: Ord Cursor

derive newtype instance showCursor :: Show Cursor

derive newtype instance graphQlDefaultResponseScalarDecoderCursor :: GraphQLDefaultResponseScalarDecoder Cursor

derive newtype instance toGraphQlArgumentValueCursor :: ToGraphQLArgumentValue Cursor

-- | original name - Datetime
newtype Datetime = Datetime String

derive instance newtypeDatetime :: Newtype Datetime _

derive newtype instance eqDatetime :: Eq Datetime

derive newtype instance ordDatetime :: Ord Datetime

derive newtype instance showDatetime :: Show Datetime

derive newtype instance graphQlDefaultResponseScalarDecoderDatetime :: GraphQLDefaultResponseScalarDecoder Datetime

derive newtype instance toGraphQlArgumentValueDatetime :: ToGraphQLArgumentValue Datetime

-- | original name - ID
newtype Id = Id String

derive instance newtypeId :: Newtype Id _

derive newtype instance eqId :: Eq Id

derive newtype instance ordId :: Ord Id

derive newtype instance showId :: Show Id

derive newtype instance graphQlDefaultResponseScalarDecoderId :: GraphQLDefaultResponseScalarDecoder Id

derive newtype instance toGraphQlArgumentValueId :: ToGraphQLArgumentValue Id

-- | original name - UUID
newtype Uuid = Uuid String

derive instance newtypeUuid :: Newtype Uuid _

derive newtype instance eqUuid :: Eq Uuid

derive newtype instance ordUuid :: Ord Uuid

derive newtype instance showUuid :: Show Uuid

derive newtype instance graphQlDefaultResponseScalarDecoderUuid :: GraphQLDefaultResponseScalarDecoder Uuid

derive newtype instance toGraphQlArgumentValueUuid :: ToGraphQLArgumentValue Uuid
