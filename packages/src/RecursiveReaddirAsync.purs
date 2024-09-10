module RecursiveReaddirAsync where

import Protolude

import Control.Promise (Promise)
import Effect.Exception.Unsafe (unsafeThrowException)
import Effect.Uncurried (EffectFn2)
import Foreign (Foreign)
import Foreign as Foreign
import Pathy (Abs, Dir, File, Path)

-- e.g. returns
-- [
--   {
--     name: 'Basic.purs',
--     path: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages',
--     fullname: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages/Basic.purs',
--     isDirectory: false
--   },
--   {
--     name: 'Buttons',
--     path: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages',
--     fullname: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages/Buttons',
--     isDirectory: true,
--     content: [
--       {
--         name: 'Buttons.purs',
--         path: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages/Buttons',
--         fullname: '/home/srghma/projects/purescript-halogen-nextjs/client/Nextjs/Pages/Buttons/Buttons.purs',
--         isDirectory: false
--       },
--     ]
--   }
-- ]
data DirOrFile
  = DirOrFile__File (Path Abs File)
  -- | { name     :: Name File
  -- | , path     :: Path Abs Dir
  -- | { fullname :: Path Abs File
  -- | }
  | DirOrFile__Dir
    -- { name     :: Name Dir
    -- , path     :: Path Abs Dir
    { fullname :: Path Abs Dir
    , content :: Array DirOrFile
    }

recursiveTreeList :: Path Abs Dir -> { include :: Array String } -> Aff DirOrFile
recursiveTreeList = unsafeThrowException $ error "recursiveTreeList"
  -- | where
  -- | foreignToDirOrFile :: Foreign -> Foreign.F DirOrFile
  -- | foreignToDirOrFile = undefined

foreign import _recursiveTreeList :: EffectFn2 String { include :: Array String } (Promise Foreign)
