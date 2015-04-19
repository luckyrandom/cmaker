##' List source files of package
##'
##' @param dir the directory of package
##' @param out Set to logical true to print resutls on screen; set a
##' character file name, to print result to the file.
##' @param collapse character to separate results for printing
##' @return An invisible list of source file names
##' @export
##' @author Chenliang Xu
list_sources <- function(dir, out, collapse = "\n", on_change = NULL) {
  sources <- c(list.files(file.path(dir, "src"),
                          pattern = '.*\\.(c|cpp|cc|h|hpp)$',
                          full.names = TRUE, recursive = TRUE),
               list.files(file.path(dir, "inst", "include"),
                          pattern = '.*\\.(c|cpp|cc|h|hpp)$',
                          full.names = TRUE, recursive = TRUE))
  rcpp_exports <- file.path(dir, "src", "RcppExports.cpp")
  sources <- sources[sources != rcpp_exports]
  sources_collapsed <- paste0(sources, collapse = collapse)
  if (!missing(out)) {
    if (is.logical(out) && out)
      cat(sources_collapsed, sep = "")
    if (is.character(out))
      if ( (!file.exists(out)) ||
          sources_collapsed != paste0(readLines(out), collapse = "\n") ) {
        cat(sources_collapsed, "\n", sep = "", file = out)
        force(on_change)
      }
  }
  invisible(sources)
}
