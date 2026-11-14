program error_handling_example
  use futils_m
#include "futils.h"

  implicit none
  integer :: i, j
  logical, dimension(5) :: larray

  print*, 'Enter two integers'
  read(*,*) i, j

  !The assert routine will error stop if the condition is not .true.
  !and it prints the condition in a message: "ASSERTION FAILED: i < j"
  !along with the file name and line number it was called from
  call error_handling%assert(i < j)

  !The abort routine simply error stops with the message provided,
  !along with the file name and line number.
  if(i < j) call error_handling%abort('i < j')
  
end program error_handling_example
