import numpy as np
import matplotlib.pyplot as plt

# Define the circle parameters
radius = 2 * np.sqrt(2)
center = (-2, 2)

# Generate points on the original circle
theta = np.linspace(0, 2 * np.pi, 100)
x_original = center[0] + radius * np.cos(theta)
y_original = center[1] + radius * np.sin(theta)

# Define the mapping function w = 1/z
def mapping_function(z):
    return 1 / z

# Apply the mapping to the original circle
z_original = x_original + 1j * y_original
w_mapped = mapping_function(z_original)

# Plotting
plt.figure(figsize=(8, 8))

# Plot the original circle
plt.plot(x_original, y_original, label='Original Circle')

# Plot the mapped circle
plt.plot(np.real(w_mapped), np.imag(w_mapped), label='Mapped Circle')

# Set aspect ratio to be equal
plt.axis('equal')

# Set labels and title
plt.title('Mapping w = 1/z of a Circle')
plt.xlabel('Real')
plt.ylabel('Imaginary')
plt.legend()
plt.grid(True)
plt.show()
