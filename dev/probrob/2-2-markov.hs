import System.Random

type Rand a = StdGen -> (a, StdGen)

getPRNG = do
  rng <- newStdGen
  let x = usePRNG rng
  print x

usePRNG :: StdGen -> [[Int]]
usePRNG rng = let (x, rng') = randomInts 5 rng
                  (y, _) = randomInts 10 rng'
              in [x, y]

randomInts :: Int -> Rand [Int]
randomInts 0 rng = ([], rng)
randomInts n rng = let (x, rng') = next rng
                       (xs, rng'') = randomInts (n-1) rng'
                   in (x:xs, rng'')

getNRandoms :: Int -> IO ()
getNRandoms n = do
  g <- getStdGen
  print $ take n (randomRs ('a', 'z') g)
