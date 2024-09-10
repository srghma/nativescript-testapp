module ContribWebpackPlugins where

import Webpack.Types (WebpackPluginInstance)

foreign import _MiniCssExtractPlugin :: forall options. { | options } -> WebpackPluginInstance

foreign import _CleanWebpackPlugin :: WebpackPluginInstance

foreign import _BundleAnalyzerPlugin :: forall options. { | options } -> WebpackPluginInstance

foreign import _HtmlWebpackPlugin :: forall options. { | options } -> WebpackPluginInstance

data HtmlWebpackPlugin__Tags

foreign import htmlWebpackPlugin__tags__toString :: HtmlWebpackPlugin__Tags -> Array String
