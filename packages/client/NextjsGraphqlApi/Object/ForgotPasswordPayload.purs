module NextjsGraphqlApi.Object.ForgotPasswordPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__ForgotPasswordPayload)
import Data.Maybe (Maybe)

clientMutationId :: SelectionSet Scope__ForgotPasswordPayload (Maybe String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__ForgotPasswordPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

success :: SelectionSet Scope__ForgotPasswordPayload (Maybe Boolean)
success = selectionForField "success" [] graphqlDefaultResponseScalarDecoder
