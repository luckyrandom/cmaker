##' Test existence of a system command.
##'
##' Test existence of a system command by trying to run the command
##' with test_options.
##' @param command The name or path of command to run.
##' @param test_options The options passed to command for testing run.
##' @return TRUE if the command successes; FALSE if it fails.
##' @author Chenliang Xu
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
