import numpy as np
import sympy as sm
resistances = input('Enter R1 R2 R3 respectively:\t').split()
r1, r2, r3 = [ float(x) for x in resistances]
v1, v2 = sm.symbols('v1 v2'.split())
R = np.array([[r1,r2, 0], [r1, 0 , r3], [ -1, 1, 1]])
print(R)
V = np.array([v1, -v2, 0])
I = sm.matrices.Matrix(R).inv() @ V
strTags = ['\nI1 = ', '\nI2 = ', '\nI3 = ']

for i in range(3):
    print(strTags[i] + str(I[i]))
