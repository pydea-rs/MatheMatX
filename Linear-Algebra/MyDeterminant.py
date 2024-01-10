from numpy import array
from numpy import transpose

def minor(arr, i, j):
    lst = list(arr)
    #delete row i
    del lst[i]
    lst = list( transpose(lst) )
    # delete column j
    del lst[j]
    Mij = transpose(lst)
    return Mij


def determinant(arr):
    n = len(arr)
    if n != len(arr[0]):
        return None # the matrix is not square

    if n == 1:
        return float(arr[0])

    det = 0
    negativity = 1
    for j in range(n):
        
        if( arr[0, j] ): # if the element is not zero; zero doesnt need calculation

            #expanding through first row
            M0j = minor(arr, 0, j)
            det += negativity * arr[0, j] * determinant(M0j)

        negativity *= -1

    return det


def adjacent(matrix):
    n = len(matrix)
    adj = [ [ 0 for j in range(n) ] for i in range(n) ]
    for i in range(n):
        for j in range(n):
            adj[i][j] = ( (-1) ** (i+j) ) * pya.determinant( pya.minor(matrix, j, i) )
            
    return array( adj )


def getMatrix(n):
    ur_matrix = []
    # the matrix must be entered row by row spliited by tab or space
    for i in range(n):
        elements = input('').split()
        row = []
        for element in elements:
            row.append(float(element))
        ur_matrix.append(row)

    return array(ur_matrix)


if __name__ == '__main__':
    n = int(input('your matrix dimension is: '))
    print('Enter the matrix row by row:')
    x = getMatrix(n)
    print(x)
    print('\n\ndet(x) = %f' % determinant(x))
