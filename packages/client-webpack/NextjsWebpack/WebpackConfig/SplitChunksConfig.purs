module NextjsWebpack.WebpackConfig.SplitChunksConfig where

import Protolude
import Data.String.Regex (Regex)
import Data.String.Regex.Flags (noFlags) as Regex
import Data.String.Regex.Unsafe (unsafeRegex) as Regex

-- from https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L346
-- this is default config from webpack site
splitChunksConfig ::
  { totalPages :: Int } ->
  { cacheGroups ::
    { commons ::
      { minChunks :: Int
      , name :: String
      , priority :: Int
      }
    , default ::
      { minChunks :: Int
      , priority :: Int
      , reuseExistingChunk :: Boolean
      }
    , defaultVendors ::
      { priority :: Int
      , test :: Regex
      }
    , styles ::
      { chunks :: String
      , enforce :: Boolean
      , minChunks :: Int
      , name :: String
      , reuseExistingChunk :: Boolean
      , test :: Regex
      }
    }
  , chunks :: String
  }
splitChunksConfig { totalPages } =
  { chunks: "all"
  , cacheGroups:
    -- only output is added
    { defaultVendors:
      { test: Regex.unsafeRegex """[\\/](node_modules|output)[\\/]""" Regex.noFlags
      , priority: -10
      }
    -- TODO: empty chunks https://github.com/webpack/webpack/issues/7300
    , "default":
      { minChunks: 2
      , priority: -20
      , reuseExistingChunk: true
      }
    , styles:
      { name: "styles"
      , test: Regex.unsafeRegex """\.s?css$""" Regex.noFlags
      , chunks: "all"
      , minChunks: 2
      , enforce: true
      , reuseExistingChunk: true
      }
    , commons:
      { name: "commons"
      , minChunks: totalPages
      , priority: 20
      }
    }
  }
