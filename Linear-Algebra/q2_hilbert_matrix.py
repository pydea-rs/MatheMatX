from numpy import *

def hilbert(rows, columns):
       h = zeros((rows, columns))
       for i in range(rows): # i = 0 1 2 3 ...
             for j in range (columns): # j 0 1 2 3
                   # h(i,j) = 1 / ( i+j-1)
                   h[i, j] = 1 / ( (i + 1) + (j + 1) - 1)
       return h

if __name__ == '__main__':
      a = hilbert(3, 3)
      print('Hilbert(3,3) = \n' + str(a) + '\n\n')
      b = array( [ 11, 6.5, 4.7 ] )
      x = linalg.solve(a, b)
      print( x )
