#!/usr/bin/env python

"""
Solving heat equation
u_t = a^2 u_xx
u(0,t) = 0
u(2pi,t) = 0
IC
"""

import math
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator

#grid
N = 64
h = 2*math.pi/N
x = h*np.arange(0,N)

alpha = 0.5
t = 0
dt = 0.001

v = abs(x-3)
I = complex(0,1)
k = np.array([I*y for y in range(0,N/2) + [0]  + range(-N/2+1,0)])
k2 = k**2

tmax, tplot = 5,0.1
plotgap = int(round(tplot/dt))
nplots = int(round(tmax/tplot))

data = np.zeros((nplots+1,N))
data[0,:] = v
tdata = [t]

for i in xrange(nplots):
  v_hat = np.fft.fft(v)

  for n in xrange(plotgap):
    v_hat = v_hat + dt*alpha*k2 * v_hat

  v = np.real(np.fft.ifft(v_hat))
  data[i+1,:] = v

  # real time vector
  t = t+plotgap*dt
  tdata.append(t)

xx,tt = (np.mat(A) for A in (np.meshgrid(x,tdata)))

fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_surface(xx,tt, data, rstride=1, cstride=1, cmap = cm.jet,
		linewidth=0, antialiased=False)
fig.colorbar(surf, shrink=0.5, aspect=5)
plt.xlabel('x')
plt.ylabel('t')
plt.show()



