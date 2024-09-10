exports.lazyLoadedImport = function() {
  // or can use require.ensure
  var x = import(
    './LazyLoaded.purs'
  )
  console.log(x)
  return x
}
