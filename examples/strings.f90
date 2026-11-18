program strings_example
#include "futils.h"
  use futils_m

  type(string_t) :: string

  string = 'sTrInG'

  call string%make_upper
  print*, 'upper: |'//string//'|'
  
  call string%make_lower
  print*, 'lower: |'//string//'|'

  print*, 'index(string, i):', index(string, 'i'), index(string%s, 'i')

  string = string%s(1:2)
  print*, 'string(1:2): |'//string//'|'









end program strings_example
