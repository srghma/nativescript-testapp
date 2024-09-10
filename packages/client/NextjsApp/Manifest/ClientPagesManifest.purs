module NextjsApp.Manifest.ClientPagesManifest where

import Protolude
import NextjsApp.Manifest.PageManifest as NextjsApp.Manifest.PageManifest
import NextjsApp.Route as NextjsApp.Route
import Nextjs.Utils as Nextjs.Utils
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Data.Argonaut.Decode as ArgonautCodecs
import NextjsApp.Constants as NextjsApp.Constants

type ClientPagesManifest
  = Record (NextjsApp.Route.WebRoutesVacantRow NextjsApp.Manifest.PageManifest.PageManifest)

getBuildManifest :: Aff ClientPagesManifest
getBuildManifest = do
  json <- Nextjs.Utils.findJsonFromScriptElement (Web.DOM.ParentNode.QuerySelector NextjsApp.Constants.pagesManifestId)
  Nextjs.Utils.requiredJsonDecodeResult $ ArgonautCodecs.decodeJson json
