module NextjsApp.WebRouteToPageServer where

import Protolude
import Data.Variant
import Nextjs.Page as Nextjs.Page
import NextjsApp.Pages.Examples.Ace as NextjsApp.Pages.Examples.Ace
import NextjsApp.Pages.Examples.Basic as NextjsApp.Pages.Examples.Basic
import NextjsApp.Pages.Examples.Components as NextjsApp.Pages.Examples.Components
import NextjsApp.Pages.Examples.ComponentsInputs as NextjsApp.Pages.Examples.ComponentsInputs
import NextjsApp.Pages.Examples.ComponentsMultitype as NextjsApp.Pages.Examples.ComponentsMultitype
import NextjsApp.Pages.Examples.DeeplyNested as NextjsApp.Pages.Examples.DeeplyNested
import NextjsApp.Pages.Examples.EffectsAffAjax as NextjsApp.Pages.Examples.EffectsAffAjax
import NextjsApp.Pages.Examples.EffectsEffectRandom as NextjsApp.Pages.Examples.EffectsEffectRandom
import NextjsApp.Pages.Examples.HigherOrderComponents as NextjsApp.Pages.Examples.HigherOrderComponents
import NextjsApp.Pages.Examples.Interpret as NextjsApp.Pages.Examples.Interpret
import NextjsApp.Pages.Examples.KeyboardInput as NextjsApp.Pages.Examples.KeyboardInput
import NextjsApp.Pages.Examples.Lazy as NextjsApp.Pages.Examples.Lazy
import NextjsApp.Pages.Examples.Lifecycle as NextjsApp.Pages.Examples.Lifecycle
import NextjsApp.Pages.Examples.TextNodes as NextjsApp.Pages.Examples.TextNodes
import NextjsApp.Pages.Index as NextjsApp.Pages.Index
import NextjsApp.Pages.Login as NextjsApp.Pages.Login
import NextjsApp.Pages.Register as NextjsApp.Pages.Register
import NextjsApp.Pages.Secret as NextjsApp.Pages.Secret
import NextjsApp.Pages.VerifyUserEmailWeb as NextjsApp.Pages.VerifyUserEmailWeb
import NextjsApp.Route as NextjsApp.Route

-- XXX: you should NOT IMPORT this module from client

-- | routeIdMapping :: Record (NextjsApp.Route.WebRoutesVacantRow Nextjs.Page.PageSpecBoxed)
-- | routeIdMapping =
-- |   { route__Index:                           NextjsApp.Pages.Index.page
-- |   , route__Login:                           NextjsApp.Pages.Login.page
-- |   , route__Register:                        NextjsApp.Pages.Register.page
-- |   , route__Secret:                          NextjsApp.Pages.Secret.page
-- |   , route__VerifyUserEmailWeb:              NextjsApp.Pages.VerifyUserEmailWeb.page
-- |   , route__Examples__Ace:                   NextjsApp.Pages.Examples.Ace.page
-- |   , route__Examples__Basic:                 NextjsApp.Pages.Examples.Basic.page
-- |   , route__Examples__Components:            NextjsApp.Pages.Examples.Components.page
-- |   , route__Examples__ComponentsInputs:      NextjsApp.Pages.Examples.ComponentsInputs.page
-- |   , route__Examples__ComponentsMultitype:   NextjsApp.Pages.Examples.ComponentsMultitype.page
-- |   , route__Examples__EffectsAffAjax:        NextjsApp.Pages.Examples.EffectsAffAjax.page
-- |   , route__Examples__EffectsEffectRandom:   NextjsApp.Pages.Examples.EffectsEffectRandom.page
-- |   , route__Examples__HigherOrderComponents: NextjsApp.Pages.Examples.HigherOrderComponents.page
-- |   , route__Examples__Interpret:             NextjsApp.Pages.Examples.Interpret.page
-- |   , route__Examples__KeyboardInput:         NextjsApp.Pages.Examples.KeyboardInput.page
-- |   , route__Examples__Lifecycle:             NextjsApp.Pages.Examples.Lifecycle.page
-- |   , route__Examples__DeeplyNested:          NextjsApp.Pages.Examples.DeeplyNested.page
-- |   , route__Examples__TextNodes:             NextjsApp.Pages.Examples.TextNodes.page
-- |   , route__Examples__Lazy:                  NextjsApp.Pages.Examples.Lazy.page
-- |   }

webRouteToPageSpecBoxed :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Nextjs.Page.PageSpecBoxed
webRouteToPageSpecBoxed = match
  { route__Index:                           const NextjsApp.Pages.Index.page
  , route__Login:                           const NextjsApp.Pages.Login.page
  , route__Register:                        const NextjsApp.Pages.Register.page
  , route__Secret:                          const NextjsApp.Pages.Secret.page
  , route__VerifyUserEmailWeb:              const NextjsApp.Pages.VerifyUserEmailWeb.page
  , route__Examples__Ace:                   const NextjsApp.Pages.Examples.Ace.page
  , route__Examples__Basic:                 const NextjsApp.Pages.Examples.Basic.page
  , route__Examples__Components:            const NextjsApp.Pages.Examples.Components.page
  , route__Examples__ComponentsInputs:      const NextjsApp.Pages.Examples.ComponentsInputs.page
  , route__Examples__ComponentsMultitype:   const NextjsApp.Pages.Examples.ComponentsMultitype.page
  , route__Examples__EffectsAffAjax:        const NextjsApp.Pages.Examples.EffectsAffAjax.page
  , route__Examples__EffectsEffectRandom:   const NextjsApp.Pages.Examples.EffectsEffectRandom.page
  , route__Examples__HigherOrderComponents: const NextjsApp.Pages.Examples.HigherOrderComponents.page
  , route__Examples__Interpret:             const NextjsApp.Pages.Examples.Interpret.page
  , route__Examples__KeyboardInput:         const NextjsApp.Pages.Examples.KeyboardInput.page
  , route__Examples__Lifecycle:             const NextjsApp.Pages.Examples.Lifecycle.page
  , route__Examples__DeeplyNested:          const NextjsApp.Pages.Examples.DeeplyNested.page
  , route__Examples__TextNodes:             const NextjsApp.Pages.Examples.TextNodes.page
  , route__Examples__Lazy:                  const NextjsApp.Pages.Examples.Lazy.page
  }
