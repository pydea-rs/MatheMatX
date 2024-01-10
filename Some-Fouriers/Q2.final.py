import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import quad

# Define the function f
f = lambda x: (-1)**(int(x)) if x >= 0 else (-1) ** int(x-1)
L = 1

# Compute Fourier series coefficients
def integrate(f, a, b):
    result, _ = quad(f, a, b)
    return result

def fourier_series_coefficients(f, n_terms=1000):
    a_n = []
    b_n = []
    c_n = []
    for n in range(0, n_terms):
        a = (1 / L) * integrate(lambda x: f(x) * np.cos(n * x), -L, L)
        b = (1 / L) * integrate(lambda x: f(x) * np.sin(n * x * np.pi / L), -L, L)

        a_n.append(a)
        b_n.append(b)
        c_n.append(complex(a, b) / 2)

    return a_n, b_n, c_n

# Generate Fourier series
def fourier_series(x, a_n, b_n):
    series_sum = 0.5 * a_n[0]

    for n in range(1, len(a_n)):
        series_sum += a_n[n] * np.cos(n * x * np.pi / L) + b_n[n] * np.sin(n * x * np.pi / L)

    return series_sum

# Plotting
x_values = np.linspace(-5, 5, 100)
plt.figure(figsize=(20,10))
for i, terms in enumerate([10, 50, 100], start=1):
    a_n, b_n, c_n = fourier_series_coefficients(f, n_terms=terms)
    print(f"Exponential Fourier Series Coefficients for N={terms}: ", c_n, end="\n\n")
    y_values = [fourier_series(x, a_n, b_n) for x in x_values]

    plt.subplot(130 + i), plt.plot(x_values, list(map(f, x_values))), plt.plot(x_values, y_values, label='Fourier series'), plt.title(f'Fourier Series | N = {terms}')
    plt.xlabel('x')
    plt.ylabel('f(x)')
    plt.legend(['Actual f', 'Fourier f'])
plt.show()
