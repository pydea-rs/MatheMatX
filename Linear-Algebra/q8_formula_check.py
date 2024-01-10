import numpy as np
import sympy


def createSymbolicMatrix(elementSymbol , rows, columns):
    r = []
    for i in range(1,rows + 1):
        for j in range(1,columns + 1):
            r.append(sympy.symbols( '%s%d%d' % (elementSymbol, i, j) ) )
    return np.reshape(r, (rows, columns))

if __name__ == '__main__':
    i = 0
    while( i != 1 and i != 2):
        i = int(input('Select the prooving method:\n1) \
                      By symbolic matrices\t\t2) By random matrices\t'))
    if i == 1:
        A = createSymbolicMatrix('a', 2, 3)
        B = createSymbolicMatrix('b', 3, 2)
    elif i == 2:
        A = np.random.randint(-10, 10, [2, 3])
        B = np.random.randint(-10,10, [3, 2])
    else:
        print('WRONG INPUT')
        exit
    print('A = \n' + str(A))
    print('\n\nB = \n' + str(B))

    K = sympy.symbols('K')

    A = sympy.matrices.Matrix(A)
    B = sympy.matrices.Matrix(B)
    I3 = sympy.matrices.Matrix( np.eye(3) )
    I2 = sympy.matrices.Matrix( np.eye(2) )
    leftSide = (K ** 2) * (((K * I3) - B @ A ).det())
    print('\n\nleft side = ' + str(leftSide))

    rightSide = (K ** 3) * ( ((K * I2) - A @ B).det() )
    print('\n\nright side = ' + str(rightSide))
