module NextjsGraphqlApi.Object.UsersEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__UsersEdge, Scope__User)
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Cursor)

cursor :: SelectionSet Scope__UsersEdge (Maybe Cursor)
cursor = selectionForField "cursor" [] graphqlDefaultResponseScalarDecoder

node :: forall r . SelectionSet Scope__User r -> SelectionSet Scope__UsersEdge r
node = selectionForCompositeField
       "node"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer
