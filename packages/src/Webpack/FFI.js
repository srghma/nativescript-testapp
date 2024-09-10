exports.webpackEntrypontName = function(entrypoint) { return entrypoint.name }

exports.webpackEntrypontGetFiles = function(entrypoint) { return entrypoint.getFiles() }

exports._rawSource = function(string) {
  return new (require('webpack-sources').RawSource)(string)
}

exports.setAsset = function(assets, name, rawSource) { assets[name] = rawSource }

exports.compilationGetEntrypoints = function(compilation) {
  // console.log('compilation', compilation.entrypoints)
  return compilation.entrypoints
}
