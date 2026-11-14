cmake_minimum_required(VERSION 3.25)

project(
    futils
    VERSION 0.1.0
    DESCRIPTION "Fortran library providing some basic utilities"
    LANGUAGES Fortran
)

option(FUTILS_BUILD_EXAMPLES "Build the futils example program" ON)

add_library(futils STATIC)
add_library(futils::futils ALIAS futils)

set_target_properties(
    futils
    PROPERTIES
        Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mod"
)

target_include_directories(
    futils
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>"
)

target_sources(
    futils
    PRIVATE
        src/strings.f90
        src/error_handling.f90
        src/enum_generator.f90
        src/futils.f90
)

target_include_directories(
  futils
  PUBLIC
  include
)

target_compile_options(
  futils
  PRIVATE
  -cpp
  -ffile-prefix-map=${CMAKE_SOURCE_DIR}/src/=
)

if(FUTILS_BUILD_EXAMPLES)
  add_executable(error_handling_example examples/error_handling.f90)
  target_link_libraries(error_handling_example PRIVATE futils::futils)
  target_compile_options(error_handling_example PRIVATE -cpp)
  
  add_executable(enum_example examples/enum.f90)
  target_link_libraries(enum_example PRIVATE futils::futils)
  target_compile_options(enum_example PRIVATE -cpp)
endif()
