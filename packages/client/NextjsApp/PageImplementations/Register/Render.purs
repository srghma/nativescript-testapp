module NextjsApp.PageImplementations.Register.Render where

import NextjsApp.PageImplementations.Register.Form (formComponent)
import NextjsApp.PageImplementations.Register.Types (Action(..), ChildSlots, RegisterError(..), State)
import Protolude
import NextjsApp.PageImplementations.Register.Css as NextjsApp.PageImplementations.Register.Css

import Halogen.Hooks.Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Register.Types (Action(..), ChildSlots, RegisterError(..), State)

renderError :: Maybe RegisterError -> String
renderError = maybe ""
  case _ of
       RegisterError__RegisterFailed -> "Wrong password or email is not registered"
       RegisterError__UnknownError error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State ->
  HH.ComponentHTML Action ChildSlots m
render = \state ->
  HH.div
    [ HP.class_ NextjsApp.PageImplementations.Register.Css.styles.root ]
    [ HH.text (renderError state.registerError)
    , HH.img
      [ HP.class_ NextjsApp.PageImplementations.Register.Css.styles.logo
      , HP.alt "logo"
      , HP.src purescriptLogoSrc
      ]
    , HH.slot F._formless unit formComponent unit Action__HandleRegisterForm
    ]
