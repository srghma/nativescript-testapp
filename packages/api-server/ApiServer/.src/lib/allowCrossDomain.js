// This source code may reproduce and may modify the following components:
//
// Name: createPostGraphileHttpRequestHandler.ts
// Link to file: https://github.com/graphile/postgraphile/blob/4f28fa1c99735b11f289afce59556a68f7141acf/src/postgraphile/http/createPostGraphileHttpRequestHandler.ts#L863
// Copyright: Copyright (c) 2016 Caleb Meredith, Copyright (c) 2018 Benjie Gillam
// Licence: MIT (https://github.com/graphile/postgraphile/blob/4f28fa1c99/LICENSE.md)

// this is slightly changed variant of https://github.com/graphile/postgraphile/blob/4f28fa1c99735b11f289afce59556a68f7141acf/src/postgraphile/http/createPostGraphileHttpRequestHandler.ts#L863
// but for all routes (mainly passport routes), not only postgraphile

const allowCrossDomain = ({ corsAllowOrigin }) => (req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', corsAllowOrigin)
  res.setHeader('Access-Control-Allow-Methods', 'HEAD, GET, POST')
  res.setHeader(
    'Access-Control-Allow-Headers',
    [
      'Origin',
      'X-Requested-With',
      // Used by `express-graphql` to determine whether to expose the GraphiQL
      // interface (`text/html`) or not.
      'Accept',
      // Used by PostGraphile for auth purposes.
      'Authorization',
      // Used by GraphQL Playground and other Apollo-enabled servers
      'X-Apollo-Tracing',
      // The `Content-*` headers are used when making requests with a body,
      // like in a POST request.
      'Content-Type',
      'Content-Length',
    ].join(', '),
  )

  next()
}

module.exports = allowCrossDomain
