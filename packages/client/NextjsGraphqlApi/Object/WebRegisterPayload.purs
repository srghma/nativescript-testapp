module NextjsGraphqlApi.Object.WebRegisterPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__User, Scope__WebRegisterPayload)

user :: forall r . SelectionSet
                   Scope__User
                   r -> SelectionSet
                        Scope__WebRegisterPayload
                        r
user = selectionForCompositeField
       "user"
       []
       graphqlDefaultResponseFunctorOrScalarDecoderTransformer
