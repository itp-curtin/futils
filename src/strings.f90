module strings_m

  type :: string_t
    integer :: len=0
    character(len=:), allocatable :: s
  contains
    procedure :: WRITE => write_string
    procedure :: WRITE_UNFORMATTED => write_string_unformatted
    procedure :: READ => read_string
    generic :: WRITE(FORMATTED) => WRITE
    generic :: WRITE(UNFORMATTED) => WRITE_UNFORMATTED
    generic :: READ(FORMATTED) => READ

    procedure, pass(self), public :: make_upper
    procedure, pass(self), public :: make_lower

  end type string_t

  character*26, private, parameter :: &
    upper_case="ABCDEFGHIJKLMNOPQRSTUVWXYZ", &
    lower_case="abcdefghijklmnopqrstuvwxyz"

  interface string_t
    module procedure create_string 
  end interface string_t

  interface assignment (=)
    module procedure assign_character_to_string
    module procedure assign_int4_to_string
    module procedure assign_string_to_string
  end interface

  interface operator (//)
    module procedure concat_character_and_string
    module procedure concat_string_and_character
    module procedure concat_string_and_string
  end interface

  interface operator (==)
    module procedure equiv_character_string
    module procedure equiv_string_character
    module procedure equiv_string_string
  end interface
  
  interface operator (/=)
    module procedure nequiv_character_string
    module procedure nequiv_string_character
    module procedure nequiv_string_string
  end interface

  interface index
    module procedure string_index
  end interface

  type, private :: string_tools_t
  contains
    procedure, nopass :: sentence => make_sentence_from_array_of_strings
  end type string_tools_t

  type(string_tools_t), public, parameter :: string_tools = string_tools_t() 

contains

   pure type(string_t) function create_string(s) result(res)
    implicit none
    character(len=*), intent(in) :: s

    res = s
  end function create_string

  pure logical function equiv_character_string(lhs,rhs) result(retval)
    implicit none
    character(len=*), intent(in) :: lhs
    type(string_t), intent(in) :: rhs

    retval = (lhs == rhs%s)

  end function
  
  pure logical function equiv_string_character(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs
    character(len=*), intent(in) :: rhs

    retval = (lhs%s == rhs)

  end function
  
  pure logical function equiv_string_string(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs, rhs

    retval = (lhs%s == rhs%s)

  end function
  
  pure logical function nequiv_character_string(lhs,rhs) result(retval)
    implicit none
    character(len=*), intent(in) :: lhs
    type(string_t), intent(in) :: rhs

    retval = (lhs /= rhs%s)

  end function
  
  pure logical function nequiv_string_character(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs
    character(len=*), intent(in) :: rhs

    retval = (lhs%s /= rhs)

  end function
  
  pure logical function nequiv_string_string(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs, rhs

    retval = (lhs%s /= rhs%s)

  end function
    

  pure function concat_character_and_string(lhs,rhs) result(retval)
    implicit none
    character(len=*), intent(in) :: lhs
    type(string_t), intent(in) :: rhs
    character(len=:), allocatable :: retval

    allocate(character(len(lhs)+rhs%len) :: retval)
    retval = lhs//rhs%s

  end function
  
  pure function concat_string_and_character(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs
    character(len=*), intent(in) :: rhs
    character(len=:), allocatable :: retval

    allocate(character(len(rhs)+lhs%len) :: retval)
    retval = lhs%s//rhs

  end function
  
  pure function concat_string_and_string(lhs,rhs) result(retval)
    implicit none
    type(string_t), intent(in) :: lhs, rhs
    character(len=:), allocatable :: retval

    allocate(character(lhs%len+rhs%len) :: retval)
    retval = lhs%s//rhs%s

  end function

  subroutine write_string(str,unit, iotype, v_list, iostat, iomsg)
    class(string_t), intent(in) :: str
    INTEGER, INTENT(IN) :: unit
    CHARACTER(*), INTENT(IN) :: iotype
    INTEGER, INTENT(IN)  :: v_list(:)
    INTEGER, INTENT(OUT) :: iostat
    CHARACTER(*), INTENT(INOUT) :: iomsg

    write(unit, '(A)' , IOSTAT=iostat) str%s

  end subroutine write_string
  
  subroutine write_string_unformatted(str,unit, iostat, iomsg)
    class(string_t), intent(in) :: str
    INTEGER, INTENT(IN) :: unit
    INTEGER, INTENT(OUT) :: iostat
    CHARACTER(*), INTENT(INOUT) :: iomsg

    write(unit, *, IOSTAT=iostat) str%s

  end subroutine write_string_unformatted

  SUBROUTINE read_string(str, unit, iotype, v_list, iostat, iomsg)
    class(string_t), INTENT(INOUT) :: str
    INTEGER, INTENT(IN) :: unit
    CHARACTER(*), INTENT(IN) :: iotype
    INTEGER, INTENT(IN)  :: v_list(:)
    INTEGER, INTENT(OUT) :: iostat
    CHARACTER(*), INTENT(INOUT) :: iomsg

    READ (unit, *, IOSTAT=iostat) str%s

  END SUBROUTINE

  pure subroutine assign_int4_to_string(outstring, inint)
    implicit none
    type(string_t), intent(out) :: outstring
    integer*4, intent(in) :: inint
    character(len=512) :: tempchar
    integer :: len

    if(allocated(outstring%s)) deallocate(outstring%s)
    write(tempchar,'(I0)') inint
    len = len_trim(tempchar)
    allocate(character(len) :: outstring%s)
    outstring%s = trim(adjustl(tempchar))

  end subroutine assign_int4_to_string
  
  pure subroutine assign_character_to_string(outstring, inchar)
    implicit none
    type(string_t), intent(out) :: outstring
    character(len=*), intent(in) :: inchar

    if(allocated(outstring%s)) deallocate(outstring%s)
    allocate(character(len(inchar)) :: outstring%s)
    outstring%s = inchar
    outstring%len = len(outstring%s)
  end subroutine assign_character_to_string
  
  pure subroutine assign_string_to_string(outstring, instring)
    implicit none
    type(string_t), intent(out) :: outstring
    type(string_t), intent(in) :: instring

    if(allocated(outstring%s)) deallocate(outstring%s)
    allocate(character(instring%len) :: outstring%s)
    outstring%s = instring%s
    outstring%len = instring%len 
  end subroutine assign_string_to_string

  pure function make_sentence_from_array_of_strings(array) result(s)
    implicit none
    type(string_t), dimension(:), intent(in) :: array
    type(string_t) :: s

    integer :: n, i

    n = size(array)

    s = array(1) 
    do i=2, n
      s = s // ' ' // array(i)
    enddo

  end function make_sentence_from_array_of_strings

  subroutine make_upper(self)
    implicit none
    class(string_t), intent(inout) :: self
    integer :: i, k

    do i=1, len(self%s)
      k = index(lower_case,self%s(i:i))
      if(k /= 0) self%s(i:i) = upper_case(k:k)
    enddo

  end subroutine make_upper
  
  subroutine make_lower(self)
    implicit none
    class(string_t), intent(inout) :: self
    integer :: i, k

    do i=1, len(self%s)
      k = index(upper_case,self%s(i:i))
      if(k /= 0) self%s(i:i) = lower_case(k:k)
    enddo

  end subroutine make_lower

  pure integer function string_index(self, s)
    implicit none
    class(string_t), intent(in) :: self
    character(len=*), intent(in) :: s

    string_index = index(self%s, s)
  end function string_index

end module strings_m
