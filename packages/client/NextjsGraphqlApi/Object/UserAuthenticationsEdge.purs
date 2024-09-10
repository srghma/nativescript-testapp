module NextjsGraphqlApi.Object.UserAuthenticationsEdge where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes
  (Scope__UserAuthenticationsEdge, Scope__UserAuthentication)
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Cursor)

cursor :: SelectionSet Scope__UserAuthenticationsEdge (Maybe Cursor)
cursor = selectionForField "cursor" [] graphqlDefaultResponseScalarDecoder

node :: forall r . SelectionSet
                   Scope__UserAuthentication
                   r -> SelectionSet
                        Scope__UserAuthenticationsEdge
                        r
node = selectionForCompositeField
       "node"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer
