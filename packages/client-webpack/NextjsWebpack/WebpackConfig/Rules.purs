module NextjsWebpack.WebpackConfig.Rules where

import NextjsWebpack.WebpackConfig.Types (Target(..))
import Protolude

import Data.String.Regex.Flags (noFlags) as Regex
import Data.String.Regex.Unsafe (unsafeRegex) as Regex
import Webpack.Types (Rule)
import WebpackSpagoLoader as WebpackSpagoLoader
import Foreign.NullOrUndefined as Foreign.NullOrUndefined

foreign import scssAndImagesRules :: { production :: Boolean } -> Array Rule

rules :: { target :: Target, spagoAbsoluteOutputDir :: String, production :: Boolean } -> Array Rule
rules { target, spagoAbsoluteOutputDir, production } =
  WebpackSpagoLoader.rules { spagoAbsoluteOutputDir }
  <> scssAndImagesRules { production }
  <> case target of
          Target__Server ->
            -- for https://github.com/purescript-contrib/purescript-ace/blob/e991e47a6f63ab49274572088b978a7cda288814/src/Ace.js#L3
            [ { test: Regex.unsafeRegex "ace-builds" Regex.noFlags
              , use: [ { loader: "null-loader", options: Foreign.NullOrUndefined.undefined } ]
              }
            ]
          _ -> []
