PROGRAM LaplaceSolver
  IMPLICIT NONE

  INTEGER, PARAMETER :: Nx = 10, Ny = 10
  REAL(8), PARAMETER :: L = 1.0, H = 1.0
  REAL(8), PARAMETER :: dx = L / REAL(Nx), dy = H / REAL(Ny)
  REAL(8), DIMENSION(0:Nx, 0:Ny) :: T
  INTEGER :: i, j, iter
  REAL(8) :: error, tol
  REAL(8), PARAMETER :: pi = 3.14159265358979
  ! Initialize temperature field
  T = 0.0

  ! Boundary conditions
  T(:, 1) = 0.0        ! Bottom side
  T(:, Ny) = 0.0       ! Top side
  T(1, :) = 0.0        ! Left side
  T(Nx, :) = 0.0       ! Right side

  ! Top side boundary condition
  DO i = 1, Nx
    T(i, Ny) = SIN(pi * REAL(i-1) * dx)
  END DO

  ! Iterative solution
  iter = 0
  tol = 1.0E-12

  DO WHILE (iter < 1000)
    error = 0.0

    DO j = 2, Ny-1
      DO i = 2, Nx-1
        T(i, j) = 0.25 * (T(i+1, j) + T(i-1, j) + T(i, j+1) + T(i, j-1))
        error = MAX(error, ABS(T(i, j) - 0.25 * (T(i+1, j) + T(i-1, j) + T(i, j+1) + T(i, j-1))))
      END DO
    END DO

    iter = iter + 1

    ! Print current values with full indices
    PRINT *, "Iteration #", iter
    PRINT *, "Temperature Field:"

    DO j = 0, Ny
      DO i = 0, Nx
        PRINT *, "T(", i, ",", j, ") = ", T(i, j)
      END DO
    END DO

    PRINT *, " "
    PRINT *, "Error Value So Far:", error
    PRINT *, "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
    IF (error < tol) THEN
      EXIT
    END IF
  END DO

END PROGRAM LaplaceSolver
