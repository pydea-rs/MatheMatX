import numpy as np
import matplotlib.pyplot as plt

def initialize_potential(N, V0):
    V = np.zeros((N, N))
    V[0, :] = V0  # Top edge
    V[-1, :] = V0  # Bottom edge
    V[:, 0] = 0  # Left edge
    V[:, -1] = 0  # Right edge
    return V

def apply_boundary_conditions(V, Y, c, d, V0):
    left_edge_indices = (Y >= c) & (Y <= d)

    for i in range(V.shape[0]):
        if left_edge_indices[i, 0]:
            V[i, 0] = V0  # Left edge inside the rectangle
        if left_edge_indices[i, -1]:
            V[i, -1] = V0  # Right edge inside the rectangle
            
def calculate_max_error(V_new, V_old):
    return np.max(np.abs(V_new - V_old))

def solve_laplace_equation(V, Y, c, d, omega, epsilon):
    N = V.shape[0]
    error = 1  # Initial error

    while error > epsilon:
        V_old = V.copy()

        for i in range(1, N-1):
            for j in range(1, N-1):
                if (Y[i, j] >= c) and (Y[i, j] <= d):
                    continue
                V[i, j] = (1 + omega) * 0.25 * (V[i+1, j] + V[i-1, j] + V[i, j+1] + V[i, j-1]) - omega * V[i, j]

        error = calculate_max_error(V, V_old)

    return V

def plot_potential_distribution(X, Y, V):
    plt.figure(figsize=(8, 6))
    plt.contourf(X, Y, V, cmap='plasma')
    plt.colorbar()
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('Potential distribution')
    plt.show()

def main():
    V0 = 100
    params = {'a': 10, 'b': 2, 'c': 0.5, 'd': 1.5, 'V0': 100}
    for field in params:
        params[field] = float(input(f'Enter {field}: [default: {params[field]}] ') or params[field])
        
    print('Solving the case for:', ", ".join([f'{field}={params[field]}' for field in params]))

    N = 100
    x = np.linspace(0, params['a'], N)
    y = np.linspace(0, params ['b'], N)
    X, Y = np.meshgrid(x, y)

    V = initialize_potential(N, params['V0'])
    apply_boundary_conditions(V, Y, params['c'], params['d'], params['V0'])

    omega = 0.9
    epsilon = 1e-5

    V = solve_laplace_equation(V, Y, params['c'], params['d'], omega, epsilon)

    plot_potential_distribution(X, Y, V)

if __name__ == "__main__":
    main()
