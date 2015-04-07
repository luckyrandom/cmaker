generators_linux <- c("Unix Makefiles",
                      "Ninja",
                      "Eclipse CDT4 - Ninja",
                      "CodeBlocks - Ninja",
                      "CodeLite - Ninja")

generators_mac <- c(generators_linux,
                    "Xcode")

sysname <- Sys.info()[['sysname']]

##' Get supported cmake generators.
##'
##' @return supported generators
##' @export
##' @author Chenliang Xu
ls_generators <- function() {
  switch(sysname,
         Windows= generators_windows,
         Linux  = generators_linux,
         Darwin = generators_mac)
}

##' Generate project file for IDE.
##'
##' Call cmake to generate project file for IDE.
##' @param dir the directory
##' @param generator the cmake generator to use
##' @param ... args pass to cmake
##' @export
##' @author Chenliang Xu
generate_project <- function(dir, generator,
                             ...) {
  generator <- match.arg(generator, ls_generators())
  cmake_dir <- normalizePath(file.path(dir, "cmake"))
  proj_dir <- cmake_dir
  cmake(paste("-G", shQuote(generator), cmake_dir), proj_dir, ...)
  if (length(grep("^Eclipse CDT4", generator)) > 0) {
    ## Temperary fix for the bug of cmake Eclipse generator that
    ## doesn't handle include path properly.
    lines <- readLines(file.path(proj_dir, ".cproject"))
    matched <- grep("<pathentry", readLines("inst/examples/rcppexample/cmake/.cproject"))
    if(length(matched) == 0) stop("Can not find place to insert include path. Please report as an issue.")
    writeLines(append(lines,
                      paste0('<pathentry include="',
                             include_path(dir),
                             '" kind="inc" path="" system="true"/>'),
                      min(matched) - 1),
               file.path(proj_dir, ".cproject"))
  }

  if (length(grep("^CodeBlocks", generator)) > 0) {
    if (sysname == "Darwin")
      warning("According to the descripton on download page, Code::Blocks for Mac is currently not as stable as are other ports, especially on Mountain Lion.")
  }
}
