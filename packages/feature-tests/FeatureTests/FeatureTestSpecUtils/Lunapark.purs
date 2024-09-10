module FeatureTests.FeatureTestSpecUtils.Lunapark where

import Protolude

import Control.Monad.Reader (class MonadAsk)
import Lunapark as Lunapark
import Run (Run)
import Run as Run
import Run.Except as Run
import Run.Reader as Run

throwLunaparkError :: ∀ t26 t27. MonadThrow Error t26 ⇒ Lunapark.Error → t26 t27
throwLunaparkError = \e -> throwError $ error $ "[runFeatureTest] Lunapark error: " <> Lunapark.printError e

runLunaparkImplementation
  :: forall m a
   . MonadAff m
  => Lunapark.Interpreter ()
  -> Run ( aff ∷ Run.AFF , effect ∷ Run.EFFECT , except ∷ Run.EXCEPT Lunapark.Error , lunapark ∷ Lunapark.LUNAPARK , lunaparkActions ∷ Lunapark.LUNAPARK_ACTIONS ) a
  -> m (Either Lunapark.Error a)
runLunaparkImplementation interpreter action =
  liftAff
  $ Run.runBaseAff'
  $ Run.runExcept
  $ Lunapark.runInterpreter interpreter
  $ action

runLunapark
  :: forall m r a
   . MonadAff m
  => MonadAsk { interpreter :: Lunapark.Interpreter () | r } m
  => MonadThrow Error m
  => Run ( aff ∷ Run.AFF , effect ∷ Run.EFFECT , except ∷ Run.EXCEPT Lunapark.Error , lunapark ∷ Lunapark.LUNAPARK , lunaparkActions ∷ Lunapark.LUNAPARK_ACTIONS ) a
  -> m a
runLunapark action = ask >>= \config ->
  runLunaparkImplementation config.interpreter action >>= either throwLunaparkError pure
