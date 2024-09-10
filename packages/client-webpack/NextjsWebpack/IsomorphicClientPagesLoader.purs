module NextjsWebpack.IsomorphicClientPagesLoader (PageWithRouteId, default, optionsCodec) where

import Control.Promise
import Data.Codec
-- | import Data.Newtype
import Effect.Uncurried
import Foreign
import LoaderUtils
import ModuleName
import Pathy
import Pathy
import Protolude
import Webpack.Loader
import Data.Argonaut.Core (Json)
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Codec.Argonaut (JsonCodec, JsonDecodeError(..))
import Data.Codec.Argonaut as Data.Codec.Argonaut
import Data.Codec as Codec
import Data.Lens as Lens
import Data.Lens.Iso as Lens
import Data.Profunctor (dimap)
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Foreign as Foreign
import NextjsApp.Route
import NextjsApp.Route as NextjsApp.Route
import Node.Buffer as Node.Buffer
import Node.Encoding as Node.Encoding
import PathyExtra
import Node.URL (Query)
import Node.URL as Node.URL
import Foreign (Foreign)
import Foreign as Foreign
import Foreign.NullOrUndefined as Foreign.NullOrUndefined
import Foreign.Object (Object)
import Foreign.Object as Object
import Unsafe.Coerce (unsafeCoerce)
import NodeUrlExtra

type PageWithRouteId routeId page =
  { routeId :: routeId
  , page :: page
  }

-- TODO: custom
type QueryDecodeError = JsonDecodeError

type QueryCodec a = BasicCodec (Either QueryDecodeError) Query a

type Options
  = { absoluteCompiledPagePursPath :: String -- e.g. ".../output/Foo/index.js"
    , absoluteJsDepsPath :: Maybe String -- e.g. ".../client/Pages/Foo.deps.js" or null
    , route :: String
    }

optionsCodec :: QueryCodec Options
optionsCodec = basicCodec (fromQuery >>> dec) (enc >>> toQuery)
  where
  lookupOrThrow name obj = Object.lookup name obj # note (AtKey name MissingValue)

  dec :: Object String -> Either JsonDecodeError Options
  dec obj = do
    (absoluteCompiledPagePursPath :: String) <- lookupOrThrow "absoluteCompiledPagePursPath" obj
    (route :: String) <- lookupOrThrow "route" obj
    pure
      { absoluteCompiledPagePursPath
      , absoluteJsDepsPath: Object.lookup "absoluteJsDepsPath" obj
      -- TODO: validate route
      , route
      }

  enc :: Options -> Object String
  enc obj =
    Object.fromFoldable
      $ Array.catMaybes
          [ Just $ "absoluteCompiledPagePursPath" /\ obj.absoluteCompiledPagePursPath
          , map (\x -> "absoluteJsDepsPath" /\ x) obj.absoluteJsDepsPath
          , Just $ "route" /\ obj.route
          ]

renderPageWithRouteId :: PageWithRouteId String String -> String
renderPageWithRouteId { routeId, page } = String.joinWith ""
  [ "{"
  , " routeId: " <> show routeId <> ","
  , " page: require(" <> show page <> ").page"
  , "}"
  ]

-- | "default" is a magic word
-- | https://github.com/webpack/loader-runner/blob/cebc687275edc688a5d8cf0d7c9a2be34c67fa4d/lib/loadLoader.js#L45
-- | https://github.com/webpack/webpack/issues/11581#issuecomment-704200033
default :: Loader
default =
  mkAsyncLoader \context buffer ->
    liftEffect do
      (query :: Query) <- getOptions context
      options <- case Codec.decode optionsCodec query of
        Left decodeError -> throwError $ error $ Data.Codec.Argonaut.printJsonDecodeError decodeError
        Right options -> pure options
      let
        source =
          String.joinWith "" <<< map (\x -> x <> ";")
            $ Array.catMaybes
                [ options.absoluteJsDepsPath <#> \absoluteJsDepsPath -> "require(" <> show absoluteJsDepsPath <> ")"
                , Just $
                    "(window.__PAGE_CACHE_BUS=window.__PAGE_CACHE_BUS||[]).push("
                    <> renderPageWithRouteId { routeId: options.route, page: options.absoluteCompiledPagePursPath }
                    <> ")"
                ]
      source' <- Node.Buffer.fromString source Node.Encoding.UTF8
      pure { source: source' }
