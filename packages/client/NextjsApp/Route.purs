module NextjsApp.Route where

import Data.Symbol (reflectSymbol)
import Effect.Exception.Unsafe (unsafeThrow)
import Protolude
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Show.Generic (genericShow)
import Data.Lens (view) as Lens
import Data.Lens.Iso (Iso', iso) as Lens
import Data.String as String
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Foreign.Object (Object)
import Foreign.Object as Object
import Record.ExtraSrghma as Record.ExtraSrghma
import Type.Prelude (RProxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Data.Variant
import Type.Proxy (Proxy(..))

type WebRoutesVacantRow a =
  ( route__Index                           :: a
  , route__Login                           :: a
  , route__Register                        :: a
  , route__Secret                          :: a
  , route__VerifyUserEmailWeb              :: a
  , route__Examples__Ace                   :: a
  , route__Examples__Basic                 :: a
  , route__Examples__Components            :: a
  , route__Examples__ComponentsInputs      :: a
  , route__Examples__ComponentsMultitype   :: a
  , route__Examples__EffectsAffAjax        :: a
  , route__Examples__EffectsEffectRandom   :: a
  , route__Examples__HigherOrderComponents :: a
  , route__Examples__Interpret             :: a
  , route__Examples__KeyboardInput         :: a
  , route__Examples__Lifecycle             :: a
  , route__Examples__DeeplyNested          :: a
  , route__Examples__TextNodes             :: a
  , route__Examples__Lazy                  :: a
  )

-- | type WebRoutesProxiesRow =
-- |   , route__Index                           :: SProxy "route__Index"
-- |   , route__Login                           :: SProxy "route__Login"
-- |   , route__Register                        :: SProxy "route__Register"
-- |   , route__Secret                          :: SProxy "route__Secret"
-- |   , route__VerifyUserEmailWeb              :: SProxy "route__VerifyUserEmailWeb"
-- |   ( route__Examples__Ace                   :: SProxy "route__Examples__Ace"
-- |   , route__Examples__Basic                 :: SProxy "route__Examples__Basic"
-- |   , route__Examples__Components            :: SProxy "route__Examples__Components"
-- |   , route__Examples__ComponentsInputs      :: SProxy "route__Examples__ComponentsInputs"
-- |   , route__Examples__ComponentsMultitype   :: SProxy "route__Examples__ComponentsMultitype"
-- |   , route__Examples__EffectsAffAjax        :: SProxy "route__Examples__EffectsAffAjax"
-- |   , route__Examples__EffectsEffectRandom   :: SProxy "route__Examples__EffectsEffectRandom"
-- |   , route__Examples__HigherOrderComponents :: SProxy "route__Examples__HigherOrderComponents"
-- |   , route__Examples__Interpret             :: SProxy "route__Examples__Interpret"
-- |   , route__Examples__KeyboardInput         :: SProxy "route__Examples__KeyboardInput"
-- |   , route__Examples__Lifecycle             :: SProxy "route__Examples__Lifecycle"
-- |   , route__Examples__DeeplyNested          :: SProxy "route__Examples__DeeplyNested"
-- |   , route__Examples__TextNodes             :: SProxy "route__Examples__TextNodes"
-- |   , route__Examples__Lazy                  :: SProxy "route__Examples__Lazy"
-- |   )

-- | webRoutesProxies :: Record WebRoutesProxiesRow
-- | webRoutesProxies =
-- |   , route__Index:                           SProxy
-- |   , route__Login:                           SProxy
-- |   , route__Register:                        SProxy
-- |   , route__Secret:                          SProxy
-- |   , route__VerifyUserEmailWeb:              SProxy
-- |   { route__Examples__Ace:                   SProxy
-- |   , route__Examples__Basic:                 SProxy
-- |   , route__Examples__Components:            SProxy
-- |   , route__Examples__ComponentsInputs:      SProxy
-- |   , route__Examples__ComponentsMultitype:   SProxy
-- |   , route__Examples__EffectsAffAjax:        SProxy
-- |   , route__Examples__EffectsEffectRandom:   SProxy
-- |   , route__Examples__HigherOrderComponents: SProxy
-- |   , route__Examples__Interpret:             SProxy
-- |   , route__Examples__KeyboardInput:         SProxy
-- |   , route__Examples__Lifecycle:             SProxy
-- |   , route__Examples__DeeplyNested:          SProxy
-- |   , route__Examples__TextNodes:             SProxy
-- |   , route__Examples__Lazy:                  SProxy
-- |   }

-- | webRoutes :: Record (WebRoutesVacantRow (Variant WebRoutesWithParamRow))
-- | webRoutes =
-- |   , route__Index
-- |   , route__Login
-- |   , route__Register
-- |   , route__Secret
-- |   , route__VerifyUserEmailWeb
-- |   { route__Examples__Ace
-- |   , route__Examples__Basic
-- |   , route__Examples__Components
-- |   , route__Examples__ComponentsInputs
-- |   , route__Examples__ComponentsMultitype
-- |   , route__Examples__EffectsAffAjax
-- |   , route__Examples__EffectsEffectRandom
-- |   , route__Examples__HigherOrderComponents
-- |   , route__Examples__Interpret
-- |   , route__Examples__KeyboardInput
-- |   , route__Examples__Lifecycle
-- |   , route__Examples__DeeplyNested
-- |   , route__Examples__TextNodes
-- |   , route__Examples__Lazy
-- |   }

type WebRoutesWithParamRow =
  ( route__Index                           :: Unit
  , route__Login                           :: Unit
  , route__Register                        :: Unit
  , route__Secret                          :: Unit
  , route__VerifyUserEmailWeb              :: String
  , route__Examples__Ace                   :: Unit
  , route__Examples__Basic                 :: Unit
  , route__Examples__Components            :: Unit
  , route__Examples__ComponentsInputs      :: Unit
  , route__Examples__ComponentsMultitype   :: Unit
  , route__Examples__EffectsAffAjax        :: Unit
  , route__Examples__EffectsEffectRandom   :: Unit
  , route__Examples__HigherOrderComponents :: Unit
  , route__Examples__Interpret             :: Unit
  , route__Examples__KeyboardInput         :: Unit
  , route__Examples__Lifecycle             :: Unit
  , route__Examples__DeeplyNested          :: Unit
  , route__Examples__TextNodes             :: Unit
  , route__Examples__Lazy                  :: Unit
  )

webRoutesWithParamRowToString :: Variant WebRoutesWithParamRow -> String
webRoutesWithParamRowToString = match
  { route__Index:                           const "route__Index"
  , route__Login:                           const "route__Login"
  , route__Register:                        const "route__Register"
  , route__Secret:                          const "route__Secret"
  , route__VerifyUserEmailWeb:              const "route__VerifyUserEmailWeb"
  , route__Examples__Ace:                   const "route__Examples__Ace"
  , route__Examples__Basic:                 const "route__Examples__Basic"
  , route__Examples__Components:            const "route__Examples__Components"
  , route__Examples__ComponentsInputs:      const "route__Examples__ComponentsInputs"
  , route__Examples__ComponentsMultitype:   const "route__Examples__ComponentsMultitype"
  , route__Examples__EffectsAffAjax:        const "route__Examples__EffectsAffAjax"
  , route__Examples__EffectsEffectRandom:   const "route__Examples__EffectsEffectRandom"
  , route__Examples__HigherOrderComponents: const "route__Examples__HigherOrderComponents"
  , route__Examples__Interpret:             const "route__Examples__Interpret"
  , route__Examples__KeyboardInput:         const "route__Examples__KeyboardInput"
  , route__Examples__Lifecycle:             const "route__Examples__Lifecycle"
  , route__Examples__DeeplyNested:          const "route__Examples__DeeplyNested"
  , route__Examples__TextNodes:             const "route__Examples__TextNodes"
  , route__Examples__Lazy:                  const "route__Examples__Lazy"
  }

type MobileRoutesWithParamRow =
  ( route__Index                           :: Unit
  , route__Login                           :: Unit
  , route__Register                        :: Unit
  , route__Secret                          :: Unit
  , route__VerifyUserEmailMobile           :: Unit
  , route__Examples__Ace                   :: Unit
  , route__Examples__Basic                 :: Unit
  , route__Examples__Components            :: Unit
  , route__Examples__ComponentsInputs      :: Unit
  , route__Examples__ComponentsMultitype   :: Unit
  , route__Examples__EffectsAffAjax        :: Unit
  , route__Examples__EffectsEffectRandom   :: Unit
  , route__Examples__HigherOrderComponents :: Unit
  , route__Examples__Interpret             :: Unit
  , route__Examples__KeyboardInput         :: Unit
  , route__Examples__Lifecycle             :: Unit
  , route__Examples__DeeplyNested          :: Unit
  , route__Examples__TextNodes             :: Unit
  , route__Examples__Lazy                  :: Unit
  )

route__Examples__Ace :: forall v . Variant ( route__Examples__Ace :: Unit | v )
route__Examples__Ace = inj (SProxy :: SProxy "route__Examples__Ace") unit

route__Examples__Basic :: forall v . Variant ( route__Examples__Basic :: Unit | v )
route__Examples__Basic = inj (SProxy :: SProxy "route__Examples__Basic") unit

route__Examples__Components :: forall v . Variant ( route__Examples__Components :: Unit | v )
route__Examples__Components = inj (SProxy :: SProxy "route__Examples__Components") unit

route__Examples__ComponentsInputs :: forall v . Variant ( route__Examples__ComponentsInputs :: Unit | v )
route__Examples__ComponentsInputs = inj (SProxy :: SProxy "route__Examples__ComponentsInputs") unit

route__Examples__ComponentsMultitype :: forall v . Variant ( route__Examples__ComponentsMultitype :: Unit | v )
route__Examples__ComponentsMultitype = inj (SProxy :: SProxy "route__Examples__ComponentsMultitype") unit

route__Examples__EffectsAffAjax :: forall v . Variant ( route__Examples__EffectsAffAjax :: Unit | v )
route__Examples__EffectsAffAjax = inj (SProxy :: SProxy "route__Examples__EffectsAffAjax") unit

route__Examples__EffectsEffectRandom :: forall v . Variant ( route__Examples__EffectsEffectRandom :: Unit | v )
route__Examples__EffectsEffectRandom = inj (SProxy :: SProxy "route__Examples__EffectsEffectRandom") unit

route__Examples__HigherOrderComponents :: forall v . Variant ( route__Examples__HigherOrderComponents :: Unit | v )
route__Examples__HigherOrderComponents = inj (SProxy :: SProxy "route__Examples__HigherOrderComponents") unit

route__Examples__Interpret :: forall v . Variant ( route__Examples__Interpret :: Unit | v )
route__Examples__Interpret = inj (SProxy :: SProxy "route__Examples__Interpret") unit

route__Examples__KeyboardInput :: forall v . Variant ( route__Examples__KeyboardInput :: Unit | v )
route__Examples__KeyboardInput = inj (SProxy :: SProxy "route__Examples__KeyboardInput") unit

route__Examples__Lifecycle :: forall v . Variant ( route__Examples__Lifecycle :: Unit | v )
route__Examples__Lifecycle = inj (SProxy :: SProxy "route__Examples__Lifecycle") unit

route__Examples__DeeplyNested :: forall v . Variant ( route__Examples__DeeplyNested :: Unit | v )
route__Examples__DeeplyNested = inj (SProxy :: SProxy "route__Examples__DeeplyNested") unit

route__Examples__TextNodes :: forall v . Variant ( route__Examples__TextNodes :: Unit | v )
route__Examples__TextNodes = inj (SProxy :: SProxy "route__Examples__TextNodes") unit

route__Examples__Lazy :: forall v . Variant ( route__Examples__Lazy :: Unit | v )
route__Examples__Lazy = inj (SProxy :: SProxy "route__Examples__Lazy") unit

route__Index :: forall v . Variant ( route__Index :: Unit | v )
route__Index = inj (SProxy :: SProxy "route__Index") unit

route__Login :: forall v . Variant ( route__Login :: Unit | v )
route__Login = inj (SProxy :: SProxy "route__Login") unit

route__Register :: forall v . Variant ( route__Register :: Unit | v )
route__Register = inj (SProxy :: SProxy "route__Register") unit

route__Secret :: forall v . Variant ( route__Secret :: Unit | v )
route__Secret = inj (SProxy :: SProxy "route__Secret") unit

route__VerifyUserEmailWeb :: forall v . String -> Variant ( route__VerifyUserEmailWeb :: String | v )
route__VerifyUserEmailWeb = inj (SProxy :: SProxy "route__VerifyUserEmailWeb")

route__VerifyUserEmailMobile :: forall v . Variant ( route__VerifyUserEmailMobile :: Unit | v )
route__VerifyUserEmailMobile = inj (SProxy :: SProxy "route__VerifyUserEmailMobile") unit
