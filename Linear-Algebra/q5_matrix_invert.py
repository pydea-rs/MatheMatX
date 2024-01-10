import MyDeterminant as pya
from numpy import array

def adjacent(matrix):
    n = len(matrix)
    adj = [ [ 0.0 for j in range(n) ] for i in range(n) ]
    for i in range(n):
        for j in range(n):
            adj[i][j] = ((-1) ** (i+j)) *       \
                    pya.determinant(pya.minor(matrix, j, i))
            
    return array( adj )

if __name__ == '__main__':
    print('Enter the matrix row by row:')
    x = pya.getMatrix(2)
    detx = pya.determinant(x)
    adjx = adjacent(x)
    print('|x| = ' + str(detx))
    print('\n\nadj(x) = \n' + str(adjx))

    if( detx ) :
        invx = (1 / detx) * adjx
        print('\n\ninv(x) = \n' + str(invx))
    else:
        print('\n\nx is not Invertible')
