module NextjsGraphqlApi.Object.DeleteUserAuthenticationPayload where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , Optional
  , toGraphQLArguments
  )
import NextjsGraphqlApi.Scopes
  ( Scope__DeleteUserAuthenticationPayload
  , Scope__UserAuthentication
  , Scope__UserAuthenticationsEdge
  )
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Id)
import NextjsGraphqlApi.Enum.UserAuthenticationsOrderBy
  (UserAuthenticationsOrderBy)
import Type.Row (type (+))

clientMutationId :: SelectionSet
                    Scope__DeleteUserAuthenticationPayload
                    (Maybe
                     String)
clientMutationId = selectionForField
                   "clientMutationId"
                   []
                   graphqlDefaultResponseScalarDecoder

deletedUserAuthenticationId :: SelectionSet
                               Scope__DeleteUserAuthenticationPayload
                               (Maybe
                                Id)
deletedUserAuthenticationId = selectionForField
                              "deletedUserAuthenticationId"
                              []
                              graphqlDefaultResponseScalarDecoder

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__DeleteUserAuthenticationPayload
                         (Maybe
                          r)
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

userAuthentication :: forall r . SelectionSet
                                 Scope__UserAuthentication
                                 r -> SelectionSet
                                      Scope__DeleteUserAuthenticationPayload
                                      (Maybe
                                       r)
userAuthentication = selectionForCompositeField
                     "userAuthentication"
                     []
                     graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationEdgeInputRowOptional r = ( orderBy :: Optional
                                                             (Array
                                                              UserAuthenticationsOrderBy)
                                                | r
                                                )

type UserAuthenticationEdgeInput = {
| UserAuthenticationEdgeInputRowOptional + ()
}

userAuthenticationEdge :: forall r . UserAuthenticationEdgeInput -> SelectionSet
                                                                    Scope__UserAuthenticationsEdge
                                                                    r -> SelectionSet
                                                                         Scope__DeleteUserAuthenticationPayload
                                                                         (Maybe
                                                                          r)
userAuthenticationEdge input = selectionForCompositeField
                               "userAuthenticationEdge"
                               (toGraphQLArguments
                                input)
                               graphqlDefaultResponseFunctorOrScalarDecoderTransformer
