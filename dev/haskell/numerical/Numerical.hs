module Numerical where

polyval :: Fractional a => [a] -> a -> a
polyval coeffs x = foldr (\b c -> b + x*c) 0 coeffs

polyderv :: Fractional a => [a] -> [a]
polyderv coeffs = zipWith (*) (map fromIntegral [1..n]) (tail coeffs)
	where
		n = (length coeffs) - 1

rk4Step :: ((Double, Double) -> Double) -> Double -> (Double,Double) -> (Double, Double)
rk4Step f h (x, y) = (xnext, ynext)
	where
		k1 = f (x, y)
		k2 = f (x+h/2, y+h/2*k1)
		k3 = f (x+h/2, y+h/2*k2)
		k4 = f (x+h, y+h*k3)

		xnext = x + h
		ynext = y + h/6*(k1 + 2*k2 + 2*k3 + k4)
	
rk4 :: ((Double, Double) -> Double) -> Double -> Double -> Double -> Double -> [(Double, Double)]
rk4 f x0 xf y0 h = xypairs
	where
		iterator = iterate $ rk4Step f h
		xypairs = takeWhile (\(x,y) -> x <= xf) $ iterator (x0, y0)

