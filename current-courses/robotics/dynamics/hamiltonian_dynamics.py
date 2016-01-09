from scipy.integrate import odeint
from numpy.linalg import solve

from baxter_pykdl import baxter_kinematics
from baxter_interface import Limb

limb_name = 'left'
eps = 1e-6

Baxter_Limb = Limb(limb_name)
Limb_Kinematics = baxter_kinematics(limb_name)

def make_joint_dict(q):
	

def Get_K(q):
	return Limb.intertia(

def Grad_K(K_center, q):

def Grad_V(q):

def f(x):
	q = x[0:d]
	p = x[(d+1):2*d]

	K = Get_K(q)
	q_dot = solve(K, p)
	p_dot = -(0.5 * np.dot(q_dot.T, np.dot(Grad_K(K, q), q_dot)) + Grad_V(q))

	return np.array([q_dot, p_dot])
	
#
d = 7

# evaluation times
t_max = 3.0
n = 1000
time = np.linspace(0, t_max, n)

# initial conditions
q_init = np.array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
p_init = np.array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])

x_init = np.array([q_init, p_init])

odeintf(f, x_init, times)

