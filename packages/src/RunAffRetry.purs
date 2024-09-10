module RunAffRetry where

import Effect.Aff.Retry
import Protolude

import Data.Array (uncons)
import Effect.Aff (delay)
import Prim.Row (class Cons) as Row
import Run (Run, AFF)
import Run as Run
import Run.Except (EXCEPT)
import Run.Except as Run
import Unsafe.Coerce (unsafeCoerce)
import RunExtra
import RunCatchEffect

retrying
  :: ∀ b r
   . RetryPolicyM Aff
  -> (RetryStatus -> b -> Run ( aff :: AFF | r ) Boolean) -- An action to check whether the result should be retried.
                                     -- If True, we delay and retry the operation.
  -> (RetryStatus -> Run ( aff :: AFF | r ) b)            -- Action to run
  -> Run ( aff :: AFF | r ) b
retrying policy check action = go defaultRetryStatus
  where
  go status = do
    res <- action status
    ifM (check status res)
      (Run.liftAff (applyAndDelay policy status) >>= maybe (pure res) go)
      (pure res)

recovering
  :: ∀ r a e
   . RetryPolicyM Aff
  -> Array (RetryStatus -> e -> Aff Boolean)
  -> (RetryStatus -> Run ( aff :: AFF, except ∷ EXCEPT e, catch :: CATCH e | r ) a)
  -> Run ( aff :: AFF, except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
recovering policy checks f = go defaultRetryStatus
  where
    go :: RetryStatus -> Run ( aff :: AFF, except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
    go status = catch (recover checks) (f status)
      where
        recover
          :: Array (RetryStatus -> e -> Aff Boolean)
          -> e
          -> Run ( aff :: AFF, except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
        recover chks e =
          case uncons chks of
              Nothing -> Run.throw e
              Just headTail -> handle e headTail

        handle
          :: e
          -> { head :: RetryStatus -> e -> Aff Boolean, tail :: Array (RetryStatus -> e -> Aff Boolean) }
          -> Run ( aff :: AFF, except ∷ EXCEPT e, catch ∷ CATCH e | r ) a
        handle e hs =
          Run.liftAff (hs.head status e) >>=
            if _
              then Run.liftAff (applyAndDelay policy status) >>= maybe (Run.throw e) go
              else recover hs.tail e
