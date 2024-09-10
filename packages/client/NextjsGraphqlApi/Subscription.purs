module NextjsGraphqlApi.Subscription where

import Type.Row (type (+))
import GraphQLClient
  ( SelectionSet
  , Scope__RootSubscription
  , selectionForCompositeField
  , toGraphQLArguments
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__ListenPayload)

type ListenInputRowRequired r = ( topic :: String | r )

type ListenInput = { | ListenInputRowRequired + () }

listen :: forall r . ListenInput -> SelectionSet
                                    Scope__ListenPayload
                                    r -> SelectionSet
                                         Scope__RootSubscription
                                         r
listen input = selectionForCompositeField
               "listen"
               (toGraphQLArguments
                input)
               graphqlDefaultResponseFunctorOrScalarDecoderTransformer
