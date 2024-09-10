module NextjsGraphqlApi.Object.VerifyUserEmailPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__VerifyUserEmailPayload, Scope__UserEmail)
import Data.Maybe (Maybe)

clientMutationId :: SelectionSet Scope__VerifyUserEmailPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__VerifyUserEmailPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userEmail :: forall r . SelectionSet
                        Scope__UserEmail
                        r -> SelectionSet
                             Scope__VerifyUserEmailPayload
                             (Maybe
                              r)
userEmail = selectionForCompositeField
            "userEmail"
            []
            graphqlDefaultResponseFunctorOrScalarDecoderTransformer
