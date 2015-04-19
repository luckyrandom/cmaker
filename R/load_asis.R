##' Load the package asis.
##'
##' Load a package asis. It's similar to `devtools::load_all` but
##' never compile a DLL. Instead, it assumes the DLL has been compiled
##' properly. See `devtools::load_all` for other detials.
##'
##' The implementation is copied from `devtools::load_all` and
##' modifyed gently.
##' @title Load the package asis.
##' @param pkg package description, can be path or package name.
##' @inheritParams devtools::load_all
##' @export
##' @author Chenliang Xu
load_asis <- function(pkg = ".", reset = TRUE, export_all = TRUE) {
  ## TODO: This function should be a part of devtools. It's a gentle
  ##  modification on devtools::load_all. Use so many internal
  ##  function from devtools is messy.
    if (!devtools::is.package(pkg)) {
      pkg <- devtools::as.package(pkg)
    }
    if (pkg$package == "devtools") {
        as.list(devtools::ns_env(pkg))
    }
    if (devtools:::is_loaded(pkg) && is.null(devtools::dev_meta(pkg$package))) {
        devtools::unload(pkg)
    }
    devtools:::unload_dll(pkg)
    if (reset) {
      devtools:::clear_cache()
      if (devtools:::is_loaded(pkg))
        devtools:::unload(pkg)
    }
    if (!devtools:::is_loaded(pkg))
        devtools:::create_ns_env(pkg)
    out <- list(env = devtools::ns_env(pkg))
    devtools:::load_depends(pkg)
    devtools:::load_imports(pkg)
    devtools:::insert_imports_shims(pkg)
    out$data <- devtools:::load_data(pkg)
    out$code <- devtools:::load_code(pkg)
    devtools:::register_s3(pkg)
    out$dll <- devtools:::load_dll(pkg)
    if (length(out$dll) == 0) {
      warning("No dynamic library found. Is it compiled correctly?")
    }
    devtools:::run_pkg_hook(pkg, "load")
    devtools:::run_ns_load_actions(pkg)
    devtools:::run_user_hook(pkg, "load")
    devtools:::setup_ns_exports(pkg, export_all)
    if (!devtools:::is_attached(pkg))
      devtools:::attach_ns(pkg)
    devtools:::export_ns(pkg)
    devtools:::run_pkg_hook(pkg, "attach")
    devtools:::run_user_hook(pkg, "attach")
    devtools:::insert_global_shims()
    invisible(out)
}
