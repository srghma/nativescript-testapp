// https://github.com/vercel/next.js/blob/497cac4b93de9ecf6c7ed79bd6557dcd3bb51be5/packages/next/build/webpack/plugins/build-manifest-plugin.ts#L243-L255
// https://github.com/webpack/webpack/issues/11425

const webpack = require('webpack')

exports.mkNextJsBuildManifest = function(doWork) {
  class NextJsBuildManifest {
    apply(compiler) {
      compiler.hooks.make.tap('NextJsBuildManifest', (compilation) => {
        compilation.hooks.processAssets.tap(
          {
            name: 'NextJsBuildManifest',
            stage: webpack.Compilation.PROCESS_ASSETS_STAGE_ADDITIONS,
          },
          (assets) => {
            doWork(compilation, assets)
          }
        )
      })
    }
  }

  return new NextJsBuildManifest()
}
