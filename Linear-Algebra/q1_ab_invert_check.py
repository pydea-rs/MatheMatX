from numpy import *

a = array( [[ 1 , 4, 1], [ 1, 3, 2 ], [ -1, 2, 7 ]] )
b = array( [[ 1, 0, 1], [2, 5, 12], [ -9, 1, 1]] )
aInvert = linalg.inv( a )
bInvert = linalg.inv ( b )
print('A ^ -1 = \n' + str(aInvert) + '\n\nB ^ -1 = \n' + str(bInvert))
abInvert = linalg.inv( a @ b )
bInvert_aInvert = bInvert @ aInvert
print('\n\n(AB) ^ -1 = \n' + str(abInvert) + \
      '\n\n(B^-1)(A^-1) = \n' + str(bInvert_aInvert))
