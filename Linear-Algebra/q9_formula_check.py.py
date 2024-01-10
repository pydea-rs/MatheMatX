from numpy import *

a = array([ [7, -6, -4, 1],\
            [-5, 1, 0, -2],\
            [10, 11, 7, -3],\
            [19, 9, 7, 1] ])
b = [ 4.230, -11.043, 49.991, 69.536 ]
db = (10 ** -4) * array([0.27, 7.76, -3.77, 3.93])
x = linalg.solve(a, b)
dx = linalg.solve(a, db)

dxNorm = linalg.norm(dx)
xNorm = linalg.norm(x)
aCond = linalg.cond(a)
dbNorm = linalg.norm(db)
bNorm = linalg.norm(b)

# show all matrices,vectors, and other values
matrices = { 'A' : a, 'b' : b, 'db' : db ,'x' : x, 'dx' : dx}
for item in matrices:
    print( item + ' = ' + str(matrices[item]), end='\n\n' )
values = { '||dx||' : dxNorm, '||x||' : xNorm, 'cond(A)' : aCond,\
           '||db||' : linalg.norm(db), '||b||' : linalg.norm(b) }
for item in values:
    print( item + ' = ' + str(values[item]), end='\n\n' )

# formula
print('||dx|| / ||x|| <= cond(A) * ||db|| / ||b||', end='\n\n')
leftSide = dxNorm / xNorm
rightSide = aCond * dbNorm / bNorm
print(str(leftSide) + ' <= ' + str(rightSide))
