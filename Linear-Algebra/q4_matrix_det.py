import MyDeterminant as pya

n = int(input('Enter your matrix dimension: ')) # n = 2 or 3
print('Enter the matrix row by row:')
x = pya.getMatrix(n)
print(x)
detx = pya.determinant(x)
print('\n\ndet(x) = ' + str(detx))
if detx:
    print('x is Invertible')
else:
    print('x is Not Invertible')