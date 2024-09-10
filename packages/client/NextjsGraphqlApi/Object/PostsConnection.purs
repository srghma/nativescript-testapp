module NextjsGraphqlApi.Object.PostsConnection where

import GraphQLClient
  ( SelectionSet
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  )
import NextjsGraphqlApi.Scopes
  (Scope__PostsEdge, Scope__PostsConnection, Scope__Post, Scope__PageInfo)

edges :: forall r . SelectionSet
                    Scope__PostsEdge
                    r -> SelectionSet
                         Scope__PostsConnection
                         (Array
                          r)
edges = selectionForCompositeField
        "edges"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

nodes :: forall r . SelectionSet
                    Scope__Post
                    r -> SelectionSet
                         Scope__PostsConnection
                         (Array
                          r)
nodes = selectionForCompositeField
        "nodes"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

pageInfo :: forall r . SelectionSet
                       Scope__PageInfo
                       r -> SelectionSet
                            Scope__PostsConnection
                            r
pageInfo = selectionForCompositeField
           "pageInfo"
           []
           graphqlDefaultResponseFunctorOrScalarDecoderTransformer

totalCount :: SelectionSet Scope__PostsConnection Int
totalCount = selectionForField
             "totalCount"
             []
             graphqlDefaultResponseScalarDecoder
