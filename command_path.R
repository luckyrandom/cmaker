cmake_path <- function() getOption("cmaker.cmake.path", Sys.which("cmake"))
ninja_path <- function() getOption("cmaker.ninja.path", Sys.which("ninja"))
