module Mjml where

import Protolude
import Effect.Uncurried
import Foreign
import Foreign.Object

data ValidationLevel
  = ValidationLevel__Strict
  | ValidationLevel__Soft
  | ValidationLevel__Skip

printValidationLevel =
  case _ of
       ValidationLevel__Strict -> "strict"
       ValidationLevel__Soft   -> "soft"
       ValidationLevel__Skip   -> "skip"

type MjmlOptionsInternal =
  { keepComments ::         Boolean
  , ignoreIncludes ::       Boolean
  , beautify ::             Boolean
  , minify ::               Boolean
  , validationLevel ::      String
  }

type MjmlOptions =
  -- | { fonts ::                Object
  { keepComments ::         Boolean
  , ignoreIncludes ::       Boolean
  , beautify ::             Boolean
  , minify ::               Boolean
  , validationLevel ::      ValidationLevel
  -- | , filePath ::             String
  -- | , preprocessors ::        Array
  -- | , juicePreserveTags ::    Boolean
  -- | , minifyOptions ::        Options
  -- | , mjmlConfigPath ::       String
  -- | , useMjmlConfigOptions :: Boolean
  }

defaultMjmlOptions :: MjmlOptions
defaultMjmlOptions =
  { keepComments:    true
  , ignoreIncludes:  false
  , beautify:        false
  , minify:          false
  , validationLevel: ValidationLevel__Soft
  }

mjmlOptionsToInternal :: MjmlOptions -> MjmlOptionsInternal
mjmlOptionsToInternal
  { keepComments
  , ignoreIncludes
  , beautify
  , minify
  , validationLevel
  } =
    { keepComments
    , ignoreIncludes
    , beautify
    , minify
    , validationLevel: printValidationLevel validationLevel
    }

type Mjml2HtmlOutput =
  { html :: String
  , json ::
    { file             :: String
    , absoluteFilePath :: String
    , line             :: Int
    , includedIn       :: Array String
    , tagName          :: String
    , children         :: Foreign
    , attributes       :: Object Foreign
    }
  , errors :: Array Foreign
  }

foreign import _mjml2html :: EffectFn2 String MjmlOptionsInternal Mjml2HtmlOutput

mjml2html :: String -> MjmlOptions -> Effect Mjml2HtmlOutput
mjml2html input mjmlOptions = runEffectFn2 _mjml2html input (mjmlOptionsToInternal mjmlOptions)
