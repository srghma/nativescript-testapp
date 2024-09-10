module SimpleLookupEnv where

import Prelude
import Data.Maybe (maybe)
import Data.Int as Data.Int
import Effect.Exception (throw)
import Node.Process (lookupEnv)
import Effect (Effect)

lookupEnvValue :: String -> Effect String
lookupEnvValue name = lookupEnv name >>= maybe (throw $ "Missing environment variable " <> name) pure

lookupEnvValueInt :: String -> Effect Int
lookupEnvValueInt name = lookupEnvValue name >>= (\string -> (pure $ Data.Int.fromString string) >>= maybe (throw $ "Invalid " <> name <> ": expected valid integer but got " <> string) pure)
