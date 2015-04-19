cmake_minimum_required(VERSION 2.8.4)

# Defalut -Wno-dev
if(NOT DEFINED CMAKE_SUPPRESS_DEVELOPER_WARNINGS)
  set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE INTERNAL "No dev warnings")
endif()

set(PKG_DIR ${CMAKE_CURRENT_SOURCE_DIR})

project(@@project@@ @@language@@)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PKG_DIR}/cmake/modules)
find_package(LibR)
if(${LIBR_FOUND})
else()
  message(FATAL_ERROR "No R...")
endif()

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e" 
  "cmaker::list_sources('${PKG_DIR}', out = TRUE, collapse = ';')"
  OUTPUT_VARIABLE SOURCE_FILES
  ERROR_VARIABLE SOURCE_FILES_ERROR
  RESULT_VARIABLE SOURCE_FILES_RESULT
  )
message(AUTHOR_WARNING
  "SOURCE_FILES : ${SOURCE_FILES}")
message(AUTHOR_WARNING
  "SOURCE_FILES_ERROR : ${SOURCE_FILES_ERROR}")
if(NOT SOURCE_FILES_RESULT EQUAL 0)
  message( FATAL_ERROR "Fail to list source files")
endif()

execute_process(
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e"
  "cmaker::list_sources('${PKG_DIR}', out = '${PKG_DIR}/cmake/settings/source_files')")

add_custom_command(
  OUTPUT ${PKG_DIR}/cmake/settings/never_write
  COMMAND ${LIBR_EXECUTABLE}
  "--slave" "-e"
  "cmaker::list_sources('${PKG_DIR}', out = '${PKG_DIR}/cmake/settings/source_files', \
                       on_change = stop('Error: Detect change of list of source files. Rerun build to get it correct.'))"
  VERBATIM)

add_custom_target(list_sources ALL
  DEPENDS ${PKG_DIR}/cmake/settings/never_write)

configure_file(${PKG_DIR}/cmake/settings/source_files
  ${PKG_DIR}/cmake/settings/source_files_who_care)

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

set(COMPILE_ATTRIBUTES @@compileAttributes@@)

if(COMPILE_ATTRIBUTES)
  ADD_CUSTOM_COMMAND(
    OUTPUT ${PKG_DIR}/src/RcppExports.cpp
    COMMAND ${LIBR_EXECUTABLE}
    "--slave" "-e" "\"Rcpp::compileAttributes('${PKG_DIR}')\""
    DEPENDS ${SOURCE_FILES} list_sources
    )
  add_library(${PKG_NAME} SHARED ${SOURCE_FILES} ${PKG_DIR}/src/RcppExports.cpp)
else()
  add_library(${PKG_NAME} SHARED ${SOURCE_FILES})
  add_dependencies(${PKG_NAME} list_sources)
endif()

set(CXX_STANDARD @@cxx_standard@@)

target_link_libraries(${PKG_NAME}
  ${LIBR_LIBRARIES})
set_property(TARGET ${PKG_NAME} PROPERTY CXX_STANDARD ${CXX_STANDARD})
file(WRITE ${PKG_DIR}/cmake/settings/cxx_standard ${CXX_STANDARD})

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
