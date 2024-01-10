! To calculate the multiple integral of a function f(x, y) using Gaussian quadrature with Legendre polynomials, where y ranges from 2x to x^3 and x ranges from 2 to 3, you can follow these steps:

! Transform the integral to a standard form.
! Choose the number of points for Gaussian quadrature in both x and y dimensions.
! Calculate the Legendre points and weights for both dimensions.
! Use a nested loop to evaluate the function at the Legendre points and compute the integral.
! Here's a Fortran code to perform this calculation:
program gauss_legendre_integral
  implicit none

  integer, parameter :: n_x = 4  ! Number of points for Gaussian quadrature in x
  integer, parameter :: n_y = 4  ! Number of points for Gaussian quadrature in y
  real(8) :: x(n_x), w_x(n_x)  ! Gaussian quadrature points and weights in x
  real(8) :: y(n_y), w_y(n_y)  ! Gaussian quadrature points and weights in y
  real(8) :: integral, x_min, x_max, y_min, y_max
  integer :: i, j

  ! Define the region of integration
  x_min = 2.0d0
  x_max = 3.0d0
  y_min = 2.0d0
  y_max = x_max**3

  ! Calculate the Legendre points and weights for both dimensions
  call gauss_legendre(n_x, x, w_x)
  call gauss_legendre(n_y, y, w_y)

  ! Initialize the integral
  integral = 0.0d0

  ! Perform the double integral using Gaussian quadrature
  do i = 1, n_x
    do j = 1, n_y
      integral = integral + w_x(i) * w_y(j) * f(x(i), y(j))
    end do
  end do

  ! Output the result
  write(*, *) "Approximate integral: ", integral

contains

  subroutine gauss_legendre(n, x, w)
    ! Subroutine to compute the Gaussian quadrature points and weights
    integer, intent(in) :: n
    real(8), intent(out) :: x(n), w(n)
    integer :: i
    real(8) :: m, xi

    m = n / 2.0d0

    do i = 1, n
      xi = cos((2*i - 1) * 3.14159265358979323846d0 / (2*n))
      x(i) = 0.5d0 * (x_max + x_min) + 0.5d0 * (x_max - x_min) * xi
      w(i) = (x_max - x_min) / (2.0d0 * m)
    end do

  end subroutine gauss_legendre

  real(8) function f(x, y)
    ! Function to evaluate the integrand f(x, y)
    real(8), intent(in) :: x, y
    f = ... ! Replace with your function f(x, y)
  end function f

end program gauss_legendre_integral

! Replace ... in the f(x, y) function with your specific function that you want to integrate.
! The code uses Gaussian quadrature to approximate the integral over the given region of integration. Adjust the number of points for Gaussian quadrature to control the accuracy of the result.
