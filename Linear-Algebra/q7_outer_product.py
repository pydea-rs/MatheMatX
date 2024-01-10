from numpy import array

def outerProduct(v1, v2):
    l1 = len(v1)
    l2 = len(v2)
    u = array ( [ [ 0.0 for j in range(l2) ] for i in range(l1) ] )

    for i in range(l1):
        for j in range(l2):
            u[i, j] = v1[i] * v2[j]

    return u

if __name__ == '__main__':
    p1 = [ -0.58835, -0.78446, -0.19612 ]
    print('P1 = ', p1, end='\n\n')
    p2 = [ -0.47624, 0.087932, -0.87491 ]
    print('P2 = ', p2, end='\n\n')
    print('outer(P1,P2) = \n', outerProduct(p1, p2))
