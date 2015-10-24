lottery 0 _ _ _ _      = 0
lottery ntickets n0 n30 n800 n1200000 = (n0 / totaltickets) * (lottery (ntickets - 1) (n0 - 1) n30 n800 n1200000)
	+ (n30 / totaltickets) * ( 30 + (lottery (ntickets - 1) n0 (n30 - 1) n800 n1200000))
	+ (n800 / totaltickets) * ( 800 + (lottery (ntickets - 1) n0 n30 (n800 - 1) n1200000))
	+ (n1200000 / totaltickets) * ( 1200000 + (lottery (ntickets -1) n0 n30 n800 (n1200000 - 1)))
	where
		totaltickets = (n0 + n30 + n800 + n1200000)
lottery ntickets n0 n30 n800 1 = (n0 / totaltickets) * (lottery (ntickets - 1) (n0 - 1) n30 n800 1)
	+ (n30 / totaltickets) * ( 30 + (lottery (ntickets - 1) n0 (n30 - 1) n800 1))
	+ (n800 / totaltickets) * ( 800 + (lottery (ntickets - 1) n0 n30 (n800 - 1) 1))
	where
		totaltickets = (n0 + n30 + n800 + 1)

main = do
	print (lottery 1 (2000000 - 4000 - 500 - 1) 4000 500 1)
	print (lottery 2 (2000000 - 4000 - 500 - 1) 4000 500 1)
	print (lottery 3 (2000000 - 4000 - 500 - 1) 4000 500 1)
	print (lottery 4 (2000000 - 4000 - 500 - 1) 4000 500 1)
	print (lottery 5 (2000000 - 4000 - 500 - 1) 4000 500 1)
