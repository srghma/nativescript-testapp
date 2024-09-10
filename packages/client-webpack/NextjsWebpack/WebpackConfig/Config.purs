module NextjsWebpack.WebpackConfig.Config where

import NextjsWebpack.WebpackConfig.Types (Target(..))
import Protolude

import ContribWebpackPlugins (_BundleAnalyzerPlugin, _CleanWebpackPlugin, _HtmlWebpackPlugin, _MiniCssExtractPlugin, htmlWebpackPlugin__tags__toString)
import Data.Array as Array
import Data.Codec.Argonaut.Common as Codec.Argonaut
import Data.Lens as Lens
import Foreign as Foreign
import Foreign.NullOrUndefined as Foreign.NullOrUndefined
import Foreign.Object as Object
import Heterogeneous.Mapping (hmap)
import HeterogeneousExtraShow as HeterogeneousExtraShow
import NextjsApp.NodeEnv as NextjsApp.NodeEnv
import NextjsApp.Route
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.Template as NextjsApp.Template
import NextjsWebpack.BuildManifestPlugin as NextjsWebpack.BuildManifestPlugin
import NextjsWebpack.IsomorphicClientPagesLoader as NextjsWebpack.IsomorphicClientPagesLoader
import NextjsWebpack.WebpackConfig.Rules as NextjsWebpack.WebpackConfig.Rules
import NextjsWebpack.WebpackConfig.SplitChunksConfig as NextjsWebpack.WebpackConfig.SplitChunksConfig
import Node.URL as Node.URL
import Pathy (Abs, Dir, File, Path, dir, file, (</>))
import PathyExtra (printPathPosixSandboxAny)
import Record as Record
import Webpack.Plugins (webpack)
import Webpack.Types (Configuration)
import ForeignObjectExtra (updateKeys)

config ::
  { target :: Target
  , watch :: Boolean
  , production :: Boolean
  , root :: Path Abs Dir
  , appDir :: Path Abs Dir
  , bundleAnalyze :: Boolean
  , spagoOutput :: Path Abs Dir
  } ->
  Configuration
config { target, watch, production, root, appDir, bundleAnalyze, spagoOutput } =
  { watch
  , target:
    case target of
      Target__Browser _ -> "web"
      Target__Server -> "node"
      Target__Mobile _ -> "web"
  , mode: if production then "production" else "development"
  -- mode: "development"
  , devServer:
    case target of
      Target__Browser _ -> Foreign.NullOrUndefined.undefined
      Target__Server -> Foreign.NullOrUndefined.undefined
      Target__Mobile _ ->
        Foreign.unsafeToForeign
          { hot: false
          }
  , output:
    { path:
      let
        outputDir = if production then dir (Proxy :: Proxy ".dist") else dir (Proxy :: Proxy ".dist-dev")
      in
        printPathPosixSandboxAny
          $ case target of
              Target__Browser _ -> root </> outputDir </> dir (Proxy :: Proxy "client")
              Target__Server -> root </> outputDir </> dir (Proxy :: Proxy "server")
              Target__Mobile _ -> root </> dir (Proxy :: Proxy "www")
    , filename:
      case target of
        Target__Browser _ -> if production then "[name]-[contenthash].js" else "[name].js"
        Target__Server -> "[name].js"
        Target__Mobile _ -> "index.js"
    , publicPath:
      case target of
        Target__Browser _ -> "/"
        Target__Server -> "/"
        Target__Mobile _ -> "./" -- from https://github.com/jantimon/html-webpack-plugin/issues/488
    , libraryTarget:
      case target of
        Target__Server -> Foreign.unsafeToForeign "commonjs2"
        Target__Browser _ -> Foreign.NullOrUndefined.undefined
        Target__Mobile _ -> Foreign.NullOrUndefined.undefined
    -- This saves chunks with the name given via `import()`
    , chunkFilename:
      case target of
        Target__Browser _ -> Foreign.unsafeToForeign $ "chunks/[name]-[contenthash].js"
        Target__Server -> Foreign.NullOrUndefined.undefined
        Target__Mobile _ -> Foreign.NullOrUndefined.undefined
    }
  , entry:
    case target of
      Target__Server ->
        Object.fromHomogeneous
          { main: Array.singleton $ printPathPosixSandboxAny $ appDir </> file (Proxy :: Proxy "server.entry.js")
          }
      Target__Browser { entrypointsObject } ->
        let
          (pages :: RouteIdMapping (Array String)) =
            flip NextjsApp.Route.mapRouteIdMappingWithKey entrypointsObject \routeId clientPagesLoaderOptions ->
              let
                (route :: Route) = Lens.review NextjsApp.Route._routeToRouteIdIso routeId

                options =
                  { absoluteCompiledPagePursPath: clientPagesLoaderOptions.absoluteCompiledPagePursPath
                  , absoluteJsDepsPath: clientPagesLoaderOptions.absoluteJsDepsPath
                  , route
                  }

                loaderPath = printPathPosixSandboxAny $ spagoOutput </> dir (Proxy :: Proxy "NextjsWebpack.IsomorphicClientPagesLoader") </> file (Proxy :: Proxy "index.js")
              in
                Array.singleton $ loaderPath <> "?" <> Node.URL.toQueryString (Codec.Argonaut.encode NextjsWebpack.IsomorphicClientPagesLoader.optionsCodec options) <> "!"

          mainPage =
            { main: Array.singleton $ printPathPosixSandboxAny $ appDir </> file (Proxy :: Proxy "client.entry.js")
            }
        in
          Object.fromHomogeneous $ Record.union pages mainPage
      Target__Mobile { entrypointsObject } ->
        let
          (absoluteJsDepsPaths :: Array (Path Abs File)) = Array.catMaybes $ map _.absoluteJsDepsPath $ Object.values $ Object.fromHomogeneous entrypointsObject

          mainPath = appDir </> file (Proxy :: Proxy "mobile.entry.js")
        in
          Object.fromHomogeneous { main: map printPathPosixSandboxAny $ absoluteJsDepsPaths <> [ mainPath ] }
  , node:
    case target of
      Target__Server ->
        Foreign.unsafeToForeign
          { __dirname: false -- possible values: false - runtime, true - during complilation, "mock" - "/"
          }
      _ -> Foreign.unsafeToForeign false
  , bail: true
  , profile: false
  , stats: "errors-only"
  , context: printPathPosixSandboxAny root
  , devtool:
    case target of
      Target__Server -> Foreign.unsafeToForeign false
      _ -> if production then Foreign.unsafeToForeign false else Foreign.unsafeToForeign "eval"
  , "module": { rules: NextjsWebpack.WebpackConfig.Rules.rules { target, spagoAbsoluteOutputDir: printPathPosixSandboxAny spagoOutput, production } }
  , resolve:
    { extensions: [ ".purs", ".js" ]
    }
  , resolveLoader:
    { alias: Object.fromHomogeneous {}
    }
  -- TODO: per page https://github.com/webpack-contrib/mini-css-extract-plugin#extracting-css-based-on-entry
  , plugins:
    Array.catMaybes
      [ Just
          $ _MiniCssExtractPlugin
              { filename:
                case target of
                  Target__Browser _ -> if production then "css/[name].[fullhash].css" else "css/[name].css"
                  Target__Server -> if production then "css/[name].[fullhash].css" else "css/[name].css"
                  Target__Mobile _ -> "index.css"
              , chunkFilename:
                case target of
                  Target__Browser _ -> if production then "css/[id].[fullhash].css" else "css/[id].css"
                  Target__Server -> if production then "css/[id].[fullhash].css" else "css/[id].css"
                  Target__Mobile _ -> "index.css"
              }
      , Just $ webpack._DefinePlugin
          $ let
              (commonEnv :: NextjsApp.NodeEnv.Env) =
                { apiUrl: "/graphql"
                , isProduction: production
                }

              commonEnv' =
                commonEnv
                # hmap HeterogeneousExtraShow.Show
                # Object.fromHomogeneous
                # updateKeys (\x -> "process.env." <> x)
                # map Foreign.unsafeToForeign
            in
              case target of
                Target__Server -> Object.union commonEnv' $ Object.fromHomogeneous
                    -- for purescript-ace on node environment: dont throw "undefined" exception, just make `var ace = false`
                    { "ace": Foreign.unsafeToForeign false
                    }
                _ -> commonEnv'
      , case target of
          Target__Server ->
            Just
              $ webpack._ProvidePlugin
                  -- on node - use "xhr2" package
                  { "XMLHttpRequest": "xhr2"
                  }
          _ -> Nothing
      , Just $ webpack._NoEmitOnErrorsPlugin
      , Just $ _CleanWebpackPlugin
      , if bundleAnalyze then
          Just $ _BundleAnalyzerPlugin { analyzerPort: 8888 }
        else
          Nothing
      , case target of
          Target__Browser { favIconResponse } -> Just $ NextjsWebpack.BuildManifestPlugin.buildManifestPlugin { favIconResponse }
          _ -> Nothing
      , case target of
          Target__Mobile _ ->
            Just
              $ _HtmlWebpackPlugin
                  { minify: false
                  , inject: false -- dont inject headTags and bodyTags after template is generated - we will do that ourselves
                  , templateContent:
                    \options ->
                      NextjsApp.Template.template
                        { title: "Purescript Nextjs"
                        , targetData: NextjsApp.Template.TargetData__Mobile
                        , headTags: htmlWebpackPlugin__tags__toString options.htmlWebpackPlugin.tags.headTags
                        , bodyTags: htmlWebpackPlugin__tags__toString options.htmlWebpackPlugin.tags.bodyTags
                        }
                  }
          _ -> Nothing
      -- from https://medium.com/@glennreyes/how-to-disable-code-splitting-in-webpack-1c0b1754a3c5
      -- disables chunks completely for mobile , disables lazy loaded files `import("./file.js")`
      , case target of
          Target__Mobile _ -> Just $ webpack.optimize._LimitChunkCountPlugin { maxChunks: 1 }
          _ -> Nothing
      ]
  , optimization:
    { emitOnErrors: false
    , splitChunks:
      case target of
        Target__Browser { entrypointsObject } ->
          Foreign.unsafeToForeign
            $ NextjsWebpack.WebpackConfig.SplitChunksConfig.splitChunksConfig
                { totalPages: Array.length $ Object.keys $ Object.fromHomogeneous entrypointsObject
                }
        _ -> Foreign.unsafeToForeign false
    , nodeEnv: false
    , runtimeChunk:
      case target of
        -- extract webpack runtime to separate module, e.g. "/runtime/webpack-xxxxx.js"
        Target__Browser _ -> Foreign.unsafeToForeign { name: "webpack" }
        _ -> Foreign.unsafeToForeign false
    , minimize:
      case target of
        Target__Browser _ -> production
        _ -> false
    -- | minimizer: production && target === "browser" ? [
    -- |   new (require("terser-webpack-plugin"))({}),
    -- |   new (require("optimize-css-assets-webpack-plugin"))({}),
    -- |   // // Minify CSS
    -- |   // new CssMinimizerPlugin({
    -- |   //   postcssOptions: {
    -- |   //     map: {
    -- |   //       // `inline: false` generates the source map in a separate file.
    -- |   //       // Otherwise, the CSS file is needlessly large.
    -- |   //       inline: false,
    -- |   //       // `annotation: false` skips appending the `sourceMappingURL`
    -- |   //       // to the end of the CSS file. Webpack already handles this.
    -- |   //       annotation: false,
    -- |   //     },
    -- |   //   },
    -- |   // }),
    }
  }
