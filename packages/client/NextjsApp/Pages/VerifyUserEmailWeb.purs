module NextjsApp.Pages.VerifyUserEmailWeb (page) where

import Nextjs.Page
import NextjsApp.PageImplementations.VerifyUserEmailWeb.Types
import NextjsApp.Queries.Utils
import Protolude

import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.AppM (AppM(..))
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.PageImplementations.VerifyUserEmailWeb as NextjsApp.PageImplementations.VerifyUserEmailWeb
import NextjsApp.Route as NextjsApp.Route
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query

pageSpec :: PageSpec NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.VerifyUserEmailWeb.component
  , title: "Verify User Email"
  }

page :: PageSpecBoxed NextjsApp.Route.WebRoutesWithParamRow (AppM NextjsApp.Route.WebRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
