module Webpack.Types where

import Data.String.Regex (Regex)
import Node.Path (FilePath)
import Foreign (Foreign)
import Foreign.Object (Object)

type UseElement
  = { loader :: String, options :: Foreign }

type Rule
  = { test :: Regex, use :: Array UseElement }

data SplitChunksConfig

data WebpackEntrypont

data Compilation

data Assets

data RawSource

data WebpackPluginInstance

type Configuration
  = { bail :: Boolean
    , context :: FilePath -- Path Abs Dir
    , devServer :: Foreign
    , devtool :: Foreign
    , entry :: Object (Array FilePath) -- Path Abs File
    , mode :: String
    , "module" :: { rules :: Array Rule }
    , node :: Foreign
    , optimization ::
      { minimize :: Boolean
      , emitOnErrors :: Boolean
      , nodeEnv :: Boolean
      , runtimeChunk :: Foreign
      , splitChunks :: Foreign
      }
    , output ::
      { chunkFilename :: Foreign
      , filename :: String
      , libraryTarget :: Foreign
      , path :: FilePath -- Path Abs Dir
      , publicPath :: String
      }
    , plugins :: Array WebpackPluginInstance
    , profile :: Boolean
    , resolve ::
      { extensions :: Array String
      -- | , modules :: Array String
      }
    , resolveLoader ::
      { alias :: Object Foreign
      -- | , mainFields :: Array String
      -- | , modules :: Array String
      }
    , stats :: String
    , target :: String
    , watch :: Boolean
    }
