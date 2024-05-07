
module cts_numdummies
  implicit none
  contains

  subroutine dpnumdummy(q,amp)
    ! dummy numerator in double precision. Always returns zero.
    implicit none
    include 'cts_dpc.h'
      , intent(in), dimension(0:3) :: q
    include 'cts_dpc.h'
      , intent(out) :: amp
    amp = 0
  end subroutine dpnumdummy

  subroutine mpnumdummy(q,amp)
    ! dummy numerator in quad precision. Always returns zero.
    include 'cts_mprec.h'
    implicit none
    include 'cts_mpc.h'
      , intent(in), dimension(0:3) :: q
    include 'cts_mpc.h'
      , intent(out) :: amp
    amp = 0
  end subroutine mpnumdummy
end module cts_numdummies
