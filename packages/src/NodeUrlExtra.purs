module NodeUrlExtra where

import Node.URL (Query)
import Foreign.Object (Object)
import Unsafe.Coerce (unsafeCoerce)

-- | Should be one level
toQuery :: Object String -> Query
toQuery = unsafeCoerce

fromQuery :: Query -> Object String
fromQuery = unsafeCoerce
