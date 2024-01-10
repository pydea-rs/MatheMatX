program monte_carlo_int3
    implicit none
    real::constant
    integer::n,xa,xb,ya,yb,za,zb
    real::lx, ly, lz
    real::randx, randy, randz
    real::x,y,z
    integer::i
    real::f_xyz, sum_f, integral, exact_value, error
    xa = -1
    xb = 5
    ya = 2
    yb = 4
    za = 0
    zb = 1
    n = 100
    sum_f = 0
    integral = 0
    randx = 1
    randy = 1
    randz = 1
    exact_value = 36

    lx = xb - xa
    ly = yb - ya
    lz = zb - za
    constant = lx * ly * lz / n
    call random_seed()

    do i=1, n
        call random_number(randx)
        call random_number(randy)
        call random_number(randz)
        x = randx * lx
        y = randy * ly
        z = randz * lz

        f_xyz = x + y * (z ** 2)
        sum_f = sum_f + f_xyz
        integral = sum_f * constant
        print*,"f(x=", x, "y=", y, "z=", z, ") = ", f_xyz, " => I{", i, "} = ", integral
    enddo

    print*, "--------------------------------------------------------------------------------"
    print*,"final value = ", integral

    if (exact_value > integral) then
        error = exact_value - integral
    else 
        error = integral - exact_value
    end if
    print*, "--------------------------------------------------------------------------------"
    print*,"monte carlo error = ", error

end