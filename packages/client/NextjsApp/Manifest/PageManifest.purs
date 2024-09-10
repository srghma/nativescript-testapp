module NextjsApp.Manifest.PageManifest where

import Protolude
import Data.Array as Data.Array

type PageManifest
  = { css :: Array String
    , js :: Array String
    }

mergePageManifests :: PageManifest -> PageManifest -> PageManifest
mergePageManifests a b = { css: Data.Array.nubEq (a.css <> b.css), js: Data.Array.nubEq (a.js <> b.js) }
