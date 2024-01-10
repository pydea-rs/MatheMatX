from numpy import array

def innerProduct(a, b):
    n = len(a) # number of rows in a
    m = len(b[0]) # number of columns in b
    p = len(b) # number of rows in b || number of columns in a
    #c = zeros( (n,m) )
    c = array( [ [ 0.0 for j in range(m) ] for i in range(n)] )
 
    for i in range(n):
        for j in range(m):
            for k in range(p):
                c[i, j] += float( a[i, k] * b[k , j] )
    return c

if __name__ == '__main__':
    p1 = array( [ [-0.58835, 0.70206, 0.40119], \
                  [-0.78446, -0.37524, -0.49377], \
                  [-0.19612, -0.60523, 0.77152] ] )
    print('P1 = ', p1, end='\n\n')
    p2 = array( [ [-0.47624, -0.4264, 0.30151], \
                  [0.087932, 0.86603, -0.40825], \
                  [-0.87491, -0.26112, 0.86164] ] )
    print('P2 = ', p2, end='\n\n')
    print('inner(P1,P2) = ',innerProduct(p1,p2))
