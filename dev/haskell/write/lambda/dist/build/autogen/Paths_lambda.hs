module Paths_lambda (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/chris/dev/haskell/write/lambda/.cabal-sandbox/bin"
libdir     = "/home/chris/dev/haskell/write/lambda/.cabal-sandbox/lib/i386-linux-ghc-7.6.3/lambda-0.1.0.0"
datadir    = "/home/chris/dev/haskell/write/lambda/.cabal-sandbox/share/i386-linux-ghc-7.6.3/lambda-0.1.0.0"
libexecdir = "/home/chris/dev/haskell/write/lambda/.cabal-sandbox/libexec"
sysconfdir = "/home/chris/dev/haskell/write/lambda/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "lambda_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "lambda_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "lambda_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lambda_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "lambda_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
