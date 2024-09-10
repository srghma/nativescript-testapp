module RunCatchEffect where

import Effect.Aff.Retry
import Protolude
import RunExtra

import Data.Array (uncons)
import Data.Functor.Variant (FProxy(..))
import Effect.Aff (delay)
import Prim.Row (class Cons) as Row
import Run (Run, AFF)
import Run as Run
import Run.Except (EXCEPT)
import Run.Except as Run
import Run.Except as Run.Except
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data Catch e a = Catch (Maybe e → a)

derive instance functorCatch ∷ Functor (Catch e)

_catch = SProxy ∷ SProxy "catch"

type CATCH e = FProxy (Catch e)

catch
  ∷ ∀ e a r
  . (e → Run ( catch ∷ CATCH e | r ) a)
  → Run ( catch ∷ CATCH e | r ) a
  → Run ( catch ∷ CATCH e | r ) a
catch handler attempt = do
  mbErr ← Run.lift _catch $ Catch identity
  case mbErr of
    Just e → handler e
    Nothing → attempt

reverseCatch
  ∷ ∀ a e r
  . e
  → Run ( except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
  → Run ( except ∷ EXCEPT e, catch ∷ CATCH e | r ) Unit
reverseCatch defErr attempt = do
  mbErr ← Run.lift _catch $ Catch identity
  case mbErr of
    Just e → pure unit
    Nothing → Run.Except.throw defErr

runCatch
  ∷ ∀ r e a
  . Run ( except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
  → Run r (Either e a)
runCatch = loop (pure <<< Left)
  where
  split =
    Run.on _catch Right
    $ Run.on Run.Except._except
        (Left <<< Right)
        (Left <<< Left)
  loop hndl r = case Run.peel r of
    Right a →
      pure $ Right a
    Left f → case split f of
      Right (Catch cont) →
        loop (\e → loop hndl $ cont $ Just e) $ cont Nothing
      Left (Right (Run.Except.Except err)) →
        hndl err
      Left (Left others) →
        loop hndl =<< Run.send others
