exports._run         = require("graphile-worker").run
exports._quickAddJob = require("graphile-worker").quickAddJob
exports._stop        = function(runner) { return runner.stop() }
