##' Get the R package name.
##'
##' Parse the DESCRIPTION file, and retrive the R package name.
##' @title R package name.
##' @param dir The directory of package.
##' @return The package name.
##' @author Chenliang Xu
pkg_name <- function(dir = ".") {
  pkg <- tools:::.split_description(tools:::.read_description(file.path(dir, 'DESCRIPTION')))$DESCRIPTION['Package']
  if(is.na(pkg)) stop('Package name not found');
  pkg
}
