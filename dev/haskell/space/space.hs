{-# LANGUAGE InstanceSigs #-}

import System.Random
import Data.List

data PointTree a = Nil | Branch a (PointTree a) (PointTree a) (PointTree a) (PointTree a)
  deriving (Eq)

instance (Show a) => Show (PointTree a) where
  show :: PointTree a -> String
  show ptree = shower ptree 0
    where
      shower :: (Show a) => PointTree a -> Int -> String
      shower Nil n = take (2*n) $ repeat ' '
      shower (Branch a Nil Nil Nil Nil) n = (take (2*n) $ repeat ' ') ++ (show a)
      shower (Branch a top right bottom left) n = (take (2*n) $ repeat ' ') ++ (show a) ++ "\n" ++ (shower top (n+1))
                                                                                    ++ "\n" ++ (shower right (n+1))
										    ++ "\n" ++ (shower bottom (n+1))
									            ++ "\n" ++ (shower left (n+1))

mean :: (RealFrac n) => [n] -> n
mean list = (sum list) / (fromIntegral (length list))

makeTree :: (RealFrac b) => [ (b,b) ] -> PointTree (b,b)
makeTree [] = Nil
makeTree (p:[]) = Branch p Nil Nil Nil Nil
makeTree points = let (xs, ys) = unzip points
		      meanx = mean xs
		      meany = mean ys
		  in Branch (meanx, meany) (makeTree [ (x,y) | (x,y) <- points, x >= meanx, y >= meany ])
		                           (makeTree [ (x,y) | (x,y) <- points, x >= meanx, y < meany ])
					   (makeTree [ (x,y) | (x,y) <- points, x < meanx, y < meany ])
					   (makeTree [ (x,y) | (x,y) <- points, x < meanx, y >= meany ])


closestPoint :: (RealFrac b) => PointTree (b,b) -> (b,b) -> (b,b)
closestPoint Nil _ = error "nope"
closestPoint (Branch p Nil Nil Nil Nil) _ = p
closestPoint (Branch (meanx, meany) top right bottom left) (x,y) = case x > meanx of
	    							      True -> case y > meany of 
				                                               True -> (if top /= Nil then closestPoint top (x,y) else (meanx, meany))
									       False -> (if right /= Nil then closestPoint right (x,y) else (meanx, meany))
								      False -> case y > meany of
			                                                       True -> (if left /= Nil then closestPoint left (x,y) else (meanx, meany))
									       False -> (if bottom /= Nil then closestPoint bottom (x,y) else (meanx, meany))

main :: IO ()
main = do
  g <- getStdGen
  let rlist = take 100 (randoms g :: [Double])
  let ourTree =  makeTree (zip (take 50 rlist) (drop 50 rlist))
  print ourTree
  print (0.1, 0.1)
  print $ closestPoint ourTree (0.1, 0.1) 
