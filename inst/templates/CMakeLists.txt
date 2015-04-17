cmake_minimum_required(VERSION 2.8.4)
set(PKG_DIR ${CMAKE_CURRENT_SOURCE_DIR})

project(@@project@@ LANGUAGES @@language@@)

FILE(GLOB SOURCE_FILES
  ${PKG_DIR}/src/*.h
  ${PKG_DIR}/src/*.hpp
  ${PKG_DIR}/src/*.cc
  ${PKG_DIR}/src/*.cpp)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PKG_DIR}/cmake/modules)
find_package(LibR)
if(${LIBR_FOUND})
else()
  message(FATAL_ERROR "No R...")
endif()

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e" "cat(cmaker::pkg_name('${PKG_DIR}'))"
  OUTPUT_VARIABLE PKG_NAME
  RESULT_VARIABLE PKG_RESULT
  )
if(NOT PKG_RESULT EQUAL 0)
  message( FATAL_ERROR "Fail to find package name")
endif()
message(STATUS "Detect R package: " ${PKG_NAME})

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e" "cat(paste0(cmaker::include_path('${PKG_DIR}'), collapse = ';'))"
  OUTPUT_VARIABLE PKG_INCLUDE_DIRS
  RESULT_VARIABLE PKG_INCLUDE_RESULT
  )
if(NOT PKG_INCLUDE_RESULT EQUAL 0)
  message( FATAL_ERROR "Fail to find package include path")
endif()
include_directories(BEFORE ${LIBR_INCLUDE_DIRS})
include_directories(BEFORE ${PKG_INCLUDE_DIRS})
include_directories(BEFORE "../inst/include/")

execute_process(
  COMMAND ${LIBR_EXECUTABLE} "CMD" "config" "--ldflags"
  OUTPUT_VARIABLE R_LD_FLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
set(CMAKE_SHARED_LINKER_FLAGS ${R_LD_FLAGS})

if (APPLE)
  set(CMAKE_MACOSX_RPATH OFF)
endif()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PKG_DIR}/src/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${PKG_DIR}/src/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PKG_DIR}/src/)

add_library(${PKG_NAME} SHARED ${SOURCE_FILES})
target_link_libraries(${PKG_NAME}
  ${LIBR_LIBRARIES})
set_property(TARGET ${PKG_NAME} PROPERTY CXX_STANDARD @@cxx_standard@@)

if (NOT WIN32)
  set_property(TARGET ${PKG_NAME} PROPERTY PREFIX "")
  set_property(TARGET ${PKG_NAME} PROPERTY OUTPUT_NAME "${PKG_NAME}.so")
  set_property(TARGET ${PKG_NAME} PROPERTY SUFFIX "")
endif()

if (NOT CMAKE_BUILD_TYPE)
  message(STATUS "No build type selected, default to Debug")
  set(CMAKE_BUILD_TYPE Debug)
endif()

# print includepath to file
file(WRITE ${PKG_DIR}/cmake/settings/includepath "")
get_property(includepath DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${includepath})
  file(APPEND  ${PKG_DIR}/cmake/settings/includepath "${dir}\n")
endforeach()

file(WRITE ${PKG_DIR}/cmake/settings/projectname ${CMAKE_PROJECT_NAME})
