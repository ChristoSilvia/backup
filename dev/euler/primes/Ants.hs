module Ants where

import Data.List
import Control.Monad
import Control.Applicative

data Arrow = In | Out | None
  deriving (Show, Eq)

type CarryArrow = Arrow
type PrevLineArrow = Arrow
type ThisLineArrow = Arrow

type Row = [Arrow]
type PrevRow = [PrevLineArrow]
type ThisRow = [ThisLineArrow]

computeNewRows :: PrevRow -> ThisRow -> CarryArrow -> Maybe [ ThisRow ]
computeNewRows (p:pr) [] carry = Just <$> (map fst (possible carry p))

computeCarry :: PrevRow -> ThisRow -> Maybe Arrow
computeCarry prevrow row = foldM (\car (prevr, thisrow) -> mirror <$> (carry prevr thisrow car)) None (zip prevrow row)

possible :: CarryArrow -> PrevLineArrow -> [ (ThisLineArrow, CarryArrow) ]
possible Out  In   = [(None, None)]
possible None In   = [(Out, None), (None, Out)]
possible In   None = [(Out, None), (None, Out)]
possible None None = [(Out, In), (In, Out)]
possible Out  None = [(In, None), (None, In)]
possible In   Out  = [(None, None)]
possible None Out  = [(In, None), (None, In)]
possible In   In   = []
possible Out  Out  = []

carry :: PrevLineArrow -> ThisLineArrow -> CarryArrow -> Maybe Arrow
carry In   In   In   = Nothing
carry In   In   None = Nothing
carry In   In   Out  = Nothing
carry In   Out  In   = Nothing
carry In   Out  None = Just None
carry In   Out  Out  = Nothing
carry In   None In   = Nothing
carry In   None None = Just Out
carry In   None Out  = Just None
carry Out  In   In   = Nothing
carry Out  In   Out  = Nothing
carry Out  In   None = Just None
carry Out  Out  In   = Nothing
carry Out  Out  Out  = Nothing
carry Out  Out  None = Nothing
carry Out  None In   = Just None
carry Out  None Out  = Nothing
carry Out  None None = Just In
carry None In   In   = Nothing
carry None In   Out  = Just None
carry None In   None = Just Out
carry None Out  In   = Just None
carry None Out  Out  = Nothing
carry None Out  None = Just In
carry None None In   = Just Out
carry None None Out  = Just In
carry None None None = Nothing

mirror :: Arrow -> Arrow
mirror None = None
mirror Out  = In
mirror In   = Out
