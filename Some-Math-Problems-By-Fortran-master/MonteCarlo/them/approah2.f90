REAL FUNCTION FUN(X, Y, Z)
    IMPLICIT NONE
    REAL, INTENT(IN)::X, Y, Z
    FUN = X + Y * (Z ** 2)
END FUNCTION FUN

program MC
    IMPLICIT NONE
    REAL::FUN
    REAL::RX(100), RY(100), RZ(100), F(100)
    REAL::X1,X2,Y1,Y2,Z2,Z1
    INTEGER::K
    CALL RANDOM_SEED()
    Z2 = 1
    Z1 = 0
    Y2 = 4
    Y1 = 2
    X2= 5
    X1 = -1
    
    CALL RANDOM_NUMBER(RZ)
    RZ = RZ * (Z2 - Z1)
    CALL RANDOM_NUMBER(RY)
    RY = RY * (Y2 - Y1)
    CALL RANDOM_NUMBER(RX)
    RX = RX * (X2 - X1)
    DO K=1,100
        F(K) = (Z2 - Z1) * (Y2 - Y1) * (X2 - X1) * FUN(RX(K), RY(K), RZ(K)) / 100
    ENDDO

    PRINT *, "ANTEGRAL = ", SUM(F), " -VA- ERROR = ", ABS(SUM(F) - 36)
end