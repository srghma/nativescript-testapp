module NextjsApp.Pages.VerifyUserEmailMobile (page) where

import Nextjs.Page
import NextjsApp.PageImplementations.VerifyUserEmailMobile.Types
import NextjsApp.Queries.Utils
import Protolude

import GraphQLClient (GraphQLError, Scope__RootMutation, Scope__RootQuery, SelectionSet(..))
import GraphQLClient as GraphQLClient
import NextjsApp.AppM (AppM(..))
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.PageImplementations.VerifyUserEmailMobile as NextjsApp.PageImplementations.VerifyUserEmailMobile
import NextjsApp.Route as NextjsApp.Route
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query

pageSpec :: PageSpec NextjsApp.Route.MobileRoutesWithParamRow (AppM NextjsApp.Route.MobileRoutesWithParamRow) Unit
pageSpec =
  { pageData: PageData__Static unit
  , component: NextjsApp.PageImplementations.VerifyUserEmailMobile.component
  , title: "Verify User Email"
  }

page :: PageSpecBoxed NextjsApp.Route.MobileRoutesWithParamRow (AppM NextjsApp.Route.MobileRoutesWithParamRow)
page = mkPageSpecBoxed pageSpec
