module NextjsGraphqlApi.Query where

import GraphQLClient
  ( SelectionSet
  , Scope__RootQuery
  , selectionForCompositeField
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , toGraphQLArguments
  , Optional
  )
import NextjsGraphqlApi.Scopes
  ( Scope__User
  , Scope__Node
  , Scope__Post
  , Scope__PostsConnection
  , Scope__UserAuthentication
  )
import Data.Maybe (Maybe)
import NextjsGraphqlApi.Scalars (Id, Uuid, Cursor)
import Type.Row (type (+))
import NextjsGraphqlApi.InputObject (PostCondition) as NextjsGraphqlApi.InputObject
import NextjsGraphqlApi.Enum.PostsOrderBy (PostsOrderBy)

currentUser :: forall r . SelectionSet
                          Scope__User
                          r -> SelectionSet
                               Scope__RootQuery
                               (Maybe
                                r)
currentUser = selectionForCompositeField
              "currentUser"
              []
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

id :: SelectionSet Scope__RootQuery Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

type NodeInputRowRequired r = ( id :: Id | r )

type NodeInput = { | NodeInputRowRequired + () }

node :: forall r . NodeInput -> SelectionSet
                                Scope__Node
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
node input = selectionForCompositeField
             "node"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type PostInputRowRequired r = ( rowId :: Uuid | r )

type PostInput = { | PostInputRowRequired + () }

post :: forall r . PostInput -> SelectionSet
                                Scope__Post
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
post input = selectionForCompositeField
             "post"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type PostByIdInputRowRequired r = ( id :: Id | r )

type PostByIdInput = { | PostByIdInputRowRequired + () }

postById :: forall r . PostByIdInput -> SelectionSet
                                        Scope__Post
                                        r -> SelectionSet
                                             Scope__RootQuery
                                             (Maybe
                                              r)
postById input = selectionForCompositeField
                 "postById"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

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
                                       Scope__RootQuery
                                       (Maybe
                                        r)
posts input = selectionForCompositeField
              "posts"
              (toGraphQLArguments
               input)
              graphqlDefaultResponseFunctorOrScalarDecoderTransformer

query :: forall r . SelectionSet
                    Scope__RootQuery
                    r -> SelectionSet
                         Scope__RootQuery
                         r
query = selectionForCompositeField
        "query"
        []
        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserInputRowRequired r = ( rowId :: Uuid | r )

type UserInput = { | UserInputRowRequired + () }

user :: forall r . UserInput -> SelectionSet
                                Scope__User
                                r -> SelectionSet
                                     Scope__RootQuery
                                     (Maybe
                                      r)
user input = selectionForCompositeField
             "user"
             (toGraphQLArguments
              input)
             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationInputRowRequired r = ( rowId :: Uuid | r )

type UserAuthenticationInput = { | UserAuthenticationInputRowRequired + () }

userAuthentication :: forall r . UserAuthenticationInput -> SelectionSet
                                                            Scope__UserAuthentication
                                                            r -> SelectionSet
                                                                 Scope__RootQuery
                                                                 (Maybe
                                                                  r)
userAuthentication input = selectionForCompositeField
                           "userAuthentication"
                           (toGraphQLArguments
                            input)
                           graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationByIdInputRowRequired r = ( id :: Id | r )

type UserAuthenticationByIdInput = {
| UserAuthenticationByIdInputRowRequired + ()
}

userAuthenticationById :: forall r . UserAuthenticationByIdInput -> SelectionSet
                                                                    Scope__UserAuthentication
                                                                    r -> SelectionSet
                                                                         Scope__RootQuery
                                                                         (Maybe
                                                                          r)
userAuthenticationById input = selectionForCompositeField
                               "userAuthenticationById"
                               (toGraphQLArguments
                                input)
                               graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserAuthenticationByServiceAndIdentifierInputRowRequired r = ( identifier :: String
                                                                  , service :: String
                                                                  | r
                                                                  )

type UserAuthenticationByServiceAndIdentifierInput = {
| UserAuthenticationByServiceAndIdentifierInputRowRequired + ()
}

userAuthenticationByServiceAndIdentifier :: forall r . UserAuthenticationByServiceAndIdentifierInput -> SelectionSet
                                                                                                        Scope__UserAuthentication
                                                                                                        r -> SelectionSet
                                                                                                             Scope__RootQuery
                                                                                                             (Maybe
                                                                                                              r)
userAuthenticationByServiceAndIdentifier input = selectionForCompositeField
                                                 "userAuthenticationByServiceAndIdentifier"
                                                 (toGraphQLArguments
                                                  input)
                                                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByIdInputRowRequired r = ( id :: Id | r )

type UserByIdInput = { | UserByIdInputRowRequired + () }

userById :: forall r . UserByIdInput -> SelectionSet
                                        Scope__User
                                        r -> SelectionSet
                                             Scope__RootQuery
                                             (Maybe
                                              r)
userById input = selectionForCompositeField
                 "userById"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByUsernameInputRowRequired r = ( username :: String | r )

type UserByUsernameInput = { | UserByUsernameInputRowRequired + () }

userByUsername :: forall r . UserByUsernameInput -> SelectionSet
                                                    Scope__User
                                                    r -> SelectionSet
                                                         Scope__RootQuery
                                                         (Maybe
                                                          r)
userByUsername input = selectionForCompositeField
                       "userByUsername"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UserByUsernameOrVerifiedEmailInputRowRequired r = ( usernameOrEmail :: String
                                                       | r
                                                       )

type UserByUsernameOrVerifiedEmailInput = {
| UserByUsernameOrVerifiedEmailInputRowRequired + ()
}

userByUsernameOrVerifiedEmail :: forall r . UserByUsernameOrVerifiedEmailInput -> SelectionSet
                                                                                  Scope__User
                                                                                  r -> SelectionSet
                                                                                       Scope__RootQuery
                                                                                       (Maybe
                                                                                        r)
userByUsernameOrVerifiedEmail input = selectionForCompositeField
                                      "userByUsernameOrVerifiedEmail"
                                      (toGraphQLArguments
                                       input)
                                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer
