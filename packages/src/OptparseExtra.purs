module OptparseExtra where

import Options.Applicative
import Protolude

import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString

nonEmptyString :: ReadM NonEmptyString
nonEmptyString = eitherReader $ NonEmptyString.fromString >>> note "Expected non empty string"

nonempty :: ReadM String
nonempty = nonEmptyString <#> NonEmptyString.toString
