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
    character*12, parameter :: newline = new_line('a')//repeat(' ',11)
    integer :: n, i

    file_s = trim(adjustl(file))
    line_s = line

    n = len_trim(file) + 7

    msg_s = repeat('-',n)
    msg_s = msg_s//newline//'FILE: '//file_s
    msg_s = msg_s//newline//'LINE: '//line_s
    msg_s = msg_s//newline//'MSG:: '//trim(adjustl(msg))
    msg_s = msg_s//newline//repeat('-',n)

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
