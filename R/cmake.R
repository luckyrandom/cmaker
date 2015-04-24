##' Run cmake within R
##'
##' @param options a character vector of options pass to cmake.
##' @param wd the work directory to run cmake in.
##' @param env_vars environment variables to set before running the command.
##' @param cmake_command the name or the path of cmake command in the system.
##' @return Invisible \code{TRUE} if the command succeeds, throws an error if
##' the command fails.
##' @export
##' @author Chenliang Xu
cmake <- function(options = "--version",
                  wd = getwd(),
                  env_vars = NULL,
                  cmake_command = cmaker_command_path("cmake")) {
  if (!command_exist(cmake_command)) stop("cmake command not found")
  devtools::in_dir(wd, devtools::system_check(cmake_command, options, env_vars))
}


cmake_help <- {function(){
  out_cache <- NULL
  function() {
    if ( is.null(out_cache) ) {
      out <- system(paste(cmaker_command_path("cmake"), "--help"), intern = TRUE)
      out_cache <<- paste0(out, collapse = "\n")
    }
    out_cache
  }
}}()
