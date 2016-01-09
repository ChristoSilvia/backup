module Ants

import Data.List

data Arrow = In | Out | None
	deriving (show, eq)

type CarryArrow = Arrow
type PrevLineArrow = Arrow
type ThisLineArrow = Arrow

possible :: CarryArrow -> PrevLineArrow -> List (ThisLineArrow, CarryArrow)
possible Out  In   = [(None, None)]
possible None In   = [(Out, None), (None, Out)]
possible In   None = [(Out, None), (None, Out)]
possible None None = [(Out, In), (In, Out)]
possible Out  None = [(In, None), (None, In)]
possible In   Out  = [(None, None)]
possible None Out  = [(In, None), (None, In)]
possible In   In   = []
possible Out  Out  = []
