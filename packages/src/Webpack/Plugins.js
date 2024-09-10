const webpack = require("webpack")

exports.webpack = {
  _DefinePlugin: function(opts) {
    return new webpack.DefinePlugin(opts)
  },
  _ProvidePlugin: function(opts) {
    return new webpack.ProvidePlugin(opts)
  },
  _NoEmitOnErrorsPlugin: new webpack.NoEmitOnErrorsPlugin(),
  optimize: {
    _LimitChunkCountPlugin: function(opts) { return new webpack.optimize.LimitChunkCountPlugin(opts) }
  }
}
