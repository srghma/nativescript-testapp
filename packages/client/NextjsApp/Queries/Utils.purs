module NextjsApp.Queries.Utils where

import Protolude

import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv

throwEitherGraphqlError :: forall t10 t15 t9. MonadThrow Error t9 => Either (GraphQLError t15) t10 -> t9 t10
throwEitherGraphqlError = (throwError <<< error <<< GraphQLClient.printGraphQLError) \/ pure

------------

graphqlApiQueryRequest :: forall t19. SelectionSet Scope__RootQuery t19 -> Aff (Either (GraphQLError t19) t19)
graphqlApiQueryRequest =
  GraphQLClient.graphqlQueryRequest
  NextjsApp.NodeEnv.env.apiUrl
  GraphQLClient.defaultRequestOptions

graphqlApiQueryRequestOrThrow :: forall t24. SelectionSet Scope__RootQuery t24 -> Aff t24
graphqlApiQueryRequestOrThrow query = graphqlApiQueryRequest query >>= throwEitherGraphqlError

-----------------

graphqlApiMutationRequest :: forall t31. SelectionSet Scope__RootMutation t31 -> Aff (Either (GraphQLError t31) t31)
graphqlApiMutationRequest =
  GraphQLClient.graphqlMutationRequest
  NextjsApp.NodeEnv.env.apiUrl
  GraphQLClient.defaultRequestOptions

graphqlApiMutationRequestOrThrow :: forall t36. SelectionSet Scope__RootMutation t36 -> Aff t36
graphqlApiMutationRequestOrThrow query = graphqlApiMutationRequest query >>= throwEitherGraphqlError
