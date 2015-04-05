##' Include path of package.
##'
##' The implementation is copied from `tools:::.install_packages` and
##' modifyed gently.
##' @title Include path of package.
##' @param dir The directory of package.
##' @return The include path of package.
##' @export
##' @author Chenliang Xu
include_path <- function(dir = ".") {
    f <- file.path(dir, "DESCRIPTION")
    pkgInfo <- tools:::.split_description(tools:::.read_description(f))
    linkTo <- pkgInfo$LinkingTo
    include <- character()
    if (!is.null(linkTo)) {
        lpkgs <- sapply(linkTo, function(x) x[[1L]])
        paths <- find.package(lpkgs, quiet = TRUE)
        bpaths <- basename(paths)
        if (length(paths)) {
            have_vers <- (vapply(linkTo, length, 1L) >
                          1L) & lpkgs %in% bpaths
            for (z in linkTo[have_vers]) {
                p <- z[[1L]]
                path <- paths[bpaths %in% p]
                current <- readRDS(file.path(path, "Meta",
                                             "package.rds"))$DESCRIPTION["Version"]
                target <- as.numeric_version(z$version)
                if (!do.call(z$op, list(as.numeric_version(current),
                                        target)))
                    stop(gettextf("package %s %s was found, but %s %s is required by %s",
                                  sQuote(p), current, z$op, target, sQuote(pkgname)),
                         call. = FALSE, domain = NA)
            }
            include <- paste(paste0(paths, "/include"), collapse = " ")
        }
    }
    include
}
