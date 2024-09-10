module NextjsApp.PageImplementations.Login.Render where

import NextjsApp.PageImplementations.Login.Form (formComponent)
import NextjsApp.PageImplementations.Login.Types (Action(..), ChildSlots, LoginError(..), State)
import Protolude
import NextjsApp.PageImplementations.Login.Css as NextjsApp.PageImplementations.Login.Css

import Halogen.Hooks.Formless as F
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import NextjsApp.Blocks.PurescriptLogo (purescriptLogoSrc)
import NextjsApp.Route as NextjsApp.Route
import NextjsApp.PageImplementations.Login.Types (Action(..), ChildSlots, LoginError(..), State)

renderError :: Maybe LoginError -> String
renderError = maybe ""
  case _ of
       LoginError__LoginFailed -> "Wrong password or email is not registered"
       LoginError__UnknownError error -> "Unknown error: " <> error

render ::
  forall m r.
  MonadAsk { navigate :: Variant NextjsApp.Route.WebRoutesWithParamRow -> Effect Unit | r } m =>
  MonadEffect m =>
  MonadAff m =>
  State ->
  HH.ComponentHTML Action ChildSlots m
render = \state ->
  HH.div
    [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.root ]
    [ HH.text (renderError state.loginError)
    , HH.img
      [ HP.class_ NextjsApp.PageImplementations.Login.Css.styles.logo
      , HP.alt "logo"
      , HP.src purescriptLogoSrc
      ]
    , HH.slot F._formless unit formComponent unit Action__HandleLoginForm
    ]
