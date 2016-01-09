{-# LANGUAGE BangPatterns #-}
import System.Random
import Data.List

data Weather = Sunny | Cloudy | Rainy deriving (Eq, Show, Enum, Bounded)

nextW :: Weather -> Double -> Weather
nextW Sunny r | r < 0.8 = Sunny
nextW Sunny r | r > 0.8 = Cloudy
nextW Cloudy r | r < 0.4 = Sunny
nextW Cloudy r | r < 0.8 = Cloudy
nextW Cloudy r = Rainy
nextW Rainy r | r < 0.2 = Sunny
nextW Rainy r | r < 0.8 = Cloudy
nextW Rainy r = Rainy

weathers :: [Double] -> Weather -> [Weather]
weathers (d:ds) w0 = let w1 = nextW w0 d
                   in w1 : weathers ds w1

stepper :: (Int, Int, Int) -> Weather -> (Int, Int, Int) 
stepper (!s,!c,!r) Sunny = (s+1,c,r)
stepper (!s,!c,!r) Cloudy = (s,c+1,r)
stepper (!s,!c,!r) Rainy = (s,c,r+1)

compile :: [Weather] -> (Int, Int, Int)
compile = foldl' stepper (0,0,0)

showws :: (Int,Int,Int) -> String
showws (s, c, r) = let sum = s+c+r
                   in (show $ 100.0 * (fromIntegral s)/(fromIntegral sum) )
                   ++ "% sunny | "
                   ++ (show $ 100.0 * (fromIntegral c)/(fromIntegral sum) )
                   ++ "% cloudy | "
                   ++ (show $ 100.0 * (fromIntegral r)/(fromIntegral sum) )
                   ++ "% rainy"

main = do
  g <- getStdGen
  putStrLn . showws . compile . take 10000 $ weathers (randoms g :: [Double]) Rainy
