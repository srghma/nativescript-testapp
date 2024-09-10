module NextjsWebpack.FaviconsConfig where

import Data.Nullable as Nullable
import Favicons (FaviconsConfig)

faviconsConfig :: Boolean -> FaviconsConfig
faviconsConfig isProd =
  { path: "/"
  , appName: Nullable.notNull "Nextjs example app"
  , appShortName: Nullable.notNull "Nextjs"
  , appDescription: Nullable.notNull "Example application for the best framework"
  , developerName: Nullable.null
  , developerURL: Nullable.null
  , dir: "auto"
  , lang: "en-US"
  , background: "#fff"
  , theme_color: "#fff"
  , appleStatusBarStyle: "black-translucent"
  , display: "standalone"
  , orientation: "any"
  , scope: "/"
  , start_url: "/"
  , version: "1.0"
  , logging: false
  , pixel_art: false
  , loadManifestWithCredentials: false
  , icons:
    { android: isProd
    , appleIcon: false
    , appleStartup: false
    , coast: false
    , favicons: isProd
    , firefox: isProd
    , windows: false
    , yandex: false
    }
  }
