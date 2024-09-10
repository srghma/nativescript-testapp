exports.mkExpressSessionStore = function(expressSession) {
  return function(config) {
    const PgSession = require("connect-pg-simple")(expressSession)

    return new PgSession(config)
  }
}
