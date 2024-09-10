module GraphileWorker where

import Control.Promise
import Data.Exists
import Data.Function.Uncurried
import Data.JSDate
import Data.Nullable
import Database.PostgreSQL
import Effect.Uncurried
import Protolude

import Control.Promise as Promise
import Data.Argonaut.Core (Json)
import Foreign (Foreign)
import Foreign.Object (Object)
import Foreign.Object as Object
import Type.Row.Homogeneous (class Homogeneous)
import Unsafe.Coerce (unsafeCoerce)

data GraphileWorkerRunner

type Logger =
  { error :: EffectFn1 String Unit
  , warn  :: EffectFn1 String Unit
  , info  :: EffectFn1 String Unit
  , debug :: EffectFn1 String Unit
  }

type Job =
  { id              :: String
  , queue_name      :: Nullable String
  , task_identifier :: String
  , payload         :: Foreign
  , priority        :: Number
  , run_at          :: JSDate
  , attempts        :: Number
  , max_attempts    :: Number
  , last_error      :: Nullable String
  , created_at      :: JSDate
  , updated_at      :: JSDate
  , key             :: Nullable String
  , revision        :: Number
  , locked_at       :: Nullable JSDate
  , locked_by       :: Nullable String
  , flags           :: Nullable (Object Boolean)
  }

type TaskSpec =
  { queueName :: Nullable String
  , runAt :: Nullable JSDate
  , priority :: Nullable Number
  , maxAttempts :: Nullable Number
  , jobKey :: Nullable String
  , flags :: Nullable (Array String)
  }

type AddJobFunction = EffectFn3 String (Nullable Foreign) (Nullable TaskSpec) (Promise Job)

type WithPgClientImplementation a = EffectFn1 (EffectFn1 Connection (Promise a)) (Promise a)

data WithPgClient

type JobHelpers =
  { logger :: Logger
  , withPgClient :: WithPgClient
  , addJob :: AddJobFunction
  , job :: Job
  }

runWithPgClient :: forall a .
  WithPgClient ->
  (Connection -> Aff a) ->
  Aff a
runWithPgClient withPgClientBoxed f = Promise.toAffE $ runEffectFn1 withPgClient $ mkEffectFn1 \connection -> Promise.fromAff $ f connection
  where
  withPgClient :: WithPgClientImplementation a
  withPgClient = unsafeCoerce withPgClientBoxed

foreign import _run ::
  EffectFn1
  { pgPool :: Pool
  , taskList :: Object (EffectFn2 Json JobHelpers (Promise Unit))
  -- | , concurrency :: Int -- default 1
  -- | , noHandleSignals :: Boolean -- false
  -- | , pollInterval :: Int -- 2000
  }
  (Promise GraphileWorkerRunner)

foreign import _stop :: EffectFn1 GraphileWorkerRunner (Promise Unit)

stop :: GraphileWorkerRunner -> Aff Unit
stop = Promise.toAffE <<< runEffectFn1 _stop

run :: forall taskListRow .
  Homogeneous taskListRow (Json -> JobHelpers -> Aff Unit) =>
  { pgPool :: Pool
  , taskList :: Record taskListRow
  -- | , concurrency :: Int
  -- | , noHandleSignals :: Boolean
  -- | , pollInterval :: Int
  }
  -> Aff GraphileWorkerRunner
run
  { pgPool
  , taskList
  -- | , concurrency
  -- | , noHandleSignals
  -- | , pollInterval
  } = Promise.toAffE
      $ runEffectFn1 _run
        { pgPool
        , taskList: map ((\f json config -> Promise.fromAff $ f json config) >>> mkEffectFn2) $ Object.fromHomogeneous taskList
        -- | , concurrency
        -- | , noHandleSignals
        -- | , pollInterval
        }


foreign import _quickAddJob ::
  EffectFn3
  { pgPool :: Pool
  }
  String
  Json
  (Promise Unit)
