// TODO:
// wait for https://github.com/erikd/language-javascript/issues/119
// and remove LazyLoadedImportImplementation file which exists only to hack compilation error "unexpected keyword `import`"
//
// when we import like this - the `import` keyword from `LazyLoadedImportImplementation.js` is not parsed by purescript, but rather linked to THIS foreign import file using webpack-spago-loader
//
//
// so, it imports like this:
// - LazyLoadedImport.purs (wrapper)
// -> LazyLoadedImport.js (this is where the `import` should be)
// -> ./LazyLoadedImportImplementation.js (hack)
// -> LazyLoaded.purs (the page definition)
exports.lazyLoadedImport_ = require('./LazyLoadedImportImplementation.js').lazyLoadedImport
