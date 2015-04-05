generators_linux <- c("Unix Makefiles",
                      "Ninja",
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

post_generate_hook <- list()

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
  cmake(paste("-G", shQuote(generator), "."), file.path(dir, "cmake"), ...)
  if (generator %in% names(post_generate_hook)) {
    post_generate_hook[[generator]]()
  }
}
