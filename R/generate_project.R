generators_linux <- c("Unix Makefiles",
                      "Ninja",
                      "Xcode",
                      "CodeBlocks - Ninja",
                      "CodeLite - Ninja",
                      "Eclipse CDT4 - Ninja",
                      "KDevelop3",
                      "KDevelop3 - Unix Makefiles",
                      "Kate - Ninja",
                      "Sublime Text 2 - Ninja")

generators_mac <- c(generators_linux,
                    "Xcode")

##' Get supported cmake generators.
##'
##' @return supported generators
##' @author Chenliang Xu
ls_generators <- function() {
  switch(Sys.info()[['sysname']],
         Windows= generators_windows,
         Linux  = generators_linux,
         Darwin = generators_mac)
}

post_generate_hook <- list()

##' Generate project file for IDE.
##'
##' Call cmake to generate project file for IDE.
##' @param dir the directory
##' @param generator the cmake generator to use
##' @param ... args pass to cmake
##' @author Chenliang Xu
generate_project <- function(dir, generator,
                             ...) {
  generator <- match.arg(generator, ls_generators())
  cmake(paste("-G", shQuote(generator), "."), file.path(dir, "cmake"), ...)
  if (generator %in% names(post_generate_hook)) {
    post_generate_hook[[generator]]()
  }
}
