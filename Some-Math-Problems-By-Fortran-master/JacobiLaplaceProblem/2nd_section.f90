

program main
    implicit none
    REAL(8), PARAMETER :: pi = 3.14159265358979
    real(8), PARAMETER :: Lx = 1, Ly = 1, MaxIterations = 100000
    real(8) ::  dx, dy, error, flux
    integer(4) :: i=0, l, mesh_size, start_time, end_time, iterations
    real(8), dimension(4) :: tol
    real(8), dimension(50, 50) :: T
    real(8), dimension(3) :: norms, accuracies

    tol(1) = 1e-10
    tol(2) = 1e-12
    tol(3) = 1e-12
    tol(4) = 1e-12


    do i = 1, 4
        flux = 0
        error = 0
        mesh_size = i * 10
        dx = Lx / mesh_size
        dy = Ly / mesh_size
        call system_clock(start_time)
        call BoundaryCondition(T, mesh_size)
        call Jacobi(T, mesh_size, tol(i), flux, error, iterations)
        call system_clock(end_time)

        PRINT *, &
            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ", &
            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        print *, "Mesh-", i, " (", mesh_size, ", ", mesh_size, ")"
        print *, ""  !next line

        print *, "                               - - - - - - - - - - - - - - - - Final Result - - - - - - - - - - - - - - - -"
        call Examine(T, mesh_size, norms, accuracies)
        print *, ""
        print *, "                               - - - - - - - - - - - - - - - - Algorythm ", &
            "Parameters - - - - - - - - - - - - - - - -"
        print *, "FluxIntegral = ", flux, " Error = ", error, ", Iterations = ", iterations, ", Calculation time:", &
            end_time - start_time, "ms=", real((end_time - start_time), kind=4) / 1000, "secs"
        print *, ""  !next line
        print *, "                               - - - - - - - - - - - - - - - -", &
             "Norm & Accuracy - - - - - - - - - - - - - - - -"
        do l=1,3
            print *, "L", l, " = ", norms(l), " => ", "accuracy = ", accuracies(l)

        end do
        print *, ""  !next line

    end do


contains

    real(8) function Exact(x, y)
        real(8), intent(in):: x, y
        Exact = sin(pi*x) * sinh(pi*y) / sinh(pi)
    end function Exact

    real(8) function FluxIntegral(T, dimen)

        real(8), dimension(:, :), intent(in) :: T
        integer(4), intent(in) :: dimen
        integer(4) :: i, j

        FluxIntegral = 0
        do j = 2, dimen - 1
            do i = 2, dimen - 1
                FluxIntegral = FluxIntegral + (T(i+1, j) - 2*T(i, j) + T(i-1, j)) &
                            + (T(i, j+1) - 2*T(i, j) + T(i, j-1))
            end do
        end do
    end function FluxIntegral

    subroutine BoundaryCondition(T, dimen)
        integer(4), intent(in) :: dimen
        integer(4) :: c
        real(8), dimension(:, :), intent(inout) :: T

        real(8) :: dx, dy
        dx = Lx / dimen
        dy = Ly / dimen
        T(1, :) = 0  ! bottom edge
        T(:, 1) = 0  ! left edge
        T(:, dimen) = 0  ! right edge

        do c=1, dimen
            T(dimen, c) = sin(pi * (c - 1) * dx)  ! top edges
        end do

    end subroutine BoundaryCondition

    subroutine Jacobi(T, dimen, tol, flux, error, iterations)
        integer(4), intent(in) :: dimen
        integer(4), intent(inout) :: iterations
        real(8), intent(inout) :: error, flux
        real(8), dimension(:, :), intent(inout) :: T
        real(8), intent(in) :: tol
        real(8), dimension(40, 40) :: T_old
        integer(4) :: i, j

        T_old = T
        error = tol + 1
        iterations = 0
        ! The code will run until it reaches the preferred error
        ! if not, we considered a MaxIteration Parameter to stop the algorythm from stuckin into endless loop
        do while (error > tol .and. iterations < MaxIterations)
            ! print *, error, tol
            do j = 2, dimen - 1
                do i = 2, dimen - 1
                    T(i, j) = 0.25 * (T_old(i+1, j) + T_old(i-1, j) + T_old(i, j+1) + T_old(i, j-1))
                end do
            end do
            ! Calculating the error by FluxIntegral

            flux = FluxIntegral(T, dimen)
            error = sqrt(flux)

            T_old = T
            iterations = iterations + 1
        end do

    end subroutine Jacobi

    subroutine Examine(T, dimen, TvsX_norms, accuracies)
        real(8), dimension(:, :), intent(in) :: T
        integer(4), intent(in) :: dimen
        real(8), dimension(3), intent(inout) :: TvsX_norms, accuracies
        real(8), dimension(dimen, dimen) :: X
        real(8), dimension(dimen) :: ag_n1, ag_nI, T_n1, X_n1, T_nI, X_nI
        real(8), dimension(3) :: T_norms, X_norms
        real(8) :: difference

        integer(4) :: i, j

        ! the code of this this section can be wraped into function and subroutines
        ! but this way is the most optimized way considering the performance

        ! L1 = Calculate sum of matrix columns and select the maximum value
        TvsX_norms(1) = -1  ! T again exact-values matrices norms
        ! square root of sum of matrix elements ^ 2
        TvsX_norms(2) = 0
        ! Linf = Calculate sum of matrix rows and select the maximum value
        TvsX_norms(3) = -1 ! norm_inf

        T_norms(1) = -1  ! T again exact-values matrices norms
        T_norms(2) = 0
        T_norms(3) = -1 ! norm_inf

        X_norms(1) = -1  ! T again exact-values matrices norms
        X_norms(2) = 0
        X_norms(3) = -1 ! norm_inf

        do i = 1, dimen
            ag_nI(i) = 0
            T_nI(i) = 0
            X_nI(i) = 0

            do j = 1, dimen
                TvsX_norms(1) = TvsX_norms(1) + difference
                X(i, j) = Exact((j - 1) * dx, (i - 1) * dy)
                difference = abs(T(i, j) - X(i, j))
                ag_nI(i) = ag_nI(i) + difference ! adding each column of thgis row to calculate the sum of this row
                T_nI(i) = T_nI(i) + T(i, j) ! adding each column of thgis row to calculate the sum of this row
                X_nI(i) = X_nI(i) + X(i, j) ! adding each column of thgis row to calculate the sum of this row

                TvsX_norms(2) = TvsX_norms(2) + (difference ** 2)
                T_norms(2) = T_norms(2) + (T(i, j) ** 2)
                X_norms(2) = X_norms(2) + (X(i, j) ** 2)

                print *, "T(", i, ",", j, ") = ", T(i, j), " Exact value = ", &
                    X(i, j), " Difference = ", difference
            end do

            ! norm_inf is the maximum value of the abs sum of each row
            if (TvsX_norms(3) < ag_nI(i)) then
                TvsX_norms(3) = ag_nI(i)
            end if

            if (T_norms(3) < T_nI(i)) then
                T_norms(3) = T_nI(i)
            end if

            if (X_norms(3) < X_nI(i)) then
                X_norms(3) = X_nI(i)
            end if
        end do

        ! norm_2 just needs to convert to 2nd root of itself, to complete norm2 formula
        TvsX_norms(2) = sqrt(TvsX_norms(2))
        T_norms(2) = sqrt(T_norms(2))
        X_norms(2) = sqrt(X_norms(2))

        do j = 1, dimen
            ag_nI(1) = 0
            T_nI(1) = 0
            X_nI(1) = 0
            do i = 1, dimen
                ag_n1(j) = ag_n1(j) + abs(T(i, j) - X(i, j))
                T_n1(j) = T_n1(j) + abs(T(i, j))
                X_n1(j) = X_n1(j) + abs(X(i, j))

            end do

            if (TvsX_norms(1) < ag_n1(j)) then
                TvsX_norms(1) = ag_n1(j)
            end if

            if (T_norms(1) < T_n1(j)) then
                T_norms(1) = T_n1(j)
            end if

            if (X_norms(1) < X_n1(j)) then
                X_norms(1) = X_n1(j)
            end if
        end do

        ! calculate accuracies as: acc = 1 - (normTagainsX / (normT + normX))
        do i=1, 3
            accuracies(i) = 1.0 - (TvsX_norms(i) / (X_norms(i) + T_norms(i)))
        end do

    end subroutine Examine


end program main
