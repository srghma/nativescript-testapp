module PathyExtra where

import Protolude
import Node.Process as Node.Process
import Pathy (class IsDirOrFile, class IsRelOrAbs, Abs, AnyDir, AnyFile, Dir, Parser, Path, parseAbsDir, parsePath, posixParser, posixPrinter, printPath, sandboxAny)
import Data.String as String

mkDirAbsoluteIfNotAlready :: String -> String
mkDirAbsoluteIfNotAlready string = case String.stripSuffix (String.Pattern "/") string of
  Just _ -> string
  Nothing -> string <> "/"

cwd :: Effect (Path Abs Dir)
cwd =
  Node.Process.cwd
    >>= \(d :: String) ->
        let
          validD = mkDirAbsoluteIfNotAlready d
        in
          case parseAbsDir posixParser validD of
            Just d' -> pure d'
            Nothing -> throwError $ error $ validD <> "is cwd, but not absolute"

printPathPosixSandboxAny :: ∀ a b. IsRelOrAbs a ⇒ IsDirOrFile b ⇒ Path a b → String
printPathPosixSandboxAny = printPath posixPrinter <<< sandboxAny

parseAnyFile :: Parser -> String -> Maybe AnyFile
parseAnyFile p = parsePath p (const Nothing) (const Nothing) (Just <<< Right) (Just <<< Left) Nothing

parseAnyDir :: Parser -> String -> Maybe AnyDir
parseAnyDir p = parsePath p (Just <<< Right) (Just <<< Left) (const Nothing) (const Nothing) Nothing
