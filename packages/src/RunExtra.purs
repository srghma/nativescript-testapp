module RunExtra where

import Protolude

import Data.Array (uncons)
import Effect.Aff (delay)
import Prim.Row (class Cons) as Row
import Run (Run, AFF)
import Run as Run
import Run.Except (EXCEPT)
import Run.Except as Run
import Unsafe.Coerce (unsafeCoerce)

-- from https://github.com/purescript-webrow/webrow/blob/68144f421b6652b93bb9ceeb9ed69762286ae905/src/WebRow/PostgreSQL/PG.purs#L135
--
-- | Run.expand definition is based on `Union` constraint
-- | We want to use Row.Cons here instead
expand' ∷ ∀ l b t t_. Row.Cons l b t_ t ⇒ SProxy l → Run t_ ~> Run t
expand' _ = unsafeCoerce

