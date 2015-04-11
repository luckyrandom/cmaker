generators_linux <- c("Unix Makefiles",
                      "Ninja",
                      "Eclipse CDT4 - Ninja",
                      "CodeBlocks - Ninja",
                      "CodeLite - Ninja",
                      "Sublime Text 2 - Ninja")

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
  proj_name <- readLines(file.path(cmake_dir, "projectname"), n = 1, warn = FALSE)

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

  if (length(grep("^Sublime Text 2", generator)) > 0) {
    proj <- jsonlite::fromJSON(file.path(proj_dir, paste0(proj_name, ".sublime-project")))
    proj$settings$sublimeclang_options <- paste0("-I", readLines(file.path(cmake_dir, "includepath")))
    proj$folders$path <- "../"
    write(jsonlite::prettify(jsonlite::toJSON(proj)), file = file.path(proj_dir, paste0(proj_name, ".sublime-project")))
    build_all <- grep(" - all$", proj$build_systems$name, value = TRUE)
    message("The autocomplete depends on the SublimeClang plugin.")
  }
}
