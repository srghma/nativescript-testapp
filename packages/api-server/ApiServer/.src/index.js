const express = require('express')
const pg = require('pg')

const initFacebookOauth = require('./modules/initFacebookOauth')
const initPostgraphile = require('./modules/initPostgraphile')

const allowCrossDomain = require('./lib/allowCrossDomain')

const app = express()

const isProd = process.env.NODE_ENV === 'production'

const rootPgPool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
})

function requiredEnvVar(envName) {
  const value = process.env[envName]
  if (!value) { throw new Error(`cannot find process.env.${envName}`) }
  return value
}

if (process.env.CORS_ALLOW_ORIGIN) {
  if (isProd) {
    // don't use it in prod because it's costly option, use nginx in prod
    console.warn(
      `warning: CORS_ALLOW_ORIGIN=${process.env.CORS_ALLOW_ORIGIN} enabled in production!!! it's costly option, better use nginx`,
    )
  }

  app.use(
    allowCrossDomain({
      corsAllowOrigin: process.env.CORS_ALLOW_ORIGIN,
    }),
  )
}

if (process.env.FACEBOOK_APP_ID || process.env.FACEBOOK_APP_SECRET) {
  initFacebookOauth(app, {
    rootPgPool,
    clientID:     requiredEnvVar('FACEBOOK_APP_ID'),
    clientSecret: requiredEnvVar('FACEBOOK_APP_SECRET'),
    jwtSecret:    requiredEnvVar('JWT_SECRET'),
  })
} else {
  console.warn(
    "warning: Facebook oauth disabled because credentials wasn't found",
  )
}

app.use(
  initPostgraphile({
    isProd,
    databaseUrl:          requiredEnvVar('DATABASE_URL'),
    exposedSchema:        requiredEnvVar('EXPOSED_SCHEMA'),
    exportGqlSchemaPath:  requiredEnvVar('EXPORT_GQL_SCHEMA'),
    exportJsonSchemaPath: requiredEnvVar('EXPORT_JSON_SCHEMA'),
    jwtSecret:            requiredEnvVar('JWT_SECRET'),
  })
)

const server = app.listen(requiredEnvVar('PORT'), requiredEnvVar('HOST'), err => {
  if (err) throw err

  console.log(
    'info: Express server started on %s:%s, mode - %s',
    server.address().address,
    server.address().port,
    app.settings.env,
  )
})
