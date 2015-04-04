cmake_minimum_required(VERSION 2.8.4)
set(PKG_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)

project(@@project@@ LANGUAGES @@language@@)

FILE(GLOB SOURCE_FILES
  ${PKG_DIR}/src/*.h
  ${PKG_DIR}/src/*.hpp
  ${PKG_DIR}/src/*.cc
  ${PKG_DIR}/src/*.cpp)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/Modules)
find_package(LibR)
if(${LIBR_FOUND})
else()
  message(FATAL_ERROR "No R...")
endif()

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e" "cat(RCMakeTemplate::pkg_name('${PKG_DIR}'))"
  OUTPUT_VARIABLE PKG_NAME
  ERROR_VARIABLE  PKG_ERR
  )
message(STATUS "Detect R package: " ${PKG_NAME})

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e" "cat(RCMakeTemplate::include_path('${PKG_DIR}'))"
  OUTPUT_VARIABLE PKG_INCLUDE_DIRS
  )
include_directories(BEFORE ${LIBR_INCLUDE_DIRS})
include_directories(BEFORE ${PKG_INCLUDE_DIRS})
include_directories(BEFORE "../inst/include/")

execute_process(
  COMMAND ${LIBR_EXECUTABLE} "CMD" "config" "--ldflags"
  OUTPUT_VARIABLE R_LD_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
set(CMAKE_SHARED_LINKER_FLAGS ${R_LD_FLAGS})

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PKG_DIR}/src/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${PKG_DIR}/src/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PKG_DIR}/src/)

add_library(${PKG_NAME}_lib SHARED ${SOURCE_FILES})
target_link_libraries(${PKG_NAME}_lib
  ${LIBR_LIBRARIES})
set_property(TARGET ${PKG_NAME}_lib PROPERTY CXX_STANDARD @@cxx_standard@@)

if (APPLE)
    set_property(TARGET ${PKG_NAME}_lib PROPERTY PREFIX "")
    set_property(TARGET ${PKG_NAME}_lib PROPERTY OUTPUT_NAME "${PKG_NAME}.so")
    set_property(TARGET ${PKG_NAME}_lib PROPERTY SUFFIX "")
endif()
