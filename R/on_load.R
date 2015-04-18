cmake_version <- function() {
  version_info <- system(paste(shQuote(cmaker_command_path("cmake")), "--version"),
                         intern = TRUE)
  version <- sub("(cmake version )((\\d+\\.)+\\d+).*", "\\2", version_info[[1]])
  numeric_version(version)
}

ninja_version <- function() {
  version <- system(paste(shQuote(cmaker_command_path("ninja")), "--version"),
                         intern = TRUE)
  numeric_version(version)
}

.onLoad <- function(libname, pkgname) {
  if (command_exist(cmake_path())) {
    if (cmake_version < "3.2")
      packageStartupMessage("System program `cmake` is old. Update to the newest version if possbile")
  } else {
    packageStartupMessage("Error: Cannot find system program `cmake`.")
  }
  if (!command_exist(ninja_path())) {
    packageStartupMessage("Warning: Cannot find system program `ninja`, while it's required for most generated project.")
  }
}
