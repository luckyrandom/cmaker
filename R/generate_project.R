generators_mac <- c("Unix Makefiles",
                    "Ninja",
                    "Xcode",
                    "CodeBlocks - Ninja",
                    "CodeLite - Ninja",
                    "Eclipse CDT4 - Ninja",
                    "KDevelop3",
                    "KDevelop3 - Unix Makefiles",
                    "Kate - Ninja",
                    "Sublime Text 2 - Ninja")

ls_generators <- function() {
  switch(Sys.info()[['sysname']],
         Windows= generators_windows,
         Linux  = generators_linux,
         Darwin = generators_mac)
}

post_generate_hook <- list()

generate_project <- function(dir, generator,
                             ...) {
  generator <- match.arg(generator, ls_generators())
  cmake(paste("-G", shQuote(generator), "."), file.path(dir, "cmake"), ...)
  if (generator %in% names(post_generate_hook)) {
    post_generate_hook[[generator]]()
  }
}
