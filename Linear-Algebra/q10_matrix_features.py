from numpy import *
m = random.rand(3,3)
mInvert = linalg.inv(m)
mRank = linalg.matrix_rank(m)
mNull = 3 - mRank
eigens = linalg.eigvals(m)
b = array([1.0, 0.9, 0.8])
x = linalg.solve(m, b)
strAnswers = [['\nRandom Matrix:\n', str(m)], ['\nMarix Invert:\n', str(mInvert)],
             ['\nMatrix Rank:\t', str(mRank)], ['\nMatrix Nullity:\t', str(mNull)],
              ['\nEigenValues:\t',str(eigens)], ['\nAx=B ==> x:\t', str(x)]]
for i in range(len(strAnswers)):
    print(strAnswers[i][0] + strAnswers[i][1])

print('\n\n----------------------Postive Definite?----------------------------------')
# starting from 1x1 matrix until it reaches the 3x3 matrix,
# the code calculates determinants and checks if their positive and
# saves the boolean result in 'determinantPositive'.
determinantsPositive = []
for i in range(3):
    t = m[0:i+1, 0:i+1]
    detT = linalg.det(t)
    determinantsPositive.append( detT > 0 )
    print('\nt = \n' + str(t) + '\t==> |t| = ' + str(detT))

print('\nMatrix is' + (' ' if all(determinantsPositive) \
                       else ' NOT ' ) + 'Positive Defenite.' )
