#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

def dft_slow(x):
  x = np.asarray(x, dtype=float)
  N = x.shape[0]
  n = np.arange(N)
  k = n.reshape((N,1))
  M = np.exp(-2j * np.pi * k * n / N)
  return np.dot(M,x)

def FFT(x):
  x = np.asarray(x, dtype=float)
  N = x.shape[0]

  if N%2 > 0:
    raise ValueError("size of x must be a power of 2")
  elif N <= 32:
    return dft_slow(x)
  else:
    X_even = FFT(x[::2])
    X_odd  = FFT(x[1::2])
    factor = np.exp(-2j * np.pi * np.arange(N)/ N)
    return np.concatenate([X_even + factor[:N / 2] * X_odd,
                           X_even + factor[N / 2:] * X_odd])

def coefficients(domain):
  return [ 2.0 / ( n * np.pi) * (-1)**(n+1) for n in domain ]

def heat(x,t):
  return np.sum([ a_n * np.exp( -1 * (np.pi * (n+1))**2 * t) * np.sin((n+1) * np.pi * x)  for n, a_n in enumerate(coefficients(xrange(1,20))) ] )

X = np.linspace(0,1,100)

for big_t in xrange(0,200):
  t = 0.001 * big_t  
  U = [ heat(x,t) for x in X ]
  plt.axis([-0.1,1.1,-0.2,1.2])
  plt.plot(X,U)
  plt.savefig("{0}-hfp.png".format(big_t))
  plt.clf()
