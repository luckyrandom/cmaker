command_exist <- function(command, test_options) {
  command_base <- basename(command)
  default_options <- c(make = "--version",
                       cmake = "--version",
                       ninja = "--version")
  if (missing(test_options)) {
    test_options  <- ""
    if (command_base %in% names(default_options)) {
      test_options <- default_options[[command_base]]
    }
  }
  tryCatch(I(devtools::in_dir(tempdir(),
                              devtools::system_check(command, test_options, quiet = TRUE))),
           error = function(e){FALSE} )
}
