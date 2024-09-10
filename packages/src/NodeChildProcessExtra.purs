module NodeChildProcessExtra where

import Protolude
import Data.Posix.Signal as Data.Posix.Signal
import Effect.Ref as Ref
import Node.ChildProcess (StdIOBehaviour(..), ChildProcess)
import Node.ChildProcess as Node.ChildProcess
import Node.Process as Node.Process
import Node.Stream (Stream, Write)
import Unsafe.Coerce (unsafeCoerce)

forget :: forall r. Stream ( write :: Write ) -> Stream r
forget = unsafeCoerce

noInputOnlyOutput :: Array (Maybe StdIOBehaviour)
noInputOnlyOutput = [ Just Ignore, Just (ShareStream (forget Node.Process.stdout)), Just (ShareStream (forget Node.Process.stderr)) ]

withOneProcessATime :: Effect ({ spawn :: Effect ChildProcess -> Effect Unit, killIfRunning :: Effect Unit })
withOneProcessATime = do
  latest <- Ref.new Nothing
  let
    killIfRunning =
      Ref.read latest
        >>= maybe (pure unit) \process -> do
            -- | traceM { process }
            Node.ChildProcess.kill Data.Posix.Signal.SIGKILL process
  let
    spawn runProcess = do
      killIfRunning
      childProcess <- runProcess
      Ref.write (Just childProcess) latest
      pure unit
  pure
    { spawn
    -- kill zombies
    , killIfRunning
    }
