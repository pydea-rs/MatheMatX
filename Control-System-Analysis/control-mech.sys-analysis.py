import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt
import math

# Define system parameters
M1 = 1
M2 = 1
k1 = 1
k2 = 6

D1 = 0.5
D2 = 0.1

f = lambda t: math.sin(t)

# Define model equations
def model(y, t):
    x1, dx1, x2, dx2 = y
    dydt = [
        dx1,
        (-(k1+k2)*x1 - (D1+D2)*dx1 - k1*x2 - D1*dx2)/M2,
        dx2,
        (k1*x1 + D1*dx1 - k1*x2 - D1*dx2 - f(t))/M1
    ]
    return dydt

# Initial conditions
initial_conditions = [0, 0, 0, 0]

# Time points
t = np.linspace(0, 20, 1000)

# Solve the ODEs
solution = odeint(model, initial_conditions, t)

# Plot the results
plt.figure()
plt.plot(t, solution[:, 0], 'r', label='x1')
plt.plot(t, solution[:, 1], 'b', label='dx1')
plt.plot(t, solution[:, 2], 'g', label='x2')
plt.plot(t, solution[:, 3], 'm', label='dx2')
plt.legend()
plt.xlabel('Time')
plt.ylabel('State')
plt.title('System Response to Step Input')
plt.show()

# Plot the pole-zero map
A = np.array([ [0, 1, 0, 0],
    [-(k1+k2)/M2, -(D1+D2)/M2, - k1/M2, -D1/M2],
    [0, 0, 0, 1],
    [k1/M1, D1/M1, -k1/M1, -D1/M1]])

eigenvalues, _ = np.linalg.eig(A)

plt.figure()
plt.scatter(np.real(eigenvalues), np.imag(eigenvalues), marker='x', color='red')
plt.axhline(0, color='black', linewidth=0.5)
plt.axvline(0, color='black', linewidth=0.5)
plt.xlabel('Real Part')
plt.ylabel('Imaginary Part')
plt.title('Pole-Zero Map')
plt.show()
