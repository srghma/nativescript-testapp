module NextjsGraphqlApi.Object.UserEmail where

import GraphQLClient
  (SelectionSet, selectionForField, graphqlDefaultResponseScalarDecoder)
import NextjsGraphqlApi.Scopes (Scope__UserEmail)
import NextjsGraphqlApi.Scalars (Datetime, Uuid)
import Data.Maybe (Maybe)

createdAt :: SelectionSet Scope__UserEmail Datetime
createdAt = selectionForField "createdAt" [] graphqlDefaultResponseScalarDecoder

email :: SelectionSet Scope__UserEmail String
email = selectionForField "email" [] graphqlDefaultResponseScalarDecoder

isVerified :: SelectionSet Scope__UserEmail Boolean
isVerified = selectionForField
             "isVerified"
             []
             graphqlDefaultResponseScalarDecoder

passwordResetEmailSentAt :: SelectionSet Scope__UserEmail (Maybe Datetime)
passwordResetEmailSentAt = selectionForField
                           "passwordResetEmailSentAt"
                           []
                           graphqlDefaultResponseScalarDecoder

rowId :: SelectionSet Scope__UserEmail Uuid
rowId = selectionForField "rowId" [] graphqlDefaultResponseScalarDecoder

updatedAt :: SelectionSet Scope__UserEmail Datetime
updatedAt = selectionForField "updatedAt" [] graphqlDefaultResponseScalarDecoder

userId :: SelectionSet Scope__UserEmail Uuid
userId = selectionForField "userId" [] graphqlDefaultResponseScalarDecoder

verificationEmailSentAt :: SelectionSet Scope__UserEmail (Maybe Datetime)
verificationEmailSentAt = selectionForField
                          "verificationEmailSentAt"
                          []
                          graphqlDefaultResponseScalarDecoder

verificationToken :: SelectionSet Scope__UserEmail (Maybe String)
verificationToken = selectionForField
                    "verificationToken"
                    []
                    graphqlDefaultResponseScalarDecoder
