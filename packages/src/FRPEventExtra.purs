module FRPEventExtra where

import Protolude
import FRP.Event (Event)
import FRP.Event as Event
import Effect.Ref as Ref

withPrevious :: forall a. Event a -> Event { previous :: Maybe a, current :: a }
withPrevious event =
  Event.makeEvent \push -> do
    latest <- Ref.new Nothing
    closeInner <-
      Event.subscribe event \current -> do
        previous <- Ref.read latest
        Ref.write (Just current) latest
        push { previous, current }
    pure closeInner

distinctWith :: forall a. (a -> a -> Boolean) -> Event a -> Event a
distinctWith isEq event =
  Event.filterMap
    ( \{ current, previous } -> case previous of
        Just previous' ->
          if isEq previous' current then
            Nothing
          else
            Just current
        Nothing -> Just current
    )
    (withPrevious event)

distinct :: forall a. Eq a => Event a -> Event a
distinct = distinctWith eq
