// TODO: abs?
const spagoDhall = './spago-client.dhall'

const spagoOptions = {
  output:    require('webpack-spago-loader/lib/getAbsoluteOutputDirFromSpago')(spagoDhall),
  pursFiles: require('webpack-spago-loader/lib/getSourcesFromSpago')(spagoDhall),

  compiler: 'psa',
  // note that warnings are shown only when file is recompiled, delete output folder to show all warnings
  compilerOptions: {
    censorCodes: [
      'ImplicitQualifiedImport',
      'UnusedImport',
      'ImplicitImport',
    ].join(','),
    // strict: true
  }
}

const cleanupCssModulesGenerator = require(spagoOptions.output + '/NextjsWebpack.Utils.OnFilesChangedRunCommand/index.js').onFilesChangedRunCommand({
  files: ['packages/client/**/*.scss'],
  command: [ 'generate-halogen-css-modules', '-d', './packages/client' ],
})()

const { spawnServer, killServerIfRunning } = require(spagoOptions.output + '/NextjsWebpack.Utils.OneServerATimeSpawner/index.js').oneServerATimeSpawner()

const livereloadPort = 35729

;(async function() {
  ///////////////////////////////////

  const reloadApp = require('express')()

  const reloadReturned = await require('reload')(reloadApp)

  require('http').createServer(reloadApp).listen(livereloadPort, function () {
    console.log('[livereload] Listening on %s ...', livereloadPort)
  })

  ///////////////////////////////////

  require('webpack-spago-loader/watcher-job')({
    // additionalWatchGlobs: ['packages/client/**/*.scss', 'src/**/*.scss'],
    additionalWatchGlobs: [],
    options: spagoOptions,
    onStart: () => {},
    onError: () => {},
    onSuccess: async () => {
      killServerIfRunning()

      // clear cache
      console.log('clearing resolve.cache')

      console.time('require.cache')
      for (const cachePath in require.cache) {
        if (cachePath.startsWith(spagoOptions.output)) {
          delete require.cache[cachePath]
        }
      }
      console.timeEnd('require.cache')

      console.time('webpack build')
      require(spagoOptions.output + '/NextjsWebpack.Entries.Dev/index.js').runWebpack({
        onSuccess: function({ serverConfig, clientConfig }) {
          console.timeEnd('webpack build')
          // hardcoded, dont know how to find (serverConfig.output.filename doesn't help)
          const serverFilePath = require('path').resolve(serverConfig.output.path, 'main.js')

          spawnServer({
            serverFilePath,
            port:                   3001,
            compiliedClientDirPath: clientConfig.output.path,
            livereloadPort,
            onSpawnFinish: function() {
              console.log('[livereload] sending refresh')

              reloadReturned.reload()
            },
          })()
        }
      })()
    }
  })

  process.on('beforeExit', function() {
    console.log('cleaning up server and chokidar')
    cleanupCssModulesGenerator()
    killServerIfRunning()
  })
})()
