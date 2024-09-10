require("@babel/register")({
  presets: ['@babel/preset-env'],
  plugins: ['@babel/plugin-transform-runtime']
})

const createConfig = require('./config').default

module.exports = async function(env) {
  if(!env) { throw new Error('env should be specified explicitly, but got ' + env) }

  const production = env.mode === 'production'

  await require('webpack-spago-loader/build-job')(require('./lib/spago-options'))

  const config = await createConfig({ production, target: 'mobile' })

  // console.log(config)

  return config
}
