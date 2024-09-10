module ApiServer.PostgraphilePassportAuthPlugin.Utils where

import Protolude

import Data.Newtype (over)
import Database.PostgreSQL (Connection, PGError, Pool, Row4(..))
import Database.PostgreSQL as PostgreSQL
import Effect.Aff (bracket)

bracketEither ∷ ∀ a b eAcc eRes . Aff (Either eAcc a) → (a → Aff Unit) → (a → Aff (Either eRes b)) → Aff (Either eAcc (Either eRes b))
bracketEither acquire completed run =
  bracket
  acquire
  ( case _ of
         Left eAcc -> pure unit
         Right a -> completed a
  )
  ( case _ of
         Left e -> pure $ Left e
         Right a -> map Right (run a)
  )

withConnectionEither ::
  forall a e.
  Pool ->
  (Connection -> Aff (Either e a)) ->
  Aff (Either PGError (Either e a))
withConnectionEither p k = bracketEither (PostgreSQL.connect p) cleanup run
  where
  cleanup { done } = liftEffect done
  run { connection } = k connection

withConnectionExceptT ::
  forall a e.
  Pool ->
  (PGError -> e) ->
  (Connection -> ExceptT e Aff a) ->
  ExceptT e Aff a
withConnectionExceptT pool toError action =
  ExceptT $
  (map $ either (toError >>> Left) identity) $
  withConnectionEither pool (runExceptT <<< action)

mapErrorExceptT :: forall m e e' a . Functor m => (e -> e') -> ExceptT e m a -> ExceptT e' m a
mapErrorExceptT f = over ExceptT $ map (lmap f)

maybeToExceptT :: forall e m . Functor m => m (Maybe e) -> ExceptT e m Unit
maybeToExceptT = ExceptT <<< map (maybe (Right unit) Left)

