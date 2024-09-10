const { postgraphile, makePluginHook } = require('postgraphile')
const GraphileSupporter = require('@graphile/supporter')
const { PgMutationUpsertPlugin } = require('postgraphile-upsert-plugin')

// import ExportExcelSubscriptionPlugin from './ExportExcelSubscriptionPlugin'

module.exports = function initPostgraphile(
  {
    isProd,
    databaseUrl,
    exposedSchema,
    exportGqlSchemaPath,
    exportJsonSchemaPath,
    jwtSecret,
  },
) {
  // default - extendedErrors: ['hint', 'detail', 'errcode'],
  // doing this because `extendedErrors: undefined` doesnt set extendedErrors to default
  const extendedErrors = isProd
    ? {}
    : {
        extendedErrors: [
          'severity',
          'code',
          'detail',
          'hint',
          'positon',
          'internalPosition',
          'internalQuery',
          'where',
          'schema',
          'table',
          'column',
          'dataType',
          'constraint',
          'file',
          'line',
          'routine',
        ],
      }

  return postgraphile(databaseUrl, exposedSchema, {
    // when false (default):
    // 1. `id` field on table is exposed as `id: <TYPE>` in schema
    // 2. on schema added field `nodeId: ID` - globally unique id, base64 encoded string "<TABLE_NAME>:<PRIM_KEY>"
    // when true:
    // 1. `id` field on table is exposed as `rowId: <TYPE>` in schema
    // 2. on schema added field `id: ID` - globally unique id, base64 encoded string "<TABLE_NAME>:<PRIM_KEY>"
    classicIds: true,

    watchPg: !isProd,

    // handled by allowCrossDomain method
    enableCors: false,

    // disable in prod to prevent security issues (like change smth without authorization)
    graphiql:        !isProd,
    enhanceGraphiql: !isProd,

    pgDefaultRole: 'app_anonymous',

    disableQueryLog: false,

    exportJsonSchemaPath,
    exportGqlSchemaPath,
    jwtPgTypeIdentifier: 'app_public.jwt',
    jwtSecret,

    showErrorStack: !isProd,

    // enable sbscriptions
    subscriptions:                     true, // Enable websockets in GraphiQL
    simpleSubscriptions:               true, // Add simple subscriptions support to the schema
    pluginHook:                        makePluginHook([GraphileSupporter]),
    subscriptionAuthorizationFunction: 'app_hidden.validate_subscription',

    appendPlugins: [
      PgMutationUpsertPlugin,
      // ExportExcelSubscriptionPlugin, // custom to allow per user topics
    ],

    // extendedErrors: ['hint', 'detail', 'errcode'],
    ...extendedErrors,
  })
}
