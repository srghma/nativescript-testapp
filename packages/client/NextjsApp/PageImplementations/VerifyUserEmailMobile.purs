module NextjsApp.PageImplementations.VerifyUserEmailMobile (component) where

import NextjsGraphqlApi.Scalars
import Material.Classes.LayoutGrid
import NextjsApp.PageImplementations.VerifyUserEmailMobile.Render
import NextjsApp.PageImplementations.VerifyUserEmailMobile.Types
import Protolude

import Affjax as Affjax
import NextjsGraphqlApi.InputObject as NextjsGraphqlApi.InputObject
import NextjsGraphqlApi.Mutation as NextjsGraphqlApi.Mutation
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Query as NextjsGraphqlApi.Query
import Browser.Cookie as Browser.Cookie
import Data.Argonaut.Decode as Data.Argonaut.Decode
import Data.Array as Array
import Data.Array.NonEmpty as NonEmptyArray
import Data.Either (Either(..))
import Data.Email (Email)
import Data.Email as Email
import Data.Int as Int
import Data.Lens.Record as Lens
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Data.Variant (Variant, inj)
import GraphQLClient (GraphQLError, Scope__RootMutation, SelectionSet(..))
import GraphQLClient as GraphQLClient
import Halogen as H
import Halogen.Component as Halogen.Component
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import HalogenMWC.Button as Button
import HalogenMWC.TextField.Outlined as TextField.Outlined
import HalogenMWC.Utils (setEfficiently)
import NextjsApp.AppM (AppM)
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Data.Password (Password)
import NextjsApp.Data.Password as NextjsApp.Data.Password
import NextjsApp.Navigate as NextjsApp.Navigate
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Data.InUseUsernameOrEmail (InUseUsernameOrEmail)
import NextjsApp.Data.InUseUsernameOrEmail as NextjsApp.Data.InUseUsernameOrEmail
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.Queries.Utils
import NextjsGraphqlApi.Object.User as NextjsGraphqlApi.Object.User
import NextjsGraphqlApi.Object.WebLoginPayload as NextjsGraphqlApi.Object.WebLoginPayload
import NextjsGraphqlApi.Scalars as NextjsGraphqlApi.Scalars

component ::
  forall m r.
  MonadAsk { navigate :: Variant NextjsApp.Route.MobileRoutesWithParamRow -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const { loginError: Nothing }
    , render
    , eval:
      H.mkEval
        $ H.defaultEval
            { initialize = Just Action__Initialize
            , handleAction =
              case _ of
                  Action__Initialize -> traceM "Action__Initialize"
            }
    }
