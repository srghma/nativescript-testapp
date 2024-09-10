exports._MiniCssExtractPlugin = function(opts) {
  const MiniCssExtractPlugin = require("mini-css-extract-plugin")
  return new MiniCssExtractPlugin(opts)
}

exports._CleanWebpackPlugin = new (require("clean-webpack-plugin").CleanWebpackPlugin)()

exports._BundleAnalyzerPlugin = function (opts) { return new (require("webpack-bundle-analyzer").BundleAnalyzerPlugin)(opts) }

exports._HtmlWebpackPlugin = function (opts) { new (require("html-webpack-plugin"))(opts) }

exports.htmlWebpackPlugin__tags__toString = function (tags) {
  const r = tags.toString()

  console.log('htmlWebpackPlugin__tags__toString', r)

  if (!Array.isArray(r)) { throw new Error('not an array') }

  return r
}
