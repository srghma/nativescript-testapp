module SimpleXMLWithIndentation where

import Protolude
import Data.String.Yarn (unlines) as String
import Data.String.Common (joinWith) as String

indent :: String -> String
indent x = "  " <> x

unlinesIndent :: Array String -> String
unlinesIndent = String.unlines <<< map indent

tagStart :: String -> String
tagStart x = "<" <> x <> ">"

tagEnd :: String -> String
tagEnd x = "</" <> x <> ">"

printProp :: Tuple String String -> String
printProp (name /\ val) = name <> "=\"" <> val <> "\""

printProps :: Array (Tuple String String) -> String
printProps = String.joinWith " " <<< map printProp

tagOneline :: String -> Array (String /\ String) -> String -> String
tagOneline tagName props content = tagStart (tagName <> " " <> printProps props) <> content <> tagEnd tagName

tagMultiLine :: String -> Array (String /\ String) -> Array String -> String
tagMultiLine tagName props content = String.unlines $ [ tagStart (tagName <> " " <> printProps props), unlinesIndent content, tagEnd tagName ]
