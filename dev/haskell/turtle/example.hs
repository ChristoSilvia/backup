#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import Turtle
            
main = do
  is_test <- testdir "test"
  case is_test of
    True -> echo "test exists"
    False -> mkdir "test"
  let cmd = "tar cvf test.tar.gz test"
  x <- shell cmd empty
  case x of
    ExitSuccess -> return ()
    ExitFailure n -> die (cmd <> " failed with exit code: " <> repr n)
