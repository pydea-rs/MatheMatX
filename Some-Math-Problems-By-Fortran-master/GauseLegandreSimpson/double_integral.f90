program double_integral
  implicit none

  integer, parameter :: n_x = 12  ! Number of subintervals for Simpson's rule in x
  integer, parameter :: n_y = 4    ! Number of points for Gaussian quadrature in y
  real(8) :: x_min, x_max, y_min, y_max, delta_x, delta_y, y_min_span, y_max_span
  real(8) :: integral
  integer :: i, j, y_spans
  real(8) :: x_i, x_ip1
  real(8), dimension(n_y) :: y_points, y_weights

  ! Define the limits of integration
  x_min = 2.0
  x_max = 3.0
  
  y_spans = 3
  y_min = 2.0 * x_min
  y_max = x_max**3

  ! Define Gaussian quadrature points and weights for the y-direction
  call legendre_quadrature(n_y, y_points, y_weights)

  ! Initialize the integral
  integral = 0.0

  ! Calculate the integral using Simpson's rule for the x-direction
  delta_x = (x_max - x_min) / n_x

  ! Divide the y-direction into three equal-length spans
  delta_y = (y_max - y_min) / y_spans

  ! Start the simpson integral on x alongside the gaus integral on y
  do i = 1, n_x
    x_i = x_min + (i - 1) * delta_x
    x_ip1 = x_i + delta_x
    write(*, *) "Simpson: n_x = ", i, ", x_i = ", x_i
    
    do j = 1, 3
      y_min_span = y_min + (j - 1) * delta_y
      y_max_span = y_min + j * delta_y
      write(*, *) "                   - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
      write(*, *) "    y span: [", y_min_span, ", ", y_max_span, "]"
      ! Apply Gaussian quadrature for the y-direction on each span
      integral = integral + delta_x * gauss_legendre(y_points, y_weights, y_min_span, y_max_span, x_i, x_ip1)
      write(*, *) "    Whole integral until now: ", integral
    end do
    write(*, *) "- - - - - - - - - - - - - - - - - - - - - - - -  - - - - - -", &
      " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  end do

  ! Output the result
  write(*, *) "Approximate double integral: ", integral

contains

  ! Function f(x, y) to be integrated
  real(8) function f(x, y)
    real(8), intent(in) :: x, y
    if (y < 10.0) then
      f = (2.0**x) * (cos(tan(y))**2)
    else
      f = (exp(x)) * (cos(y)**2)
    end if
  end function f

  ! Subroutine for Gaussian quadrature with Legendre polynomial points and weights
  subroutine legendre_quadrature(n, x, w)
    integer, intent(in) :: n
    real(8), intent(out) :: x(n), w(n)
    ! Legendre quadrature points and weights for n
    select case(n)
    case(2)
      x = (/ -0.5773502691896257, 0.5773502691896257 /)
      w = (/ 1.0, 1.0 /)
    case(4)
      x = (/ -0.8611363115940526, -0.3399810435848563, 0.3399810435848563, 0.8611363115940526 /)
      w = (/ 0.3478548451374538, 0.6521451548625461, 0.6521451548625461, 0.3478548451374538 /)
    end select
  end subroutine legendre_quadrature

  ! Function for Gaussian quadrature in the y-direction
  real(8) function gauss_legendre(y_points, y_weights, a, b, x_i, x_ip1)
    real(8), dimension(*), intent(in) :: y_points, y_weights
    real(8), intent(in) :: a, b, x_i, x_ip1
    integer :: k
    real(8) :: result, y_k
    result = 0.0
    do k = 1, n_y
      y_k = 0.5 * (b - a) * y_points(k) + 0.5 * (b + a)
      result = result + y_weights(k) * f(x_i, y_k)
      write(*, *) "        Gauss Legendre: n_y = ", k, ", y_j = ", y_k, ", Integral in y direction untill now: ", result
    end do
    gauss_legendre = result
  end function gauss_legendre

end program double_integral

