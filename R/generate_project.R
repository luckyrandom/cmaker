IDEs_linux <- c("CodeBlocks - Ninja",
                "CodeLite - Ninja",
                "Sublime Text 2 - Ninja")

IDEs_mac <- c("CodeLite - Ninja",
              "Sublime Text 2 - Ninja",
              "Xcode")

IDEs_windows <- character()

sysname <- Sys.info()[['sysname']]

##' Get supported cmake IDEs.
##'
##' @return supported IDEs
##' @export
##' @author Chenliang Xu
ls_IDEs <- function() {
  switch(sysname,
         Windows= IDEs_windows,
         Linux  = IDEs_linux,
         Darwin = IDEs_mac)
}

setting_file <- function(pkg_dir, name) {
  file.path(pkg_dir, "cmake", "settings", name)
}

##' Generate project file for IDE.
##'
##' Generate project file for IDE. It calles `cmake` to generate
##' project file, and then adjust the generated files if needed.
##' @param dir the directory of R package
##' @param IDE the IDE to generate. It's the same as cmake generator.
##' @param cmake_options additon cmake options.
##' @export
##' @author Chenliang Xu
generate_project <- function(dir, IDE, cmake_options = "") {
  IDE <- match.arg(IDE, ls_IDEs())
  cmake_dir <- normalizePath(dir)
  proj_dir <- file.path(dir, "proj")
  dir.create(proj_dir, recursive = TRUE)
  proj_dir <- normalizePath(file.path(dir, "proj"))
  cmake(paste("-G", shQuote(IDE), cmake_dir, cmake_options), proj_dir)
  proj_name <- readLines(setting_file(dir, "projectname"), n = 1, warn = FALSE)
  if (length(grep("^Eclipse CDT4", IDE)) > 0) {
    ## Temperary fix for the bug of cmake Eclipse IDE that
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
  
  if (length(grep("^CodeBlocks", IDE)) > 0) {
    if (sysname == "Darwin")
      warning("According to the descripton on download page, Code::Blocks for Mac is currently not as stable as are other ports, especially on Mountain Lion.")
  }

  if (length(grep("^Sublime Text 2", IDE)) > 0) {
    proj <- jsonlite::fromJSON(file.path(proj_dir, paste0(proj_name, ".sublime-project")))
    proj$settings$sublimeclang_options <- paste0("-I", readLines(setting_file(dir, "includepath")))
    proj$folders$path <- "../"
    write(jsonlite::prettify(jsonlite::toJSON(proj)), file = file.path(proj_dir, paste0(proj_name, ".sublime-project")))
    message("The autocomplete depends on the SublimeClang plugin.")
  }

  if (length(grep("^CodeLite", IDE)) > 0) {
    cxx_standard <- scan(setting_file(dir, "cxx_standard"), integer())
    enable_cpp11 <- if(cxx_standard %in% c(11, 14)) {"yes"} else {"no"}
    proj <- XML::xmlParse(file.path(proj_dir, paste0(proj_name, ".project")))
    conf <- XML::getNodeSet(proj, "/CodeLite_Project/Settings/Configuration[@Name='Debug']")[[1]]
    newXMLNode <- XML::newXMLNode
    completion <- newXMLNode("Completion",
                             newXMLNode("ClangCmpFlagsC"),
                             newXMLNode("ClangCmpFlags"),
                             newXMLNode("ClangPP"),
                             newXMLNode("SearchPaths",
                                        paste(readLines(setting_file(dir, "includepath")), collapse = "\n")),
                             attrs = list(EnableCpp11 = enable_cpp11))
    XML::addChildren(conf, completion)
    write(XML::saveXML(proj), file = file.path(proj_dir, paste0(proj_name, ".project")))
  }
}
