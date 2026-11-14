# futils
Some basic Fortran utilities

## Installation
futils can be added to your project as a submodule, for example:
```bash
  git submodule add https://github.com/itp-curtin/futils src/external/futils
```
and then your `CMakeLists.txt` file should contain:
```cmake
  add_subdirectory(external/futils)
  target_link_libraries(my_app PRIVATE futils::futils)
```

## Usage
The utilities provided by futils also require preprocessor macros included in `include/futils.h`.

To use futils:
```Fortran
program main
  use futils_m
#include "futils.h"
```

The cmake configuration provided should include the futils `include` directory in the include path of your
program's compilation.

Some example programs are provided in `examples`.
To compile them:
```bash
cmake -B build && cmake --build build
```

Then run:
```bash
./build/error_handling_example
./build/enum_example
```
