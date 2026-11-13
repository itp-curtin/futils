#define NEW_ENUM(enum) \
  type, public, extends(enumerator_t) :: enum/**/_t; \
  end type enum/**/_t; \
  type, private :: enum/**/_enum_t; \

#define ENUMERATOR(enum,enumerator) \
  type(enum/**/_t) :: enumerator = enum/**/_t(__COUNTER__,.true.)
  
#define END_ENUM(enum) \
  end type enum/**/_enum_t; \
  type(enum/**/_enum_t), public, parameter :: enum/**/_enum = enum/**/_enum_t()
