##' Add cmake files to the R package.
##'
##' @param dir the path of R package.
##' @param project project name to be created in cmake. Retrieve from
##' DESCRIPTION file if it is not set.
##' @param language programming lagnuage to be compiled.
##' @param cxx_standard cxx_standard used.
##' @export
##' @author Chenliang Xu
add_cmake <- function(dir,
                      project,
                      language = c("CXX", "C"),
                      cxx_standard = c("11", "14", "98"),
                      compileAttributes = TRUE) {
  if(!file.exists(file.path(dir, 'DESCRIPTION')))
    stop("Fail to find file DESCRIPTION. The directory seems not to be a R package.")
  if(missing(project)) {
    project <- pkg_name(dir)
  }
  if(file.exists(file.path(dir, "CMakeLists.txt")))
    stop("CMakeLists.txt file exits. We will not overwrite it.")
  invisible(file.copy(from = system.file("templates/cmake", package = "cmaker"),
                      to = file.path(dir),
                      recursive = TRUE))
  language <- match.arg(language)
  cxx_standard <- match.arg(cxx_standard)
  settings <- list(project = project,
                   language = language,
                   cxx_standard = cxx_standard,
                   compileAttributes = compileAttributes)
  writeLines(template(readLines(system.file("templates/CMakeLists.txt", package = "cmaker")),
                      settings),
             file.path(dir, "CMakeLists.txt"))
}
