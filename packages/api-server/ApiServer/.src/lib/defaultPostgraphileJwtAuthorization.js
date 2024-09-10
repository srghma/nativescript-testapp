// This source code may reproduce and may modify the following components:
//
// Name: createPostGraphileHttpRequestHandler.ts
// Link to file: https://github.com/graphile/postgraphile/blob/master/src/postgraphile/http/createPostGraphileHttpRequestHandler.ts#L115
// Copyright: Copyright (c) 2016 Caleb Meredith, Copyright (c) 2018 Benjie Gillam
// Licence: MIT (https://github.com/graphile/postgraphile/blob/4f28fa1c99/LICENSE.md)
//
// Name: withPostGraphileContext.ts
// Link to file: https://github.com/graphile/postgraphile/blob/master/src/postgraphile/withPostGraphileContext.ts#L266-L297
// Copyright: Copyright (c) 2016 Caleb Meredith, Copyright (c) 2018 Benjie Gillam
// Licence: MIT (https://github.com/graphile/postgraphile/blob/4f28fa1c99/LICENSE.md)
//
// Name: installPostGraphile.js
// Link to file: https://github.com/graphile/examples/blob/master/server-koa2/middleware/installPostGraphile.js#L30-L35
// Copyright: Copyright (c) 2016 Caleb Meredith, Copyright (c) 2018 Benjie Gillam
// Licence: MIT (https://github.com/graphile/postgraphile/blob/4f28fa1c99/LICENSE.md)

// How to use default implementation (throw error when postgraphile throws)
// https://github.com/graphile/postgraphile/blob/master/src/postgraphile/http/createPostGraphileHttpRequestHandler.ts#L115
// https://github.com/graphile/postgraphile/blob/master/src/postgraphile/withPostGraphileContext.ts#L266-L297

// here
// https://github.com/graphile/examples/blob/master/server-koa2/middleware/installPostGraphile.js#L30-L35
// you are throwing away data from token and just use data from passport

// related to

// https://github.com/graphile/postgraphile/issues/709
// https://github.com/graphile/postgraphile/issues/635

// -----------------------

// https://www.graphile.org/postgraphile/jwk-verification/

const jwt = require('jwt-then')

module.exports = ({
  // look pgDefaultRole option here https://www.graphile.org/postgraphile/usage-library/
  pgDefaultRole,

  // look jwtSecret option here https://www.graphile.org/postgraphile/usage-library/
  jwtSecret,

  // look jwtVerifyOptions option here https://www.graphile.org/postgraphile/usage-library/
  jwtVerifyOptions = {
    // If 'audience' property is unspecified, it will default to ['postgraphile']
    audience: 'postgraphile',
  },
}) => async req => {
  if (req.headers.authorization) {
    try {
      const { authorization } = req.headers
      const token = authorization.split(' ')[1]

      const data = await jwt.verify(token, jwtSecret, jwtVerifyOptions)

      return {
        'jwt.claims.user_id': data.user_id,
        role:                 data.role,
      }
    } catch (e) {
      e.status = 401 // append a generic 401 Unauthorized header status
      throw e
    }
  }

  return {
    role: pgDefaultRole,
  }
}
