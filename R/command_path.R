##' Get the system command path
##'
##' Retrive the path from option("cmaker.command.path") if exists;
##' otherwise find command with Sys.which
##' @param command command name
##' @return path of command
##' @export
##' @author Chenliang Xu
cmaker_command_path <- function(command)
  getOption(sprintf("cmaker.%s.path", command),
            Sys.which(command))
