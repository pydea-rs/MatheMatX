import numpy as np
import scipy.integrate as integrate

# Define the function
def f(x):
    return np.cos(x) if 0 <= x <= np.pi else 0

# Define the Fourier transform of the function
def F(w):
    return integrate.quad(lambda x: f(x) * np.exp(-1j * w * x), -np.inf, np.inf)[0]

# Generate an array of w values
w = np.linspace(-25, 25, 1000)

# Apply the Fourier transform on each element of w array
y = np.vectorize(F)(w)

# Plotting
import matplotlib.pyplot as plt
plt.figure(figsize=(10,5))
plt.plot(w, [f(x) for x in w], label='f(x)')

plt.figure(figsize=(10,5))
plt.plot(w, y.real, label='Real part')
plt.plot(w, y.imag, label='Imaginary part')
plt.xlabel('w')
plt.ylabel('F(w)')
plt.title('Fourier transform of the given function')
plt.legend()
plt.grid(True)
plt.show()
