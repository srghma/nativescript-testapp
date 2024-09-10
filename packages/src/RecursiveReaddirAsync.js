const rra = require('recursive-readdir-async')

exports._recursiveTreeList = function(pagesDir, options) {
  return rra.list(
    pagesDir,
    {
      mode: rra.TREE,
      recursive: true,
      include: options.include,
    }
  )
}
