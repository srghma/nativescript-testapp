exports._webpack = require('webpack')

exports._webpackCompilerRun = function(compiler, handler) {
  compiler.run(handler)
}
