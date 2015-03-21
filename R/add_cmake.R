cmake_template <- function(settings) {
  lines <- readLines(system.file("templates/cmake/CMakeLists.txt", package = "RCMakeTemplate"))
  for(var in names(settings)) {
    lines <- gsub(paste0("@@", var, "@@"),
                  settings[[var]],
                  lines)
  }
  return(lines)
}

add_cmake <- function(dir,
                      project = "Project",
                      language = c("CXX", "C", "Fortran"),
                      cxx_standard = c("11", "14", "98")) {
  if(!file.exists(file.path(dir, 'DESCRIPTION')))
    stop("Fail to find file DESCRIPTION. The directory seems not to include a R package.")
  if(file.exists(file.path(dir, "cmake")))
    stop("The directory cmake exits. We don't overwrite it.")
  invisible(file.copy(from = system.file("templates/cmake", package = "RCMakeTemplate"),
                      to = file.path(dir),
                      recursive = TRUE))

  language <- match.arg(language)
  cxx_standard <- match.arg(cxx_standard)
  settings <- list(project = project,
                   language = language,
                   cxx_standard = cxx_standard)
  writeLines(cmake_template(settings),
             file.path(dir, "cmake", "CMakeLists.txt"))  
}