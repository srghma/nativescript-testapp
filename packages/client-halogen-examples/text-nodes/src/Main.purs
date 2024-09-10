module Example.TextNodes.Main (component) where

import Protolude

import Halogen as H
import Halogen.HTML as HH
import Example.TextNodes.Elem as Example.TextNodes.Elem
import Example.TextNodes.Keyed as Example.TextNodes.Keyed
import Type.Proxy

type ChildSlots =
  ( elem :: H.Slot (Const Void) Void Unit
  , keyed :: H.Slot (Const Void) Void Unit
  )

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: const unit
    , render
    , eval: H.mkEval H.defaultEval
    }

-- This test is used to check that components with empty text is not rerendered
-- How I checked this? I added trace and clicked on buttons

-- | patchText = EFn.mkEffectFn2 \state newVdom → do
-- |   let { build, node, value: value1 } = state
-- |   case newVdom of
-- | -    Grafted g →
-- | +    Grafted g → do
-- | +      traceM "rerendered"
-- |       EFn.runEffectFn2 patchText state (runGraft g) -- Before there was a Text on this place. We call patchText instead of patch to be able to remove text
-- |     Text value2
-- | -      | value1 == value2 →
-- | +      | value1 == value2 → do
-- | +          traceM "not rerendered"
-- |           pure $ mkStep $ Step node state patchText haltText
-- |       | otherwise → do
-- | +          traceM "rerendered"
-- |           let nextState = { build, node, value: value2 }
-- |           EFn.runEffectFn2 Util.setTextContent value2 node
-- |           pure $ mkStep $ Step node nextState patchText haltText
-- |     _ → do
-- | +      traceM "rerendered"
-- |       EFn.runEffectFn1 haltText state
-- |       EFn.runEffectFn1 build newVdom

-- | the result was this picture https://imgur.com/26f053D

render :: forall m query. Unit -> H.ComponentHTML query ChildSlots m
render _ =
  HH.div_
    [ HH.slot (Proxy :: _ "elem") unit Example.TextNodes.Elem.component unit absurd
    , HH.slot (Proxy :: _ "keyed") unit Example.TextNodes.Keyed.component unit absurd
    ]
