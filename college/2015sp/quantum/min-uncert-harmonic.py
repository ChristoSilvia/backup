
# coding: utf-8

# In[54]:

import numpy as np
from scipy.misc import factorial
import matplotlib.pyplot as plt


# In[47]:

def hermite_coeffs(n):
    coeffs = np.zeros(n+1)
    
    coeffs[n] = 2**n
    for i in range(n-2,-1,-1):
        coeffs[i] = -0.5*(i+2)*(i+1)/(n-i)*coeffs[i+2]
        
    return coeffs


# In[50]:

len(hermite_coeffs(56))


# In[59]:

def psi(n):
    def psi_n(xi):
      hermite_sum = 0.0
      hermite_coeff_list = hermite_coeffs(n)
      for i in range(0,n+1):
        hermite_sum += hermite_coeff_list[i]*xi**i
      return hermite_sum*np.exp(-xi**2/2.0)/np.sqrt(2**n*factorial(n))
    return np.vectorize(psi_n)
        


# In[87]:

p = psi(1)
X = np.linspace(-10,10,200,dtype=np.complex)


def min_uncert(X,alpha):
  minimum = np.zeros(200,dtype=np.complex)
  for n in range(0,20):
    minimum += np.exp(-np.abs(alpha)**2/2)*alpha**n/np.sqrt(factorial(n))*psi(n)(X)
  return minimum


for i in range(0,100):
  plt.clf()
  plt.axis([-10,10,-0.1,1.1])
  plt.plot(X,0.1*X**2, color='b')
  plt.plot(X,np.abs(min_uncert(X,2.0*np.exp(complex(0,1)*2*np.pi*i/100.0))),color='r', linewidth=5)
  plt.savefig("min-uncert2/wave%03d.png" % i)

# In[ ]:



