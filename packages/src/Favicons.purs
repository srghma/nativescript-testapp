module Favicons where

import Protolude
import Data.Nullable (Nullable)
import Node.Buffer (Buffer)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

-- https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/favicons/index.d.ts
type FaviconsConfig
  = { path :: String -- Path for overriding default icons path. `String`
    , appName :: Nullable String -- Your application's name. `String`
    , appShortName :: Nullable String -- Your application's short_name. `String`. Optional. If not set, appName will be used
    , appDescription :: Nullable String -- Your application's description. `String`
    , developerName :: Nullable String -- Your (or your developer's) name. `String`
    , developerURL :: Nullable String -- Your (or your developer's) URL. `String`
    , dir :: String -- Primary text direction for name, short_name, and description
    , lang :: String -- Primary language for name and short_name
    , background :: String -- Background colour for flattened icons. `String`
    , theme_color :: String -- Theme color user for example in Android's task switcher. `String`
    , appleStatusBarStyle :: String -- Style for Apple status bar: "black-translucent", "default", "black". `String`
    , display :: String -- Preferred display mode: "fullscreen", "standalone", "minimal-ui" or "browser". `String`
    , orientation :: String -- Default orientation: "any", "natural", "portrait" or "landscape". `String`
    , scope :: String -- set of URLs that the browser considers within your app
    , start_url :: String -- Start URL when launching the application from a device. `String`
    , version :: String -- Your application's version String. `String`
    , logging :: Boolean -- Print logs to console? `boolean`
    , pixel_art :: Boolean -- Keeps pixels "sharp" when scaling up, for pixel art.  Only supported in offline mode.
    , loadManifestWithCredentials :: Boolean -- Browsers don't send cookies when fetching a manifest, enable this to fix that. `boolean`
    , icons ::
      -- Platform Options:
      -- - offset - offset in percentage
      -- - background:
      --   * false - use default
      --   * true - force use default, e.g. set background for Android icons
      --   * color - set background for the specified icons
      --   * mask - apply mask in order to create circle icon (applied by default for firefox). `boolean`
      --   * overlayGlow - apply glow effect after mask has been applied (applied by default for firefox). `boolean`
      --   * overlayShadow - apply drop shadow after mask has been applied .`boolean`
      { android :: Boolean -- Create Android homescreen icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , appleIcon :: Boolean -- Create Apple touch icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , appleStartup :: Boolean -- Create Apple startup images. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , coast :: Boolean -- Create Opera Coast icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , favicons :: Boolean -- Create regular favicons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , firefox :: Boolean -- Create Firefox OS icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , windows :: Boolean -- Create Windows 8 tile icons. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      , yandex :: Boolean -- Create Yandex browser icon. `boolean` or `{ offset, background, mask, overlayGlow, overlayShadow }` or an array of sources
      }
    }

type FavIconResponse
  = { images :: Array { name :: String, contents :: Buffer }
    , files :: Array { name :: String, contents :: Buffer }
    , html :: Array String
    }

foreign import _favicons :: Buffer -> FaviconsConfig -> EffectFnAff FavIconResponse

favicons :: Buffer -> FaviconsConfig -> Aff FavIconResponse
favicons buffer config = fromEffectFnAff (_favicons buffer config)
