module NextjsWebpack.Utils.OneServerATimeSpawner where

import NodeChildProcessExtra (noInputOnlyOutput, withOneProcessATime)
import Pathy (Abs, Dir, File, Path, parseAbsDir, parseAbsFile, posixParser)
import PathyExtra (printPathPosixSandboxAny)
import Protolude
import Effect.Class.Console (log)
import Node.ChildProcess as Node.ChildProcess
import Data.String.Yarn as String

oneServerATimeSpawner ::
  Effect
    { spawnServer ::
      { serverFilePath :: String
      , port :: Int
      , livereloadPort :: Int
      , compiliedClientDirPath :: String
      , onSpawnFinish :: Effect Unit
      } ->
      Effect Unit
    , killServerIfRunning :: Effect Unit
    }
oneServerATimeSpawner = do
  { spawn, killIfRunning } <- withOneProcessATime
  pure
    { spawnServer:
      \config -> do
        (serverFilePath :: Path Abs File) <- parseAbsFile posixParser config.serverFilePath # maybe (throwError $ error "invalid serverFilePath") pure
        (compiliedClientDirPath :: Path Abs Dir) <- parseAbsDir posixParser config.compiliedClientDirPath # maybe (throwError $ error "invalid compiliedClientDirPath") pure
        spawn
          $ Node.ChildProcess.spawn
              "node"
              [ "--trace-deprecation"
              , printPathPosixSandboxAny serverFilePath
              , "--port"
              , show config.port
              , "--root-path"
              , printPathPosixSandboxAny compiliedClientDirPath
              , "--livereload-port"
              , show config.livereloadPort
              ]
              (Node.ChildProcess.defaultSpawnOptions { stdio = noInputOnlyOutput })
        log $ String.unlines
          $ [ "[Server] running at port " <> show config.port
            , "                    path = " <> printPathPosixSandboxAny serverFilePath
            , "                    client dir = " <> printPathPosixSandboxAny compiliedClientDirPath
            , "                    livereloadPort = " <> show config.livereloadPort
            ]

        config.onSpawnFinish
    , killServerIfRunning: killIfRunning
    }
