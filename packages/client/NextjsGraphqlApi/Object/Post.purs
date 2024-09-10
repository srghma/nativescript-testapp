module NextjsGraphqlApi.Object.Post where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__Post, Scope__User)
import NextjsGraphqlApi.Scalars (Datetime, Id, Uuid)
import Data.Maybe (Maybe)

content :: SelectionSet Scope__Post String
content = selectionForField "content" [] graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__Post Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__Post Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

name :: SelectionSet Scope__Post String
name = selectionForField "name" [] graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__Post Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__Post Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__Post
                        (Maybe
                         r)
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userId :: SelectionSet Scope__Post Uuid
userId = selectionForField "userId" [] graphqlDefaultResponseScalarDecoder
