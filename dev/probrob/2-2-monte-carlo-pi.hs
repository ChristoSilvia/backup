{-# LANGUAGE BangPatterns #-}
import System.Random
import Data.List


-- Number of samples to take
count = 10000

-- Function to keep a running total of the ones in the circle.
sumInCircle :: (Int,Int) -> (Double, Double) -> (Int, Int)
sumInCircle (!ins, !total) (x, y) | x*x + y*y < 1.0 = (ins + 1, total + 1)
sumInCircle (!ins, !total) _ = (ins, total + 1)

-- Function to process our random sequences
process :: [(Double, Double)] -> (Int, Int)
process = foldl' sumInCircle (0,0)

-- Function to display the running value
display :: (Int, Int) -> String
display (ins, count) = "Pi = "
                    ++ (show $ 4.0 * (fromIntegral ins) / (fromIntegral count))

-- Function to prepare the random sequence for processing
prep :: [Double] -> [(Double,Double)]
prep (a:b:rs) = (a,b):(prep rs)

main = do
  g <- newStdGen
  putStrLn . display . process . take count . prep $ randoms g
