module NextjsWebpack.Entries.Dev where

import Pathy (dir, (</>))
import PathyExtra (cwd)
import Protolude
import Webpack.Types (Configuration)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import NextjsWebpack.GetClientPagesEntrypoints as NextjsWebpack.GetClientPagesEntrypoints
import NextjsWebpack.WebpackConfig.Config as NextjsWebpack.WebpackConfig.Config
import NextjsWebpack.WebpackConfig.Types (Target(..))
import Unsafe.Coerce (unsafeCoerce)
import Webpack.Compiler as Webpack.Compiler
import Webpack.GetError as Webpack.GetError
import Data.Array.NonEmpty (NonEmptyArray)
import Data.String.NonEmpty (NonEmptyString)

runWebpack ::
  { onSuccess ::
    EffectFn1
      { serverConfig :: Configuration
      , clientConfig :: Configuration
      }
      Unit
  } ->
  Effect Unit
runWebpack { onSuccess } =
  launchAff_ do
    root <- liftEffect cwd
    let
      production = false

      spagoOutput = root </> dir (Proxy :: Proxy "output")

      pagesModuleNamePrefix :: NonEmptyArray NonEmptyString
      pagesModuleNamePrefix = unsafeCoerce [ "NextjsApp", "Pages" ]

      appDir = root </> dir (Proxy :: Proxy "packages") </> dir (Proxy :: Proxy "client")
    entrypointsObject <- NextjsWebpack.GetClientPagesEntrypoints.getClientPagesEntrypoints { pagesModuleNamePrefix, appDir, spagoAbsoluteOutputDir: spagoOutput }
    let
      clientConfig =
        NextjsWebpack.WebpackConfig.Config.config
          { target: Target__Browser { entrypointsObject, favIconResponse: Nothing }
          , watch: false
          , production
          , root
          , appDir
          , bundleAnalyze: false
          , spagoOutput
          }
    let
      serverConfig =
        NextjsWebpack.WebpackConfig.Config.config
          { target: Target__Server
          , watch: false
          , production
          , root
          , appDir
          , bundleAnalyze: false
          , spagoOutput
          }
    liftEffect
      $ Webpack.Compiler.webpackCompilerRunMulti (Webpack.Compiler.webpackCompilerMulti [ clientConfig, serverConfig ]) \merror stats -> case Webpack.GetError.webpackGetErrors merror stats of
          Just errors -> throwError $ unsafeCoerce $ errors
          Nothing -> runEffectFn1 onSuccess { serverConfig, clientConfig }
