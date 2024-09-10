module NextjsWebpack.GetClientPagesEntrypoints where

-- Copy of
--
-- https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/entries.ts#L131
-- https://github.com/vercel/next.js/blob/90638c70010310ba19aa0f28847b6226fdd20339/packages/next/build/webpack-config.ts#L665-L676
--
-- More how everything should work:
--
-- https://github.com/vercel/next.js/blob/b88f20c90bf4659b8ad5cb2a27956005eac2c7e8/packages/next/build/webpack/loaders/next-client-pages-loader.ts
-- https://github.com/vercel/next.js/blob/7dbdf1d89eef004170d8f2661b4b3c299962b1f8/packages/next/client/index.js#L58
-- https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/link.tsx#L204
-- script prefetched https://github.com/vercel/next.js/blob/3036463080d7905aa22da46e63f6c50dd50adc3c/packages/next/client/page-loader.js#L36-L49
-- script added https://github.com/vercel/next.js/blob/42a328f3e44a560d45821a582beb257fdeea10af/packages/next/client/page-loader.js#L254
import ModuleName
import NextjsApp.Route
import Pathy (Abs, Dir, File, Name, Path, Rel, dir', file, file', joinName, (</>))
import Protolude
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NonEmptyString
import Node.FS.Stats as Node.FS.Stats
import Protolude.Node as Protolude.Node
import Record.Extra as Record.Extra
import Record.ExtraSrghma as Record.ExtraSrghma
import PathyExtra (printPathPosixSandboxAny)
import Data.Lens as Lens
import NextjsApp.Route as NextjsApp.Route
import Data.Newtype (wrap)

-- | moduleNameToManifestPageId :: ModuleName -> String
-- | moduleNameToManifestPageId (ModuleName m) = String.joinWith manifestPageIdSeparator (NonEmptyArray.toArray $ map NonEmptyString.toString m)
nonEmptyStringToName :: forall n. NonEmptyString -> Name n
nonEmptyStringToName = \n -> joinName { name: n, ext: Nothing }

moduleNameToName :: forall n. ModuleName -> Name n
moduleNameToName = printModuleName >>> nonEmptyStringToName

type ClientPagesLoaderOptions
  = { absoluteCompiledPagePursPath :: Path Abs File -- e.g. ".../output/Foo/index.js"
    , absoluteJsDepsPath :: Maybe (Path Abs File) -- e.g. ".../client/Pages/Foo.deps.js" or null
    }

-- | getFileModule :: Path Abs File -> Aff ModuleName
-- | getFileModule = \filePath -> do
-- |   firstLine <- Firstline.firstline filePath
-- |   let
-- |       (trimmedModuleName :: Maybe String) = (Regex.match moduleNameRegex firstLine >>= NonEmptyArray.head) <#> String.trim
-- |       (trimmedModuleName' :: Maybe (NonEmptyArray NonEmptyString)) = trimmedModuleName >>= moduleNameFromString (String.Pattern " ")
-- |   case trimmedModuleName' of
-- |        Nothing -> throwError $ error $ "cannot find module name on the first line " <> firstLine
-- |        Just moduleName -> pure (ModuleName moduleName)
-- |   where
-- |     moduleNameRegex = Regex.unsafeRegex """module (\S+)""" Regex.noFlags
-- | processTree :: Path Abs Dir -> DirOrFile -> Aff (Array (ModuleName /\ ClientPagesLoaderOptions))
-- | processTree spagoAbsoluteOutputDir =
-- |   case _ of
-- |        DirOrFile__File fullname -> do
-- |           (moduleName :: ModuleName) <- getFileModule fullname -- moduleName = e.g. Nextjs.Pages.Foo
-- |        DirOrFile__Dir { content } -> map join $ parTraverse (processTree spagoAbsoluteOutputDir) content
foldAppendDirs :: Path Abs Dir -> Array (Path Rel Dir) -> Path Abs Dir
foldAppendDirs = foldl (\acc dir -> acc </> dir)

routeToModuleName :: NonEmptyArray NonEmptyString -> Route -> ModuleName
routeToModuleName pagesModuleNamePrefix route = ModuleName (pagesModuleNamePrefix <> unwrap (Lens.view NextjsApp.Route._routeIdToRouteIdArrayIso (Lens.view NextjsApp.Route._routeToRouteIdIso route)))

-- | routeToModuleName pagesModuleNamePrefix
getClientPagesEntrypoints :: { pagesModuleNamePrefix :: NonEmptyArray NonEmptyString, appDir :: Path Abs Dir, spagoAbsoluteOutputDir :: Path Abs Dir } -> Aff (RouteIdMapping ClientPagesLoaderOptions)
getClientPagesEntrypoints { pagesModuleNamePrefix, appDir, spagoAbsoluteOutputDir } = do
  let
    (pagesToOptionsRec :: RouteIdMapping (Aff ClientPagesLoaderOptions)) =
      flip Record.Extra.mapRecord NextjsApp.Route.routeIdToRouteMapping
        ( \route -> do
            let
              moduleName = routeToModuleName pagesModuleNamePrefix route
            let
              (absoluteCompiledPagePursPath :: Path Abs File) = spagoAbsoluteOutputDir </> dir' (moduleNameToName moduleName) </> file (Proxy :: Proxy "index.js") -- e.g. ".../output/Foo/index.js"
            -- | unlessM (Protolude.Node.filePathExistsAndIs Node.FS.Stats.isFile (printPathPosixSandboxAny absoluteCompiledPagePursPath)) $ do
            -- |   throwError $ error $ "spago output file doesn't exist: " <> printPathPosixSandboxAny absoluteCompiledPagePursPath
            let
              (absoluteJsDepsPath :: Path Abs File) =
                let
                  ({ init, last } :: { init :: Array NonEmptyString, last :: NonEmptyString }) = NonEmptyArray.unsnoc (unwrap moduleName)

                  (disToFile :: Array (Path Rel Dir)) = map (nonEmptyStringToName >>> dir') init
                in
                  (foldAppendDirs appDir disToFile) </> (file' $ joinName { name: last, ext: Just (NonEmptyString.nes (Proxy :: Proxy "deps.js")) })
            (absoluteJsDepsPathExists :: Boolean) <- Protolude.Node.filePathExistsAndIs Node.FS.Stats.isFile (printPathPosixSandboxAny absoluteJsDepsPath)
            pure
              { absoluteCompiledPagePursPath
              , absoluteJsDepsPath:
                if absoluteJsDepsPathExists then
                  Just absoluteJsDepsPath
                else
                  Nothing
              }
        )
  Record.ExtraSrghma.parSequenceRecord pagesToOptionsRec
