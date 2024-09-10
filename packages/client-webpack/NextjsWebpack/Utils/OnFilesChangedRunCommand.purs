module NextjsWebpack.Utils.OnFilesChangedRunCommand where

import Protolude
import Chokidar as Chokidar
import Data.Array.NonEmpty as NonEmptyArray
import Data.Time.Duration (Milliseconds(..))
import FRP.Event (Event)
import FRP.Event (subscribe) as Event
import FRP.Event.Time (debounce) as Event
import FRPEventExtra as FRPEventExtra
import Node.ChildProcess as Node.ChildProcess
import NodeChildProcessExtra (noInputOnlyOutput, withOneProcessATime)

onFilesChangedRunCommand :: { files :: Array String, command :: Array String } -> Effect (Effect Unit)
onFilesChangedRunCommand config = do
  files <- NonEmptyArray.fromArray config.files # maybe (throwError $ error "expected non empty files") pure
  command <- NonEmptyArray.fromArray config.command # maybe (throwError $ error "expected non empty command") pure
  let
    -- distinct does nothing but just in case Chokidar.watch files
    (event :: Event String) =
      Event.debounce (Milliseconds 500.0)
        $ FRPEventExtra.distinct
        $ Chokidar.watch files
  let
    command' = NonEmptyArray.uncons command
  { spawn, killIfRunning } <- withOneProcessATime
  let
    onEvent :: String -> Effect Unit
    onEvent path = do
      -- | traceM { m: "onEvent", path }
      spawn (Node.ChildProcess.spawn command'.head command'.tail (Node.ChildProcess.defaultSpawnOptions { stdio = noInputOnlyOutput }))
  stopChokidar <- Event.subscribe event onEvent
  pure do
    stopChokidar
    killIfRunning
