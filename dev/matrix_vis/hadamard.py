import numpy as np
import matplotlib.pyplot as plt
import re

def hinton(matrix, max_weight=None, ax=None):
  ax = ax if ax is not None else plt.gca()

  if not max_weight:
    max_weight = 2**np.ceil(np.log(np.abs(matrix).max())/np.log(2))
  
  ax.patch.set_facecolor('gray')
  ax.set_aspect('equal','box')
  ax.xaxis.set_major_locator(plt.NullLocator())
  ax.yaxis.set_major_locator(plt.NullLocator())

  for (x,y),w in np.ndenumerate(matrix):
    color = 'white' if w>0 else 'black'
    size = 1
    rect = plt.Rectangle([x-size/2, y-size/2], size, size,
                         facecolor=color, edgecolor=color)
    ax.add_patch(rect)
    print (x,y)

  ax.autoscale_view()
  ax.invert_yaxis()

if __name__ == '__main__':
  hadamard = np.loadtxt('H428.txt')
  hinton(hadamard)
  plt.savefig("hadamard.png")
