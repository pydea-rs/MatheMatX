import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import cv2

# read in grayscale
img = cv2.imread('test.jpg', 0)

# svd
u, s, v = np.linalg.svd(img)

#inspect shape of the matrices
print(u.shape, s.shape, v.shape)

# plot images with different number of components

comps = [ 638, 500, 400, 300, 200, 100 ]
plt.figure(figsize = (16,8))

for i in range(6):
    lowRank = u[:, :comps[i]] @ np.diag(s[:comps[i]]) @ v[:comps[i], :]
    plt.subplot(2, 3, i+1),\
        plt.imshow(lowRank, cmap = 'gray'),\
        plt.axis('off'),\
        plt.title("Original image with n_components = " + str(comps[i]) ) \
        if i == 0 else plt.title("n_components = " + str(comps[i]))
plt.show()
