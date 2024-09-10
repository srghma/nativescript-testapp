// from https://github.com/graphile/bootstrap-react-apollo/blob/master/server/middleware/installClientServerProxy.js

const httpProxy = require("http-proxy")

exports._installFrontendServerProxy = function installFrontendServer(httpServer, app, targetUrl) {
  const proxy = httpProxy.createProxyServer({
    target: targetUrl,
    ws: true,
  })

  proxy.on('error', e => {
    console.error("Proxy error occurred:", e)
  })

  app.use((req, res, _next) => {
    proxy.web(req, res, {}, e => {
      console.error(e)

      res.statusCode = 503

      res.end("Error occurred while proxying to client application - is it running? " + e.message)
    })
  })

  // DONT PROXY WEBSOCKET ON DEV TO CLIENT SSR SERVER
  // because Postgraphile of this api server will handle it
  // httpServer.on("upgrade", (req, socket, head) => {
  //   proxy.ws(req, socket, head)
  // })
}
