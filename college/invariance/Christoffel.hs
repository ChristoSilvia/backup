import Data.Monoid

class Ring a where
  plus :: a -> a -> a
  times :: a -> a -> a
  neg :: a -> a
  zero :: a
  one :: a
infixr plus 6
infixr times 7

class Differentiable a where
  d :: a -> a

class Symbolic a where
  eval :: a -> Double -> Double

--             (coefficient) (sin power) (cos power)
data Trig = Trig [(Double, Int, Int)]
	
instance Show Trig where
  show (Trig []) = ""
  show (Trig ((1.0,1,0):[])) = "sin(x)"
  show (Trig ((1.0,0,1):[])) = "cos(x)"
  show (Trig ((1.0,n,0):[])) = "sin^" ++ (show n) ++ "(x) "
  show (Trig ((1.0,0,m):[])) = "cos^" ++ (show m) ++ "(x) "
  show (Trig ((1.0,n,m):[])) = "sin^" ++ (show n) ++ "(x)*cos^" ++ (show m) ++ "(x)"
  show (Trig ((c,n,m):[])) = (show c) ++ "*" ++ (show (Trig ((1.0,n,m):[])))
  show (Trig (a:as))       = (show (Trig (a:[]))) ++ " + " ++ (show (Trig as))

instance Ring Trig where
  one = (Trig (1.0,0,0):[])
  zero = (Trig (0.0,0,0):[])
  (Trig as) plus (Trig bs) = Trig (as ++ bs)
  (Trig ((c,n,m):[]) times (Trig bs) = Trig (map (\(c1,n1,m1) -> (c*c1,n+n1,m+m1)) bs)
  (Trig (a:as)) times (Trig bs) = ((Trig (a:[])) times (Trig bs)) plus ((Trig as) times (Trig bs))
  neg (Trig (c,n,m):as) = (Trig ((-c),n,m)) plus (neg (Trig as))



instance Monoid Trig where
  mempty = Trig []
  mappend (Trig as) (Trig bs) = Trig (as ++ bs)

instance Symbolic Trig where
  eval (Trig []) = \x -> 0
  eval (Trig ((k,0,0):as)) = \x -> k + ((eval (Trig as)) x)
  eval (Trig ((c,sin_exp,cos_exp):as)) = \x -> c*((sin x)^sin_exp)*((cos x)^cos_exp) + ((eval (Trig as)) x)

instance Differentiable Trig where
  d (Trig []) = mempty
  d (Trig ((c,0,0):as)) = (Trig [(0.0,0,0)]) <> (d (Trig as))
  d (Trig ((c,1,0):as)) = (Trig [(c,0,1)]) <> (d (Trig as))
  d (Trig ((c,0,1):as)) = (Trig [((-1.0)*c,1,0)]) <> (d (Trig as))
  d (Trig ((c,n,0):as)) = (Trig [(((fromIntegral n)*c,n-1,1))])  <> (d (Trig as))
  d (Trig ((c,0,m):as)) = (Trig [((fromIntegral (-m))*c,1,m-1)]) <> (d (Trig as))
  d (Trig ((c,n,m):as)) = (Trig [((fromIntegral n)*c,n-1,m+1)]) <> (Trig [((fromIntegral (-m))*c,n+1,m-1)]) <> (d (Trig as))
