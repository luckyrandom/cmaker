cmaker_command_path <- function(command)
  getOption(sprintf("cmaker.%s.path", command),
            Sys.which(command))
