module Example.Lazy.Main (component) where

import Protolude

import Effect.Class.Console (log)
import Example.Lazy.LazyLoadedImport as Example.Lazy.LazyLoadedImport
import Halogen as H
import Halogen.HTML as HH
import Type.Proxy

type ChildSlots =
  ( lazyChild :: H.Slot (Const Void) Void Unit
  )

type State = Maybe (H.Component (Const Void) Unit Void Aff)

data Action
  = Initialize

component :: forall i . H.Component (Const Void) i Void Aff
component =
  H.mkComponent
    { initialState: const Nothing
    , render
    , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Initialize
      }
    }

-- | Example to show
-- |
-- | const ProfilePage = React.lazy(() => import('./ProfilePage')); // Lazy-loaded
-- |
-- | // Show a spinner while the profile is loading
-- | <Suspense fallback={<Spinner />}>
-- |   <ProfilePage />
-- | </Suspense>

render :: forall query. State -> H.ComponentHTML query ChildSlots Aff
render state =
  HH.div_
    [ HH.text "I'm parent"
    , case state of
           Nothing -> HH.text "LOADING"
           Just component' -> HH.slot (Proxy :: _ "lazyChild") unit component' unit absurd
    ]

handleAction :: forall o. Action -> H.HalogenM State Action ChildSlots o Aff Unit
handleAction Initialize = do
  H.liftEffect $ log "Initialize Root"
  component <- H.liftAff Example.Lazy.LazyLoadedImport.lazyLoadedImport
  H.put (Just component)
