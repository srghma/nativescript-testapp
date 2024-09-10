module ForeignObjectExtra where

import Protolude
import Foreign.Object (Object)
import Foreign.Object as Object

updateKeys :: forall a . (String -> String) -> Object a -> Object a
updateKeys f o =
  (Object.toUnfoldable o :: Array (Tuple String a))
  # map (\(Tuple k v) -> Tuple (f k) v)
  # Object.fromFoldable
