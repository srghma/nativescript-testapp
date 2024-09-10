module PathyOptparse where

import Protolude
import Pathy (Abs, AnyDir, AnyFile, Dir, File, Path, Rel, parseAbsDir, parseAbsFile, parseRelDir, parseRelFile, posixParser, Parser)
import Options.Applicative (ReadM, eitherReader)
import PathyExtra (parseAnyDir, parseAnyFile)

createPosixParser :: forall a. (Parser -> String -> Maybe a) -> String -> ReadM a
createPosixParser parse name =
  eitherReader
    $ \s -> case parse posixParser s of
        Nothing -> Left $ "Can't parse as " <> name <> ": `" <> show s <> "`"
        Just a -> Right a

absDirPosixParser :: ReadM (Path Abs Dir)
absDirPosixParser = createPosixParser parseAbsDir "posix abs dir"

absFilePosixParser :: ReadM (Path Abs File)
absFilePosixParser = createPosixParser parseAbsFile "posix abs file"

relDirPosixParser :: ReadM (Path Rel Dir)
relDirPosixParser = createPosixParser parseRelDir "posix rel dir"

relFilePosixParser :: ReadM (Path Rel File)
relFilePosixParser = createPosixParser parseRelFile "posix rel file"

anyFilePosixParser :: ReadM AnyFile
anyFilePosixParser = createPosixParser parseAnyFile "posix any file"

anyDirPosixParser :: ReadM AnyDir
anyDirPosixParser = createPosixParser parseAnyDir "posix any dir"
