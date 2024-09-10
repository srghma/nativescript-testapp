module NextjsGraphqlApi.Object.PostsEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__PostsEdge, Scope__Post)
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Cursor)

cursor :: SelectionSet Scope__PostsEdge (Maybe Cursor)
cursor = selectionForField "cursor" [] graphqlDefaultResponseScalarDecoder

node :: forall r . SelectionSet Scope__Post r -> SelectionSet Scope__PostsEdge r
node = selectionForCompositeField
       "node"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer
