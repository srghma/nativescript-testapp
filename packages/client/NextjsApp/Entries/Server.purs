module NextjsApp.Entries.Server where

import Protolude

import Affjax                                 as Affjax
import Ansi.Codes                             as Ansi
import Ansi.Output                            as Ansi
import ApiServerConfig                        as ApiServerConfig
import Control.Monad.Indexed.Qualified        as IndexedMonad
import Data.Argonaut.Core                     as ArgonautCore
import Data.Argonaut.Decode                   as ArgonautCodecs
import Data.String.Yarn                       as Yarn
import Effect.Class.Console                   as Console
import Hyper.Conn                             as Hyper
import Hyper.Middleware                       as Hyper
import Hyper.Middleware.Class                 as Hyper
import Hyper.Node.FileServer                  as Hyper.Node
import Hyper.Node.Server                      as Hyper.Node
import Hyper.Request                          as Hyper
import Hyper.Response                         as Hyper
import Hyper.Status                           as Hyper
import Hyper.Cookies                          as Hyper
import Nextjs.Page                            as Nextjs.Page
import HalogenVdomStringRendererHalogenComponent                 as HalogenVdomStringRendererHalogenComponent
import NextjsApp.Manifest.ClientPagesManifest as NextjsApp.Manifest.ClientPagesManifest
import NextjsApp.Manifest.PageManifest        as NextjsApp.Manifest.PageManifest
import NextjsApp.Manifest.ServerBuildManifest as NextjsApp.Manifest.ServerBuildManifest
import NextjsApp.Route                        as NextjsApp.Route
import NextjsApp.WebRouteDuplexCodec             as NextjsApp.WebRouteDuplexCodec
import NextjsApp.WebRouteToPageServer         as NextjsApp.WebRouteToPageServer
import NextjsApp.Router.Server                as NextjsApp.Router
import NextjsApp.Router.Shared                as NextjsApp.Router
import NextjsApp.Server.Config                as NextjsApp.Server.Config
import NextjsApp.Server.PageTemplate          as NextjsApp.Server.PageTemplate
import Node.FS.Stats                          as Node.FS.Stats
import Options.Applicative                    as Options.Applicative
import PathyExtra                             (printPathPosixSandboxAny)
import Protolude.Node                         as Protolude.Node
import Routing.Duplex                         as Routing.Duplex
import Routing.Duplex.Parser                  as Routing.Duplex
import Data.MediaType.Common                  as Data.MediaType.Common
import Data.NonEmpty as NonEmpty
import Foreign.Object as Object

data StaticOrDynamicPageData input
  = StaticOrDynamicPageData__Static input
  | StaticOrDynamicPageData__Dynamic { input :: input, encoder :: input -> ArgonautCore.Json }

renderPageToString
  :: forall input
   . { page :: Nextjs.Page.PageSpec input
     , route :: (Variant NextjsApp.Route.WebRoutesWithParamRow)
     , buildManifest :: NextjsApp.Manifest.ServerBuildManifest.BuildManifest
     , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
     , pageManifest :: NextjsApp.Manifest.PageManifest.PageManifest
     , pageData :: StaticOrDynamicPageData input
     , config :: NextjsApp.Server.Config.Config
     }
  -> String
renderPageToString
  { page
  , route
  , buildManifest
  , clientPagesManifest
  , pageManifest
  , pageData
  , config
  } =
  NextjsApp.Server.PageTemplate.pageTemplate
    { faviconsHtml: buildManifest.faviconsHtml
    , clientPagesManifest
    , currentPageManifest: pageManifest
    , pageSpecResolved:
      { title: page.title
      , component
      , pageData: pageData'
      , livereloadPort: config.livereloadPort
      }
    }
  where
  routerInput :: input -> NextjsApp.Router.ServerState
  routerInput input =
    { currentPageInfo: Just
      { route
      , pageSpecWithInputBoxed:
        Nextjs.Page.mkPageSpecWithInputBoxed
        { input
        , component: page.component
        , title: page.title
        }
      }
    }

  component :: String
  component = case pageData of
    StaticOrDynamicPageData__Static input -> HalogenVdomStringRendererHalogenComponent.renderComponent NextjsApp.Router.serverComponent (routerInput input)
    StaticOrDynamicPageData__Dynamic { input } -> HalogenVdomStringRendererHalogenComponent.renderComponent NextjsApp.Router.serverComponent (routerInput input)

  pageData' :: NextjsApp.Server.PageTemplate.StaticOrDynamicPageData
  pageData' = case pageData of
    StaticOrDynamicPageData__Static _ -> NextjsApp.Server.PageTemplate.StaticOrDynamicPageData__Static
    StaticOrDynamicPageData__Dynamic { input, encoder } -> NextjsApp.Server.PageTemplate.StaticOrDynamicPageData__Dynamic (encoder input)

respondWithRendedPage :: forall c .
  String ->
  Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) c)
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) c)
    Unit
respondWithRendedPage page = IndexedMonad.do
  Hyper.writeStatus Hyper.statusOK
  Hyper.closeHeaders
  Hyper.respond page

renderPage ::
  forall c input.
  { config :: NextjsApp.Server.Config.Config
  , buildManifest :: NextjsApp.Manifest.ServerBuildManifest.BuildManifest
  , route :: (Variant NextjsApp.Route.WebRoutesWithParamRow)
  , clientPagesManifest :: NextjsApp.Manifest.ClientPagesManifest.ClientPagesManifest
  , pageManifest :: NextjsApp.Manifest.PageManifest.PageManifest
  } ->
  Nextjs.Page.PageSpec input ->
  Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) { cookies :: Unit | c })
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) { cookies :: Unit | c })
    Unit
renderPage
  { config
  , buildManifest
  , route
  , clientPagesManifest
  , pageManifest
  }
  page =
    case page.pageData of
      Nextjs.Page.PageData__Dynamic pageData -> IndexedMonad.do
        Hyper.cookies

        conn <- Hyper.getConn

        let (sessionHeaderValue :: Maybe String) =
              case conn.components.cookies of
                  Right cookies -> Object.lookup ApiServerConfig.expressSessionMiddleware_cookieName cookies <#> NonEmpty.head
                  Left _ -> Nothing

        Hyper.putConn conn { components { cookies = unit } }

        (pageDataResponse :: Nextjs.Page.PageData_DynamicResponse input) <-
          Hyper.lift'
          $ pageData.request
          $ Nextjs.Page.PageData_DynamicRequestOptions__Server { sessionHeader: Tuple ApiServerConfig.expressSessionMiddleware_cookieName <$> sessionHeaderValue }

        case pageDataResponse of
            Nextjs.Page.PageData_DynamicResponse__Error error -> IndexedMonad.do
              Hyper.writeStatus Hyper.statusBadRequest
              Hyper.contentType Data.MediaType.Common.textPlain
              Hyper.closeHeaders
              Hyper.respond
                $ Yarn.unlines
                    [ "Error (TODO: render as html):"
                    , "  " <> error
                    ]
            Nextjs.Page.PageData_DynamicResponse__Redirect { redirectToLocation, logout } -> IndexedMonad.do
              Hyper.redirect (Routing.Duplex.print NextjsApp.WebRouteDuplexCodec.routeCodec redirectToLocation)
              if logout
                then Hyper.setCookie ApiServerConfig.expressSessionMiddleware_cookieName "" (Hyper.defaultCookieAttributes { maxAge = Hyper.maxAge 0 })
                else pure unit
              Hyper.closeHeaders
              Hyper.end
            Nextjs.Page.PageData_DynamicResponse__Success input ->
              respondWithRendedPage
              $ renderPageToString
                { page
                , route
                , buildManifest
                , clientPagesManifest
                , pageManifest
                , pageData: StaticOrDynamicPageData__Dynamic { input, encoder: pageData.codec.encoder }
                , config
                }
      Nextjs.Page.PageData__Static input ->
        respondWithRendedPage
        $ renderPageToString
          { page
          , route
          , buildManifest
          , clientPagesManifest
          , pageManifest
          , pageData: StaticOrDynamicPageData__Static input
          , config
          }

app ::
  ∀ c.
  { buildManifest :: NextjsApp.Manifest.ServerBuildManifest.BuildManifest
  , config :: NextjsApp.Server.Config.Config
  } ->
  Hyper.Middleware
    Aff
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.StatusLineOpen) { cookies :: Unit | c })
    (Hyper.Conn Hyper.Node.HttpRequest (Hyper.Node.HttpResponse Hyper.ResponseEnded) { cookies :: Unit | c })
    Unit
app { buildManifest, config } = IndexedMonad.do
  request <- Hyper.getRequestData
  case Routing.Duplex.parse NextjsApp.WebRouteDuplexCodec.routeCodec request.url of
    Left (error :: Routing.Duplex.RouteError) -> IndexedMonad.do
      Hyper.writeStatus Hyper.statusBadRequest
      Hyper.closeHeaders
      Hyper.respond $ "Cannot find route: " <> show error
    Right route -> IndexedMonad.do
      Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightYellow) $ "  PageSpecBoxed requested: " <> show route
      let
        pageManifest = NextjsApp.WebRouteToPageServer.webRouteToPageSpecBoxed route buildManifest.pages
        mergedPageManifest = NextjsApp.Manifest.PageManifest.mergePageManifests buildManifest.main pageManifest
      Nextjs.Page.unPageSpecBoxed
        ( renderPage
            { config
            , buildManifest
            , route
            , clientPagesManifest: buildManifest.pages
            , pageManifest: mergedPageManifest
            }
        )
        (NextjsApp.WebRouteToPageServer.webRouteToPageSpecBoxed route NextjsApp.WebRouteToPageServer.routeIdMapping)

main :: Effect Unit
main =
  launchAff_ do
    config <- liftEffect $ Options.Applicative.execParser NextjsApp.Server.Config.opts
    buildManifest <- liftEffect $ NextjsApp.Manifest.ServerBuildManifest.getBuildManifest config
    let
      (rootPath' :: String) = printPathPosixSandboxAny config.rootPath
    Protolude.Node.filePathExistsAndIs Node.FS.Stats.isDirectory rootPath'
      >>= if _ then
          Console.log $ Ansi.withGraphics (Ansi.foreground Ansi.BrightGreen) $ "Using static files dir: " <> rootPath'
        else
          Protolude.Node.exitWith 1 $ "Could not find static files dir: " <> rootPath'
    liftEffect
      $ Hyper.Node.runServer
          (Hyper.Node.defaultOptionsWithLogging { port = Hyper.Node.Port config.port })
          { cookies: unit }
          (app { buildManifest, config } # Hyper.Node.fileServer rootPath')
