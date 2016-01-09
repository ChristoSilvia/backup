#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import Turtle
             
--         +-- A subroutine
--         |
--         |     +-- Retuns Universal Time
--         v     v
datePwd :: IO UTCTime
datePwd = do
  dir <- pwd
  result <- datefile dir
  return result

--      +-- A subroutine
--      |
--      |  +-- Returns Nothing
--      |  |
--      v  v
main :: IO ()
main = do
  time <- datePwd
  print time
