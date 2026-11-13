program error_handling_example
  use futils_m
#include "futils.h"

  implicit none
  integer :: i, j

  print*, 'Enter two integers'
  read(*,*) i, j

  call error_handling%assert(i < j)


  if(i < j) call error_handling%abort('i < j')
  
end program error_handling_example
