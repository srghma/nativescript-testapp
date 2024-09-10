exports._passportStrategyGithub = function(options, verify) {
  return new (require('passport-github').Strategy)(
    Object.assign({ passReqToCallback: true }, options),
    verify
  )
}
