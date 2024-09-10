module NextjsGraphqlApi.Mutation where

import NextjsGraphqlApi.InputObject
  ( DeleteUserInput
  , DeleteUserAuthenticationInput
  , DeleteUserAuthenticationByIdInput
  , DeleteUserAuthenticationByServiceAndIdentifierInput
  , DeleteUserByIdInput
  , DeleteUserByUsernameInput
  , ForgotPasswordInput
  , ResetPasswordInput
  , UpdateUserInput
  , UpdateUserByIdInput
  , UpdateUserByUsernameInput
  , VerifyUserEmailInput
  , WebLoginInput
  , WebRegisterInput
  ) as NextjsGraphqlApi.InputObject
import Type.Row (type (+))
import GraphQLClient
  ( SelectionSet
  , Scope__RootMutation
  , selectionForCompositeField
  , toGraphQLArguments
  , graphqlDefaultResponseFunctorOrScalarDecoderTransformer
  )
import NextjsGraphqlApi.Scopes
  ( Scope__DeleteUserPayload
  , Scope__DeleteUserAuthenticationPayload
  , Scope__ForgotPasswordPayload
  , Scope__ResetPasswordPayload
  , Scope__UpdateUserPayload
  , Scope__VerifyUserEmailPayload
  , Scope__WebLoginPayload
  , Scope__WebRegisterPayload
  )
import Data.Maybe (Maybe)

type DeleteUserInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserInput
                                    | r
                                    )

type DeleteUserInput = { | DeleteUserInputRowRequired + () }

deleteUser :: forall r . DeleteUserInput -> SelectionSet
                                            Scope__DeleteUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
deleteUser input = selectionForCompositeField
                   "deleteUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserAuthenticationInput
                                                  | r
                                                  )

type DeleteUserAuthenticationInput = {
| DeleteUserAuthenticationInputRowRequired + ()
}

deleteUserAuthentication :: forall r . DeleteUserAuthenticationInput -> SelectionSet
                                                                        Scope__DeleteUserAuthenticationPayload
                                                                        r -> SelectionSet
                                                                             Scope__RootMutation
                                                                             (Maybe
                                                                              r)
deleteUserAuthentication input = selectionForCompositeField
                                 "deleteUserAuthentication"
                                 (toGraphQLArguments
                                  input)
                                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationByIdInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserAuthenticationByIdInput
                                                      | r
                                                      )

type DeleteUserAuthenticationByIdInput = {
| DeleteUserAuthenticationByIdInputRowRequired + ()
}

deleteUserAuthenticationById :: forall r . DeleteUserAuthenticationByIdInput -> SelectionSet
                                                                                Scope__DeleteUserAuthenticationPayload
                                                                                r -> SelectionSet
                                                                                     Scope__RootMutation
                                                                                     (Maybe
                                                                                      r)
deleteUserAuthenticationById input = selectionForCompositeField
                                     "deleteUserAuthenticationById"
                                     (toGraphQLArguments
                                      input)
                                     graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserAuthenticationByServiceAndIdentifierInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserAuthenticationByServiceAndIdentifierInput
                                                                        | r
                                                                        )

type DeleteUserAuthenticationByServiceAndIdentifierInput = {
| DeleteUserAuthenticationByServiceAndIdentifierInputRowRequired + ()
}

deleteUserAuthenticationByServiceAndIdentifier :: forall r . DeleteUserAuthenticationByServiceAndIdentifierInput -> SelectionSet
                                                                                                                    Scope__DeleteUserAuthenticationPayload
                                                                                                                    r -> SelectionSet
                                                                                                                         Scope__RootMutation
                                                                                                                         (Maybe
                                                                                                                          r)
deleteUserAuthenticationByServiceAndIdentifier input = selectionForCompositeField
                                                       "deleteUserAuthenticationByServiceAndIdentifier"
                                                       (toGraphQLArguments
                                                        input)
                                                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserByIdInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserByIdInput
                                        | r
                                        )

type DeleteUserByIdInput = { | DeleteUserByIdInputRowRequired + () }

deleteUserById :: forall r . DeleteUserByIdInput -> SelectionSet
                                                    Scope__DeleteUserPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
deleteUserById input = selectionForCompositeField
                       "deleteUserById"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type DeleteUserByUsernameInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.DeleteUserByUsernameInput
                                              | r
                                              )

type DeleteUserByUsernameInput = { | DeleteUserByUsernameInputRowRequired + () }

deleteUserByUsername :: forall r . DeleteUserByUsernameInput -> SelectionSet
                                                                Scope__DeleteUserPayload
                                                                r -> SelectionSet
                                                                     Scope__RootMutation
                                                                     (Maybe
                                                                      r)
deleteUserByUsername input = selectionForCompositeField
                             "deleteUserByUsername"
                             (toGraphQLArguments
                              input)
                             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ForgotPasswordInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.ForgotPasswordInput
                                        | r
                                        )

type ForgotPasswordInput = { | ForgotPasswordInputRowRequired + () }

forgotPassword :: forall r . ForgotPasswordInput -> SelectionSet
                                                    Scope__ForgotPasswordPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
forgotPassword input = selectionForCompositeField
                       "forgotPassword"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type ResetPasswordInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.ResetPasswordInput
                                       | r
                                       )

type ResetPasswordInput = { | ResetPasswordInputRowRequired + () }

resetPassword :: forall r . ResetPasswordInput -> SelectionSet
                                                  Scope__ResetPasswordPayload
                                                  r -> SelectionSet
                                                       Scope__RootMutation
                                                       (Maybe
                                                        r)
resetPassword input = selectionForCompositeField
                      "resetPassword"
                      (toGraphQLArguments
                       input)
                      graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.UpdateUserInput
                                    | r
                                    )

type UpdateUserInput = { | UpdateUserInputRowRequired + () }

updateUser :: forall r . UpdateUserInput -> SelectionSet
                                            Scope__UpdateUserPayload
                                            r -> SelectionSet
                                                 Scope__RootMutation
                                                 (Maybe
                                                  r)
updateUser input = selectionForCompositeField
                   "updateUser"
                   (toGraphQLArguments
                    input)
                   graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserByIdInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.UpdateUserByIdInput
                                        | r
                                        )

type UpdateUserByIdInput = { | UpdateUserByIdInputRowRequired + () }

updateUserById :: forall r . UpdateUserByIdInput -> SelectionSet
                                                    Scope__UpdateUserPayload
                                                    r -> SelectionSet
                                                         Scope__RootMutation
                                                         (Maybe
                                                          r)
updateUserById input = selectionForCompositeField
                       "updateUserById"
                       (toGraphQLArguments
                        input)
                       graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type UpdateUserByUsernameInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.UpdateUserByUsernameInput
                                              | r
                                              )

type UpdateUserByUsernameInput = { | UpdateUserByUsernameInputRowRequired + () }

updateUserByUsername :: forall r . UpdateUserByUsernameInput -> SelectionSet
                                                                Scope__UpdateUserPayload
                                                                r -> SelectionSet
                                                                     Scope__RootMutation
                                                                     (Maybe
                                                                      r)
updateUserByUsername input = selectionForCompositeField
                             "updateUserByUsername"
                             (toGraphQLArguments
                              input)
                             graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type VerifyUserEmailInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.VerifyUserEmailInput
                                         | r
                                         )

type VerifyUserEmailInput = { | VerifyUserEmailInputRowRequired + () }

verifyUserEmail :: forall r . VerifyUserEmailInput -> SelectionSet
                                                      Scope__VerifyUserEmailPayload
                                                      r -> SelectionSet
                                                           Scope__RootMutation
                                                           (Maybe
                                                            r)
verifyUserEmail input = selectionForCompositeField
                        "verifyUserEmail"
                        (toGraphQLArguments
                         input)
                        graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type WebLoginInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.WebLoginInput
                                  | r
                                  )

type WebLoginInput = { | WebLoginInputRowRequired + () }

webLogin :: forall r . WebLoginInput -> SelectionSet
                                        Scope__WebLoginPayload
                                        r -> SelectionSet
                                             Scope__RootMutation
                                             (Maybe
                                              r)
webLogin input = selectionForCompositeField
                 "webLogin"
                 (toGraphQLArguments
                  input)
                 graphqlDefaultResponseFunctorOrScalarDecoderTransformer

type WebRegisterInputRowRequired r = ( input :: NextjsGraphqlApi.InputObject.WebRegisterInput
                                     | r
                                     )

type WebRegisterInput = { | WebRegisterInputRowRequired + () }

webRegister :: forall r . WebRegisterInput -> SelectionSet
                                              Scope__WebRegisterPayload
                                              r -> SelectionSet
                                                   Scope__RootMutation
                                                   (Maybe
                                                    r)
webRegister input = selectionForCompositeField
                    "webRegister"
                    (toGraphQLArguments
                     input)
                    graphqlDefaultResponseFunctorOrScalarDecoderTransformer
