module NextjsWebpack.WebpackConfig.Types where

import Protolude
import Favicons (FavIconResponse)
import NextjsApp.Route
import NextjsWebpack.GetClientPagesEntrypoints (ClientPagesLoaderOptions)

-- https://github.com/zeit/next.js/blob/450d4bd0f32a042fd452c81bc3850ec31306eab3/packages/next/next-server/lib/constants.ts#L35
data Target
  = Target__Browser { entrypointsObject :: RouteIdMapping ClientPagesLoaderOptions, favIconResponse :: Maybe FavIconResponse }
  | Target__Server
  | Target__Mobile { entrypointsObject :: RouteIdMapping ClientPagesLoaderOptions }

