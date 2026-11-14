module enums_m
  use futils_m
#include "futils.h"

  NEW_ENUM(fruit)
    ENUMERATOR(fruit, apple)
    ENUMERATOR(fruit, orange)
  END_ENUM(fruit)

  NEW_ENUM(veggie)
    ENUMERATOR(veggie, carrot)
    ENUMERATOR(veggie, potato)
  END_ENUM(veggie)

end module enums_m

program enum_example
  use enums_m

  type(fruit_t) :: fruit1, fruit2
  type(veggie_t) :: veggie1, veggie2

  fruit1 = fruit_enum%apple
  fruit2 = fruit_enum%orange

  veggie1 = veggie_enum%carrot
  veggie2 = veggie_enum%potato

#ifdef _TYPE_ERROR
  !An assignment like this:
  fruit1 = veggie_enum%carrot
  !Results in a compiler error like this:
  !Cannot convert TYPE(veggie_t) to TYPE(fruit_t)
#endif

  if(fruit1 == fruit_enum%apple) then
    print*, 'fruit 1 is an apple'
  endif
  
  if(fruit2 /= fruit_enum%apple) then
    print*, 'fruit 2 is not an apple'
  endif

  fruit2 = fruit1
  if(fruit2 == fruit_enum%apple) then
    print*, 'fruit 2 is an apple now'
  endif

  !This below does not result in a compiler error because all enumerator types
  !extend from the same base type and the comparison operator is defined for
  !the base type. However, the comparison routine checks that the lhs/rhs are
  !of the same concrete type and if not it stops with an assertion failure.
  if(fruit1 == veggie_enum%potato) then
    print*, 'fruit 1 is a potato'
  endif
 
end program enum_example
