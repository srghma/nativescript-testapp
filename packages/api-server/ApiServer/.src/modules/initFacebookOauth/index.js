const jwt = require('jwt-then')
const passport = require('passport')
const FacebookTokenStrategy = require('passport-facebook-token')

// https://github.com/graphile/postgraphile/issues/635#issuecomment-346373323
// https://github.com/passport/express-4.x-facebook-example/blob/master/server.js
// https://github.com/philipbrack/express-passport-facebook-token-example/blob/master/server.js
// https://github.com/philipbrack/express-passport-facebook-token-example-client/blob/master/src/app/app.component.ts
// https://github.com/graphile/examples/blob/bb0a3a24b8/server-koa2/middleware/installPassport.js

module.exports = function initFacebookOauth(
  app,
  { rootPgPool, clientID, clientSecret, jwtSecret },
) {
  passport.use(
    new FacebookTokenStrategy(
      {
        clientID,
        clientSecret,
        passReqToCallback: true,
      },
      async (req, accessToken, refreshToken, profile, done) => {
        // TODO: logging system
        console.log(
          'FacebookTokenStrategy called',
          accessToken,
          refreshToken,
          profile,
        )

        // TODO:
        // accessToken and refreshToken allows to use facebook api from server
        // consider to store them too

        let jwtData

        try {
          const { rows } = await rootPgPool.query(
            `select * from app_private.login_or_register_oauth($1, $2, $3, $4, $5, $6)`,
            [
              'facebook', // service
              profile.id, // service identifier
              profile.emails[0].value, // email
              profile.name.familyName, // firstName
              profile.name.givenName, // lastName
              profile._json.avatar_url, // avatar
            ],
          )

          jwtData = rows[0] // eslint-disable-line prefer-destructuring
        } catch (error) {
          done(error, null)
          return
        }

        done(null, jwtData) // the jwtData object we just made gets passed to the route's controller as `req.user`
      },
    ),
  )

  app.use(passport.initialize())

  // this route exchanges facebook accessToken to jwt token
  app.get('/oauth/facebook/exchange_token', (req, res) => {
    passport.authenticate(
      'facebook-token',
      { session: false },
      async (err, jwtData, info) => {
        console.log(
          '/oauth/facebook/exchange_token called',
          err,
          jwtData,
          info,
          req.user,
        )

        if (err) {
          if (err.oauthError) {
            const oauthError = JSON.parse(err.oauthError.data)
            // 401 - Unauthorized
            res.status(401).send(oauthError.error.message)
          } else {
            // 501 - Not implemented
            res.status(501).send(err)
          }
        } else {
          // do the logic of actual end point here.

          // slightly changed variant of
          // https://github.com/graphile/graphile-engine/blob/d481ab969a9cafe0e6ef8651428ead15bab0dc8f/packages/graphile-build-pg/src/plugins/PgJWTPlugin.js#L71-L90
          const token = await jwt.sign(jwtData, jwtSecret, {
            audience:  'postgraphile',
            issuer:    'postgraphile',
            expiresIn: '1 day',
          })

          console.log(token)

          res.send({ token })
        }
      },
    )(req, res)
  })
}
