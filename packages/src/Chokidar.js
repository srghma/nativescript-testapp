exports._watch = function({ files, onAll }) {
  const watcher = require('chokidar').watch(files)

  watcher.on('all', function(event, path) {
    onAll(path)
  })

  return function() {
    watcher.close()
  }
}
