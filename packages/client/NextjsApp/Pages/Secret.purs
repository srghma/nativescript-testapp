module NextjsApp.Pages.Secret (page) where

import Protolude

import NextjsApp.Queries.Utils
import NextjsApp.PageImplementations.Secret.Types
import Nextjs.Page
import NextjsApp.PageImplementations.Secret as NextjsApp.PageImplementations.Secret
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.AppM (AppM(..))

pageSpec :: PageSpec SecretPageUserData
pageSpec =
  { pageData: PageData__Dynamic
      { request: pageData_DynamicRequestOptions__To__RequestOptions >>> \graphqlRequestOptions ->
        GraphQLClient.graphqlQueryRequest
        NextjsApp.NodeEnv.env.apiUrl
        graphqlRequestOptions
        ( NextjsGraphqlApi.Query.currentUser
          ( ado
              id <- NextjsGraphqlApi.Object.User.id <#> unwrap
              name <- NextjsGraphqlApi.Object.User.name
              username <- NextjsGraphqlApi.Object.User.username
            in SecretPageUserData { id, name, username }
          )
        )
        <#>
          either
          (PageData_DynamicResponse__Error <<< GraphQLClient.printGraphQLError)
          (maybe
            ( PageData_DynamicResponse__Redirect
              { redirectToLocation: NextjsApp.Route.route__Login
              , logout: true
              }
            )
            PageData_DynamicResponse__Success
          )
      , codec: mkPageData_DynamicCodec
      }
  , component: NextjsApp.PageImplementations.Secret.component
  , title: "Secret"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
