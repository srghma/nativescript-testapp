module NextjsGraphqlApi.Object.UserAuthentication where

import GraphQLClient
  (SelectionSet, selectionForField, graphqlDefaultResponseScalarDecoder)
import NextjsGraphqlApi.Scopes (Scope__UserAuthentication)
import NextjsGraphqlApi.Scalars (Datetime, Id, Uuid)

createdAt :: SelectionSet Scope__UserAuthentication Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__UserAuthentication Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

identifier :: SelectionSet Scope__UserAuthentication String
identifier = selectionForField
             "identifier"
             []
             graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__UserAuthentication Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

service :: SelectionSet Scope__UserAuthentication String
service = selectionForField "service" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__UserAuthentication Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder
