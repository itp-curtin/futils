module enum_generator_m
#include "error_handling.h"
  use error_handling_m
  use strings_m

  private

#define NAME_MAX_LEN 32

  type, public, abstract :: enumerator_t
    !private
    integer :: id
    character(len=NAME_MAX_LEN) :: name
    logical :: set = .false.
  contains
    private
    procedure, pass(lhs) :: is_equal
    procedure, pass(lhs) :: not_equal
    generic, public :: operator(==) => is_equal
    generic, public :: operator(/=) => not_equal
    procedure, public, pass(self) :: unset => unset_enumerator
    procedure, public, pass(self) :: is_set => is_set_enumerator
    procedure, public, pass(self) :: get_name => get_enumerator_name
  end type enumerator_t

  interface assignment(=)
    module procedure assign_enumerator
  end interface


  ! How to create enums:
  !
  !   NEW_ENUM(<name>)
  !     ENUMERATOR(<name>, <enumerator>)
  !   END_ENUM(<name>)
  !
  ! This creates two derived types:
  !   type( <name>_t ) 
  !   type( <name>_enum_t )
  ! 
  ! and an instance of <name>_enum_t called <name>_enum.
  ! The type <name>_enum_t contains all of the defined enumerators, which
  ! are of type <name>_t.
  ! The user can create their own instances of the type <name>_t, and set them to any of
  ! the defined enumerators.
  !   
  ! E.g.:
  !
  ! NEW_ENUM(fruit)
  !   ENUMERATOR(fruit, apple)
  !   ENUMERATOR(fruit, orange)
  ! END_ENUM(fruit)
  !   
  ! type(fruit_t) :: myfruit
  ! myfruit = fruit_enum%apple 
  ! if(myfruit /= fruit_enum%orange) then ...
  ! etc
  !
  ! The enumerators (e.g. fruit_t) are all extensions of the abstract type < enumerator_t >.
  ! The enums (e.g. fruit_enum_t) are all extensions of the abstract type < enum_t >.


contains

  pure subroutine unset_enumerator(self)
    implicit none
    class(enumerator_t), intent(inout) :: self

    self%set = .false.
  end subroutine unset_enumerator

  pure elemental logical function is_set_enumerator(self)
    implicit none
    class(enumerator_t), intent(in) :: self

    is_set_enumerator = self%set

  end function is_set_enumerator
  
  pure elemental logical function is_equal(lhs, rhs)
    implicit none
    class(enumerator_t), intent(in) :: lhs, rhs

    call error_handling%assert(same_type_as(lhs,rhs))
    call error_handling%assert(lhs%set)
    call error_handling%assert(rhs%set)

    is_equal = (lhs%id == rhs%id)
  end function is_equal
  
  pure logical function not_equal(lhs, rhs)
    implicit none
    class(enumerator_t), intent(in) :: lhs, rhs
    
    call error_handling%assert(same_type_as(lhs,rhs))
    call error_handling%assert(lhs%set)
    call error_handling%assert(rhs%set)

    not_equal = (lhs%id /= rhs%id)
  end function not_equal
  
  subroutine assign_enumerator(lhs, rhs)
    implicit none
    class(enumerator_t), intent(out) :: lhs
    class(enumerator_t), intent(in) :: rhs
    
    if(.not.same_type_as(lhs,rhs)) then
      call error_handling%abort('enumerator_t types not equivalent in setter subroutine')
    endif
    
    if(.not.rhs%set) then
      call error_handling%abort('RHS enumerator_t type not set in comparison')
    endif

    lhs%id = rhs%id
    lhs%set = .true.

  end subroutine assign_enumerator

  pure type(string_t) function get_enumerator_name(self) result(name)
    implicit none
    class(enumerator_t), intent(in) :: self

    name = trim(adjustl(self%name))
  end function get_enumerator_name

end module enum_generator_m
