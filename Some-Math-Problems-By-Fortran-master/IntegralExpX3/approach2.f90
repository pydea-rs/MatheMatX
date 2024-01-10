REAL FUNCTION E_X_3(X)
    IMPLICIT NONE
    REAL, INTENT(IN)::X
    REAL::X3, E
    X3 = X ** 3
    E = 1 / 2.718
    E_X_3 = E ** X3
END FUNCTION E_X_3

program ANTEGRALEX_3
    IMPLICIT NONE
    REAL::H, F_0, X_0
    REAL::X_K, F_K
    REAL::E_X_3, EX3
    INTEGER::K
    H = .01
    PRINT *, "MOAHESEBEYE ANTEGRALEH e^(-x^3) AZ TARIGH RAVESHEH NOGHTEH MIANI:"
    PRINT *,""
    
    PRINT *, "    DARIM: "
    PRINT *, "    h = ", H, ", x = [0, 1]"
    PRINT *, "    DAR NATIJEH n = (b - a) / h = 100"
    X_0 = H / 2
    EX3 = E_X_3(X_0)
    F_0 = H * E_X_3(X_0)
    PRINT *, "    BA SHORO AZ: x_0 = ", x_0, "f_0 = " , F_0, " ALGORYTHM TEKRAR RA EJRA MIKONIM"
    PRINT *, "    KE: f(k+1) = h * f(xk) + fk"
    DO K=1, 100
        IF( K == 1 )THEN            
            F_K = H * E_X_3(X_0)  +  F_0
            X_K =  X_0 + H
        ELSE
            F_K = H * E_X_3(X_K)  +  F_K
            X_K =  X_K + H
        END IF
    ENDDO
    PRINT *,""
    PRINT *, "HASELE ANTEGRAL {{ ", F_K, " }} AST."
end