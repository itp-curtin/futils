module error_handling_m
  use strings_m

  !This module goes hand-in-hand with the macros defined in error_handling.h

  private
  public :: error_handling

  type, private :: error_handling_t
  contains
    procedure, nopass :: abort_routine => error_handling_abort_routine
    procedure, nopass, private :: error_handling_assert_routine, error_handling_assert_array_routine
    generic, public :: assert_routine => error_handling_assert_routine, error_handling_assert_array_routine
  end type error_handling_t

  type(error_handling_t), parameter :: error_handling = error_handling_t()

contains

   pure subroutine error_handling_abort_routine(line,file,msg)
    implicit none

    !-=-= INPUT/OUTPUT
    integer, intent(in) :: line
    character(len=*), intent(in) :: file, msg
    type(string_t) :: file_s, line_s, msg_s

    file_s = trim(adjustl(file))
    line_s = line

    msg_s = '[ '//file_s//': LINE '//line_s//' ] :: '//trim(adjustl(msg))

    error stop msg_s%s

  end subroutine error_handling_abort_routine

  pure subroutine error_handling_assert_routine(condition,condition_str,line,file)
    implicit none

    !-=-= INPUT/OUTPUT
    logical, intent(in) :: condition
    character(len=*), intent(in) :: condition_str
    integer, intent(in) :: line
    character(len=*), intent(in) :: file
  
    if(.not.condition) call error_handling_abort_routine(line,file,"ASSERTION FAILED: "//trim(adjustl(condition_str)))

  end subroutine error_handling_assert_routine
  
  pure subroutine error_handling_assert_array_routine(condition,condition_str,line,file)
    implicit none

    !-=-= INPUT/OUTPUT
    logical, dimension(:), intent(in) :: condition
    character(len=*), intent(in) :: condition_str
    integer, intent(in) :: line
    character(len=*), intent(in) :: file
  
    if(.not.all(condition)) call error_handling_abort_routine(line,file,"ASSERTION FAILED: "//trim(adjustl(condition_str)))

  end subroutine error_handling_assert_array_routine

end module error_handling_m
