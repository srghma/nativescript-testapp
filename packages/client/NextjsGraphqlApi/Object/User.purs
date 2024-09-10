module NextjsGraphqlApi.Object.User where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Optional
  , selectionForCompositeField
  , toGraphQLArguments
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes (Scope__User, Scope__PostsConnection)
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Datetime, Id, Cursor, Uuid)
import NextjsGraphqlApi.InputObject (PostCondition) as NextjsGraphqlApi.InputObject
import NextjsGraphqlApi.Enum.PostsOrderBy (PostsOrderBy)
import Type.Row (type (+))

avatarUrl :: SelectionSet Scope__User (Maybe String)
avatarUrl = selectionForField "avatarUrl" [] graphqlDefaultResponseScalarDecoder

createdAt :: SelectionSet Scope__User Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

id :: SelectionSet Scope__User Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

isAdmin :: SelectionSet Scope__User Boolean
isAdmin = selectionForField "isAdmin" [] graphqlDefaultResponseScalarDecoder

name :: SelectionSet Scope__User (Maybe String)
name = selectionForField "name" [] graphqlDefaultResponseScalarDecoder

type PostsInputRowOptional r = ( after :: Optional Cursor
                               , before :: Optional Cursor
                               , condition :: Optional
                                              NextjsGraphqlApi.InputObject.PostCondition
                               , first :: Optional Int
                               , last :: Optional Int
                               , offset :: Optional Int
                               , orderBy :: Optional (Array PostsOrderBy)
                               | r
                               )

type PostsInput = { | PostsInputRowOptional + () }

posts :: forall r . PostsInput -> SelectionSet
                                  Scope__PostsConnection
                                  r -> SelectionSet
                                       Scope__User
                                       r
posts input = selectionForCompositeField
              "posts"
              (toGraphQLArguments
               input)
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

rowId :: SelectionSet Scope__User Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__User Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

username :: SelectionSet Scope__User String
username = selectionForField "username" [] graphqlDefaultResponseScalarDecoder

userSecretId :: SelectionSet Scope__User Uuid
userSecretId = selectionForField
               "userSecretId"
               []
               graphqlDefaultResponseScalarDecoder
