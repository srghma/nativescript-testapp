# how webpack-spago-loader is being used

on build (client and server) - the `webpack-spago-loader/build-job` one-off task is being used
on dev (client and server) - the `webpack-spago-loader/watcher-job` watcher is being used

-- on build and dev for mobile - the plugin is used because we run webpack through cordova and there is no way to check is it one time
